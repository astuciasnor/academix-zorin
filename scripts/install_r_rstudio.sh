#!/bin/bash
# Instala o ambiente R completo, RStudio e dependências de compilação.
# VERSÃO 1.3: Reintroduz a instalação da fonte Cascadia Code.

set -e

# --- Variáveis de Configuração ---
RSTUDIO_URL="https://download1.rstudio.org/electron/jammy/amd64/rstudio-2025.05.1-513-amd64.deb"
TEMP_DOWNLOAD_DIR="/tmp/academix-downloads-$$"

# --- Funções ---
log_info() {
    echo ""
    echo "🔵 --- $1 ---"
}

# --- Início da Execução ---
log_info "Iniciando a instalação do R, RStudio e dependências"
mkdir -p "$TEMP_DOWNLOAD_DIR"

# 1. Preparar o sistema e adicionar o repositório CRAN
log_info "Configurando o repositório oficial do R (CRAN)..."
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo gpg --dearmor -o /usr/share/keyrings/cran.gpg
echo "deb [signed-by=/usr/share/keyrings/cran.gpg] https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" | sudo tee /etc/apt/sources.list.d/cran.list
sudo apt-get update

# 2. Instalar a versão mais recente do R e ferramentas de desenvolvimento
log_info "Instalando R (r-base) e ferramentas de desenvolvimento (r-base-dev)..."
sudo apt-get install -y r-base r-base-dev

# 3. Instalar bibliotecas de sistema e fontes
log_info "Instalando bibliotecas de sistema e fontes recomendadas..."
sudo apt-get install -y \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  libgit2-dev \
  libpng-dev \
  libjpeg-dev \
  libcairo2-dev \
  libpango1.0-dev \
  libharfbuzz-dev \
  libfribidi-dev \
  libfreetype6-dev \
  libtiff5-dev \
  libwebp-dev \
  libfontconfig1-dev \
  libudunits2-dev \
  libgdal-dev \
  libgeos-dev \
  libproj-dev \
  libpq-dev \
  libssh2-1-dev \
  libopenblas-dev \
  liblapack-dev \
  gfortran \
  fonts-cascadia-code # <-- FONTE ADICIONADA AQUI

# 4. Baixar e Instalar a versão mais recente do RStudio
log_info "Baixando a versão mais recente do RStudio Desktop..."
RSTUDIO_DEB_PATH="$TEMP_DOWNLOAD_DIR/rstudio-latest.deb"

if ! wget -O "$RSTUDIO_DEB_PATH" "$RSTUDIO_URL"; then
    echo "❌ ERRO: Falha ao baixar o RStudio. Verifique a URL no topo do script."
    exit 1
fi

log_info "Instalando o RStudio..."
if ! sudo apt install -y "$RSTUDIO_DEB_PATH"; then
    echo "❌ ERRO: A instalação do RStudio falhou."
    exit 1
fi

# 5. Limpeza do arquivo de instalação
log_info "Limpando arquivos temporários..."
rm -f "$RSTUDIO_DEB_PATH"

echo ""
echo "🎉 Ambiente R e RStudio instalado com sucesso!"
exit 0
