------------- VENDINHA ---------------
/* Crie um schema/database novo e se conecte à ele,
depois execute tudo abaixo de uma vez, sem medo nem dó*/

------------- CLIENTES ---------------
/* criando sequence e tabela clientes, suables */

CREATE SEQUENCE clientes_seq;
CREATE TABLE clientes (
    id_cliente INT NOT NULL DEFAULT NEXTVAL('clientes_seq'),
    nome_completo VARCHAR(50) NOT NULL,
    cpf CHAR(11) NOT NULL,
    data_nascimento DATE,
    email VARCHAR(50) NULL,
    CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
    CONSTRAINT unique_cpf UNIQUE (cpf),
	CONSTRAINT unique_email UNIQUE (email)
);

------------- DÍVIDAS ---------------
/* criando sequence e tabela dividas, suables */

CREATE SEQUENCE dividas_seq;
CREATE TABLE dividas (
    id_divida INT NOT NULL DEFAULT NEXTVAL('dividas_seq'),
    id_cliente INT NOT NULL,
    valor_divida DECIMAL(8, 2) NOT NULL,
    data_criacao DATE NOT NULL DEFAULT CURRENT_DATE,
    situacao BOOL NOT NULL,
    data_pagamento DATE,
    descricao VARCHAR(255) NOT NULL,
    CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente),
    CONSTRAINT pk_divida PRIMARY KEY (id_divida)
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

/* A função abaixo é executada sempre antes da
inserção ou update dum cliente e impede que a
data de nascimento seja maior que a data atual */
CREATE OR REPLACE FUNCTION validar_data_nascimento()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.data_nascimento >= CURRENT_DATE THEN
        RAISE EXCEPTION 'A data de nascimento deve ser menor que a data atual.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

------------- TRIGGERS -----------------
/* A trigger abaixo é acionada sempre ANTES
da inserção ou update de uma dívida e
chama a função verifica_total_dividas() */
CREATE TRIGGER trigger_verifica_total_dividas
BEFORE INSERT OR UPDATE ON dividas
FOR EACH ROW
EXECUTE FUNCTION verifica_total_dividas();

/* A trigger abaixo é acionada sempre ANTES
da inserção ou update de um cliente e chama
a função verifica_data_nascimento() */
CREATE TRIGGER verificar_data_nascimento
BEFORE INSERT OR UPDATE ON clientes
FOR EACH ROW
EXECUTE FUNCTION validar_data_nascimento();