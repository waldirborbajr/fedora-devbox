#!/usr/bin/env bash
# install.sh
INSTALL_DIR="/opt/devbox"
mkdir -p "$INSTALL_DIR"
cp -r . "$INSTALL_DIR"
chmod +x "$INSTALL_DIR"/*.sh "$INSTALL_DIR"/lib/*.sh "$INSTALL_DIR"/langs/*.sh
ln -sf "$INSTALL_DIR/start.sh" /usr/local/bin/devbox
echo "Devbox instalado! Agora basta digitar 'devbox' no terminal."