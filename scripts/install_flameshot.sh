#!/bin/bash
# Instala a ferramenta de captura de tela Flameshot via Flatpak.

set -e
log_info() { echo -e "\n🔵 --- $1 ---"; }

log_info "Iniciando a instalação do Flameshot via Flatpak"

log_info "Garantindo que o Flatpak e o Flathub estejam configurados..."
if ! command -v flatpak &> /dev/null; then
    sudo apt install -y flatpak
fi
if ! flatpak remotes | grep -q flathub; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

log_info "Instalando Flameshot..."
if ! flatpak install -y flathub org.flameshot.Flameshot; then
    echo "❌ ERRO: Falha ao instalar Flameshot via Flatpak."
    exit 1
fi

echo "🎉 Flameshot instalado com sucesso!"
echo "Dica: Configure um atalho de teclado para o comando 'flameshot gui'."
exit 0
