#!/bin/bash
set -e

# This script updates the Homebrew cask file with the latest release information

VERSION=${1:-$(cat version.txt)}
VERSION_NO_V=${VERSION#v}  # Remove 'v' prefix if present

# Build the release artifact
echo "Building release for version ${VERSION_NO_V}..."
make clean
make release

# Get the SHA256 of the zip file
SHA256=$(shasum -a 256 build/LogseqTodo-${VERSION_NO_V}.zip | awk '{print $1}')

echo "Version: ${VERSION_NO_V}"
echo "SHA256: ${SHA256}"

# Update the cask file from template
sed -e "s/{{VERSION}}/${VERSION_NO_V}/g" \
    -e "s/{{SHA256}}/${SHA256}/g" \
    homebrew/logseq-todo.rb.template > homebrew/logseq-todo.rb

echo "Updated homebrew/logseq-todo.rb with version ${VERSION_NO_V}"