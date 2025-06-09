# Meu Primeiro Projeto Python no Zorin OS Lite

Este é um projeto de exemplo para você começar a programar em Python no seu novo ambiente.

## Configuração

Este projeto usa um ambiente virtual para gerenciar suas dependências de pacotes Python de forma isolada.

### Ativar o Ambiente Virtual

Para trabalhar neste projeto no terminal, você deve primeiro ativar o ambiente virtual:

```bash
source .venv/bin/activate
```

Após ativar, o terminal exibirá `(.venv)` no prompt.

### Desativar o Ambiente Virtual

Quando terminar de trabalhar no projeto, você pode desativar o ambiente virtual:

```bash
deactivate
```

## Rodar o Projeto

Para executar o arquivo principal:

```bash
python main.py
```

## Bibliotecas Pre-instaladas

As seguintes bibliotecas foram instaladas automaticamente neste ambiente virtual:

*   `pandas` (para manipulação de dados)
*   `matplotlib` (para criação de gráficos)
*   `jupyterlab` (para notebooks interativos)

## Abrir no VS Code

No terminal, estando dentro do diretório `~/PythonProjects/my_first_project`, você pode abrir o projeto no VS Code com:

```bash
code .
```

**Dica para VS Code:** Na primeira vez que você abrir este projeto no VS Code, ele pode perguntar qual interpretador Python usar. Selecione a opção que aponta para `.venv/bin/python` dentro do seu projeto para garantir que o VS Code utilize o ambiente virtual recém-criado.
