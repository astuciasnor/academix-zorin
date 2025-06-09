<p align="center">
  <img src="https://raw.githubusercontent.com/astuciasnor/academix-zorin/main/images/academix_logo.png" alt="Academix-Zorin Logo" width="600"/>
</p>

<h1 align="center">Academix-Zorin</h1>

<p align="center">
  <strong>Robustez, Eficiência e Estilo para sua Jornada Acadêmica.</strong>
</p>

<p align="center">
  <a href="#-o-que-é-o-academix-zorin">Visão Geral</a> •
  <a href="#-instalação-rápida">Instalação</a> •
  <a href="#-programas-instalados">Programas</a> •
  <a href="https://astuciasnor.github.io/academix-zorin/"><strong>📄 Manual Completo</strong></a>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/astuciasnor/academix-zorin/main/images/academix_demo.gif" alt="Academix-Zorin em ação" width="800"/>
</p>

## 🚀 O que é o Academix-Zorin?

**Academix-Zorin** é um projeto de inclusão digital e científica que automatiza a configuração do sistema Zorin OS. Criado para facilitar a vida de estudantes, pesquisadores e professores, ele transforma uma instalação limpa do Zorin em um sistema poderoso e pronto para a produção, sem a necessidade de conhecimento avançado em Linux.

Com um único comando, o Academix-Zorin instala e configura um ambiente completo para produção de textos, análise de dados, edição de imagens e gerenciamento de referências.

---

## ⚡ Instalação Rápida

Para começar, abra o terminal (`Ctrl+Alt+T`) e execute os seguintes comandos. O processo é 100% automático.

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/astuciasnor/academix-zorin.git
    ```

2.  **Entre no diretório do projeto:**
    ```bash
    cd academix-zorin
    ```

3.  **Execute o instalador:**
    ```bash
    ./academix-zorin.sh
    ```
    O script pedirá sua senha de administrador e cuidará de todo o resto. Sente-se, tome um café e veja a mágica acontecer!

---

## 📦 Programas Instalados

O instalador irá configurar os seguintes módulos para você:

### 🎓 Produtividade Acadêmica
- **WPS Office**: Suíte de escritório moderna e compatível (com tradução pt-BR).
- **Zotero**: Gerenciador de referências bibliográficas.
- **Integração Zotero-WPS**: Para citar diretamente nos seus documentos.
- **Okular**: Visualizador de documentos poderoso (PDF, etc.).
- **Xournal++**: Para fazer anotações em PDFs e artigos.

### 🔬 Desenvolvimento Científico
- **R & RStudio**: O ambiente padrão para análise estatística.
- **Python & VS Code**: A combinação mais popular para ciência de dados e desenvolvimento.
- **Quarto**: Sistema de publicação para criar artigos e relatórios.
- **Inkscape**: Editor de gráficos vetoriais para criar figuras com qualidade de publicação.

### 🛠️ Utilitários Essenciais
- **Google Chrome**: Navegador web rápido.
- **Mailspring**: Cliente de e-mail elegante e eficiente.
- **KeePassXC**: Gerenciador de senhas seguro e de código aberto.
- **PeaZip**: Compactador e descompactador de arquivos.
- **Flameshot**: Ferramenta avançada para captura de tela.
- **Pinta**: Editor de imagens simples e rápido.

---

## 🔧 Manutenção e Notas Importantes

Alguns scripts dependem de links de download diretos que podem mudar com o tempo. Se a instalação de um dos programas abaixo falhar no futuro, pode ser necessário atualizar a variável de URL no topo do script correspondente, localizado na pasta `scripts/`:
- `install_r_rstudio.sh` (para o RStudio)
- `install_peazip.sh`
- `install_mailspring.sh`

---

## 📅 Atualizações Futuras (Roadmap)

Este projeto será mantido ativamente. A versão 2.0 planeja incluir:
*   Menu de seleção interativo para escolher quais programas instalar.
*   Suporte a softwares de CAD (FreeCAD/LibreCAD) e LaTeX (TexLive).
*   Um organizador de tarefas e um editor de vídeo.

---

## 🙌 Autor

Desenvolvido por **Evaldo Silva** ([@astuciasnor](https://github.com/astuciasnor)), professor da Universidade Federal do Pará, apaixonado por ciência, educação e software livre.

> "Hoje parece fácil, mas foi preciso dedicação."

---

## 📖 Documentação Completa

Para um guia detalhado sobre cada programa instalado, dicas de uso e tutoriais de pós-instalação (como a configuração do GRUB), consulte nosso manual completo:

### ➡️ **[Acessar o Manual do Usuário Academix-Zorin](https://astuciasnor.github.io/academix-zorin/)**