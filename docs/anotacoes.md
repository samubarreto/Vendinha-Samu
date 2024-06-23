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
  * Deve haver no fim da lista um somatório do total de dívidas do cliente
* Listagem de Dívidas:
  * Deve ser possível marcar uma dívida como paga
  * Deve aparecer a soma das dívidas de um cliente
  * A somatória de dívidas não deve ultrapassar 200 reais
