#!/bin/bash
# Instala o compactador de arquivos PeaZip.
# VERSÃO 1.2: Usa a URL mais recente (v10.4.0) encontrada pelo mantenedor.

set -e
log_info() { echo -e "\n🔵 --- $1 ---"; }

# --- Variáveis de Configuração ---
# URL fixa para a versão estável mais recente do PeaZip.
# Encontre novas versões em: https://github.com/peazip/PeaZip/releases
PEAZIP_URL="https://github.com/peazip/PeaZip/releases/download/10.4.0/peazip_10.4.0.LINUX.GTK2-1_amd64.deb"

# --- Início da Instalação ---
log_info "Iniciando a instalação do PeaZip"
TEMP_DOWNLOAD_DIR="/tmp/academix-downloads-$$"
mkdir -p "$TEMP_DOWNLOAD_DIR"

PEAZIP_DEB_PATH="$TEMP_DOWNLOAD_DIR/peazip.deb"

log_info "Baixando o PeaZip (v10.4.0)..."
echo "URL: $PEAZIP_URL"
if ! wget -O "$PEAZIP_DEB_PATH" "$PEAZIP_URL"; then
    echo "❌ ERRO: Falha ao baixar o PeaZip. Verifique a URL no topo do script."
    exit 1
fi

log_info "Instalando o PeaZip..."
if ! sudo apt install -y "$PEAZIP_DEB_PATH"; then
    echo "❌ ERRO: A instalação do PeaZip falhou."
    exit 1
fi

rm -f "$PEAZIP_DEB_PATH"
echo "🎉 PeaZip instalado com sucesso!"
exit 0
