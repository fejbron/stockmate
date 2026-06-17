#!/usr/bin/env bash
#
# testflight.sh — build, sign, and upload the iOS app to TestFlight from the CLI.
#
# One-time setup
# --------------
# 1. In App Store Connect → Users and Access → Integrations → App Store Connect
#    API, create a key with the "App Manager" role. Download the .p8 (you can
#    only download it once) and note the Key ID and Issuer ID.
# 2. Put the key where Apple tools auto-discover it:
#       mkdir -p ~/.appstoreconnect/private_keys
#       mv ~/Downloads/AuthKey_XXXXXXXXXX.p8 ~/.appstoreconnect/private_keys/
# 3. Create scripts/.asc.env (gitignored) with your IDs:
#       ASC_KEY_ID=XXXXXXXXXX
#       ASC_ISSUER_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
#    (ASC_KEY_PATH is optional; defaults to the path from step 2.)
#
# Usage
# -----
#   scripts/testflight.sh            # build + upload using pubspec build number
#   scripts/testflight.sh 4          # set build number to 4 first, then upload
#
# Requires: a paid Apple Developer Program membership and an app record for the
# bundle id (com.stockmate) already created in App Store Connect.

set -euo pipefail

# --- locate project root (this script lives in <project>/scripts) ------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_DIR"

# --- load credentials --------------------------------------------------------
if [[ -f "$SCRIPT_DIR/.asc.env" ]]; then
  # shellcheck disable=SC1091
  source "$SCRIPT_DIR/.asc.env"
fi

: "${ASC_KEY_ID:?Set ASC_KEY_ID (env or scripts/.asc.env)}"
: "${ASC_ISSUER_ID:?Set ASC_ISSUER_ID (env or scripts/.asc.env)}"
ASC_KEY_PATH="${ASC_KEY_PATH:-$HOME/.appstoreconnect/private_keys/AuthKey_${ASC_KEY_ID}.p8}"

if [[ ! -f "$ASC_KEY_PATH" ]]; then
  echo "ERROR: API key not found at: $ASC_KEY_PATH" >&2
  echo "       See the setup notes at the top of this script." >&2
  exit 1
fi

# --- optional build-number bump ---------------------------------------------
if [[ "${1:-}" =~ ^[0-9]+$ ]]; then
  NEW_BUILD="$1"
  echo "==> Setting build number to $NEW_BUILD in pubspec.yaml"
  # version line looks like: version: 1.0.0+3
  /usr/bin/sed -i '' -E "s/^(version: [0-9]+\.[0-9]+\.[0-9]+)\+[0-9]+/\1+${NEW_BUILD}/" pubspec.yaml
fi
echo "==> $(grep '^version:' pubspec.yaml)"

ARCHIVE_PATH="$PROJECT_DIR/build/ios/archive/Runner.xcarchive"

echo "==> Regenerating Flutter Xcode config (release)"
flutter build ios --config-only --release

echo "==> Archiving"
rm -rf "$ARCHIVE_PATH"
xcodebuild -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath "$ARCHIVE_PATH" \
  -allowProvisioningUpdates \
  archive

echo "==> Exporting + uploading to TestFlight"
xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportOptionsPlist ios/ExportOptions.plist \
  -exportPath "$PROJECT_DIR/build/ios/ipa" \
  -allowProvisioningUpdates \
  -authenticationKeyPath "$ASC_KEY_PATH" \
  -authenticationKeyID "$ASC_KEY_ID" \
  -authenticationKeyIssuerID "$ASC_ISSUER_ID"

echo "==> Done. The build will appear in App Store Connect → TestFlight after processing."
