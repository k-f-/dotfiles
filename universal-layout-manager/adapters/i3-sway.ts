#!/usr/bin/env bun

/**
 * i3/Sway Window Manager Adapter
 *
 * Implements the universal layout manager for i3 (X11) and Sway (Wayland).
 * Both window managers share the same IPC protocol with minor differences.
 */

import { $ } from "bun";
import { parseArgs } from "node:util";
import type {
	UniversalLayoutConfig,
	Layout,
	LayoutItem,
	WindowManager,
	Size,
} from "../core/types.ts";
import {
	detectWindowManager,
	resolveAppIdentifier,
	mapLayoutType,
	sizeToPixels,
	isLayoutWindow,
	isLayoutWindowWithSize,
	isLayoutGroup,
	isLayoutGroupWithSize,
	hasSize,
} from "../core/types.ts";

// Types for i3/Sway IPC responses
interface I3Window {
	id: number;
	name: string;
	window_properties?: {
		class?: string;
		instance?: string;
		title?: string;
	};
	app_id?: string; // Sway only (Wayland)
	window?: number; // X11 window ID
	focused: boolean;
	visible: boolean;
}

interface I3Workspace {
	num: number;
	name: string;
	focused: boolean;
	visible: boolean;
	output: string;
	rect: {
		x: number;
		y: number;
		width: number;
		height: number;
	};
}

interface I3Output {
	name: string;
	active: boolean;
	primary: boolean;
	current_workspace: string;
	rect: {
		x: number;
		y: number;
		width: number;
		height: number;
	};
}

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

// Detect window manager (i3 or sway)
const windowManager = await detectWindowManager();
if (windowManager !== "i3" && windowManager !== "sway") {
	console.error(
		`Error: This adapter requires i3 or Sway. Detected: ${windowManager}`,
	);
	process.exit(1);
}

// Determine which command to use
const wmCommand = windowManager === "sway" ? "swaymsg" : "i3-msg";

if (args.values.listLayouts) {
	console.log(Object.keys(config.layouts).join("\n"));
	process.exit(0);
}

function printHelp() {
	console.log(
		`\nUniversal Layout Manager - ${windowManager.toUpperCase()} Adapter\n\nUsage:\n  i3-sway-adapter [options] <layout-name>\n\nOptions:\n  -l, --layout <layout-name>   Specify the layout name\n  -c, --configFile <path>      Path to the layout configuration file (default: ~/.config/universal-wm/layouts.json)\n  -L, --listLayouts            List available layout names\n  -n, --noLaunch               Only organize existing windows, don't launch apps\n  -a, --all                    Apply all layouts\n  -h, --help                   Show this help message and exit\n\nExamples:\n  # Apply the 'work' layout\n  i3-sway-adapter work\n\n  # Organize existing windows without launching apps\n  i3-sway-adapter --noLaunch work\n\n  # Apply all layouts\n  i3-sway-adapter --all\n`,
	);
}

if (args.values.help || layoutName === "help") {
	printHelp();
	process.exit(0);
}

if (!layoutName && !args.values.all) {
	printHelp();
	process.exit(0);
}

const stashWorkspace = config.stashWorkspace ?? "S";
const appMappings = config.appMappings ?? {};

// Helper Functions

async function getWindows(): Promise<I3Window[]> {
	const tree = await $`${wmCommand} -t get_tree`.json();
	const windows: I3Window[] = [];

	function traverse(node: any) {
		if (node.window) {
			windows.push(node as I3Window);
		}
		if (node.nodes) {
			for (const child of node.nodes) {
				traverse(child);
			}
		}
		if (node.floating_nodes) {
			for (const child of node.floating_nodes) {
				traverse(child);
			}
		}
	}

	traverse(tree);
	return windows;
}

async function getWorkspaces(): Promise<I3Workspace[]> {
	return await $`${wmCommand} -t get_workspaces`.json();
}

async function getOutputs(): Promise<I3Output[]> {
	return await $`${wmCommand} -t get_outputs`.json();
}

async function focusWorkspace(workspace: string) {
	await $`${wmCommand} workspace ${workspace}`.nothrow();
}

async function moveWindowToWorkspace(windowId: number, workspace: string) {
	await $`${wmCommand} [con_id="${windowId}"] move container to workspace ${workspace}`.nothrow();
}

async function focusWindow(windowId: number) {
	await $`${wmCommand} [con_id="${windowId}"] focus`.nothrow();
}

async function setLayout(layoutType: string) {
	await $`${wmCommand} layout ${layoutType}`.nothrow();
}

async function splitOrientation(orientation: "horizontal" | "vertical") {
	const split = orientation === "horizontal" ? "splith" : "splitv";
	await $`${wmCommand} split ${split === "splith" ? "h" : "v"}`.nothrow();
}

async function resizeWindow(
	windowId: number,
	dimension: "width" | "height",
	pixels: number,
) {
	await focusWindow(windowId);
	// i3/Sway resize command: resize set <width> <height>
	if (dimension === "width") {
		await $`${wmCommand} resize set ${pixels} 0`.nothrow();
	} else {
		await $`${wmCommand} resize set 0 ${pixels}`.nothrow();
	}
}

function matchWindow(window: I3Window, appIdentifier: string): boolean {
	// For Sway (Wayland), check app_id
	if (windowManager === "sway" && window.app_id) {
		return window.app_id === appIdentifier;
	}

	// For i3 (X11) or XWayland apps in Sway, check window class
	if (window.window_properties?.class) {
		return window.window_properties.class === appIdentifier;
	}

	// Fallback: check instance
	if (window.window_properties?.instance) {
		return window.window_properties.instance === appIdentifier;
	}

	return false;
}

async function getWindowId(appKey: string): Promise<number | null> {
	const appIdentifier = resolveAppIdentifier(
		appKey,
		appMappings,
		windowManager,
	);
	if (!appIdentifier) {
		console.log(`No app identifier found for ${appKey}`);
		return null;
	}

	const windows = await getWindows();
	const matchedWindow = windows.find((w) => matchWindow(w, appIdentifier));

	if (!matchedWindow) {
		console.log(`No window found for ${appKey} (${appIdentifier})`);
		return null;
	}

	return matchedWindow.id;
}

async function launchIfNotRunning(appKey: string) {
	const appIdentifier = resolveAppIdentifier(
		appKey,
		appMappings,
		windowManager,
	);
	if (!appIdentifier) {
		console.log(`Cannot launch ${appKey}: no app identifier`);
		return;
	}

	// Check if already running
	const windowId = await getWindowId(appKey);
	if (windowId) {
		return; // Already running
	}

	// Launch the application
	// Note: This is a simple launch command. You may need app-specific commands.
	console.log(`Launching ${appKey} (${appIdentifier})...`);
	await $`${wmCommand} exec ${appIdentifier}`.nothrow();
}

async function ensureWindow(
	appKey: string,
	shouldLaunch: boolean = true,
): Promise<number | null> {
	if (shouldLaunch) {
		await launchIfNotRunning(appKey);
	}

	// Wait for window to appear
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

async function clearWorkspace(workspace: string) {
	await focusWorkspace(workspace);
	const windows = await getWindows();

	for (const window of windows) {
		// Check if window is in the target workspace
		// This is a simplified check - in practice, you'd need to check the tree
		await moveWindowToWorkspace(window.id, stashWorkspace);
	}
}

async function getWorkspaceWidth(workspace: string): Promise<number> {
	const workspaces = await getWorkspaces();
	const ws = workspaces.find((w) => w.name === workspace);
	return ws?.rect.width ?? 1920; // Default fallback
}

async function getWorkspaceHeight(workspace: string): Promise<number> {
	const workspaces = await getWorkspaces();
	const ws = workspaces.find((w) => w.name === workspace);
	return ws?.rect.height ?? 1080; // Default fallback
}

// Tree Traversal Functions

async function traverseTreeMove(
	tree: LayoutItem[],
	workspace: string,
	shouldLaunch: boolean = true,
) {
	for (const item of tree) {
		if (isLayoutWindow(item) || isLayoutWindowWithSize(item)) {
			const windowId = await ensureWindow(item.app, shouldLaunch);
			if (windowId) {
				await moveWindowToWorkspace(windowId, workspace);
			}
		} else if (isLayoutGroup(item) || isLayoutGroupWithSize(item)) {
			await traverseTreeMove(item.windows, workspace, shouldLaunch);
		}
	}
}

async function traverseTreeReposition(
	tree: LayoutItem[],
	workspace: string,
	parentOrientation: "horizontal" | "vertical",
	depth: number = 0,
) {
	for (const [i, item] of tree.entries()) {
		if (isLayoutWindow(item) || isLayoutWindowWithSize(item)) {
			const windowId = await getWindowId(item.app);
			if (!windowId) continue;

			await focusWindow(windowId);

			if (depth > 0 && i > 0) {
				// Create split for subsequent windows in a group
				await splitOrientation(parentOrientation);
			}
		} else if (isLayoutGroup(item) || isLayoutGroupWithSize(item)) {
			// Process group
			if (i > 0) {
				await splitOrientation(parentOrientation);
			}
			await traverseTreeReposition(
				item.windows,
				workspace,
				item.orientation,
				depth + 1,
			);
		}
	}
}

async function traverseTreeResize(
	tree: LayoutItem[],
	workspace: string,
	totalSize: number,
	dimension: "width" | "height",
) {
	for (const item of tree) {
		if (hasSize(item)) {
			if (isLayoutWindowWithSize(item)) {
				const windowId = await getWindowId(item.app);
				if (windowId) {
					const pixels = sizeToPixels(item.size, totalSize);
					await resizeWindow(windowId, dimension, pixels);
				}
			} else if (isLayoutGroupWithSize(item)) {
				// Resize first window in group
				const firstWindow = item.windows[0];
				if (
					firstWindow &&
					(isLayoutWindow(firstWindow) ||
						isLayoutWindowWithSize(firstWindow))
				) {
					const windowId = await getWindowId(firstWindow.app);
					if (windowId) {
						const pixels = sizeToPixels(item.size, totalSize);
						await resizeWindow(windowId, dimension, pixels);
					}
				}
				// Recursively resize windows in group
				const newDimension =
					item.orientation === "horizontal" ? "width" : "height";
				await traverseTreeResize(
					item.windows,
					workspace,
					totalSize,
					newDimension,
				);
			}
		}
	}
}

// Main Layout Application

async function applyLayout(layout: Layout, shouldLaunch: boolean) {
	console.log(`\nApplying layout for workspace ${layout.workspace}...`);

	const workspace = String(layout.workspace);

	// Step 1: Clear workspace
	await clearWorkspace(workspace);

	// Step 2: Move all windows to workspace
	await traverseTreeMove(layout.windows, workspace, shouldLaunch);

	// Step 3: Focus workspace and set layout
	await focusWorkspace(workspace);
	const mappedLayout = mapLayoutType(layout.layout, windowManager);
	await setLayout(mappedLayout);

	// Step 4: Reposition windows (create splits)
	await traverseTreeReposition(
		layout.windows,
		workspace,
		layout.orientation,
	);

	// Step 5: Resize windows
	const dimension = layout.orientation === "horizontal" ? "width" : "height";
	const totalSize =
		dimension === "width"
			? await getWorkspaceWidth(workspace)
			: await getWorkspaceHeight(workspace);
	await traverseTreeResize(layout.windows, workspace, totalSize, dimension);

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
