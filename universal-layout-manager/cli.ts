#!/usr/bin/env bun

/**
 * Universal Window Manager CLI
 *
 * Auto-detects platform and window manager, then routes commands to
 * the appropriate adapter. Provides a unified interface for managing
 * window layouts across macOS (Aerospace), Linux (i3/Sway), and
 * Windows (komorebi/GlazeWM).
 */

import { $ } from "bun";
import { parseArgs } from "node:util";
import {
	detectPlatform,
	detectWindowManager,
	type WindowManager,
	type Platform,
} from "./core/types.ts";

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
		listDisplays: { type: "boolean", short: "d" },
		help: { type: "boolean", short: "h" },
		noLaunch: { type: "boolean", short: "n" },
		all: { type: "boolean", short: "a" },
		version: { type: "boolean", short: "v" },
		detect: { type: "boolean" },
	},
	strict: true,
	allowPositionals: true,
});

const VERSION = "1.0.0";

function printHelp() {
	console.log(
		`\nUniversal Window Manager CLI v${VERSION}\n\nA unified interface for managing window layouts across multiple platforms.\n\nUsage:\n  universal-wm <command> [options] [layout-name]\n\nCommands:\n  apply <layout>     Apply a specific layout\n  apply --all        Apply all layouts\n  list               List available layouts\n  validate [file]    Validate configuration file\n  migrate            Migrate from platform-specific config\n  detect             Show detected platform and window manager\n\nOptions:\n  -l, --layout <name>      Specify the layout name\n  -c, --configFile <path>  Path to config file (default: ~/.config/universal-wm/layouts.json)\n  -L, --listLayouts        List available layouts\n  -d, --listDisplays       List available displays\n  -n, --noLaunch           Only organize existing windows, don't launch apps\n  -a, --all                Apply all layouts\n  -h, --help               Show this help message\n  -v, --version            Show version\n\nExamples:\n  # Apply a layout (auto-detects window manager)\n  universal-wm apply code\n\n  # Apply all layouts\n  universal-wm apply --all\n\n  # List layouts\n  universal-wm list\n\n  # Show detected environment\n  universal-wm detect\n\n  # Validate config\n  universal-wm validate ~/.config/universal-wm/layouts.json\n\n  # Migrate from platform-specific config\n  universal-wm migrate\n\nSupported Window Managers:\n  macOS:   Aerospace\n  Linux:   i3, Sway\n  Windows: komorebi, GlazeWM (planned)\n\nFor more information, see:\n  https://github.com/yourusername/universal-layout-manager\n`,
	);
}

if (args.values.version) {
	console.log(`universal-wm v${VERSION}`);
	process.exit(0);
}

if (args.values.help) {
	printHelp();
	process.exit(0);
}

// Get command
const command = args.positionals[0];
const layoutName = args.values.layout || args.positionals[1];

// Detect environment
async function showDetection() {
	const platform = detectPlatform();
	const wm = await detectWindowManager();

	console.log("\n🔍 Detected Environment:\n");
	console.log(`   Platform:       ${platform}`);
	console.log(`   Window Manager: ${wm}`);

	// Show supported status
	const supported = ["aerospace", "i3", "sway"].includes(wm);
	const planned = ["komorebi", "glazewm", "fancywm"].includes(wm);

	if (supported) {
		console.log(`   Status:         ✅ Supported`);
	} else if (planned) {
		console.log(`   Status:         🚧 Planned (not yet implemented)`);
	} else {
		console.log(`   Status:         ❌ Not supported`);
	}

	// Show adapter path
	if (supported) {
		const adapterMap: Record<string, string> = {
			aerospace: "adapters/aerospace.ts",
			i3: "adapters/i3-sway.ts",
			sway: "adapters/i3-sway.ts",
		};
		console.log(`   Adapter:        ${adapterMap[wm]}`);
	}

	console.log();
}

// Get adapter path for window manager
function getAdapterPath(wm: WindowManager): string {
	const adapterMap: Record<WindowManager, string> = {
		aerospace: "adapters/aerospace.ts",
		i3: "adapters/i3-sway.ts",
		sway: "adapters/i3-sway.ts",
		komorebi: "adapters/komorebi.ts",
		glazewm: "adapters/glazewm.ts",
		fancywm: "adapters/fancywm.ts",
		unknown: "",
	};

	return adapterMap[wm] || "";
}

// Route command to appropriate adapter
async function routeToAdapter(adapterArgs: string[]) {
	const wm = await detectWindowManager();

	if (wm === "unknown") {
		console.error(
			"❌ Error: Could not detect window manager.\n\nSupported window managers:\n  - macOS: Aerospace\n  - Linux: i3, Sway\n  - Windows: komorebi, GlazeWM (planned)\n",
		);
		process.exit(1);
	}

	const adapterPath = getAdapterPath(wm);
	if (!adapterPath) {
		console.error(`❌ Error: No adapter found for window manager: ${wm}`);
		process.exit(1);
	}

	// Get script directory
	const scriptDir = import.meta.dir;
	const fullAdapterPath = `${scriptDir}/${adapterPath}`;

	// Check if adapter exists
	if (!(await Bun.file(fullAdapterPath).exists())) {
		console.error(
			`❌ Error: Adapter not implemented: ${adapterPath}\n\nThis window manager is planned but not yet implemented.`,
		);
		process.exit(1);
	}

	// Execute adapter with provided arguments
	const result = await Bun.spawn(["bun", fullAdapterPath, ...adapterArgs], {
		stdout: "inherit",
		stderr: "inherit",
	});

	const exitCode = await result.exited;
	process.exit(exitCode);
}

// Main command routing
async function main() {
	// Handle special commands
	if (args.values.detect || command === "detect") {
		await showDetection();
		process.exit(0);
	}

	if (command === "list" || args.values.listLayouts) {
		await routeToAdapter(["--listLayouts"]);
		return;
	}

	if (command === "validate") {
		const configFile = args.positionals[1] || args.values.configFile;
		console.log(`🔍 Validating: ${configFile}\n`);

		const configPath = await $`echo ${configFile}`.text();
		const file = Bun.file(configPath.trim());

		if (!(await file.exists())) {
			console.error(`❌ Error: Config file not found: ${configFile}`);
			process.exit(1);
		}

		try {
			const config = await file.json();

			// Basic validation
			if (!config.layouts) {
				console.error("❌ Error: Config missing 'layouts' field");
				process.exit(1);
			}

			const layoutCount = Object.keys(config.layouts).length;
			const appMappingCount = config.appMappings
				? Object.keys(config.appMappings).length
				: 0;

			console.log("✅ Config is valid!\n");
			console.log(`   Layouts:      ${layoutCount}`);
			console.log(`   App Mappings: ${appMappingCount}`);
			console.log(
				`   Stash:        ${config.stashWorkspace || "(not set)"}\n`,
			);

			process.exit(0);
		} catch (error) {
			console.error(`❌ Error: Invalid JSON: ${error}`);
			process.exit(1);
		}
	}

	if (command === "migrate") {
		const scriptDir = import.meta.dir;
		const migrateScript = `${scriptDir}/migrate-config.ts`;

		const result = await Bun.spawn(["bun", migrateScript], {
			stdout: "inherit",
			stderr: "inherit",
		});

		const exitCode = await result.exited;
		process.exit(exitCode);
	}

	if (command === "apply" || layoutName || args.values.all) {
		// Build arguments for adapter
		const adapterArgs: string[] = [];

		if (args.values.configFile) {
			adapterArgs.push("--configFile", args.values.configFile);
		}

		if (args.values.noLaunch) {
			adapterArgs.push("--noLaunch");
		}

		if (args.values.all) {
			adapterArgs.push("--all");
		} else if (layoutName) {
			adapterArgs.push(layoutName);
		} else {
			console.error(
				"❌ Error: No layout specified. Use a layout name or --all flag.",
			);
			printHelp();
			process.exit(1);
		}

		await routeToAdapter(adapterArgs);
		return;
	}

	// No valid command
	if (!command) {
		printHelp();
		process.exit(0);
	}

	console.error(`❌ Error: Unknown command: ${command}\n`);
	printHelp();
	process.exit(1);
}

// Run
try {
	await main();
} catch (error) {
	console.error(`\n❌ Error: ${error}\n`);
	process.exit(1);
}
