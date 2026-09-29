#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FLUTTER_VERSION="$(tr -d '[:space:]' < "$ROOT_DIR/.flutter-version")"
FLUTTER_ROOT="${FLUTTER_ROOT:-${HOME}/.cache/sanctumiq/flutter/${FLUTTER_VERSION}}"
FLUTTER_BIN="$FLUTTER_ROOT/bin/flutter"
FLUTTER_ARCHIVE="flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/$FLUTTER_ARCHIVE"

if [[ ! -x "$FLUTTER_BIN" ]]; then
  mkdir -p "$(dirname "$FLUTTER_ROOT")"
  DOWNLOAD_DIR="$(mktemp -d)"
  trap 'rm -rf "$DOWNLOAD_DIR"' EXIT
  echo "Downloading Flutter $FLUTTER_VERSION..."
  curl --fail --location --retry 3 --retry-delay 2 "$FLUTTER_URL" -o "$DOWNLOAD_DIR/$FLUTTER_ARCHIVE"
  mkdir -p "$FLUTTER_ROOT"
  tar -xJf "$DOWNLOAD_DIR/$FLUTTER_ARCHIVE" --strip-components=1 -C "$FLUTTER_ROOT"
fi

export PATH="$FLUTTER_ROOT/bin:$PATH"
flutter --version
flutter config --no-analytics
flutter pub get --enforce-lockfile
flutter build web --release --output "$ROOT_DIR/build/web"
