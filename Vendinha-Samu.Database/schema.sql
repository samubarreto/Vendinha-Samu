------------- VENDINHA ---------------
/* Crie um schema/database novo e se conecte à ele,
depois execute tudo abaixo de uma vez, sem medo nem dó*/

------------- CLIENTES ---------------
/* criando sequence e tabela clientes, suables */

CREATE SEQUENCE clientes_seq;
CREATE TABLE clientes (
    id_cliente INT NOT NULL DEFAULT NEXTVAL('clientes_seq') PRIMARY KEY,
    nome_completo VARCHAR(30) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE,
    email VARCHAR(50) NOT NULL UNIQUE
);

------------- DÍVIDAS ---------------
/* criando sequence e tabela dividas, suables */

CREATE SEQUENCE dividas_seq;
CREATE TABLE dividas (
    id_divida INT NOT NULL DEFAULT NEXTVAL('dividas_seq') PRIMARY KEY,
    id_cliente INT NOT NULL,
    valor_divida DECIMAL(8, 2) NOT NULL,
    data_criacao DATE NOT NULL DEFAULT CURRENT_DATE,
    situacao BOOL NOT NULL,
    data_pagamento DATE,
    descricao VARCHAR(255) NOT NULL,
    CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente)
);

--------------- FUNCTIONS --------------
/* A função abaixo é executada sempre antes da
inserção duma nova dívida, impede que o total da
dívida seja >200, só permite caso o novo insert
seja de uma dívida com situacao = true (dívida
paga) */

CREATE OR REPLACE FUNCTION verifica_total_dividas()
RETURNS TRIGGER AS $$
DECLARE
    total DECIMAL(8, 2);
BEGIN
    IF NEW.situacao = TRUE THEN -- se a situação da nova dívida é true (paga), permite o insert ou update, mesmo que passe de 200
        RETURN NEW;
    END IF;

     -- calcula o total-divida do cliente que não estão pagas (situacao = false) SEM CONTAR A DÍVIDA ATUAL, no último AND ali
    SELECT COALESCE(SUM(valor_divida), 0)
    INTO total
    FROM dividas
    WHERE id_cliente = NEW.id_cliente
    AND situacao = FALSE
    AND id_divida != COALESCE(OLD.id_divida, -1);

    -- caso o total das dívidas situacao = false, incluindo a nova dívida ou do novo update, for maior que 200, impede a inserção/atualização, else insere/atualiza :)
    IF total + NEW.valor_divida > 200 THEN
        RAISE EXCEPTION 'Total de dívidas do cliente é maior que 200. Inserção ou atualização de dívida não permitida.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

------------- TRIGGERS -----------------
/* A trigger abaixo é acionada sempre ANTES
da inserção de uma nova dívida e chama a função
verifica_total_dividas() */

CREATE TRIGGER trigger_verifica_total_dividas
BEFORE INSERT OR UPDATE ON dividas
FOR EACH ROW
EXECUTE FUNCTION verifica_total_dividas();