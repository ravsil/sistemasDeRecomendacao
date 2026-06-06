#!/usr/bin/env bash
set -euo pipefail

# Download MovieLens ml-100k zip, extract into the movielens folder, then delete the zip

URL="https://files.grouplens.org/datasets/movielens/ml-100k.zip"
ZIP_NAME="ml-100k.zip"
TARGET_DIR="movielens"

# Work from the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

mkdir -p "$TARGET_DIR"

echo "Downloading $URL..."
if command -v curl >/dev/null 2>&1; then
	curl -L --fail -o "$ZIP_NAME" "$URL"
elif command -v wget >/dev/null 2>&1; then
	wget -O "$ZIP_NAME" "$URL"
else
	echo "Error: neither curl nor wget is installed." >&2
	exit 1
fi

echo "Extracting $ZIP_NAME to $TARGET_DIR/..."
if command -v unzip >/dev/null 2>&1; then
	unzip -o "$ZIP_NAME" -d "$TARGET_DIR"
else
	if command -v python3 >/dev/null 2>&1; then
		python3 - <<PY
import zipfile
with zipfile.ZipFile("$ZIP_NAME") as z:
		z.extractall("$TARGET_DIR")
PY
	else
		echo "Error: neither unzip nor python3 available to extract zip." >&2
		rm -f "$ZIP_NAME"
		exit 1
	fi
fi

echo "Removing $ZIP_NAME..."
rm -f "$ZIP_NAME"

echo "Done!"

