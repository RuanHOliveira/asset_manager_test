# 📱 Asset Manager

## Projeto desenvolvido para desafiio técnico em processo seletivo

## 📌 Sobre o Projeto

O Asset Manager é uma aplicação desenvolvida para gerenciar equipamentos através da leitura de QR Codes. Ele permite cadastrar equipamentos, vinculá-los a usuários e realizar inventários de forma rápida e eficiente.

## 🚀 Funcionalidades

### 🔑 Login

- A aplicação inicia na tela de login, onde o usuário pode utilizar CPF e senha para acessar.

- Existe um usuário administrador padrão:

  - CPF: 99999999999

  - Senha: 123456

- É possível cadastrar novos usuários, que serão, por padrão, usuários comuns com acesso limitado.

- Durante o cadastro, são exigidos os seguintes campos:

  - Nome

  - CPF

  - Senha e confirmação da senha

- Após a validação dos dados, o usuário é cadastrado e redirecionado para a tela de login.

- Após o preenchimento e autenticação das credencias no login, o usuário é direcionado para a tela de listagem de equipamentos vinculados.

### 📋 Listagem de Equipamentos Vinculados

- Exibe todos os equipamentos vinculados ao usuário logado.

- Cada equipamento é apresentado com:

  - Nome do equipamento

  - Código do equipamento

  - Data do último inventário, se houver

- Indicação do status do inventário:

  - Válido ✅: Último inventário realizado nos últimos 30 dias.

  - Inválido ❌: Último inventário realizado há mais de 30 dias.

- O usuário pode realizar um novo inventário:

  - Ao clicar no botão, a câmera é aberta para leitura do QR Code.

  - Se o QR Code corresponder ao equipamento selecionado, a data de inventário é atualizada para a data atual.

  - A listagem é atualizada automaticamente.

### 🛠️ Listagem de Equipamentos (Somente para Administradores)

- Exibe todos os equipamentos cadastrados.

- Cada equipamento é apresentado com:

  - Nome do equipamento

  - Código do equipamento

  - Usuário vinculado, se houver

- Opção para vincular um usuário ao equipamento:

  - Exibe uma listagem de usuários cadastrados.

  - Ao selecionar um usuário, o equipamento é vinculado a ele.

  - Se o usuário for alterado, a data do inventário é zerada.

- Opção para cadastrar um novo equipamento via QR Code:

  - Ao clicar no botão, a câmera é aberta para leitura do QR Code.

  - Se o equipamento ainda não existir, o usuário confirma o cadastro.

  - O equipamento é então cadastrado e aparece na listagem.

### 🔗 Geração de QR Code

Para gerar um QR Code, utilize o site Tec-It Barcode.

- Selecione 2D Codes -> QR Code (Mobile/Smartphone).

- Insira os dados do QR Code no seguinte formato JSON:
```
{"name":"Nome do equipamento","code":"Código do equipamento"}
```

### 🛠️ Tecnologias Utilizadas

- Flutter

- SQLite (armazenamento local)

- Packages como: barcode_scan2, flutter_svg, sqflite

### 📂 Estrutura do Projeto

O projeto segue a arquitetura MVC (Model-View-Controller):

```
/lib
 ├── controllers   # Lógica da aplicação
 ├── models        # Modelos de dados
 ├── views         # Interface do usuário
 ├── src           # Recursos adicionais
 └── main.dart     # Arquivo principal
```

### 🏗️ Pré-requisitos e Instalação

#### 🔧 Requisitos:

- Flutter instalado (Guia Oficial)

- Dart SDK

#### 📥 Instalação:

# Clone o repositório

```
git clone https://github.com/RuanHOliveira/asset_manager_test.git
```

# Acesse a pasta do projeto
```
cd asset_manager_test
```
# Instale as dependências
```
flutter pub get
```
# Execute o projeto
```
flutter run
```
📞 Contato

Caso tenha dúvidas ou sugestões, entre em contato! 😃

