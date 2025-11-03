#!/usr/bin/env bun

/**
 * Migrate Aerospace Config to Universal Format
 *
 * Converts existing aerospace-layout-manager configs to the universal format
 * by extracting bundle IDs, creating app mappings, and converting layouts.
 */

import { $ } from "bun";
import { parseArgs } from "node:util";
import type {
	UniversalLayoutConfig,
	Layout,
	LayoutItem,
	AppMappings,
} from "./core/types.ts";

// Old aerospace config format
interface OldLayoutWindow {
	bundleId: string;
	size?: string;
}

interface OldLayoutGroup {
	orientation: "horizontal" | "vertical";
	size?: string;
	windows: OldLayoutItem[];
}

type OldLayoutItem = OldLayoutWindow | OldLayoutGroup;

interface OldLayout {
	workspace: string | number;
	layout: string;
	orientation: "horizontal" | "vertical";
	windows: OldLayoutItem[];
	display?: string | number;
}

interface OldLayoutConfig {
	stashWorkspace?: string;
	layouts: Record<string, OldLayout>;
}

// Common bundle ID to app name mappings
const BUNDLE_ID_MAPPING: Record<string, string> = {
	// Browsers
	"org.mozilla.firefox": "firefox",
	"com.google.Chrome": "chrome",
	"com.apple.Safari": "safari",
	"com.microsoft.edgemac": "edge",
	"company.thebrowser.Browser": "arc",

	// Terminals
	"net.kovidgoyal.kitty": "kitty",
	"com.googlecode.iterm2": "iterm",
	"com.apple.Terminal": "terminal",
	"com.github.wez.wezterm": "wezterm",
	"io.alacritty": "alacritty",

	// Editors
	"com.microsoft.VSCode": "vscode",
	"com.sublimetext.4": "sublime",
	"com.jetbrains.intellij": "intellij",
	"com.jetbrains.pycharm": "pycharm",
	"com.github.atom": "atom",
	"com.neovide.neovide": "neovide",

	// Communication
	"com.tinyspeck.slackmacgap": "slack",
	"com.hnc.Discord": "discord",
	"us.zoom.xos": "zoom",
	"com.microsoft.teams": "teams",
	"org.whispersystems.signal-desktop": "signal",
	"com.apple.MobileSMS": "messages",
	"com.skype.skype": "skype",
	"com.telegram.desktop": "telegram",

	// Media
	"com.spotify.client": "spotify",
	"com.apple.Music": "apple_music",
	"com.apple.TV": "apple_tv",
	"io.mpv": "mpv",
	"org.videolan.vlc": "vlc",

	// Productivity
	"com.apple.iCal": "calendar",
	"com.apple.mail": "mail",
	"com.apple.Notes": "notes",
	"com.apple.reminders": "reminders",
	"notion.id": "notion",
	"com.todoist.mac.Todoist": "todoist",
	"com.culturedcode.ThingsMac": "things",

	// File Management
	"com.apple.finder": "finder",
	"com.panic.Transmit": "transmit",
	"com.forklift.ForkLift": "forklift",

	// System
	"com.apple.ActivityMonitor": "activity_monitor",
	"com.apple.systempreferences": "system_preferences",

	// Development Tools
	"com.docker.docker": "docker",
	"com.postmanlabs.mac": "postman",
	"com.github.GitHubClient": "github_desktop",
	"com.figma.Desktop": "figma",

	// Utilities
	"com.1password.1password": "onepassword",
	"com.agilebits.onepassword7": "onepassword",
	"org.keepassx.keepassxc": "keepassxc",
};

// Setup
const args = parseArgs({
	args: process.argv.slice(2),
	options: {
		input: {
			type: "string",
			short: "i",
			default: "~/.config/aerospace/layouts.json",
		},
		output: {
			type: "string",
			short: "o",
			default: "~/.config/universal-wm/layouts.json",
		},
		dryRun: { type: "boolean", short: "d" },
		help: { type: "boolean", short: "h" },
	},
	strict: true,
	allowPositionals: false,
});

function printHelp() {
	console.log(
		`\nMigrate Aerospace Config to Universal Format\n\nUsage:\n  migrate-config [options]\n\nOptions:\n  -i, --input <path>   Input aerospace config file (default: ~/.config/aerospace/layouts.json)\n  -o, --output <path>  Output universal config file (default: ~/.config/universal-wm/layouts.json)\n  -d, --dryRun         Show what would be migrated without writing files\n  -h, --help           Show this help message and exit\n\nExamples:\n  # Migrate with default paths\n  migrate-config\n\n  # Preview migration without writing\n  migrate-config --dryRun\n\n  # Migrate specific file\n  migrate-config -i ~/my-layouts.json -o ~/universal-layouts.json\n`,
	);
}

if (args.values.help) {
	printHelp();
	process.exit(0);
}

const inputPath = await $`echo ${args.values.input}`.text();
const outputPath = await $`echo ${args.values.output}`.text();

// Helper functions

function bundleIdToAppKey(bundleId: string): string {
	// Check known mappings first
	if (BUNDLE_ID_MAPPING[bundleId]) {
		return BUNDLE_ID_MAPPING[bundleId];
	}

	// Generate app key from bundle ID
	// e.g., "com.apple.Safari" -> "safari"
	const parts = bundleId.split(".");
	const appName = parts[parts.length - 1];
	return appName.toLowerCase().replace(/[^a-z0-9]/g, "_");
}

function extractBundleIds(items: OldLayoutItem[]): Set<string> {
	const bundleIds = new Set<string>();

	function traverse(item: OldLayoutItem) {
		if ("bundleId" in item) {
			bundleIds.add(item.bundleId);
		} else if ("windows" in item) {
			for (const child of item.windows) {
				traverse(child);
			}
		}
	}

	for (const item of items) {
		traverse(item);
	}

	return bundleIds;
}

function convertLayoutItem(
	item: OldLayoutItem,
	bundleIdToKey: Map<string, string>,
): LayoutItem {
	if ("bundleId" in item) {
		const appKey = bundleIdToKey.get(item.bundleId);
		if (!appKey) {
			throw new Error(`No app key found for bundle ID: ${item.bundleId}`);
		}

		const newItem: any = { app: appKey };
		if (item.size) {
			newItem.size = item.size;
		}
		return newItem;
	}

	// It's a group
	const newGroup: any = {
		orientation: item.orientation,
		windows: item.windows.map((w) => convertLayoutItem(w, bundleIdToKey)),
	};
	if (item.size) {
		newGroup.size = item.size;
	}
	return newGroup;
}

function convertLayout(
	oldLayout: OldLayout,
	bundleIdToKey: Map<string, string>,
): Layout {
	return {
		workspace: oldLayout.workspace,
		layout: oldLayout.layout as any,
		orientation: oldLayout.orientation,
		windows: oldLayout.windows.map((w) => convertLayoutItem(w, bundleIdToKey)),
		display: oldLayout.display,
	};
}

// Main migration logic

async function migrate() {
	console.log("🔄 Migrating Aerospace config to Universal format...\n");

	// Read old config
	const inputFile = inputPath.trim();
	console.log(`📖 Reading: ${inputFile}`);

	if (!(await Bun.file(inputFile).exists())) {
		console.error(`❌ Error: Input file not found: ${inputFile}`);
		process.exit(1);
	}

	const oldConfig: OldLayoutConfig = await Bun.file(inputFile).json();

	// Extract all bundle IDs
	const allBundleIds = new Set<string>();
	for (const layout of Object.values(oldConfig.layouts)) {
		const bundleIds = extractBundleIds(layout.windows);
		for (const id of bundleIds) {
			allBundleIds.add(id);
		}
	}

	console.log(`\n📦 Found ${allBundleIds.size} unique bundle IDs`);

	// Create app mappings
	const appMappings: AppMappings = {};
	const bundleIdToKey = new Map<string, string>();

	for (const bundleId of allBundleIds) {
		const appKey = bundleIdToAppKey(bundleId);
		bundleIdToKey.set(bundleId, appKey);

		appMappings[appKey] = {
			macOS: bundleId,
		};

		console.log(`   ${appKey.padEnd(20)} → ${bundleId}`);
	}

	// Convert layouts
	console.log(`\n🔧 Converting ${Object.keys(oldConfig.layouts).length} layouts...`);
	const newLayouts: Record<string, Layout> = {};

	for (const [name, oldLayout] of Object.entries(oldConfig.layouts)) {
		newLayouts[name] = convertLayout(oldLayout, bundleIdToKey);
		console.log(`   ✓ ${name}`);
	}

	// Create new config
	const newConfig: UniversalLayoutConfig = {
		version: "1.0.0",
		stashWorkspace: oldConfig.stashWorkspace ?? "S",
		appMappings,
		layouts: newLayouts,
	};

	// Output
	const outputFile = outputPath.trim();

	if (args.values.dryRun) {
		console.log("\n📋 Dry run - showing output (not writing to file):\n");
		console.log(JSON.stringify(newConfig, null, 2));
	} else {
		// Create output directory if needed
		const outputDir = outputFile.substring(0, outputFile.lastIndexOf("/"));
		await $`mkdir -p ${outputDir}`.quiet();

		// Write new config
		await Bun.write(outputFile, JSON.stringify(newConfig, null, 2));
		console.log(`\n✅ Migration complete!`);
		console.log(`📝 Output: ${outputFile}`);

		// Show next steps
		console.log(`\n📚 Next steps:`);
		console.log(`   1. Review the generated config:`);
		console.log(`      cat ${outputFile}`);
		console.log(`   2. Add Linux/Windows app mappings to appMappings section`);
		console.log(`   3. Test with: bun universal-layout-manager/adapters/aerospace.ts --listLayouts`);
		console.log(
			`   4. Apply a layout: bun universal-layout-manager/adapters/aerospace.ts <layout-name>`,
		);
	}

	// Show warnings if needed
	const unknownBundleIds = Array.from(allBundleIds).filter(
		(id) => !BUNDLE_ID_MAPPING[id],
	);
	if (unknownBundleIds.length > 0) {
		console.log(`\n⚠️  Unknown bundle IDs (auto-generated app keys):`);
		for (const id of unknownBundleIds) {
			const appKey = bundleIdToAppKey(id);
			console.log(`   ${appKey.padEnd(20)} ← ${id}`);
		}
		console.log(`   Consider adding these to BUNDLE_ID_MAPPING for better names.`);
	}
}

// Run migration
try {
	await migrate();
} catch (error) {
	console.error(`\n❌ Migration failed:`, error);
	process.exit(1);
}
