#!/bin/bash
# Instala o WPS Office e, opcionalmente, aplica a tradução para pt-BR.
# VERSÃO 2.2: Não cria mais o atalho duplicado e verifica a tradução de forma mais inteligente.

set -e

# ... (função log_info e início do script permanecem os mesmos) ...
log_info() {
    echo ""
    echo "🔵 --- $1 ---"
}

# --- Início da Instalação ---
log_info "Iniciando a instalação do WPS Office"
TEMP_DOWNLOAD_DIR="/tmp/academix-downloads-$$"
mkdir -p "$TEMP_DOWNLOAD_DIR"
WPS_DEB_URL="https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/11723/wps-office_11.1.0.11723.XA_amd64.deb"
WPS_DEB_PATH="$TEMP_DOWNLOAD_DIR/wps-office.deb"
log_info "Baixando o pacote de instalação do WPS Office..."
if ! wget -O "$WPS_DEB_PATH" "$WPS_DEB_URL"; then
    echo "❌ ERRO: Falha ao baixar o WPS Office."
    exit 1
fi
log_info "Instalando o WPS Office..."
if ! sudo apt install -y "$WPS_DEB_PATH"; then
    echo "❌ ERRO: A instalação do WPS Office falhou."
    exit 1
fi

log_info "Tradução para Português (Brasil)"
read -p "Deseja instalar a tradução para Português (Brasil)? [S/n] " -n 1 -r
echo

if [[ -z "$REPLY" || "$REPLY" =~ ^[Ss]$ ]]; then
    
    log_info "Instalando a tradução para pt-BR..."
    sudo apt install -y git

    TRANSLATION_REPO_URL="https://github.com/astuciasnor/pt_br-wpsoffice.git"
    TRANSLATION_DIR="$TEMP_DOWNLOAD_DIR/pt_br-wpsoffice"

    log_info "Baixando os arquivos de tradução..."
    if git clone "$TRANSLATION_REPO_URL" "$TRANSLATION_DIR"; then
        
        log_info "Aplicando a tradução..."
        (cd "$TRANSLATION_DIR" && sudo chmod +x install.sh && sudo ./install.sh) || true # O '|| true' ignora o código de erro do script

        # --- NOVA VERIFICAÇÃO INTELIGENTE ---
        # Em vez de confiar no código de saída, verificamos se o trabalho foi feito.
        if [ -d "/opt/kingsoft/wps-office/office6/mui/pt_BR" ]; then
            echo "✅ Verificação bem-sucedida: A pasta de tradução 'pt_BR' foi encontrada."
            echo "A interface do WPS Office deve estar em português."
        else
            echo "⚠️ AVISO: A pasta de tradução 'pt_BR' não foi encontrada após a execução do script. A tradução pode ter falhado."
        fi
    else
        echo "❌ ERRO: Falha ao clonar o repositório de tradução."
    fi
else
    echo "Instalação da tradução pulada."
fi

log_info "Realizando limpeza dos arquivos temporários..."
rm -f "$WPS_DEB_PATH"
if [ -d "$TRANSLATION_DIR" ]; then
    rm -rf "$TRANSLATION_DIR"
fi

echo ""
echo "🎉 WPS Office está pronto para uso!"
exit 0
