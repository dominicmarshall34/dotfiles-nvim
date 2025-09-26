#!/bin/bash

# Neovim Configuration Installer
# This script installs the Neovim configuration to ~/.config/nvim

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration paths
NVIM_CONFIG_DIR="$HOME/.config/nvim"  # Target Neovim directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if required files exist
check_config_files() {
    print_status "Checking for configuration files..."

    required_files=(
        "init.lua"
        "lua/config/init.lua"
        "lua/config/options.lua"
        "lua/config/keymaps.lua"
        "lua/config/lazy.lua"
        "lua/config/autocmds.lua"
    )

    missing_files=()

    for file in "${required_files[@]}"; do
        if [[ ! -f "$SCRIPT_DIR/$file" ]]; then
            missing_files+=("$file")
        fi
    done

    if [[ ${#missing_files[@]} -gt 0 ]]; then
        print_error "Missing required configuration files:"
        for file in "${missing_files[@]}"; do
            echo "  - $file"
        done
        exit 1
    fi

    print_success "All required configuration files found"
}

# Function to handle existing Neovim configuration
handle_existing_config() {
    if [[ -d "$NVIM_CONFIG_DIR" ]]; then
        print_warning "Existing Neovim configuration found at $NVIM_CONFIG_DIR"
        echo -n "Do you want to overwrite it? (y/N): "
        read -r response

        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_status "Installation cancelled"
            exit 0
        fi

        print_status "Removing existing Neovim configuration..."
        rm -rf "$NVIM_CONFIG_DIR"
        print_success "Existing configuration removed"
    else
        print_status "No existing Neovim configuration found"
    fi
}

# Function to create Neovim config directory
create_config_dir() {
    print_status "Creating Neovim configuration directory..."
    mkdir -p "$NVIM_CONFIG_DIR"
    print_success "Configuration directory created"
}

# Function to copy Neovim configuration files
copy_config_files() {
    print_status "Copying configuration files..."

    # Copy all files and directories, preserving structure
    for item in "$SCRIPT_DIR"/*; do
        basename_item="$(basename "$item")"
        # Skip install scripts and README files
        if [[ "$basename_item" != "install.sh" ]] && \
           [[ "$basename_item" != "install-neovim.sh" ]] && \
           [[ "$basename_item" != "install-linux.sh" ]] && \
           [[ "$basename_item" != "README.md" ]] && \
           [[ "$basename_item" != "README" ]]; then
            cp -r "$item" "$NVIM_CONFIG_DIR/"
        fi
    done

    print_success "Configuration files copied successfully"
}

# Function to set proper permissions
set_permissions() {
    print_status "Setting proper permissions..."
    chmod -R 755 "$NVIM_CONFIG_DIR"
    print_success "Permissions set successfully"
}

# Function to verify installation
verify_installation() {
    print_status "Verifying installation..."

    if [[ -f "$NVIM_CONFIG_DIR/init.lua" ]]; then
        print_success "Installation verified: init.lua found"
    else
        print_error "Installation failed: init.lua not found"
        exit 1
    fi

    # Check if lua directory structure exists
    if [[ -d "$NVIM_CONFIG_DIR/lua/config" ]] && [[ -d "$NVIM_CONFIG_DIR/lua/plugins" ]]; then
        print_success "Directory structure verified"
    else
        print_error "Installation failed: Directory structure incomplete"
        exit 1
    fi
}

# Main installation function
main() {
    echo
    print_status "Starting Neovim configuration installation..."
    echo

    # Check if we're in the right directory
    if [[ ! -f "$SCRIPT_DIR/init.lua" ]]; then
        print_error "This script must be run from the directory containing your Neovim configuration files"
        exit 1
    fi

    # Perform installation steps
    check_config_files
    handle_existing_config
    create_config_dir
    copy_config_files
    set_permissions
    verify_installation

    echo
    print_success "Neovim configuration installed successfully!"
    echo
    print_status "Next steps:"
    echo "  1. Open Neovim with: nvim"
    echo "  2. Lazy.nvim will automatically install plugins on first launch"
    echo "  3. Wait for all plugins to install"
    echo "  4. Restart Neovim to ensure everything is working properly"
    echo
    print_status "Enjoy your new Neovim setup!"
}

# Show help if requested
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "Neovim Configuration Installer"
    echo
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "  -h, --help    Show this help message"
    echo
    echo "This script will:"
    echo "  1. Check for existing Neovim configuration"
    echo "  2. Copy the new configuration to ~/.config/nvim"
    echo "  3. Set proper permissions"
    echo "  4. Verify the installation"
    echo
    exit 0
fi

# Run the main installation
main
