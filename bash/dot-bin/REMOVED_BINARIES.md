# Removed Binaries

The following binaries have been removed from `dot-bin/` and should be installed via package managers instead.

## diff-so-fancy

Enhanced git diff formatter (Perl script, 1059 lines).

**Installation**:
```bash
# macOS
brew install diff-so-fancy

# Linux
apt install diff-so-fancy      # Debian/Ubuntu
dnf install diff-so-fancy      # Fedora
pacman -S diff-so-fancy        # Arch

# Windows
scoop install diff-so-fancy
# or
choco install diff-so-fancy
```

**Git Configuration** (after installation):
```bash
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global interactive.diffFilter "diff-so-fancy --patch"
```

---

## gotop

Terminal-based system monitor/resource viewer (compiled binary).

**Installation**:
```bash
# macOS
brew install gotop

# Linux
snap install gotop
# or download from: https://github.com/xxxserxxx/gotop/releases

# Windows
scoop install gotop
```

**Usage**:
```bash
gotop
```

---

## Rationale

**Why remove binaries from dotfiles**:
1. **Size**: Binaries are large and bloat the repository
2. **Platform-specific**: Need different binaries for different architectures
3. **Updates**: Package managers handle updates automatically
4. **Maintainability**: Package managers verify checksums and handle dependencies
5. **Best practice**: Dotfiles should contain configuration, not executables

**What belongs in dotfiles**:
- ✅ Shell scripts (text, cross-platform)
- ✅ Configuration files
- ✅ Symlink management
- ❌ Compiled binaries
- ❌ Large vendored dependencies
