#!/bin/bash
# ==============================================================================
#
#    █████╗  █████╗  █████╗ ██████╗ ███████╗███╗   ███╗██╗██╗  ██╗
#   ██╔══██╗██╔══  ╗██╔══██╗██╔══██╗██╔════╝████╗ ████║██║╚██╗██╔╝
#   ███████║██║    ║███████║██║  ██║█████╗  ██╔████╔██║██║ ╚███╔╝
#   ██╔══██║██║    ║██╔══██║██║  ██║██╔══╝  ██║╚██╔╝██║██║ ██╔██╗
#   ██║  ██║╚█████╔╝██║  ██║██████╔╝███████╗██║ ╚═╝ ██║██║██╔╝ ██╗
#   ╚═╝  ╚═╝ ╚════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝     ╚═╝╚═╝╚═╝  ╚═╝
#
#              -- ZORIN OS SCRIPT DE INSTALAÇÃO v1.0 --
#
#   Este script automatiza a preparação do sistema e a instalação
#   de um ambiente completo para produtividade e desenvolvimento.
#
#   Projeto: https://github.com/astuciasnor/academix-zorin
#
# ==============================================================================

# Sai imediatamente se qualquer comando falhar, garantindo a integridade.
set -e

# --- Funções de Logging e Execução ---

# Função para imprimir cabeçalhos e tornar a saída mais legível
log_header() {
    echo ""
    echo "=============================================================================="
    echo "=> $1"
    echo "=============================================================================="
}

# Função para executar um sub-script, verificando sua existência e o resultado
run_script() {
    # Argumentos: 1: nome do arquivo .sh, 2: descrição do programa
    local script_basename="$1"
    local description="$2"

    # Constrói o caminho completo para o script dentro da pasta 'scripts/'
    local script_path="scripts/${script_basename}"

    log_header "Iniciando: $description"
    
    if [ ! -f "$script_path" ]; then
        echo "⚠️  AVISO: Script '$script_path' não encontrado. Pulando esta etapa."
        return 0
    fi
    
    # Damos permissão de execução e rodamos o script usando seu caminho completo
    if chmod +x "$script_path" && ./"$script_path"; then
        echo "✅ SUCESSO: '$description' foi concluído."
    else
        echo "❌ ERRO FATAL: A execução de '$script_path' falhou. Abortando o processo."
        exit 1
    fi
}


# --- Início da Execução do Script Mestre ---

clear
echo '

    █████╗  █████╗  █████╗ ██████╗ ███████╗███╗   ███╗██╗██╗  ██╗
   ██╔══██╗██╔══  ╗██╔══██╗██╔══██╗██╔════╝████╗ ████║██║╚██╗██╔╝
   ███████║██║    ║███████║██║  ██║█████╗  ██╔████╔██║██║ ╚███╔╝
   ██╔══██║██║    ║██╔══██║██║  ██║██╔══╝  ██║╚██╔╝██║██║ ██╔██╗
   ██║  ██║╚█████╔╝██║  ██║██████╔╝███████╗██║ ╚═╝ ██║██║██╔╝ ██╗
   ╚═╝  ╚═╝ ╚════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝     ╚═╝╚═╝╚═╝  ╚═╝
'
echo "              -- ZORIN OS SCRIPT DE INSTALAÇÃO v1.0 --"
echo ""
echo "Bem-vindo ao instalador automatizado do Academix-Zorin!"
echo "Este processo irá configurar seu sistema com as melhores ferramentas"
echo "para produtividade e desenvolvimento científico."
echo ""
read -p "Pressione [ENTER] para começar ou [CTRL+C] para cancelar..."

# --- Ordem de Execução dos Módulos ---
run_script "00-prepare-system.sh" "Preparação e Limpeza do Sistema"
run_script "install_wps.sh"       "Suíte de Escritório (WPS Office)"
run_script "install_zotero.sh"    "Gerenciador de Referências (Zotero)"
run_script "install_integration_zotero_wps.sh" "Integração Zotero-WPS"
run_script "install_r_rstudio.sh" "Ambiente R e RStudio"
run_script "install_quarto.sh"    "Sistema de Publicação (Quarto)"
run_script "install_python_vscode.sh" "Ambiente Python e VS Code"
run_script "install_chrome.sh"    "Navegador Web (Google Chrome)"
run_script "install_mailspring.sh" "Cliente de E-mail (Mailspring)"
run_script "install_okular.sh"    "Visualizador de Documentos (Okular)"
run_script "install_peazip.sh"    "Compactador de Arquivos (PeaZip)"
run_script "install_pinta.sh"     "Editor de Imagens Simples (Pinta)"
run_script "install_gimp.sh"      "Editor de Imagens Avançado (GIMP)" # <-- GIMP ADICIONADO
run_script "install_xournalpp.sh" "Anotação de PDF e Quadro Branco (Xournal++)"
run_script "install_inkscape.sh"  "Editor de Gráficos Vetoriais (Inkscape)"
run_script "install_keepassxc.sh" "Gerenciador de Senhas (KeePassXC)"

# --- Finalização ---
log_header "PROCESSO CONCLUÍDO"
echo ""
echo "🎉 Todos os módulos da v1.0 foram instalados com sucesso!"
echo "É altamente recomendável reiniciar o seu computador para garantir"
echo "que todas as alterações e configurações sejam aplicadas corretamente."
echo ""
echo "Obrigado por usar o Academix-Zorin!"
echo ""

exit 0