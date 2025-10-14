#!/usr/bin/env bash

# archive-old-docs.sh
# Archives old documentation files based on age and completion status
#
# Usage:
#   ./scripts/archive-old-docs.sh [--dry-run] [--days N]
#
# Options:
#   --dry-run    Show what would be archived without moving files
#   --days N     Archive files older than N days (default: 90)

set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default settings
DRY_RUN=false
DAYS_OLD=90
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
DOCS_DIR="${REPO_ROOT}/docs/development"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --days)
            DAYS_OLD="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [--dry-run] [--days N]"
            echo ""
            echo "Options:"
            echo "  --dry-run    Show what would be archived without moving files"
            echo "  --days N     Archive files older than N days (default: 90)"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}Documentation Archive Tool${NC}"
echo -e "${BLUE}===========================${NC}"
echo ""
echo "Settings:"
echo "  - Dry run: ${DRY_RUN}"
echo "  - Archive files older than: ${DAYS_OLD} days"
echo "  - Documentation directory: ${DOCS_DIR}"
echo ""

# Function to calculate file age in days
file_age_days() {
    local file="$1"
    local current_time=$(date +%s)
    local file_time=$(stat -f %m "$file" 2>/dev/null || stat -c %Y "$file" 2>/dev/null)
    local age_seconds=$((current_time - file_time))
    local age_days=$((age_seconds / 86400))
    echo "$age_days"
}

# Function to archive a file
archive_file() {
    local file="$1"
    local category="$2"
    local filename=$(basename "$file")
    local archive_dir="${DOCS_DIR}/${category}/archive"

    # Extract date from filename if present (YYYY-MM-DD format)
    local date_prefix=""
    if [[ "$filename" =~ ^([0-9]{4}-[0-9]{2}-[0-9]{2})- ]]; then
        date_prefix="${BASH_REMATCH[1]}"
    else
        # Use file modification date
        date_prefix=$(date -r "$file" +%Y-%m-%d 2>/dev/null || date -d "@$(stat -c %Y "$file")" +%Y-%m-%d 2>/dev/null)
    fi

    # Create archive filename
    local archive_name="ARCHIVED-${date_prefix}-${filename}"
    local archive_path="${archive_dir}/${archive_name}"

    # Check if already has ARCHIVED prefix
    if [[ "$filename" == ARCHIVED-* ]]; then
        echo -e "${YELLOW}  ⊘ Skipping (already archived): ${filename}${NC}"
        return
    fi

    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}  → Would archive: ${filename}${NC}"
        echo -e "     to: ${category}/archive/${archive_name}"
    else
        mv "$file" "$archive_path"
        echo -e "${GREEN}  ✓ Archived: ${filename}${NC}"
        echo -e "     to: ${category}/archive/${archive_name}"

        # Update archive README
        local archive_readme="${archive_dir}/README.md"
        if [[ -f "$archive_readme" ]]; then
            # Add entry to archive README (after the "Archived Documents" header)
            local reason="Automatically archived (>${DAYS_OLD} days old)"
            sed -i.bak "/<!-- Add entries when archiving/a\\
- \`${archive_name}\` - ${reason}
" "$archive_readme"
            rm "${archive_readme}.bak"
        fi
    fi
}

# Function to check if file should be archived
should_archive() {
    local file="$1"
    local filename=$(basename "$file")

    # Skip README files
    if [[ "$filename" == "README.md" ]]; then
        return 1
    fi

    # Skip files that are already archived
    if [[ "$filename" == ARCHIVED-* ]]; then
        return 1
    fi

    # Skip files in archive directories
    if [[ "$file" == */archive/* ]]; then
        return 1
    fi

    # Check age
    local age=$(file_age_days "$file")
    if [[ $age -ge $DAYS_OLD ]]; then
        return 0
    fi

    return 1
}

# Process summaries
echo -e "${BLUE}Checking summaries...${NC}"
if [[ -d "${DOCS_DIR}/summaries" ]]; then
    found_files=false
    while IFS= read -r -d '' file; do
        if should_archive "$file"; then
            archive_file "$file" "summaries"
            found_files=true
        fi
    done < <(find "${DOCS_DIR}/summaries" -maxdepth 1 -type f -name "*.md" -print0)

    if [[ "$found_files" == false ]]; then
        echo -e "${GREEN}  ✓ No files to archive${NC}"
    fi
else
    echo -e "${YELLOW}  ! Directory not found: summaries${NC}"
fi
echo ""

# Process updates
echo -e "${BLUE}Checking updates...${NC}"
if [[ -d "${DOCS_DIR}/updates" ]]; then
    found_files=false
    while IFS= read -r -d '' file; do
        if should_archive "$file"; then
            archive_file "$file" "updates"
            found_files=true
        fi
    done < <(find "${DOCS_DIR}/updates" -maxdepth 1 -type f -name "*.md" -print0)

    if [[ "$found_files" == false ]]; then
        echo -e "${GREEN}  ✓ No files to archive${NC}"
    fi
else
    echo -e "${YELLOW}  ! Directory not found: updates${NC}"
fi
echo ""

# Process planning (be more conservative - only archive explicitly marked files)
echo -e "${BLUE}Checking planning...${NC}"
echo -e "${YELLOW}  ℹ Planning documents are typically living docs - manual review recommended${NC}"
if [[ -d "${DOCS_DIR}/planning" ]]; then
    # Only archive planning docs that are:
    # 1. Older than threshold
    # 2. Have "COMPLETED" or "ARCHIVED" in the title or first few lines
    found_files=false
    while IFS= read -r -d '' file; do
        if should_archive "$file"; then
            # Check if file contains completion markers
            if grep -q -E "(COMPLETED|ARCHIVED|Status:.*[Cc]omplete)" "$file" 2>/dev/null; then
                archive_file "$file" "planning"
                found_files=true
            else
                echo -e "${YELLOW}  ⊘ Skipping (no completion marker): $(basename "$file")${NC}"
            fi
        fi
    done < <(find "${DOCS_DIR}/planning" -maxdepth 1 -type f -name "*.md" -print0)

    if [[ "$found_files" == false ]]; then
        echo -e "${GREEN}  ✓ No files to archive${NC}"
    fi
else
    echo -e "${YELLOW}  ! Directory not found: planning${NC}"
fi
echo ""

# Summary
echo -e "${BLUE}===========================${NC}"
if [[ "$DRY_RUN" == true ]]; then
    echo -e "${YELLOW}Dry run complete. No files were moved.${NC}"
    echo -e "Run without --dry-run to perform archiving."
else
    echo -e "${GREEN}Archive complete!${NC}"
fi
echo ""
echo "Tips:"
echo "  - Review archived files in docs/development/*/archive/"
echo "  - Update archive README files with detailed notes if needed"
echo "  - Consider git committing archived changes"
