#!/bin/bash
# Instala um ambiente Python moderno (via PPA) e o Visual Studio Code (via Repo Oficial).

set -e

# --- Variáveis de Configuração ---
# Escolha a versão do Python que deseja instalar. 3.12 é a mais recente estável no PPA.
PYTHON_VERSION="3.12"

# --- Funções ---
log_info() {
    echo ""
    echo "🔵 --- $1 ---"
}

# --- Início da Execução ---
log_info "Iniciando a instalação do ambiente Python e Visual Studio Code"

# 1. Instalar Python via PPA 'deadsnakes'
log_info "Instalando Python ${PYTHON_VERSION}..."
# O '00-prepare-system.sh' já instalou 'software-properties-common'.
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt-get update
# Instala o python, o pip (via ensurepip), o venv e ferramentas de compilação C para pacotes Python
sudo apt-get install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-venv python3-pip build-essential

# 2. Instalar Visual Studio Code via Repositório Oficial da Microsoft
log_info "Instalando Visual Studio Code..."
# Adicionar a chave GPG da Microsoft
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
rm -f packages.microsoft.gpg
# Adicionar o repositório
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
sudo apt-get update
sudo apt-get install -y code # Instala o VS Code

echo ""
echo "🎉 Ambiente Python e Visual Studio Code instalados com sucesso!"
exit 0
