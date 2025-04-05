#!/bin/bash

if [ $# -lt 3 ]; then
  echo "Uso: $0 \"Nombre Visible\" URL class_name"
  exit 1
fi

APP_NAME="$1"
APP_URL="$2"
CLASS_NAME="$3"

DESKTOP_DIR="$HOME/.local/share/applications"
LAUNCH_SCRIPT_PATH="$(realpath launch.sh)"
EXEC_COMMAND="$LAUNCH_SCRIPT_PATH \"$APP_URL\" \"$CLASS_NAME\""
ICON_NAME="web-browser" # puedes cambiarlo o dejarlo genérico
FILE_NAME="${APP_NAME// /_}.desktop" # reemplaza espacios por guiones bajos
DESKTOP_FILE_PATH="$DESKTOP_DIR/$FILE_NAME"

mkdir -p "$DESKTOP_DIR"

cat > "$DESKTOP_FILE_PATH" <<EOF
[Desktop Entry]
Name=$APP_NAME
Exec=$EXEC_COMMAND
Icon=$ICON_NAME
Type=Application
Categories=Network;WebBrowser;
StartupWMClass=$CLASS_NAME
EOF

chmod +x "$DESKTOP_FILE_PATH"

echo "✅ App '$APP_NAME' creada en: $DESKTOP_FILE_PATH"
