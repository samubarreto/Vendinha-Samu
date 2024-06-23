# Vendinha Fullstack Interfocus do Samu 😎

### ·Sumário

* [Resumo do Projeto](#resumo-do-projeto)
* [TO-DO LIST](#to-do-list)
* [Instruções de Uso/Execução](#instruções-de-usoexecução)
* [Motivo de uso das bibliotecas](#justificativa-de-uso-das-bibliotecaspacotesetc)

---

### ·Resumo do Projeto:

* Interface web com HTML, CSS, JS e REACT.JS
* Uma WEB API REST, feita com ASP.NET em C#
* Um banco de dados PostgreSQL para permanencia de dados via ORM NHibernate
* Organiza e administra Dívidas de Clientes

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

###### FRONTEND HTML, CSS, JS & REACTJS

* [X] Desenvolver componente de header
* [X] Desenvolver a interface do grid de cards de clientes, componente de card de cliente
* [X] Deixar inferface de  grid de cards de clientes responsiva
* [ ] Desenvolver a interface da tabela de dívidas de um cliente, componente de tabela de dívidas
* [ ] Desenvolver componente de modal de confirmação/exclusão/edição/inserção/baixa
* [ ] Desenvolver componente de formulário de cliente/dívida
* [ ] Desenvolver componente de paginamento
* [ ] Adicionar funcionalidade de listagem dinâmica dos clientes
* [ ] Adicionar funcionalidade de listagem dinâmica das dívidas de um cliente
* [ ] CRUD Clientes no front
* [ ] CRUD Dívidas no front

###### FINALIZAÇÃO

* [ ] Identificar e Refatorar o que tiver de estranho em todo o código de front, back e banco

###### TESTES, DOCUMENTAÇÃO E ENTREGA

* [ ] Testar a aplicação baseado nos casos préviamente estabelecidos
* [X] Documentar o motivo de uso das Libs
* [X] Documentar as instruções de uso da aplicação Vendinha Fullstack Interfocus 😎
* [ ] Mandar repositório no email do Rodrigo

---

### ·Instruções de Uso/Execução

1) Tenha o SDK do DOTNET instalado:

```
https://dotnet.microsoft.com/pt-br/download
```

2) Tenha o NPM instalado:

```
https://docs.npmjs.com/downloading-and-installing-node-js-and-npm
```

3) Tenha uma IDE para Postgresql instalada, recomendo o pgAdmin:

```
https://www.pgadmin.org/download/pgadmin-4-windows/
```

4) Abra um terminal e clone o repositório:

```bash
git clone https://github.com/samubarreto/Vendinha-Fullstack-Interfocus.git
```

5) Acesse o diretório do repositório clonado:

```bash
cd .\Vendinha-Fullstack-Interfocus\
```

6) Abra o diretório atual no Explorador de Arquivos pra facilitar a explicação:

```bash
explorer .
```

7) Encontre e abra a pasta Vendinha-Samu.Database
8) Abra o arquivo schema.sql com qualquer editor de texto/código (Bloco de notas)
9) Abra sua IDE do Postgresql (pgAdmin)
10) Registre um novo servidor com as seguintes informações:

- Nome: localhost(qualquer nome)
- Host: 127.0.0.1
- Porta: 5432
- Senha: samu123

11) Conecte-se ao servidor registrado crie um banco de dados com nome = vendinha_samu
12) Abra uma nova Querry para o banco vendinha_samu:

- Cole o conteúdo do schema.sql e execute

13) Volte para o explorador de arquivos, no diretório root (Vendinha-Fullstack-Interfocus), abra o terminal e siga os comandos:

```bash
cd .\Vendinha-Samu.Backend\
cd .\Vendinha_Samu.Api\
dotnet watch run
```

14) Se estiver tudo certo, a API deve estar rodando agora.. Perfeito
15) Volte para o explorador de arquivos, no diretório root (Vendinha-Fullstack-Interfocus), abra outro terminal e siga os comandos:

```bash
cd .\Vendinha-Samu.Frontend\
npm i vite
npm run dev
```

16) Se estiver tudo certo, tanto o banco, quanto a API Backend e o Frontend devem estar rodando perfeitamente agora, pronto pra gerenciar dívidas de clientes no seu navegador 🤠

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

[![Portfolio](https://img.shields.io/badge/Portfolio-255E63?style=for-the-badge&logo=About.me&logoColor=white)](https://samubarreto.github.io/Portfolio/)
[![LinkedIn](https://img.shields.io/badge/linkedin-%230077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/samubrreto/)

</div>
