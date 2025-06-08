#!/bin/bash
# Instala o Zotero via Flatpak, o método recomendado para Linux.

set -e

log_info() {
    echo ""
    echo "🔵 --- $1 ---"
}

# --- Início da Instalação ---
log_info "Iniciando a instalação do Zotero via Flatpak"

# 1. Garantir que o Flatpak esteja instalado
# Verificamos se o comando 'flatpak' existe. O '&> /dev/null' suprime a saída.
if ! command -v flatpak &> /dev/null; then
    log_info "Flatpak não encontrado. Instalando..."
    sudo apt update
    sudo apt install -y flatpak
    echo "✅ Flatpak instalado."
else
    echo "Flatpak já está instalado."
fi

# 2. Adicionar o repositório Flathub (a principal loja de apps Flatpak)
# Verificamos se o 'flathub' já está na lista de repositórios remotos.
if ! flatpak remotes | grep -q flathub; then
    log_info "Adicionando o repositório Flathub..."
    # O '--if-not-exists' é uma segurança extra.
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    echo "✅ Repositório Flathub adicionado."
else
    echo "Repositório Flathub já está configurado."
fi

# 3. Instalar o Zotero
log_info "Instalando Zotero do Flathub..."
# O '-y' no final responde "sim" automaticamente para a instalação.
if flatpak install -y flathub org.zotero.Zotero; then
    echo "✅ Instalação do Zotero concluída com sucesso."
else
    echo "❌ ERRO: Falha ao instalar Zotero via Flatpak."
    exit 1
fi

echo ""
echo "🎉 Zotero está pronto para uso!"
echo "Você pode encontrá-lo no menu de aplicativos."

exit 0
