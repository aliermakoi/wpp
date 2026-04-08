#!/usr/bin/env bash
set -euo pipefail

# Install Python dependencies for PDF extraction.
python -m pip install -r requirements.txt

echo "Python dependencies installed."
echo "Flutter SDK must also be installed separately if not already available:"
echo "  https://docs.flutter.dev/get-started/install"
