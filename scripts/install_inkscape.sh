#!/bin/bash
# Instala o editor de gráficos vetoriais Inkscape.

set -e
log_info() { echo -e "\n🔵 --- $1 ---"; }

log_info "Iniciando a instalação do Inkscape"
log_info "Instalando Inkscape via APT..."

if ! sudo apt-get install -y inkscape; then
    echo "❌ ERRO: A instalação do Inkscape falhou."
    exit 1
fi

echo "🎉 Inkscape instalado com sucesso!"
exit 0
