/**
 * Universal Window Manager Layout Configuration Types
 *
 * These types define a platform-agnostic configuration format
 * for window layouts that works across macOS, Linux, and Windows.
 */

export type Size = `${number}/${number}`;

export type Orientation = "horizontal" | "vertical";

export type DisplayAlias = "main" | "secondary" | "internal" | "external";

export type DisplayTarget = string | number | DisplayAlias;

export type LayoutType =
	| "tiles"
	| "h_tiles"
	| "v_tiles"
	| "accordion"
	| "h_accordion"
	| "v_accordion"
	| "horizontal"
	| "vertical"
	| "tiling"
	| "floating"
	| "bsp"
	| "columns"
	| "rows";

/**
 * Platform-specific app identifiers
 */
export interface PlatformAppMapping {
	macOS?: string; // Bundle ID (e.g., "com.google.Chrome")
	linux_x11?: string; // X11 window class (e.g., "Google-chrome")
	linux_wayland?: string; // Wayland app_id (e.g., "org.mozilla.firefox")
	windows?: string; // Process name (e.g., "chrome.exe")
}

/**
 * Maps universal app identifiers to platform-specific identifiers
 */
export type AppMappings = Record<string, PlatformAppMapping>;

/**
 * Gap configuration for layouts
 */
export interface Gaps {
	inner?: number; // Gap between windows (pixels)
	outer?: number; // Gap between windows and screen edges (pixels)
}

/**
 * Basic window without size specification
 */
export interface LayoutWindow {
	app: string; // Universal app identifier (maps via appMappings)
	title?: string; // Optional window title regex for matching
	instanceIndex?: number; // Select Nth instance if multiple windows (0-indexed)
}

/**
 * Window with size specification
 */
export interface LayoutWindowWithSize extends LayoutWindow {
	size: Size; // Fractional size (e.g., "1/3", "2/3")
}

/**
 * Group of windows with shared orientation
 */
export interface LayoutGroup {
	orientation: Orientation;
	windows: LayoutItem[];
}

/**
 * Group of windows with size specification
 */
export interface LayoutGroupWithSize extends LayoutGroup {
	size: Size;
}

/**
 * Union type for all possible layout items
 */
export type LayoutItem =
	| LayoutWindow
	| LayoutWindowWithSize
	| LayoutGroup
	| LayoutGroupWithSize;

/**
 * Type guards for layout items
 */
export function isLayoutWindow(item: LayoutItem): item is LayoutWindow {
	return "app" in item && !("size" in item) && !("orientation" in item);
}

export function isLayoutWindowWithSize(
	item: LayoutItem,
): item is LayoutWindowWithSize {
	return "app" in item && "size" in item;
}

export function isLayoutGroup(item: LayoutItem): item is LayoutGroup {
	return (
		"orientation" in item && "windows" in item && !("size" in item)
	);
}

export function isLayoutGroupWithSize(
	item: LayoutItem,
): item is LayoutGroupWithSize {
	return "orientation" in item && "windows" in item && "size" in item;
}

export function hasSize(
	item: LayoutItem,
): item is LayoutWindowWithSize | LayoutGroupWithSize {
	return "size" in item;
}

/**
 * Complete layout configuration
 */
export interface Layout {
	workspace: string | number;
	layout: LayoutType;
	orientation: Orientation;
	windows: LayoutItem[];
	display?: DisplayTarget;
	gaps?: Gaps;
}

/**
 * Root configuration object
 */
export interface UniversalLayoutConfig {
	version?: string;
	stashWorkspace?: string;
	appMappings?: AppMappings;
	layouts: Record<string, Layout>;
}

/**
 * Platform detection
 */
export type Platform = "macOS" | "linux" | "windows";

export function detectPlatform(): Platform {
	const platform = process.platform;
	if (platform === "darwin") return "macOS";
	if (platform === "win32") return "windows";
	return "linux";
}

/**
 * Window manager detection
 */
export type WindowManager =
	| "aerospace"
	| "i3"
	| "sway"
	| "komorebi"
	| "glazewm"
	| "fancywm"
	| "unknown";

export async function detectWindowManager(): Promise<WindowManager> {
	const platform = detectPlatform();

	if (platform === "macOS") {
		// Check if aerospace is running
		try {
			await Bun.$`pgrep -x AeroSpace`.quiet();
			return "aerospace";
		} catch {
			return "unknown";
		}
	}

	if (platform === "linux") {
		// Check if running under X11 or Wayland
		const sessionType = process.env.XDG_SESSION_TYPE;

		if (sessionType === "wayland") {
			// Check for Sway
			if (process.env.SWAYSOCK) {
				return "sway";
			}
		} else {
			// Check for i3
			if (process.env.I3SOCK) {
				return "i3";
			}
		}
		return "unknown";
	}

	if (platform === "windows") {
		// Check for komorebi
		try {
			await Bun.$`tasklist /FI "IMAGENAME eq komorebi.exe"`.quiet();
			return "komorebi";
		} catch {}

		// Check for GlazeWM
		try {
			await Bun.$`tasklist /FI "IMAGENAME eq glazewm.exe"`.quiet();
			return "glazewm";
		} catch {}

		// Check for FancyWM
		try {
			await Bun.$`tasklist /FI "IMAGENAME eq fancywm.exe"`.quiet();
			return "fancywm";
		} catch {}

		return "unknown";
	}

	return "unknown";
}

/**
 * Resolve platform-specific app identifier from universal app key
 */
export function resolveAppIdentifier(
	appKey: string,
	appMappings: AppMappings,
	windowManager: WindowManager,
): string | null {
	const mapping = appMappings[appKey];
	if (!mapping) {
		console.warn(`No app mapping found for "${appKey}"`);
		return null;
	}

	switch (windowManager) {
		case "aerospace":
			return mapping.macOS || null;
		case "i3":
			return mapping.linux_x11 || null;
		case "sway":
			return mapping.linux_wayland || mapping.linux_x11 || null;
		case "komorebi":
		case "glazewm":
		case "fancywm":
			return mapping.windows || null;
		default:
			return null;
	}
}

/**
 * Map universal layout type to platform-specific layout type
 */
export function mapLayoutType(
	layoutType: LayoutType,
	windowManager: WindowManager,
): string {
	// Aerospace mappings (pass through)
	if (windowManager === "aerospace") {
		return layoutType;
	}

	// i3/Sway mappings
	if (windowManager === "i3" || windowManager === "sway") {
		const i3Mappings: Record<LayoutType, string> = {
			tiles: "default",
			h_tiles: "splith",
			v_tiles: "splitv",
			accordion: "tabbed",
			h_accordion: "tabbed",
			v_accordion: "stacking",
			horizontal: "splith",
			vertical: "splitv",
			tiling: "default",
			floating: "floating",
			bsp: "default", // i3/Sway don't have BSP, use default
			columns: "splith",
			rows: "splitv",
		};
		return i3Mappings[layoutType];
	}

	// komorebi mappings
	if (windowManager === "komorebi") {
		const komorebMappings: Record<LayoutType, string> = {
			tiles: "bsp",
			h_tiles: "horizontal-stack",
			v_tiles: "vertical-stack",
			accordion: "horizontal-stack", // No direct equivalent
			h_accordion: "horizontal-stack",
			v_accordion: "vertical-stack",
			horizontal: "horizontal-stack",
			vertical: "vertical-stack",
			tiling: "bsp",
			floating: "floating",
			bsp: "bsp",
			columns: "horizontal-stack",
			rows: "vertical-stack",
		};
		return komorebMappings[layoutType];
	}

	// GlazeWM mappings
	if (windowManager === "glazewm") {
		const glazeWMMappings: Record<LayoutType, string> = {
			tiles: "tiling",
			h_tiles: "columns",
			v_tiles: "rows",
			accordion: "columns", // No direct equivalent
			h_accordion: "columns",
			v_accordion: "rows",
			horizontal: "columns",
			vertical: "rows",
			tiling: "tiling",
			floating: "floating",
			bsp: "tiling",
			columns: "columns",
			rows: "rows",
		};
		return glazeWMMappings[layoutType];
	}

	// Default: return as-is
	return layoutType;
}

/**
 * Convert fractional size to pixels
 */
export function sizeToPixels(size: Size, totalPixels: number): number {
	const [numerator, denominator] = size.split("/").map(Number);
	if (!numerator || !denominator) {
		throw new Error(`Invalid size format: ${size}`);
	}
	return Math.floor(totalPixels * (numerator / denominator));
}

/**
 * Convert fractional size to percentage
 */
export function sizeToPercentage(size: Size): number {
	const [numerator, denominator] = size.split("/").map(Number);
	if (!numerator || !denominator) {
		throw new Error(`Invalid size format: ${size}`);
	}
	return (numerator / denominator) * 100;
}
