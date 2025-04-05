#!/bin/bash

if [ $# -lt 2 ]; then
  echo "Uso: $0 \"Nombre Visible\" URL [ruta_icono]"
  exit 1
fi

APP_NAME="$1"
APP_URL="$2"
CLASS_NAME="${APP_NAME// /}"

if [ -n "$3" ]; then
  ICON_PATH="$(realpath "$3")"
else
  ICON_PATH="web-browser"
fi

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
LAUNCH_SCRIPT_PATH="$SCRIPT_DIR/launch.sh"

if [ ! -f "$LAUNCH_SCRIPT_PATH" ]; then
  echo "❌ No se encontró launch.sh en: $SCRIPT_DIR"
  exit 1
fi

APPS_DIR="$SCRIPT_DIR/apps"
mkdir -p "$APPS_DIR"

APP_LAUNCHER_SH="$APPS_DIR/$CLASS_NAME.sh"
cat > "$APP_LAUNCHER_SH" <<EOF
#!/bin/bash
"$LAUNCH_SCRIPT_PATH" "$APP_URL" "$CLASS_NAME"
EOF
chmod +x "$APP_LAUNCHER_SH"

DESKTOP_DIR="$HOME/.local/share/applications"
FILE_NAME="${APP_NAME// /_}.desktop"
DESKTOP_FILE_PATH="$DESKTOP_DIR/$FILE_NAME"
EXEC_COMMAND="\"$APP_LAUNCHER_SH\""

mkdir -p "$DESKTOP_DIR"

cat > "$DESKTOP_FILE_PATH" <<EOF
[Desktop Entry]
Name=$APP_NAME
Exec=$EXEC_COMMAND
Icon=$ICON_PATH
Type=Application
Categories=Development;
StartupWMClass=$CLASS_NAME
EOF

chmod +x "$DESKTOP_FILE_PATH"

BIN_NAME="${FILE_NAME%.desktop}"
BIN_PATH="/usr/bin/$BIN_NAME"

if [ "$(id -u)" -ne 0 ]; then
  echo "🔐 Se requiere sudo para crear el ejecutable global en /usr/bin..."
  sudo bash -c "echo 'gtk-launch $BIN_NAME' > '$BIN_PATH' && chmod +x '$BIN_PATH'"
  if [ $? -eq 0 ]; then
    echo "🚀 Ejecutable creado en: $BIN_PATH"
  else
    echo "❌ Falló la creación del ejecutable en /usr/bin"
  fi
else
  echo "gtk-launch $BIN_NAME" > "$BIN_PATH"
  chmod +x "$BIN_PATH"
  echo "🚀 Ejecutable creado en: $BIN_PATH"
fi

echo "✅ App '$APP_NAME' creada en: $DESKTOP_FILE_PATH"
echo "📄 Lanzador generado en: $APP_LAUNCHER_SH"
