#!/bin/bash
# Instala o editor de imagens Pinta via Flatpak, o método mais confiável.
# VERSÃO 2.0: Final para o lançamento v1.0.

set -e
log_info() { echo -e "\n🔵 --- $1 ---"; }

log_info "Iniciando a instalação do Pinta via Flatpak"

log_info "Garantindo que o Flatpak e o Flathub estejam configurados..."
if ! command -v flatpak &> /dev/null; then
    sudo apt-get install -y flatpak
fi
if ! flatpak remotes | grep -q flathub; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

log_info "Instalando Pinta do Flathub..."
if ! flatpak install -y flathub com.github.PintaProject.Pinta; then
    echo "❌ ERRO: Falha ao instalar Pinta via Flatpak."
    exit 1
fi

echo "🎉 Pinta instalado com sucesso!"
exit 0
