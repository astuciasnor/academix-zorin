#!/bin/bash
# Instala o visualizador de documentos Okular.

set -e
log_info() { echo -e "\n🔵 --- $1 ---"; }

log_info "Iniciando a instalação do Okular"
log_info "Instalando Okular via APT..."

if ! sudo apt-get install -y okular; then
    echo "❌ ERRO: A instalação do Okular falhou."
    exit 1
fi

echo "🎉 Okular instalado com sucesso!"
exit 0
