#!/bin/bash
# setup.sh - Install cursor-config by creating symlinks
# Usage: ./setup.sh [--uninstall]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURSOR_RULES_DIR="$HOME/.cursor/rules"
LOCAL_BIN_DIR="$HOME/.local/bin"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; }

install() {
    echo "Installing cursor-config..."
    echo ""

    # Create directories if needed
    mkdir -p "$CURSOR_RULES_DIR"
    mkdir -p "$LOCAL_BIN_DIR"

    # Symlink rules
    for rule in "$SCRIPT_DIR/rules/"*.mdc; do
        if [ -f "$rule" ]; then
            rulename=$(basename "$rule")
            target="$CURSOR_RULES_DIR/$rulename"
            
            # Remove existing file/symlink
            if [ -e "$target" ] || [ -L "$target" ]; then
                rm "$target"
                warn "Replaced existing $rulename"
            fi
            
            ln -s "$rule" "$target"
            info "Linked $rulename"
        fi
    done

    # Symlink CLI tool
    cli_target="$LOCAL_BIN_DIR/cursor-context"
    if [ -e "$cli_target" ] || [ -L "$cli_target" ]; then
        rm "$cli_target"
        warn "Replaced existing cursor-context"
    fi
    
    ln -s "$SCRIPT_DIR/bin/cursor-context" "$cli_target"
    chmod +x "$SCRIPT_DIR/bin/cursor-context"
    info "Linked cursor-context CLI"

    echo ""
    echo "Installation complete!"
    echo ""
    echo "Files linked:"
    echo "  ~/.cursor/rules/*.mdc  →  $SCRIPT_DIR/rules/"
    echo "  ~/.local/bin/cursor-context  →  $SCRIPT_DIR/bin/cursor-context"
    echo ""
    
    # Check if ~/.local/bin is in PATH
    if ! echo "$PATH" | tr ':' '\n' | grep -q "$HOME/.local/bin"; then
        warn "~/.local/bin is not in your PATH"
        echo "    Add this to your ~/.zshrc or ~/.bashrc:"
        echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
}

uninstall() {
    echo "Uninstalling cursor-config..."
    echo ""

    # Remove rule symlinks
    for rule in "$SCRIPT_DIR/rules/"*.mdc; do
        if [ -f "$rule" ]; then
            rulename=$(basename "$rule")
            target="$CURSOR_RULES_DIR/$rulename"
            
            if [ -L "$target" ]; then
                rm "$target"
                info "Removed $rulename"
            elif [ -e "$target" ]; then
                warn "Skipped $rulename (not a symlink)"
            fi
        fi
    done

    # Remove CLI symlink
    cli_target="$LOCAL_BIN_DIR/cursor-context"
    if [ -L "$cli_target" ]; then
        rm "$cli_target"
        info "Removed cursor-context CLI"
    elif [ -e "$cli_target" ]; then
        warn "Skipped cursor-context (not a symlink)"
    fi

    echo ""
    echo "Uninstallation complete!"
}

# Main
case "${1:-}" in
    --uninstall|-u)
        uninstall
        ;;
    --help|-h)
        echo "Usage: ./setup.sh [--uninstall]"
        echo ""
        echo "Options:"
        echo "  --uninstall, -u   Remove symlinks"
        echo "  --help, -h        Show this help"
        ;;
    *)
        install
        ;;
esac
