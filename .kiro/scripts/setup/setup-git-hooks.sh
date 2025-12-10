#!/bin/bash
# Setup git hooks

set -e

echo "🪝 Setting up git hooks..."

# Make hooks executable
chmod +x .githooks/*

# Configure git to use .githooks directory
git config core.hooksPath .githooks

echo "✅ Git hooks configured!"
