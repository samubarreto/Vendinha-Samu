/* Clientes e somatório de suas dívidas  */

SELECT
    cl.id_cliente AS "Id-Cliente",
    cl.nome_completo AS "Nome-Completo",
    cl.cpf AS "CPF",
    EXTRACT(YEAR FROM AGE(cl.data_nascimento)) AS "Idade",
    cl.email AS "Email",
    SUM(dv.valor_divida) AS "Total-Dívida"
FROM
    clientes cl
JOIN
    dividas dv ON dv.id_cliente = cl.id_cliente
GROUP BY
    cl.id_cliente
ORDER BY
	SUM(dv.valor_divida) desc, cl.nome_completo;

/* Clientes e somatório de suas dívidas EM ABERTO */

SELECT
    cl.id_cliente AS "Id-Cliente",
    cl.nome_completo AS "Nome-Completo",
    cl.cpf AS "CPF",
    EXTRACT(YEAR FROM AGE(cl.data_nascimento)) AS "Idade",
    cl.email AS "Email",
    SUM(dv.valor_divida) AS "Total-Dívida"
FROM
    clientes cl
JOIN
    dividas dv ON dv.id_cliente = cl.id_cliente
WHERE
	dv.situacao = false
GROUP BY
    cl.id_cliente
ORDER BY
	cl.id_cliente;

/* Clientes e suas dívidas separadas */
SELECT
    cl.id_cliente AS "Id-Cliente",
    cl.nome_completo AS "Nome-Completo",
    cl.cpf AS "CPF",
    EXTRACT(YEAR FROM AGE(cl.data_nascimento)) AS "Idade",
    cl.email AS "Email",
	dv.id_divida AS "Id-Dívida",
    dv.valor_divida AS "Valor",
	dv.situacao AS "Situação-Pgto",
	dv.descricao AS "Descrição"
FROM
    clientes cl
JOIN
    dividas dv ON dv.id_cliente = cl.id_cliente
GROUP BY
    cl.id_cliente,
    dv.id_divida
ORDER BY
	SUM(dv.valor_divida) desc, cl.nome_completo;

/* Quantidade de dívidas por cliente */
SELECT
    cl.id_cliente AS "Id-Cliente",
    cl.nome_completo AS "Nome-Completo",
    cl.cpf AS "CPF",
    EXTRACT(YEAR FROM AGE(cl.data_nascimento)) AS "Idade",
    cl.email AS "Email",
    COUNT(dv.id_divida) AS "Total-Dívidas"
FROM
    clientes cl
LEFT JOIN
    dividas dv ON dv.id_cliente = cl.id_cliente
GROUP BY
    cl.id_cliente
ORDER BY
    cl.id_cliente;

/* Quantidade de dívidas em aberto e pagas de cada cliente */
SELECT
    cl.id_cliente AS "Id-Cliente",
    cl.nome_completo AS "Nome-Completo",
    cl.cpf AS "CPF",
    EXTRACT(YEAR FROM AGE(cl.data_nascimento)) AS "Idade",
    cl.email AS "Email",
    SUM(CASE WHEN dv.situacao = true THEN 1 ELSE 0 END) AS "Dívidas-Pagas",
    SUM(CASE WHEN dv.situacao = false THEN 1 ELSE 0 END) AS "Dívidas-Em-Aberto"
FROM
    clientes cl
JOIN
    dividas dv ON dv.id_cliente = cl.id_cliente
GROUP BY
    cl.id_cliente
ORDER BY
    cl.id_cliente;

/* Usar isso para paginação? Parecido com o skip e size do ASP.NET */
LIMIT
    10
OFFSET
    10;

$$ LANGUAGE plpgsql;