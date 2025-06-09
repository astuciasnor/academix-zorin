#!/bin/bash
# Instala o GIMP (GNU Image Manipulation Program) a partir de um PPA recomendado.

set -e
log_info() { echo -e "\n🔵 --- $1 ---"; }

log_info "Iniciando a instalação do GIMP"

log_info "Adicionando PPA para a versão mais recente do GIMP..."
# O -y confirma automaticamente a adição do repositório.
sudo add-apt-repository -y ppa:ubuntuhandbook1/gimp
sudo apt-get update

log_info "Instalando GIMP via APT..."
if ! sudo apt-get install -y gimp; then
    echo "❌ ERRO: A instalação do GIMP falhou."
    exit 1
fi

echo "🎉 GIMP instalado com sucesso!"
exit 0
