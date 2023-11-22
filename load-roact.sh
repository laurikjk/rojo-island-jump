#!/bin/bash

BASE_DIR=$(dirname "$0")

PACKAGES_DIR="${BASE_DIR}/src/packages"
ROACT_DIR="${PACKAGES_DIR}/roact"
REPO_URL="git@github.com:Roblox/roact.git"
TEMP_CLONE_DIR="${BASE_DIR}/temp_roact_clone"

if ! command -v git &> /dev/null
then
    echo "Git is not installed. Please install Git and try again."
    exit 1
fi

if [ -d "$ROACT_DIR" ]; then
    echo "Roact folder already exists at ${ROACT_DIR}."
    exit 1
fi

mkdir -p "$PACKAGES_DIR"

echo "Cloning Roact repository..."
if git clone "$REPO_URL" "$TEMP_CLONE_DIR"; then
    echo "Repository cloned successfully."
else
    echo "Failed to clone repository."
    exit 1
fi

echo "Moving Roact src directory to ${ROACT_DIR}..."
mv "${TEMP_CLONE_DIR}/src" "$ROACT_DIR"

echo "Cleaning up..."
rm -rf "$TEMP_CLONE_DIR"

echo "Operation completed successfully."
