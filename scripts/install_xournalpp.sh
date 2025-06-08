#!/bin/bash
# Instala o software de anotação em PDF e quadro branco Xournal++.

set -e
log_info() { echo -e "\n🔵 --- $1 ---"; }

log_info "Iniciando a instalação do Xournal++"
log_info "Instalando Xournal++ via APT (versão estável do repositório)..."

if ! sudo apt-get install -y xournalpp; then
    echo "❌ ERRO: A instalação do Xournal++ falhou."
    exit 1
fi

echo "🎉 Xournal++ instalado com sucesso!"
exit 0
