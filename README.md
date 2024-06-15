# Vendinha Fullstack Interfocus 😎 Samuel Barreto

---

> Sumário
1.[Resumo do Projeto](#resumo-projeto)
2.[TO-DO LIST](#to-do-list)
3.[Instruções de Uso/Execução](#instruções-de-usoexecução)
4.[Motivo de uso das bibliotecas](#justificativa-libs)

---

### ·Resumo do Projeto:

1. Interface web com HTML, CSS, JS e REACT.JS
2. Uma WEB API REST, feita com ASP.NET em C#
3. Um banco de dados PostgreSQL para permanencia de dados via ORM NHibernate

---

### ·TO-DO LIST

#### ·PLANEJAMENTO INICIAL

* [X] Organizar o ínicio do README.md, com as regras e requisitos já préviamente analisados - DONE
* [X] Montar casos de teste baseados nos requisitos apresentados - DONE
* [X] Montar o diagrama geral da aplicação no [MIRO](https://miro.com/pt/mapeamento-processos/) - DONE
* [X] Aprender melhor o pgAdmin ([Tutorial](https://www.youtube.com/watch?v=WFT5MaZN6g4&ab_channel=DatabaseStar)) - DONE

#### ·DATABASE

* [X] Desenvolver schema.sql das Tabelas Clientes e Dívidas, inserts de exemplo para clientes e dívidas e dqls úteis - DONE
* [X] Aplicar o schema num Postgres em localhost no pgAdmin pra ver no que dá - DONE

#### ·BACKEND BASE

* [X] /Console/Entidades - DONE
* [X] /Console/Mappings - DONE
* [X] /Console/Services - DONE

###### ·BACKEND ENDPOINTS CLIENTES

* [X] READ   [+COLLECTION NO POSTMAN] - DONE
* [X] CREATE [+COLLECTION NO POSTMAN] - DONE
* [X] UPDATE [+COLLECTION NO POSTMAN] - DONE
* [X] DELETE [+COLLECTION NO POSTMAN] - DONE

###### ·URGÊNCIAS

* [X] Urgente: Refatorar Email, não é NOT NULL, é NULLABLE, oreiei, não vi direito o requisito - DONE
* [X] Urgente: Fazer checagem de Data de Nascimento < hoje no back e banco - DONE
* [X] Urgente: Refatoração dos retornos de erro, usar o ValidationResult certo (junto com um HandleException cabuloso, retornando o membername sempre, pra facilitar no front) - DONE
* [X] Urgente: Validar CPF na API (usei uma tal de biblioteca Cpf.Cnpj muito foda, não validei 100% a nível de banco pois daria um trabalho inifinito, no banco só valida se tem 11 dígitos) - DONE

###### ·BACKEND ENDPOINTS DÍVIDAS

* [ ] READ   [+COLLECTION NO POSTMAN] - TO DO
* [ ] CREATE [+COLLECTION NO POSTMAN] - TO DO
* [ ] UPDATE [+COLLECTION NO POSTMAN] - TO DO
* [ ] DELETE [+COLLECTION NO POSTMAN] - TO DO

###### ·FRONTEND

* [ ] Prototipar as interfaces do Frontend - TO DO
* [ ] Aplicar o protótipo e codar as interfaces com HTML, CSS, JS e ReactJS - TO DO
* [ ] Chamar os endpoints corretamente para criação, edição, leitura e deleção de clientes e dívidas - TO DO

###### ·TESTES, DOCUMENTAÇÃO E ENTREGA

* [ ] Testar a aplicação baseado nos casos préviamente estabelecidos - TO DO
* [ ] Documentar o motivo de uso das Libs - TO DO
* [ ] Documentar as instruções de uso da aplicação Vendinha Fullstack Interfocus 😎 - TO DO
* [ ] Gravar apresentação do projeto - TO DO
* [ ] Mandar repositório no email do Rodrigo - TO DO

---

### ·Instruções de Uso/Execução

* Fazer

---

### ·Justificativa de uso das Bibliotecas/Pacotes/Etc...

* [BrasilAPI](https://github.com/RBonaldi/CPF.CNPJ)
  * Usei ela no dotnet pra validar o cpf muito facilmente, documentação brasileira, mole demais:

```csharp
using CpfCnpjLibrary;

Cpf.Validar("08597471077");     // True
```

* [NHibernate](https://nhibernate.info/)
  * É um ORM, serve pra mapera objetos C# em tabelas de bancos de dados Postgresql, usamos ele pois a muitos anos atrás o EF, entity-framework não fazia migrações de bancos de dados Postgres.. Então usamos o NHibernate

---
