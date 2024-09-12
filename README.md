<div align="center">
    
###### Aplicação Web para administração de Clientes e suas Dívidas💵
# Vendinha Fullstack do Samu 😎

</div>

<details><summary align="center">Prints</summary><div align="center">

###### Interface principal
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/43d11ee2-5e93-46d5-9d01-a5c4f2b74eba)

---

###### Paginamento/Pesquisa com grid dinâmico de acordo com a quantidade de clientes na tela
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/dbc5689b-a472-4372-8b27-1302cb7783b5)
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/d1345031-5989-4214-a94c-0d65d2731503)
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/a2355ff7-caa6-4a91-bba2-a136d7b8a93b)
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/152b06f5-cf08-4b82-94a1-c2fae87e157b)
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/a5a7d91e-0f06-40ed-a783-b063ad222293)

---

###### Inserção de Cliente
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/690546d0-7bf3-44bd-a5d2-12ace86687f1)

---

###### Edição de Cliente
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/93aaaa3e-9d48-4189-9e26-220939339e5c)

---

###### Exclusão de Cliente
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/f856f6e3-946e-403e-87de-fe8ae82993b7)

---

###### Edição/Remoção/Inserção de Imagem de Perfil de Cliente
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/32430ca4-3105-468e-9d7a-3ad06251c05e)
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/814c72d1-4518-473f-9ab3-9ff40c76588d)
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/77eff917-3b91-487a-8d98-106e96890bee)

---

###### Tabela de Dívidas de um cliente inadimplente
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/48487853-5e1c-474c-b372-f3c221458257)

---

###### Tabela de Dívidas de um cliente adimplente
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/16bbe878-9400-42d2-a1e9-520b91259451)

---

###### Confirmação de Baixa de Dívida em Aberto
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/fc59bc4b-6913-4d3c-ac3b-91259f6e1efe)

---

###### Inserção de Dívida
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/f7388556-aaf0-4968-a60b-794c9c78712e)

---

###### Edição de Dívida
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/be65333d-07e7-48c4-966c-76086b03d446)

---

###### Exclusão de Dívida
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/c8d01633-ca7f-4bf0-b07f-b2207bd29f56)

---

###### Interface de Página não encontrada
![image](https://github.com/samubarreto/Vendinha-Samu/assets/70921394/ff35ca1b-555e-478a-9cb4-d2145f31c09f)

</div>

</details>

---

<details>

<summary align="center">Resumo do Projeto</summary>

* Interface web com HTML, CSS, JS e REACT.JS
* Uma WEB API REST, feita com ASP.NET em C#
* Um banco de dados PostgreSQL para permanencia de dados via ORM NHibernate
* Organiza e administra Dívidas de Clientes

</details>

---

<details><summary align="center">Features</summary>

* Paginação de 10 em 10 clientes
* Busca de Clientes
* Ordenação de Cliente com maior somatório de dívidas para menor
* Exibição dinâmica para buscas/páginas com 8, 6, 4, 2, 1 e 0 clientes (Busque por: "Retorna8", "Retorna6", "Retorna4", "Retorna2", "Retorna1", "Retorna0" Para ver)
* Fácil Cadastro, Cdição e Remoção de Clientes
* Adição, alteração e remoção de imagem de perfil de Cliente
* Paginação de 10 em 10 dívidas de clientes
* Fácil Cadastro, Edição, Baixa e Remoção de Dívidas de um Cliente
* Limitação automática de 200 reais de somatório de dívidas de um Cliente

</details>

---

<details>

<summary align="center">To do List</summary>

###### PLANEJAMENTO INICIAL

* [X] Organizar o ínicio do README.md, com as regras e requisitos já préviamente analisados
* [X] Montar diagrama geral da aplicação

###### BANCO

* [X] Desenvolver schema.sql das Tabelas Clientes e Dívidas
* [X] Gerar Inserts de Mockup para clientes e dívidas
* [X] Desenvolver triggers e funções para validações à nível de banco e auxiliares

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

</details>

---

<details><summary align="center">Instruções de Uso/Execução</summary>

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

4) Tenha o driver do Postgresql instalado:

```
https://www.enterprisedb.com/downloads/postgres-postgresql-downloads
```

5) Tenha uma IDE para Postgresql instalada, recomendo o pgAdmin:

```
https://www.pgadmin.org/download/pgadmin-4-windows/
```

6) Caso tenha acabado de instalar algum dos itens acima, reinicie seu computador
7) Abra um terminal e clone o repositório:

```bash
git clone https://github.com/samubarreto/Vendinha-Samu.git
```

8) Acesse o diretório do repositório clonado:

```bash
cd .\Vendinha-Samu\
```

9) Abra o diretório atual no Explorador de Arquivos pra facilitar a explicação:

```bash
explorer .
```

10) Abra o arquivo schema.sql com qualquer editor de texto/código (Bloco de notas)
11) Abra sua IDE do Postgresql (pgAdmin)
12) Registre um novo servidor com as seguintes informações:

- Nome: localhost(qualquer nome)
- Host: 127.0.0.1
- Porta: 5432
- Senha: samu123

13) Conecte-se ao servidor registrado crie um banco de dados com nome = vendinha_samu
14) Abra uma nova Querry para o banco vendinha_samu:

- Cole o conteúdo do schema.sql e execute

15) Volte para o explorador de arquivos, no diretório root (Vendinha-Fullstack-Interfocus), abra o terminal e siga os comandos:

```bash
cd .\Vendinha-Samu.Backend\
cd .\Vendinha_Samu.Api\
dotnet watch run
```

16) Veja quais são os 4 números de porta da URL da api iniciada:

```bash
https://localhost:7258/api/clientes
```

17) Caso os 4 números após o : sejam "7258", como a url acima, pule para o passo 18

18) Caso contrário, copie esses 4 números e substitua a porta da URL na primeira linha do arquivo "\Vendinha-Samu\Vendinha-Samu.Frontend\src\services\general.js" pela porta copiada.

19) Se estiver tudo certo, a API deve estar rodando agora.. Perfeito

20) Volte para o explorador de arquivos, no diretório root (Vendinha-Fullstack-Interfocus), abra outro terminal e siga os comandos:

```bash
cd .\Vendinha-Samu.Frontend\
npm i vite
npm run dev
```

21) Provavelmente as imagens de perfil não deverão carregar, depende apenas do seu navegador, pra resolver copie e cole o link abaixo noutra guia, aceite os acessos, volte para a guia da Vendinha e recarregue a página:

```bash
https://127.0.0.1:7258/profile_pics/profile_placeholder.png
```
    
22) Se estiver tudo certo, tanto o banco, quanto a API Backend e o Frontend devem estar rodando perfeitamente agora, pronto pra gerenciar dívidas de clientes no seu navegador 🤠
23) Sinta-se livre para importar a Collection do [Postman](https://www.postman.com/downloads/), disponível em /Vendinha-Samu.postman_collection.json para testar os endpoints

</details>

---

<details><summary align="center">Justificativa de uso das Bibliotecas/Pacotes/Etc...</summary>

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

</details>

---

<div align="center">

###### Dê um git pull -ff sempre que possível para usar a versão mais atualizada

[![My Skills](https://skillicons.dev/icons?i=html,css,js,react,cs,dotnet,postgres)](https://www.linkedin.com/in/samubrreto/)
  
[![LinkedIn](https://img.shields.io/badge/linkedin-%230077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/samubrreto/)

</div>
