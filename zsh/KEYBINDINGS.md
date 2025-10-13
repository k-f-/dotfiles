# ZSH Keybindings & History Reference

## History Navigation

### Smart History Search (Type-ahead)
- **Up Arrow** / **Down Arrow** - Search history for commands that START with what you've typed
  - Example: Type `git` then press Up to see only git commands
  - Works great for multi-line commands!

### FZF Fuzzy History Search
- **Ctrl+R** - Open FZF fuzzy search of your entire history
  - Type any part of the command (fuzzy matching)
  - **Ctrl+/** - Toggle preview window
  - **Ctrl+Y** - Copy selected command to clipboard
  - **Enter** - Execute selected command

## Editing Commands

### Quick Edits
- **Ctrl+X Ctrl+E** - Open current command in $EDITOR (full editor power!)
- **Ctrl+U** - Kill (delete) everything from cursor to start of line
- **Ctrl+K** - Kill (delete) everything from cursor to end of line
- **Ctrl+W** - Delete word backwards
- **Alt+Backspace** - Delete word backwards (Mac-friendly)

### Word Movement
- **Ctrl+Left** / **Ctrl+Right** - Move backward/forward by word
- **Alt+Left** / **Alt+Right** - Move backward/forward by word (alternate)
- **Alt+F** - Forward one word

### Autosuggestions
- **Ctrl+Space** - Accept the entire suggestion (gray text)
- **End** - Accept the entire suggestion
- **Right Arrow** - Accept one character at a time

## Multi-Line Command Tips

### Best Workflow for Long Commands:
1. Start typing the beginning (e.g., `docker run`)
2. Press **Up Arrow** - filters to only commands starting with that
3. Press **Ctrl+X Ctrl+E** - opens in your editor to modify
4. Or use **Ctrl+R** for fuzzy search if you remember any part

### Quick Deletion:
- **Ctrl+U** - Clear from cursor to beginning (great for multi-line)
- **Ctrl+K** - Clear from cursor to end
- Use both together to clear and start fresh

## History Settings

Your history now keeps:
- **50,000 commands** in memory and saved to disk
- **Timestamps** for each command
- **No duplicates** (automatically removed)
- **Shared** across all terminal sessions
- Commands starting with space are ignored (privacy feature)

## Pro Tips

1. **Start typing → Up Arrow** = Best way to find recent similar commands
2. **Ctrl+R** = Best for fuzzy searching when you remember a keyword
3. **Ctrl+X Ctrl+E** = Best for editing complex multi-line commands
4. **Ctrl+U** = Quick way to bail out of a long command and start over
5. Autosuggestions learn from your history - accept with Ctrl+Space or End

## Troubleshooting

If keybindings don't work:
```bash
# Check your terminal key codes
cat -v  # then press the key combo to see what it sends
```

Common fixes:
- Make sure your terminal sends proper key codes
- Kitty/iTerm2/Alacritty generally work best
- Check terminal preferences for keyboard mappings
