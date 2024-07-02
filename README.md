# Vendinha Fullstack Interfocus do Samu 😎

### ·Sumário

* [Prints](#prints)
* [Resumo do Projeto](#resumo-do-projeto)
* [Features](#features)
* [TO-DO LIST](#to-do-list)
* [Instruções de Uso/Execução](#instruções-de-usoexecução)
* [Motivo de uso das bibliotecas](#justificativa-de-uso-das-bibliotecaspacotesetc)

---

### ·Prints:

<div align="center">

###### Interface principal
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/afbd5486-2a4a-423e-aaf7-b6102d08dd5d)

---

###### Paginamento com grid dinâmico de acordo com a quantidade de clientes na tela
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/d92af3e3-1219-467e-b768-3a25db8603ac)

---

###### Pesquisa com grid dinâmico de acordo com a quantidade de clientes retornados
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/76f3160b-80ca-4ab9-babf-41f06d40eed1)

---

###### Pesquisa com grid dinâmico de acordo com a quantidade de clientes retornados
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/32632af7-0043-47c1-a4c8-741698dea37c)

###### Inserção de Cliente
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/5c124032-420d-4390-a7d1-9100e59fe30c)

---

###### Clicar na foto de perfil do cliente para editar ou remover 
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/d77f8972-3a8d-4de7-8f10-8c830b4076d4)

---

###### Upload da imagem
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/dffec412-21a2-4b14-aca2-270a95917ed6)

---

###### Imagem de perfil alterada
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/e1072e68-ab43-452c-9d73-6ddfa6c91604)

---

###### Edição de Cliente
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/0645d4e3-99f3-42b2-aed9-e665a6e0624f)

---

###### Exclusão de Cliente
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/7e5ed415-4c0d-4080-b59a-7ba74328ef48)

---

###### Tabela de Dívidas de um cliente inadimplente
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/a960e902-c5f3-4342-a70e-66cc960b3eb6)

---

###### Confirmação de Baixa de Dívida em Aberto
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/0996b14a-493e-4ee6-bce5-0bae0a1f4f24)

---

###### Edição de Dívida
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/906a7593-225c-42d6-8056-f88a1adf459c)

---

###### Inserção de Dívida
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/f7388556-aaf0-4968-a60b-794c9c78712e)

---

###### Tabela de Dívidas de um cliente adimplente
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/48677198-cf36-42eb-a205-ec1ed60019a8)

---

###### Interface de Página não encontrada
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/ff35ca1b-555e-478a-9cb4-d2145f31c09f)

</div>

### ·Resumo do Projeto:

* Interface web com HTML, CSS, JS e REACT.JS
* Uma WEB API REST, feita com ASP.NET em C#
* Um banco de dados PostgreSQL para permanencia de dados via ORM NHibernate
* Organiza e administra Dívidas de Clientes

---

### ·Features:

* Paginação de 10 em 10 clientes
* Busca de Clientes
* Ordenação de Cliente com maior somatório de dívidas para menor
* Exibição dinâmica para buscas/páginas com 8, 6, 4, 2, 1 e 0 clientes (Busque por: "Retorna8", "Retorna6", "Retorna4", "Retorna2", "Retorna1", "Retorna0" Para ver)
* Fácil Cadastro, Cdição e Remoção de Clientes
* Adição, alteração e remoção de imagem de perfil de Cliente
* Paginação de 10 em 10 dívidas de clientes
* Fácil Cadastro, Edição, Baixa e Remoção de Dívidas de um Cliente
* Limitação automática de 200 reais de somatório de dívidas de um Cliente

---

### ·TO-DO LIST

###### PLANEJAMENTO INICIAL

* [X] Organizar o ínicio do README.md, com as regras e requisitos já préviamente analisados
* [X] Montar casos de teste baseados nos requisitos apresentados
* [X] Montar o diagrama geral da aplicação no [MIRO](https://miro.com/pt/mapeamento-processos/)
* [X] Aprender melhor o pgAdmin ([Tutorial](https://www.youtube.com/watch?v=WFT5MaZN6g4&ab_channel=DatabaseStar))

###### DATABASE

* [X] Desenvolver schema.sql das Tabelas Clientes e Dívidas, inserts de exemplo para clientes e dívidas e dqls úteis
* [X] Aplicar o schema num Postgres em localhost no pgAdmin pra ver no que dá

###### BACKEND BASE

* [X] /Console/Entidades
* [X] /Console/Mappings
* [X] /Console/Services

###### BACKEND ENDPOINTS CLIENTES

* [X] READ   [+Postman Collection]
* [X] CREATE [+Postman Collection]
* [X] UPDATE [+Postman Collection]
* [X] DELETE [+Postman Collection]

###### URGÊNCIAS

* [X] Urgente: Refatorar Email, não é NOT NULL, é NULLABLE, oreiei, não vi direito o requisito
* [X] Urgente: Fazer checagem de Data de Nascimento < hoje no back e banco
* [X] Urgente: Refatoração dos retornos de erro, usar o ValidationResult certo (junto com um HandleException cabuloso, retornando o membername sempre, pra facilitar no front)
* [X] Urgente: Validar CPF na API (usei uma tal de biblioteca Cpf.Cnpj muito foda, documentação brasileira, não validei 100% a nível de banco pois daria um trabalho inifinito, no banco só valida se tem 11 dígitos)
* [X] Ter certeza que não estou esquecendo de nada (Eu acho que não esqueci de nada)

###### BACKEND ENDPOINTS DÍVIDAS

* [X] READ DÍVIDAS/{idcliente}   [+Postman Collection]
* [X] CREATE [+Postman Collection]
* [X] UPDATE [+Postman Collection]
* [X] DELETE [+Postman Collection]

###### FRONTEND PROTÓTIPO

* [X] Prototipar Interface do grid de cards de clientes
* [X] Prototipar Interface de tabela de dívidas de um cliente
* [X] Prototipar Modal de Formulário de Inserção/Edição de Cliente/Dívida
* [X] Prototipar Modal de Confirmação de Inserção/Edição/Baixa/Exclusão de Cliente/Dívida

###### REFATORAÇÕES IMPORTANTES GERAIS

* [X] Refatorar: Protótipo, banco e mapeamento do Back para armazenar caminho da imagem de perfil do cliente na tabela cliente
* [X] Refatorar totalmente o banco e backend para imagem de perfil [+Postman Collection]
* [X] Refatorar banco, adicionar deleção em cascata do cliente, pra ser possível apagar mesmo que tenha dívidas
* [X] Refatorar banco, para ter uam coluna do somatório de dívidas de um cliente 🙂

###### FRONTEND

* [X] Desenvolver componente de header

###### FRONTEND CLIENTES

* [X] Desenvolver HTML e CSS da interface do grid de cards de clientes, componente de card de cliente
* [X] Adicionar funcionalidade de listagem dinâmica dos clientes (fetch+paginamento/busca)
* [X] Confirmação de exclusão (e recarregar página)
* [X] Formulário de edição de cliente (e recarregar página)
* [X] Formulário de edição de imagem de cliente (e recarregar página)
* [X] Formulário de inserção de cliente (e recarregar página)
* [X] Roteamento para levar do botão de somatório de dívidas para a página de tabela de dívidas e vice-versa (ir e voltar, rotear)

###### FRONTEND DÍVIDAS

* [X] Desenvolver HTML e CSS da interface da tabela de dívidas de um cliente, componente de tabela de dívidas de um cliente
* [X] Refatorar Backend endpoint de dívidas by idcliente, pra retornar da forma correta e com skip page size aplicados para paginação no front
* [X] Adicionar funcionalidade de listagem dinâmica dos clientes (fetch+paginamento)
* [X] Reaplicar confirmação de exclusão de cliente (e voltar para /clientes/)
* [X] Reaplicar formulário de edição de cliente (e recarregar página)
* [X] Confirmação de exclusão de dívida (e recarregar página)
* [X] Confirmação de baixa de dívida (e recarregar página)
* [X] Formulário de edição de dívida (e recarregar página)
* [X] Formulário de inserção de dívida (e recarregar página)

###### CHECKUP FRONTEND

* [X] CRUD Clientes no front finalizado e validado
* [X] CRUD Dívidas no front finalizado e validado

###### DOCUMENTAÇÃO E ENTREGA

* [X] Exportar Collection do Postman
* [X] Documentar o motivo de uso das Libs
* [X] Documentar as instruções de uso da aplicação Vendinha Fullstack Interfocus 😎
* [X] Entregar repositório

---

### ·Instruções de Uso/Execução

1) Tenha o GIT instalado:

```
https://git-scm.com/download/win
```

2) Tenha o SDK do DOTNET 8.0 instalado:

```
https://dotnet.microsoft.com/pt-br/download
```

3) Tenha o NPM instalado:

```
https://docs.npmjs.com/downloading-and-installing-node-js-and-npm
```

4) Tenha uma IDE para Postgresql instalada, recomendo o pgAdmin:

```
https://www.pgadmin.org/download/pgadmin-4-windows/
```

5) Caso tenha acabado de instalar algum dos itens acima, reinicie seu computador
6) Abra um terminal e clone o repositório:

```bash
git clone https://github.com/samubarreto/Vendinha-Fullstack-Interfocus.git
```

7) Acesse o diretório do repositório clonado:

```bash
cd .\Vendinha-Fullstack-Interfocus\
```

8) Abra o diretório atual no Explorador de Arquivos pra facilitar a explicação:

```bash
explorer .
```

9) Abra o arquivo schema.sql com qualquer editor de texto/código (Bloco de notas)
10) Abra sua IDE do Postgresql (pgAdmin)
11) Registre um novo servidor com as seguintes informações:

- Nome: localhost(qualquer nome)
- Host: 127.0.0.1
- Porta: 5432
- Senha: samu123

12) Conecte-se ao servidor registrado crie um banco de dados com nome = vendinha_samu
13) Abra uma nova Querry para o banco vendinha_samu:

- Cole o conteúdo do schema.sql e execute

14) Volte para o explorador de arquivos, no diretório root (Vendinha-Fullstack-Interfocus), abra o terminal e siga os comandos:

```bash
cd .\Vendinha-Samu.Backend\
cd .\Vendinha_Samu.Api\
dotnet watch run
```

15) Se estiver tudo certo, a API deve estar rodando agora.. Perfeito
16) Volte para o explorador de arquivos, no diretório root (Vendinha-Fullstack-Interfocus), abra outro terminal e siga os comandos:

```bash
cd .\Vendinha-Samu.Frontend\
npm i vite
npm run dev
```

17) Se estiver tudo certo, tanto o banco, quanto a API Backend e o Frontend devem estar rodando perfeitamente agora, pronto pra gerenciar dívidas de clientes no seu navegador 🤠
18) Sinta-se livre para importar a Collection do [Postman](https://www.postman.com/downloads/), disponível em /Vendinha-Samu.postman_collection.json para testar os endpoints

---

### ·Justificativa de uso das Bibliotecas/Pacotes/Etc...

* [CPF.CNPJ](https://github.com/RBonaldi/CPF.CNPJ)
  * Usei ela no dotnet pra validar o cpf muito facilmente, documentação brasileira, criei um novo DataValidation dentro do GeneralServieces using a lib, mole demais:

```csharp
using CpfCnpjLibrary;

Cpf.Validar("08597471077"); // True
```

* [NHibernate](https://nhibernate.info/)

  * É um ORM, serve pra mapear objetos C# em entidades (tabelas) Postgres
  * Usamos ele pois a muitos anos atrás o EF, entity-framework não fazia migrações de bancos de dados Postgres.. Então usamos o NHibernate
  * Possibilita fazer consultas, inserções, deleções, updates e mais sem precisar escrever DQL, DML, DDL no C#
* [Npgsql](https://github.com/npgsql/npgsql)

  * Permite estabelecer conexões com bancos de dados Postgres no dotnet
* [React](https://github.com/facebook/react)

  * Biblioteca utilizada para o desenvolvimento do Frontend, possibilita a divisão dos arquivos em componentes e fornece hooks como o useState, useEffect, useRegular para gerenciamento de estado mais facilmente. Modular e reutilizável.
* [simple-react-routing](https://github.com/rodrigo-web-developer/simple-react-router)

  * Biblioteca do React usada no lugar do react-router-dom para definição simplificada das rotas.

---

<div align="center">

[![My Skills](https://skillicons.dev/icons?i=html,css,js,react,cs,dotnet,postgres)](https://www.linkedin.com/in/samubrreto/)
  
[![LinkedIn](https://img.shields.io/badge/linkedin-%230077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/samubrreto/)

</div>
