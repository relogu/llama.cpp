#!/usr/bin/env bash
# Setup script for flwr-model GGUF conversion

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="${SCRIPT_DIR}/.venv"

echo "Setting up llama.cpp environment for flwr-model GGUF conversion..."
echo ""

# Create venv
if [[ ! -d "$VENV_DIR" ]]; then
    echo "Creating Python venv at $VENV_DIR..."
    python3 -m venv "$VENV_DIR"
else
    echo "Using existing venv at $VENV_DIR"
fi

# Install conversion dependencies
echo "Installing conversion dependencies..."
"$VENV_DIR/bin/pip" install --upgrade pip -q
"$VENV_DIR/bin/pip" install -r "$SCRIPT_DIR/requirements/requirements-convert_hf_to_gguf.txt" -q

# Reinstall gguf from local source (with Lizzy patches)
echo "Installing patched gguf package..."
"$VENV_DIR/bin/pip" install -e "$SCRIPT_DIR/gguf-py/" --force-reinstall --no-deps -q

echo ""
echo "✓ Setup complete!"
echo ""
echo "Usage:"
echo "  Source this script: source $SCRIPT_DIR/setup_flwr_env.sh"
echo "  Or use venv Python: $VENV_DIR/bin/python convert_hf_to_gguf.py ..."
echo ""
echo "Example:"
echo "  $VENV_DIR/bin/python convert_hf_to_gguf.py \\"
echo "    --outfile output.gguf \\"
echo "    --outtype f16 \\"
echo "    /path/to/lizzy-model"
