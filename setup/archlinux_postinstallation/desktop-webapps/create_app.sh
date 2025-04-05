#!/bin/bash

if [ $# -lt 2 ]; then
  echo "Uso: $0 \"Nombre Visible\" URL [ruta_icono]"
  exit 1
fi

APP_NAME="$1"
APP_URL="$2"
CLASS_NAME="${APP_NAME// /}"

if [ -n "$3" ]; then
  ICON_PATH="$3"
else
  ICON_PATH="web-browser"
fi

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
LAUNCH_SCRIPT_PATH="$SCRIPT_DIR/launch.sh"

if [ ! -f "$LAUNCH_SCRIPT_PATH" ]; then
  echo "❌ No se encontró launch.sh en: $SCRIPT_DIR"
  exit 1
fi

DESKTOP_DIR="$HOME/.local/share/applications"
EXEC_COMMAND="\"$LAUNCH_SCRIPT_PATH\" \"$APP_URL\" \"$CLASS_NAME\""
FILE_NAME="${APP_NAME// /_}.desktop"
DESKTOP_FILE_PATH="$DESKTOP_DIR/$FILE_NAME"

mkdir -p "$DESKTOP_DIR"

cat > "$DESKTOP_FILE_PATH" <<EOF
[Desktop Entry]
Name=$APP_NAME
Exec=$EXEC_COMMAND
Icon=$ICON_PATH
Type=Application
Categories=Network;WebBrowser;
StartupWMClass=$CLASS_NAME
EOF

chmod +x "$DESKTOP_FILE_PATH"

echo "✅ App '$APP_NAME' creada en: $DESKTOP_FILE_PATH"
