# DER - Vendinha Fullstack

#### Tabela `clientes`

* **id_cliente** : `INT` (chave primária, não nula, valor padrão gerado por sequência `clientes_seq`).
* **nome_completo** : `VARCHAR(30)` (não nulo).
* **cpf** : `CHAR(11)` (não nulo, único).
* **data_nascimento** : `DATE`.
* **email** : `VARCHAR(50)` (não nulo, único).

#### Tabela `dividas`

* **id_divida** : `INT` (chave primária, não nula, valor padrão gerado por sequência `dividas_seq`).
* **id_cliente** : `INT` (chave estrangeira, não nula, referência à tabela `clientes`).
* **data_criacao** : `DATE` (não nula, valor padrão `CURRENT_DATE`).
* **situacao** : `BOOL` (não nula).
* **data_pagamento** : `DATE` (pode ser nula).
* **descricao** : `VARCHAR(255)` (não nulo).
