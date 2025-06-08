#!/bin/bash
# Instala o cliente de e-mail Mailspring.

set -e
log_info() { echo -e "\n🔵 --- $1 ---"; }

log_info "Iniciando a instalação do Mailspring"
TEMP_DOWNLOAD_DIR="/tmp/academix-downloads-$$"
mkdir -p "$TEMP_DOWNLOAD_DIR"

# URL de download do .deb do Mailspring.
MAILSPRING_URL="https://updates.getmailspring.com/download?platform=linuxDeb"
MAILSPRING_DEB_PATH="$TEMP_DOWNLOAD_DIR/mailspring.deb"

log_info "Baixando o pacote .deb do Mailspring..."
# Usamos a opção -L no wget para seguir redirecionamentos, que é como o link deles funciona.
if ! wget -O "$MAILSPRING_DEB_PATH" "$MAILSPRING_URL"; then
    echo "❌ ERRO: Falha ao baixar o Mailspring."
    exit 1
fi

log_info "Instalando o Mailspring..."
if ! sudo apt install -y "$MAILSPRING_DEB_PATH"; then
    echo "❌ ERRO: A instalação do Mailspring falhou."
    exit 1
fi

rm -f "$MAILSPRING_DEB_PATH"
echo "🎉 Mailspring instalado com sucesso!"
exit 0
