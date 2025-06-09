#!/bin/bash
# Script para preparar um sistema Zorin OS Lite recém-instalado.
# VERSÃO 1.4: Adiciona 'git' à lista de dependências essenciais.

set -e

log_info() {
    echo ""
    echo "🔵 --- $1 ---"
}

# --- SEÇÃO 1: LIMPEZA DE REPOSITÓRIOS DE TERCEIROS (PPAs) ---
log_info "Verificando e removendo PPAs quebrados ou obsoletos..."
PPA_FILE_PATH="/etc/apt/sources.list.d/pinta-maintainers-ubuntu-pinta-stable-jammy.list"
if [ -f "$PPA_FILE_PATH" ]; then
    echo "PPA quebrado do Pinta encontrado. Removendo manualmente..."
    sudo rm -f "$PPA_FILE_PATH"
    echo "✅ Arquivo do PPA removido com sucesso."
else
    echo "PPA do Pinta não encontrado, nenhuma remoção necessária."
fi


# --- SEÇÃO 2: ATUALIZAÇÃO E INSTALAÇÃO DE DEPENDÊNCIAS ---
log_info "Atualizando listas de pacotes e instalando ferramentas essenciais..."
sudo apt-get update
ESSENTIAL_PACKAGES=(
    "curl"
    "wget"
    "git"  # <-- GIT ADICIONADO AQUI
    "software-properties-common"
    "apt-transport-https"
    "ca-certificates"
    "gnupg"
)
sudo apt-get install -y "${ESSENTIAL_PACKAGES[@]}"
echo "✅ Ferramentas essenciais instaladas."


# --- SEÇÃO 3: REMOÇÃO DE SOFTWARE PRÉ-INSTALADO ---
log_info "Removendo softwares padrão indesejados"
PACKAGES_TO_REMOVE=(
    "libreoffice*"
    "aisleriot"
    "gnome-mahjongg"
    "gnome-mines"
    "gnome-sudoku"
    "thunderbird"
)
sudo apt-get purge -y "${PACKAGES_TO_REMOVE[@]}" || true
log_info "Limpando dependências órfãs..."
sudo apt-get autoremove -y || true
echo "✅ Limpeza de software concluída."


echo ""
echo "🎉 O sistema está preparado e pronto para as instalações do Academix!"
exit 0
