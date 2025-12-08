#!/bin/bash
set -e
BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"
echo "💾 Creating backup at $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"
cp -r lib "$BACKUP_DIR/"
cp -r test "$BACKUP_DIR/"
cp pubspec.yaml "$BACKUP_DIR/"
echo "✅ Backup complete!"
