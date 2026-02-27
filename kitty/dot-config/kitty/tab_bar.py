import base64
import json
import time


ICONS = {
    "idle": "◉ review",
    "permission": "▲ permission",
    "question": "◆ question",
    "error": "✖ error",
}

STALE_SECONDS = 300


def draw_title(data):
    """Custom tab title renderer for OpenCode notification indicators.

    Called by Kitty when {custom} is used in tab_title_template.
    data is the eval_locals dict containing: title, tab_id, fmt, etc.
    """
    try:
        from kitty.fast_data_types import get_boss

        boss = get_boss()
        tab = boss.tab_for_id(data.get("tab_id"))
        if tab and tab.active_window:
            raw = tab.active_window.user_vars.get("opencode_status", "")
            if raw:
                status = json.loads(base64.b64decode(raw).decode())
                ts = status.get("ts", 0)
                if time.time() - ts < STALE_SECONDS:
                    label = ICONS.get(status.get("type", ""), "")
                    if label:
                        title = data.get("title", "")
                        return label + "  " + title
    except Exception:
        pass
    return data.get("title", "")
