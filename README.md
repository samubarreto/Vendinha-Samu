# Vendinha Fullstack Interfocus 😎 Samuel Barreto

### **FAZER (TO DO)**

1. [X] Organizar o ínicio do README.md, com as regras e requisitos já primeiramente analisados - DONE
2. [X] Montar casos de teste baseados nos requisitos apresentados - DONE
3. [X] Montar o diagrama geral da aplicação no [MIRO](https://miro.com/pt/mapeamento-processos/) - DONE
4. [X] Aprender melhor o pgAdmin ([Tutorial 1](https://www.youtube.com/watch?v=WFT5MaZN6g4&ab_channel=DatabaseStar), [Tutorial 2](https://www.youtube.com/watch?v=o23LBJ-9jsU&ab_channel=AlimonPito)) - DONE
5. [X] Gerar scripts.sql das Tabelas Clientes e Dívidas - DONE
6. [X] Aplicar o schema num Postgres em localhost no pgAdmin - DONE
7. [ ] Fazer a API em ASP.NET e o mapeamento das tabelas com o NHibernate - IN PROGRESS
8. [ ] Prototipar as interfaces do Frontend - TO DO
9. [ ] Aplicar o protótipo e codar as interfaces com HTML, CSS e JS - TO DO
1. [ ] Testar a aplicação baseado nos casos préviamente estabelecidos - TO DO
1. [ ] Documentar o motivo de uso das Libs - TO DO
1. [ ] Documentar as instruções de uso da aplicação Vendinha Fullstack Interfocus 😎 - TO DO

### Projeto feito para estágio na Interfocus, é um sistema de gerenciamento de dívidas de clientes que inclui:

1. Interface web com HTML, CSS E JS:
   1. ReactJS está permitido
   2. Deve possuir CRUD de cliente
   3. Deve possuir validações de demonstrações de erros na tela de maneira simples
   4. Deve permitir listar dívidas por cliente
   5. Deve permitir dar baixa em pagamentos de dívidas
2. Uma WEB API REST, feita com ASP.NET em C#:
   1. Quaisquer Libs ou Frameworks estão permitidos
   2. Deve aceitar e devolver dados em JSON
   3. Deve possibilitar a persistência de dados em banco de dados PostgreSQL com o NHibernate
3. Um banco de dados PostgreSQL para permanencia de dados:
   1. Deve ter um arquivo .sql com a criação do schema do banco de dados
4. README.md
   1. Explicando o motivo de escolha das libs (este readme)
   2. Explicando como executar a aplicação (este readme)

### Classes e Regras

1. Cliente.cs
   1. NomeCompleto
   2. CPF
      1. Deve ser um CPF válido
   3. DataNascimento
   4. Email
2. Divida.cs
   1. Valor
   2. Situacao
      1. Pago ou não
   3. DataCriacao
   4. DataPagamento
   5. Descricao
      1. O que foi comprado

* Listagem de Clientes:
  * A listagem no front deve ir pelo maior ValorDividaCliente ao menor
  * Deve ter um campo IDADE, calculado quando necessário
  * A listagem deve exibir páginas de 10 em 10 registros
  * Deve haver um campo de busca por nome
  * Deve haver no fim da lista um somatório do total de dívidas dos clientes (De todos os clientes, provavelmente)
* Listagem de Dívidas:
  * Deve ser possível marcar uma dívida como paga
  * Deve aparecer a soma das dívidas de um cliente
  * A somatória de dívidas não deve ultrapassar 200 reais

### Motivo de uso das libs

1. Lib 1
   1. Motivo 1
2. Lib 2
   1. Motivo 2

#### Instruções de uso e execução da aplicação

1. Passo:
2. Passo:

#### Prazo de Entrega -> 25/06

* [➡️ Veja meu portfólio aqui 😎](https://samubarreto.github.io/Portfolio/)
