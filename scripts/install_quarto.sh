#!/bin/bash
# Instala a versão mais recente do Quarto automaticamente.

set -e

log_info() {
    echo ""
    echo "🔵 --- $1 ---"
}

log_info "Iniciando a instalação do Quarto"
TEMP_DOWNLOAD_DIR="/tmp/academix-downloads-$$"
mkdir -p "$TEMP_DOWNLOAD_DIR"

# 1. Encontrar a URL da versão mais recente via API do GitHub
log_info "Buscando a URL de download da versão mais recente do Quarto..."
# Este comando usa 'curl' para consultar a API, 'grep' para filtrar a linha do .deb e 'cut' para extrair a URL.
QUARTO_URL=$(curl -s https://api.github.com/repos/quarto-dev/quarto-cli/releases/latest | grep "browser_download_url.*amd64.deb" | cut -d '"' -f 4)

if [ -z "$QUARTO_URL" ]; then
    echo "❌ ERRO: Não foi possível encontrar a URL de download do Quarto. A API do GitHub pode estar offline ou o padrão mudou."
    exit 1
fi
echo "URL encontrada: $QUARTO_URL"

# 2. Baixar e Instalar o Quarto
QUARTO_DEB_PATH="$TEMP_DOWNLOAD_DIR/quarto-latest.deb"

log_info "Baixando Quarto..."
if ! wget -O "$QUARTO_DEB_PATH" "$QUARTO_URL"; then
    echo "❌ ERRO: Falha ao baixar o Quarto."
    exit 1
fi

log_info "Instalando Quarto..."
if ! sudo apt install -y "$QUARTO_DEB_PATH"; then
    echo "❌ ERRO: A instalação do Quarto falhou."
    exit 1
fi

# 3. Limpeza
rm -f "$QUARTO_DEB_PATH"

echo ""
echo "🎉 Quarto instalado com sucesso!"
exit 0
