# Academix-Zorin

**Academix-Zorin** é um projeto voltado para a configuração automática do sistema Zorin OS (base Ubuntu) com foco em uso acadêmico e científico. Ele foi criado para facilitar a vida de estudantes, pesquisadores e professores que desejam um sistema pronto para produção de textos, análise de dados, edição de imagens e gerenciamento de referências, sem a necessidade de conhecimento avançado em Linux.

---

## 🔧 O que este projeto instala?

* Navegador Google Chrome
* WPS Office traduzido para português
* OnlyOffice Desktop
* R + RStudio + Quarto
* Python + VS Code (comvenv)
* Julia
* Zotero + integração com WPS Office
* Geogebra + Pinta (via PPA)
* Flameshot (captura de tela)

---

## 🚀 Como usar

### 1. Requisitos

* Zorin OS instalado (recomenda-se versão Core ou Lite)
* Acesso à Internet
* Espaço livre em disco (cerca de 3 GB para instalação completa)

### 2. Baixar os arquivos:

#### 💾 Scripts

Baixe os scripts de instalação:
[Download dos scripts (.sh)](https://drive.google.com/file/d/1gugdpcYKWfflllb4jltEPgztwnGRD4Dj/view)

#### 🌌 Pacotes pesados (.deb, .tar.gz, .zip)

[Download dos arquivos de instalação](https://drive.google.com/file/d/1g9rfVOP1YuU5g0dvRo9lmwL3Q37UlhjO/view)

### 3. Extração e execução

```bash
mkdir ~/AcademixZorin
cd ~/AcademixZorin
# extraia os dois arquivos compactados aqui
tar -xf scripts_academix_zorin.tar.gz
unzip arquivos_pesados.zip
chmod +x *.sh
./install_all_programs.sh
```

---

## 🔹 Estrutura de Pastas Recomendada

```text
AcademixZorin/
├── install_all_programs.sh
├── limpar_residuos.sh
├── install_gui.sh
├── integrar_zotero_wps.sh
├── install_*.sh  # (todos os outros scripts de instalação)
├── pacotes/
│   ├── google-chrome.deb
│   ├── onlyoffice.deb
│   ├── peazip.deb
│   ├── zotero.tar.bz2
│   ├── ...
└── README.md
```

---

## 📅 Atualizações

Este projeto será atualizado mensalmente para incluir:

* Novas versões de programas
* Melhoria nos scripts
* Integrações adicionais (LibreOffice, LaTeX, editores de PDF etc.)

---

## 🙌 Autor

Desenvolvido por [Evaldo Silva](https://github.com/astuciasnor), professor da Universidade Federal do Pará, apaixonado por ciência, educação e software livre.

---

**Academix-Zorin** – Para que você possa se concentrar no que importa: ensinar, aprender e produzir ciência. 🚀
