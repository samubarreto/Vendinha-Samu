# Vendinha Fullstack Interfocus 😎 Samuel Barreto

> Sumário
> [&gt;TO-DO LIST](#1-to-do-list)
> [&gt;O que contém no projeto](#2-projeto-de-sistema-de-gerenciamento-de-dívidas-de-clientes-feito-para-estágio-na-interfocus-inclui)
> [&gt;Instruções de Uso/Execução](#3-instruções-de-usoexecução)
> [&gt;Motivo de uso das libs](#4-motivo-de-uso-das-libs)

### [1] TO-DO LIST

#### [1.1] PLANEJAMENTO E TDD

* [X] Organizar o ínicio do README.md, com as regras e requisitos já préviamente analisados - DONE
* [X] Montar casos de teste baseados nos requisitos apresentados - DONE
* [X] Montar o diagrama geral da aplicação no [MIRO](https://miro.com/pt/mapeamento-processos/) - DONE
* [X] Aprender melhor o pgAdmin ([Tutorial](https://www.youtube.com/watch?v=WFT5MaZN6g4&ab_channel=DatabaseStar)) - DONE

#### [1.2] DATABASE

* [X] Desenvolver schema.sql das Tabelas Clientes e Dívidas, inserts de exemplo para clientes e dívidas e dqls úteis - DONE
* [X] Aplicar o schema num Postgres em localhost no pgAdmin pra ver no que dá - DONE

#### [1.3] BACKEND BASE

* [X] /Console/Entidades - DONE
* [X] /Console/Mappings - DONE
* [X] /Console/Services - DONE

##### [1.3.0] BACKEND ENDPOINTS CLIENTES

* [X] READ   [+COLLECTION NO POSTMAN] - DONE
* [X] CREATE [+COLLECTION NO POSTMAN] - DONE
* [X] UPDATE [+COLLECTION NO POSTMAN] - DONE
* [X] DELETE [+COLLECTION NO POSTMAN] - DONE

##### URGÊNCIAS

* [X] Urgente: Refatorar Email, não é NOT NULL, é NULLABLE, oreiei, não vi direito o requisito - DONE
* [X] Urgente: Fazer checagem de Data de Nascimento < hoje no back e banco - DONE
* [X] Urgente: Refatoração dos retornos de erro, usar o ValidationResult certo (junto com um HandleException cabuloso, retornando o membername sempre, pra facilitar no front) - DONE
* [X] Urgente: Validar CPF na API (usei uma tal de biblioteca Cpf.Cnpj muito foda, não validei 100% a nível de banco pois daria um trabalho inifinito, no banco só valida se tem 11 dígitos) - DONE

##### [1.3.1] BACKEND ENDPOINTS DÍVIDAS

* [ ] READ   [+COLLECTION NO POSTMAN] - TO DO
* [ ] CREATE [+COLLECTION NO POSTMAN] - TO DO
* [ ] UPDATE [+COLLECTION NO POSTMAN] - TO DO
* [ ] DELETE [+COLLECTION NO POSTMAN] - TO DO

#### [1.4] FRONTEND

* [ ] Prototipar as interfaces do Frontend - TO DO
* [ ] Aplicar o protótipo e codar as interfaces com HTML, CSS, JS e ReactJS - TO DO
* [ ] Chamar os endpoints corretamente para criação, edição, leitura e deleção de clientes e dívidas - TO DO

#### [1.5] TESTES, DOCUMENTAÇÃO E ENTREGA

* [ ] Testar a aplicação baseado nos casos préviamente estabelecidos - TO DO
* [ ] Documentar o motivo de uso das Libs - TO DO
* [ ] Documentar as instruções de uso da aplicação Vendinha Fullstack Interfocus 😎 - TO DO
* [ ] Gravar apresentação do projeto - TO DO
* [ ] Mandar repositório no email do Rodrigo - TO DO

### [2] Projeto de sistema de gerenciamento de dívidas de clientes feito para estágio na Interfocus, inclui:

1. Interface web com HTML, CSS, JS e REACT.JS
2. Uma WEB API REST, feita com ASP.NET em C#
3. Um banco de dados PostgreSQL para permanencia de dados via ORM NHibernate

### [3] Instruções de Uso/Execução

* abc

### [4] Motivo de uso das libs

* [BrasilAPI](https://github.com/RBonaldi/CPF.CNPJ)

Usei ela no dotnet pra validar o cpf muito facilmente, documentação brasileira, mole demais:

```csharp
using CpfCnpjLibrary;

Cpf.Validar("08597471077");     // True
```

* tal
