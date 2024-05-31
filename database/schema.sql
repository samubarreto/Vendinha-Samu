-- Criando a sequência para a tabela clientes
CREATE SEQUENCE clientes_seq;

-- Criando a tabela clientes
CREATE TABLE clientes (
    id_cliente INT NOT NULL DEFAULT NEXTVAL('clientes_seq') PRIMARY KEY,
    nome_completo VARCHAR(30) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE,
    email VARCHAR(50) NOT NULL UNIQUE
);

-- Criando a sequência para a tabela dividas
CREATE SEQUENCE dividas_seq;

-- Criando a tabela dividas
CREATE TABLE dividas (
    id_divida INT NOT NULL DEFAULT NEXTVAL('dividas_seq') PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_criacao DATE NOT NULL DEFAULT CURRENT_DATE,
    situacao BOOL NOT NULL,
    data_pagamento DATE,
    descricao VARCHAR(255) NOT NULL,
    CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente)
);