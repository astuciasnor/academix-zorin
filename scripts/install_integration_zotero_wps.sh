#!/bin/bash
# Tenta instalar a integração do Zotero com o WPS Office.
# Usa um fork do repositório para garantir estabilidade.

set -e

log_info() {
    echo ""
    echo "🔵 --- $1 ---"
}

# --- Início da Instalação da Integração ---
log_info "Iniciando a instalação da integração Zotero-WPS"

# Diretório temporário para não sujar o sistema
TEMP_DOWNLOAD_DIR="/tmp/academix-downloads-$$"
mkdir -p "$TEMP_DOWNLOAD_DIR"

# 1. Verificação de Pré-requisitos (Opcional, mas boa prática)
log_info "Verificando se WPS e Zotero parecem estar instalados..."

if ! command -v wps &> /dev/null; then
    echo "⚠️ AVISO: O comando 'wps' não foi encontrado. A integração pode falhar."
fi

if ! command -v flatpak &> /dev/null || ! flatpak list | grep -q org.zotero.Zotero; then
    echo "⚠️ AVISO: A instalação Flatpak do Zotero não foi encontrada. A integração pode falhar."
fi


# 2. Instalar dependências para o script de integração
log_info "Instalando dependências necessárias (python3, unzip)..."
sudo apt-get install -y python3 python3-pip unzip


# 3. Clonar o SEU fork do repositório de integração
log_info "Baixando os arquivos de integração do seu repositório..."
INTEGRATION_REPO_URL="https://github.com/astuciasnor/WPS-Zotero.git"
INTEGRATION_DIR="$TEMP_DOWNLOAD_DIR/WPS-Zotero"

if ! git clone "$INTEGRATION_REPO_URL" "$INTEGRATION_DIR"; then
    echo "❌ ERRO: Falha ao clonar o repositório de integração. Verifique a URL do fork."
    exit 1
fi

# 4. Executar o instalador do plugin
log_info "Tentando executar o script de instalação do plugin (install.py)..."
# Vamos executar o script de python. A saída nos dirá se ele funcionou.
# Usamos 'cd' dentro de um subshell '()' para não afetar o resto do script.
if (cd "$INTEGRATION_DIR" && python3 install.py); then
    echo "✅ Script de instalação da integração executado."
    echo "Se não houveram erros acima, a integração deve estar funcionando."
else
    echo "❌ ERRO: O script 'install.py' terminou com um erro."
    echo "A integração provavelmente falhou. Verifique as mensagens acima para mais detalhes."
    # Não usamos 'exit 1' aqui para que o script principal possa continuar, se desejado.
fi


# 5. Limpeza Final
log_info "Realizando limpeza dos arquivos temporários..."
if [ -d "$INTEGRATION_DIR" ]; then
    rm -rf "$INTEGRATION_DIR"
fi

echo ""
echo "🎉 Tentativa de integração Zotero-WPS concluída!"
exit 0
