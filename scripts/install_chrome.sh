#!/bin/bash
# Instala o navegador Google Chrome.

set -e
log_info() { echo -e "\n🔵 --- $1 ---"; }

log_info "Iniciando a instalação do Google Chrome"
TEMP_DOWNLOAD_DIR="/tmp/academix-downloads-$$"
mkdir -p "$TEMP_DOWNLOAD_DIR"

CHROME_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
CHROME_DEB_PATH="$TEMP_DOWNLOAD_DIR/chrome.deb"

log_info "Baixando o Google Chrome..."
if ! wget -O "$CHROME_DEB_PATH" "$CHROME_URL"; then
    echo "❌ ERRO: Falha ao baixar o Google Chrome."
    exit 1
fi

log_info "Instalando o Google Chrome..."
if ! sudo apt install -y "$CHROME_DEB_PATH"; then
    echo "❌ ERRO: A instalação do Google Chrome falhou."
    exit 1
fi

rm -f "$CHROME_DEB_PATH"
echo "🎉 Google Chrome instalado com sucesso!"
exit 0
