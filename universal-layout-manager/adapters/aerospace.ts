#!/usr/bin/env bun

/**
 * Aerospace Window Manager Adapter
 *
 * Wraps the existing aerospace-layout-manager to consume the universal config format.
 * This adapter translates universal app keys to macOS bundle IDs and delegates
 * to the existing aerospace implementation logic.
 */

import { $ } from "bun";
import { parseArgs } from "node:util";
import type {
	UniversalLayoutConfig,
	Layout,
	LayoutItem,
	Size,
} from "../core/types.ts";
import {
	detectWindowManager,
	resolveAppIdentifier,
	mapLayoutType,
	sizeToPixels,
	sizeToPercentage,
	isLayoutWindow,
	isLayoutWindowWithSize,
	isLayoutGroup,
	isLayoutGroupWithSize,
	hasSize,
} from "../core/types.ts";

// Types matching existing aerospace implementation
type WorkspaceLayout =
	| "h_tiles"
	| "v_tiles"
	| "h_accordion"
	| "v_accordion"
	| "tiles"
	| "accordion"
	| "horizontal"
	| "vertical"
	| "tiling"
	| "floating";

type Orientation = "horizontal" | "vertical";

type DisplayAlias = "main" | "secondary" | "internal" | "external";

interface DisplayInfo {
	id?: number;
	name: string;
	width: number;
	height: number;
	isMain: boolean;
	isInternal?: boolean;
}

enum SPDisplaysValues {
	Yes = "spdisplays_yes",
	No = "spdisplays_no",
	Supported = "spdisplays_supported",
	Internal = "spdisplays_internal",
}

type SPDisplaysDataType = {
	_name: string;
	spdisplays_ndrvs: {
		_name: string;
		_spdisplays_displayID: string;
		_spdisplays_resolution: string;
		spdisplays_main: "spdisplays_yes" | "spdisplays_no";
		spdisplays_connection_type?: "spdisplays_internal" | string;
		spdisplays_resolution: string;
	}[];
};

// Setup
const args = parseArgs({
	args: process.argv.slice(2),
	options: {
		layout: { type: "string", short: "l" },
		configFile: {
			type: "string",
			short: "c",
			default: "~/.config/universal-wm/layouts.json",
		},
		listLayouts: { type: "boolean", short: "L" },
		help: { type: "boolean", short: "h" },
		listDisplays: { type: "boolean", short: "d" },
		noLaunch: { type: "boolean", short: "n" },
		all: { type: "boolean", short: "a" },
	},
	strict: true,
	allowPositionals: true,
});

const layoutName = args.values.layout || args.positionals[0];
const configFilePath = await $`echo ${args.values.configFile}`.text();
const config: UniversalLayoutConfig = await Bun.file(
	configFilePath.trim(),
).json();

// Detect window manager
const windowManager = await detectWindowManager();
if (windowManager !== "aerospace") {
	console.error(
		`Error: This adapter requires Aerospace. Detected: ${windowManager}`,
	);
	process.exit(1);
}

if (args.values.listLayouts) {
	console.log(Object.keys(config.layouts).join("\n"));
	process.exit(0);
}

function printHelp() {
	console.log(
		`\nUniversal Layout Manager - Aerospace Adapter\n\nUsage:\n  aerospace-adapter [options] <layout-name>\n\nOptions:\n  -l, --layout <layout-name>   Specify the layout name\n  -c, --configFile <path>      Path to the layout configuration file (default: ~/.config/universal-wm/layouts.json)\n  -L, --listLayouts            List available layout names\n  -d, --listDisplays           List available displays\n  -n, --noLaunch               Only organize existing windows, don't launch apps\n  -a, --all                    Apply all layouts\n  -h, --help                   Show this help message and exit\n\nExamples:\n  # Apply the 'work' layout\n  aerospace-adapter work\n\n  # Organize existing windows without launching apps\n  aerospace-adapter --noLaunch work\n\n  # Apply all layouts\n  aerospace-adapter --all\n`,
	);
}

if (args.values.help || layoutName === "help") {
	printHelp();
	process.exit(0);
}

if (args.values.listDisplays) {
	const displays = await getDisplays();
	console.log(displays.map((d) => d.name).join("\n"));
	process.exit(0);
}

if (!layoutName && !args.values.all) {
	printHelp();
	process.exit(0);
}

const stashWorkspace = config.stashWorkspace ?? "S";
const appMappings = config.appMappings ?? {};
let selectedDisplay: DisplayInfo | undefined;

// Helper Functions (from existing aerospace implementation)

async function flattenWorkspace(workspace: string) {
	await $`aerospace flatten-workspace-tree --workspace ${workspace}`.nothrow();
}

async function switchToWorkspace(workspace: string) {
	await $`aerospace workspace ${workspace}`.nothrow();
}

async function moveWindow(windowId: string, workspace: string) {
	await $`aerospace move-node-to-workspace --window-id "${windowId}" "${workspace}" --focus-follows-window`;
}

async function getWindowsInWorkspace(workspace: string): Promise<
	{
		"app-name": string;
		"window-id": string;
		"window-title": string;
		"app-bundle-id": string;
	}[]
> {
	return await $`aerospace list-windows --workspace ${workspace} --json --format "%{window-id} %{app-name} %{window-title} %{app-bundle-id}"`.json();
}

async function joinItemWithPreviousWindow(windowId: string, orientation: "horizontal" | "vertical" = "horizontal") {
	// For a vertical group (windows stacked top/bottom), join "up" to create a vertical container
	// For a horizontal group (windows side by side), join "left" to create a horizontal container
	const direction = orientation === "vertical" ? "up" : "left";
	await $`aerospace join-with --window-id ${windowId} ${direction}`.nothrow();
}

async function focusWindow(windowId: string) {
	await $`aerospace focus --window-id ${windowId}`.nothrow();
}

async function getDisplays(): Promise<DisplayInfo[]> {
	const data = await $`system_profiler SPDisplaysDataType -json`.json();

	return data.SPDisplaysDataType.flatMap((gpu: SPDisplaysDataType) =>
		gpu.spdisplays_ndrvs?.map((d) => ({
			name: d._name,
			id: Number.parseInt(d._spdisplays_displayID) || undefined,
			width: Number.parseInt(
				(d._spdisplays_resolution || d.spdisplays_resolution || "").split(
					" x ",
				)[0] || "0",
				10,
			),
			height: Number.parseInt(
				(d._spdisplays_resolution || d.spdisplays_resolution || "").split(
					" x ",
				)[1] || "0",
				10,
			),
			isMain: d.spdisplays_main === SPDisplaysValues.Yes,
			isInternal: d.spdisplays_connection_type === SPDisplaysValues.Internal,
		})),
	);
}

function getDisplayByAlias(
	alias: DisplayAlias,
	displays: DisplayInfo[],
): DisplayInfo | undefined {
	switch (alias) {
		case "main":
			return getMainDisplay(displays);
		case "secondary":
			if (displays.length < 2) {
				console.log(
					"Alias 'secondary' is used, but only one display found. Defaulting to the main display.",
				);
				return getMainDisplay(displays);
			}
			if (displays.length > 2) {
				throw new Error(
					"Alias 'secondary' is used, but multiple secondary displays are found. Please specify an exact display name or use a different alias.",
				);
			}
			return displays.find((d) => !d.isMain);
		case "external": {
			const externalDisplays = displays.filter((d) => !d.isInternal);
			if (externalDisplays.length === 0) {
				console.log(
					"Alias 'external' is used, but no external displays found. Defaulting to the main display.",
				);
				return getMainDisplay(displays);
			}
			if (externalDisplays.length > 1) {
				throw new Error(
					"Multiple external displays found. Please specify an exact display name or use a different alias.",
				);
			}
			return externalDisplays[0];
		}
		case "internal":
			return displays.find((d) => d.isInternal);
	}
}

function getDisplayByName(
	regExp: string,
	displays: DisplayInfo[],
): DisplayInfo | undefined {
	return displays.find((d) => new RegExp(regExp, "i").test(d.name));
}

function getDisplayById(
	id: number,
	displays: DisplayInfo[],
): DisplayInfo | undefined {
	return displays.find((d) => d.id === id);
}

function getMainDisplay(displays: DisplayInfo[]): DisplayInfo | undefined {
	return displays.find((d) => d.isMain);
}

function selectDisplay(layout: Layout, displays: DisplayInfo[]): DisplayInfo {
	let display: DisplayInfo | undefined;
	if (layout.display) {
		if (
			typeof layout.display === "string" &&
			Number.isNaN(Number(layout.display))
		) {
			const isAlias = ["main", "secondary", "internal", "external"].includes(
				layout.display,
			);
			if (isAlias) {
				display = getDisplayByAlias(layout.display as DisplayAlias, displays);
			} else {
				display = getDisplayByName(layout.display, displays);
			}
		} else if (
			typeof layout.display === "number" ||
			!Number.isNaN(Number(layout.display))
		) {
			const displayId = Number(layout.display);
			display = getDisplayById(displayId, displays);
		}
	}

	if (!display) {
		if (layout.display) {
			console.log(
				`Display not found: ${layout.display}. Defaulting to the main display.`,
			);
		}
		display = getDisplayByAlias("main", displays) as DisplayInfo;
	}

	console.log(
		`Using display: ${display.name} (${display.width}x${display.height}) (${
			display.isMain ? "main" : "secondary"
		}, ${display.isInternal ? "internal" : "external"})`,
	);

	return display;
}

async function getDisplayWidth(): Promise<number | null> {
	return selectedDisplay?.width ?? null;
}

async function getDisplayHeight(): Promise<number | null> {
	return selectedDisplay?.height ?? null;
}

// Functions using universal config

async function clearWorkspace(workspace: string) {
	const windows = await getWindowsInWorkspace(workspace);

	for (const window of windows) {
		if (window["window-id"]) {
			await moveWindow(window["window-id"], stashWorkspace);
		}
	}
}

async function getWindowId(appKey: string): Promise<string | null> {
	const bundleId = resolveAppIdentifier(appKey, appMappings, windowManager);
	if (!bundleId) {
		console.log(`No bundle ID found for ${appKey}`);
		return null;
	}

	const bundleJson =
		await $`aerospace list-windows --monitor all --app-bundle-id "${bundleId}" --json`.json();
	const windowId = bundleJson?.length > 0 ? bundleJson[0]["window-id"] : null;
	if (!windowId) {
		console.log(`No windowId found for ${appKey} (${bundleId})`);
	}
	return windowId;
}

async function launchIfNotRunning(appKey: string) {
	const bundleId = resolveAppIdentifier(appKey, appMappings, windowManager);
	if (!bundleId) {
		console.log(`Cannot launch ${appKey}: no bundle ID`);
		return;
	}

	const result = await $`osascript -e "application id \"${bundleId}\" is running"`.text();
	const isRunning = result.trim() === "true";
	if (!isRunning) {
		await $`open -b "${bundleId}"`;
	}
}

async function ensureWindow(
	appKey: string,
	shouldLaunch: boolean = true,
): Promise<string | null> {
	if (shouldLaunch) {
		await launchIfNotRunning(appKey);
	}

	const maxRetries = shouldLaunch ? 20 : 5;
	const retryDelay = shouldLaunch ? 100 : 50;

	for (let i = 0; i < maxRetries; i++) {
		const windowId = await getWindowId(appKey);
		if (windowId) {
			return windowId;
		}
		if (i < maxRetries - 1) {
			await new Promise((resolve) => setTimeout(resolve, retryDelay));
		}
	}
	return null;
}

async function setWorkspaceLayout(
	workspace: string,
	layoutType: WorkspaceLayout,
) {
	const workspaceWindows = await getWindowsInWorkspace(workspace);
	if (workspaceWindows.length > 0) {
		const windowId = workspaceWindows?.[0]?.["window-id"];
		await $`aerospace layout ${layoutType} --window-id ${windowId}`.nothrow();
	}
}

async function traverseTreeMove(
	tree: LayoutItem[],
	workspace: string,
	shouldLaunch = true,
) {
	for (const item of tree) {
		if (isLayoutWindow(item) || isLayoutWindowWithSize(item)) {
			const windowId = await ensureWindow(item.app, shouldLaunch);

			if (windowId) {
				await moveWindow(windowId, workspace);
			}
		} else if (isLayoutGroup(item) || isLayoutGroupWithSize(item)) {
			await traverseTreeMove(item.windows, workspace, shouldLaunch);
		}
	}
}

async function traverseTreeReposition(tree: LayoutItem[], workspace: string, depth = 0, parentOrientation: "horizontal" | "vertical" = "horizontal") {
	for (const [i, item] of tree.entries()) {
		if (depth === 0 && i === 0) {
			await flattenWorkspace(workspace);
			const mappedLayout = mapLayoutType(
				"tiles" as any,
				windowManager,
			) as WorkspaceLayout;
			await setWorkspaceLayout(workspace, mappedLayout);
		}
		if (isLayoutWindow(item) || isLayoutWindowWithSize(item)) {
			if (depth > 0 && i > 0) {
				const windowId = await getWindowId(item.app);
				if (windowId) {
					await focusWindow(windowId);
					await joinItemWithPreviousWindow(windowId, parentOrientation);
				}
			}
		} else if (isLayoutGroup(item) || isLayoutGroupWithSize(item)) {
			console.log("section:", item.orientation, "depth:", depth);
			await traverseTreeReposition(item.windows, workspace, depth + 1, item.orientation);
		}
	}
}

async function resizeWindow(
	windowId: string | null,
	size: Size,
	dimension: "width" | "height",
) {
	if (!windowId) {
		console.log("Skipping resize: window not found");
		return;
	}

	console.log("Resizing window", windowId, "to", size);
	const screenDimension =
		dimension === "width" ? await getDisplayWidth() : await getDisplayHeight();
	const [numerator, denominator] = size.split("/").map(Number);

	if (!screenDimension || !numerator || !denominator) {
		console.error("Unable to determine display dimensions");
		return;
	}

	const newSize = Math.floor(screenDimension * (numerator / denominator));
	console.log("New size:", newSize);

	await $`aerospace resize --window-id ${windowId} ${dimension} ${newSize}`.nothrow();
}

function getDimension(item: LayoutItem, parentOrientation: Orientation) {
	if (isLayoutGroup(item) || isLayoutGroupWithSize(item)) {
		return item.orientation === "horizontal" ? "width" : "height";
	}
	return parentOrientation === "horizontal" ? "width" : "height";
}

async function traverseTreeResize(
	tree: LayoutItem[],
	parentOrientation: Orientation,
	depth = 0,
	parent: LayoutItem | null = null,
) {
	for (const [i, item] of tree.entries()) {
		if (hasSize(item)) {
			if (isLayoutWindowWithSize(item)) {
				const windowId = await getWindowId(item.app);
				const dimension = getDimension(item, parentOrientation);
				await resizeWindow(windowId, item.size, dimension);
			} else if (isLayoutGroupWithSize(item)) {
				const firstChildWindow = item.windows[0];
				if (
					firstChildWindow &&
					(isLayoutWindow(firstChildWindow) ||
						isLayoutWindowWithSize(firstChildWindow))
				) {
					const windowId = await getWindowId(firstChildWindow.app);
					const dimension = parent
						? getDimension(parent, parentOrientation)
						: parentOrientation === "horizontal"
							? "width"
							: "height";
					await resizeWindow(windowId, item.size, dimension);
				}
				await traverseTreeResize(
					item.windows,
					item.orientation,
					depth + 1,
					item,
				);
			}
		} else if (isLayoutGroup(item)) {
			await traverseTreeResize(item.windows, item.orientation, depth + 1, item);
		}
	}
}

// Main Layout Application

async function applyLayout(layout: Layout, shouldLaunch: boolean) {
	console.log(`\nApplying layout for workspace ${layout.workspace}...`);

	const workspace = String(layout.workspace);

	// Select display
	const displays = await getDisplays();
	if (!displays || displays.length === 0) {
		throw new Error("No displays found");
	}
	selectedDisplay = layout.display
		? selectDisplay(layout, displays)
		: getDisplayByAlias("main", displays);

	if (!selectedDisplay) {
		throw new Error(
			`A display could not be selected for layout. Please check your configuration.`,
		);
	}

	// Step 1: Clear workspace
	await clearWorkspace(workspace);

	// Step 2: Move all windows to workspace
	await traverseTreeMove(layout.windows, workspace, shouldLaunch);

	// Step 3: Reposition windows
	await traverseTreeReposition(layout.windows, workspace);

	// Step 4: Switch to workspace
	await switchToWorkspace(workspace);

	// Step 5: Resize windows
	await traverseTreeResize(layout.windows, layout.orientation);

	console.log(`✓ Layout applied for workspace ${layout.workspace}`);
}

// Main Execution

const shouldLaunch = !args.values.noLaunch;

if (args.values.all) {
	// Apply all layouts
	for (const [name, layout] of Object.entries(config.layouts)) {
		console.log(`\n=== Applying layout: ${name} ===`);
		await applyLayout(layout, shouldLaunch);
	}
} else if (layoutName) {
	// Apply single layout
	const layout = config.layouts[layoutName];
	if (!layout) {
		console.error(`Error: Layout "${layoutName}" not found`);
		process.exit(1);
	}
	await applyLayout(layout, shouldLaunch);
}

console.log("\n✓ Done!");
