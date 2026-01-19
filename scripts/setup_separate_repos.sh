#!/bin/bash
# Script to create separate repositories for pub.dev publishing
# Run this from the NearFlutter root directory

set -e

echo "=== NEAR Flutter SDK - Separate Repos Setup ==="
echo ""
echo "This script will create 3 separate repositories:"
echo "  1. near_jsonrpc_types"
echo "  2. near_jsonrpc_client"
echo "  3. near_wallet_adapter"
echo ""

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    echo "ERROR: GitHub CLI (gh) is not installed."
    echo "Install it from: https://cli.github.com/"
    exit 1
fi

# Check if logged in
if ! gh auth status &> /dev/null; then
    echo "ERROR: Not logged in to GitHub CLI."
    echo "Run: gh auth login"
    exit 1
fi

BASE_DIR=$(pwd)
PACKAGES_DIR="$BASE_DIR/packages"
OUTPUT_DIR="$BASE_DIR/../near_flutter_packages"

echo "Creating output directory: $OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# Function to setup a package repo
setup_package_repo() {
    local PACKAGE_NAME=$1
    local PACKAGE_DIR="$PACKAGES_DIR/$PACKAGE_NAME"
    local REPO_DIR="$OUTPUT_DIR/$PACKAGE_NAME"

    echo ""
    echo "=== Setting up $PACKAGE_NAME ==="

    # Copy package to new directory
    echo "Copying package files..."
    rm -rf "$REPO_DIR"
    cp -r "$PACKAGE_DIR" "$REPO_DIR"

    # Remove workspace resolution from pubspec if present
    cd "$REPO_DIR"
    if grep -q "resolution: workspace" pubspec.yaml; then
        sed -i '/resolution: workspace/d' pubspec.yaml
    fi

    # Initialize git repo
    echo "Initializing git repository..."
    git init
    git add .
    git commit -m "Initial release v0.1.0"

    # Create GitHub repo
    echo "Creating GitHub repository..."
    gh repo create "0xjesus/$PACKAGE_NAME" --public --source=. --push \
        --description "$(grep 'description:' pubspec.yaml | sed 's/description: //')"

    echo "✓ $PACKAGE_NAME repository created: https://github.com/0xjesus/$PACKAGE_NAME"
}

# Setup each package (order matters for dependencies)
setup_package_repo "near_jsonrpc_types"
setup_package_repo "near_jsonrpc_client"
setup_package_repo "near_wallet_adapter"

echo ""
echo "=== All repositories created! ==="
echo ""
echo "Next steps:"
echo "1. Go to https://pub.dev/packages/create"
echo "2. For each package, run: dart pub publish"
echo ""
echo "Publishing order (important!):"
echo "  1. near_jsonrpc_types (no dependencies)"
echo "  2. near_jsonrpc_client (depends on types)"
echo "  3. near_wallet_adapter (depends on both)"
echo ""
echo "Make sure your pub.dev account is linked to 0xj.dev publisher!"
