#!/bin/bash
# Instala o gerenciador de senhas KeePassXC via Flatpak.
# VERSÃO 2.0: Migrado de PPA (descontinuado) para Flatpak.

set -e
log_info() { echo -e "\n🔵 --- $1 ---"; }

log_info "Iniciando a instalação do KeePassXC via Flatpak"

log_info "Garantindo que o Flatpak e o Flathub estejam configurados..."
if ! command -v flatpak &> /dev/null; then
    sudo apt-get install -y flatpak
fi
if ! flatpak remotes | grep -q flathub; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

log_info "Instalando KeePassXC do Flathub..."
if ! flatpak install -y flathub org.keepassxc.KeePassXC; then
    echo "❌ ERRO: Falha ao instalar KeePassXC via Flatpak."
    exit 1
fi

echo "🎉 KeePassXC instalado com sucesso!"
exit 0
