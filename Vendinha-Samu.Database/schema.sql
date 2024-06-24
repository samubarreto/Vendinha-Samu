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
    data_nascimento DATE NOT NULL,
    email VARCHAR(50) NULL,
	profile_url TEXT,
    somatorio_dividas DECIMAL(8,2) NOT NULL DEFAULT 0,
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
    situacao BOOL NOT NULL DEFAULT false,
    data_pagamento DATE,
    descricao VARCHAR(255) NOT NULL,
    CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente) ON DELETE CASCADE,
    CONSTRAINT pk_divida PRIMARY KEY (id_divida)
);

--------------- FUNCTIONS --------------
/* A função abaixo é executada sempre antes da
inserção duma nova dívida, impede que o total da
dívida seja >200, só permite caso o novo insert
seja de uma dívida com situacao = true (dívida
paga) */

CREATE OR REPLACE FUNCTION validar_total_dividas()
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

/* A função abaixo é executada sempre antes da
inserção ou update dum cliente e impede que o
cpf seja inválido */
CREATE OR REPLACE FUNCTION validar_cpf()
RETURNS TRIGGER AS $$
DECLARE
    cpf_text VARCHAR(11);
BEGIN
    -- bota o novo cpf no cpftext declarado acima
    cpf_text := NEW.cpf;

    -- se tem 11 dígitos
    IF LENGTH(cpf_text) <> 11 OR NOT (cpf_text ~ '^[0-9]+$') THEN
        RAISE EXCEPTION 'CPF inválido. O CPF deve conter exatamente 11 dígitos numéricos.';
    
    END IF;

    -- se n caiu no if retorna o cpf
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/* A função abaixo é executada sempre antes da
inserção ou update dum cliente e preenche a foto
de perfil com o placeholder caso esteja vazio */
CREATE OR REPLACE FUNCTION setar_padrao_perfil()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.profile_url = '') OR  (NEW.profile_url IS NULL) THEN
        NEW.profile_url := 'http://127.0.0.1:7258/profile_pics/profile_placeholder.png';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/* A função abaixo é executada sempre antes da
inserção, update ou delete de uma dívida e atualiza
o somatório de dívidas na tabela de clientes kkkkk rachei */
CREATE OR REPLACE FUNCTION atualizar_somatorio_dividas()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        -- SE FOR DELETE
        UPDATE clientes
        SET somatorio_dividas = (
            SELECT COALESCE(SUM(valor_divida), 0)
            FROM dividas
            WHERE id_cliente = OLD.id_cliente
            AND situacao = false
        )
        WHERE id_cliente = OLD.id_cliente;
    ELSE
        -- SE FOR UPDATE OU INSERT
        UPDATE clientes
        SET somatorio_dividas = (
            SELECT COALESCE(SUM(valor_divida), 0)
            FROM dividas
            WHERE id_cliente = NEW.id_cliente
            AND situacao = false
        )
        WHERE id_cliente = NEW.id_cliente;
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


------------- TRIGGERS -----------------
/* A trigger abaixo é acionada sempre ANTES
da inserção ou update de uma dívida e
chama a função verifica_total_dividas() */
CREATE TRIGGER trigger_verifica_total_dividas
BEFORE INSERT OR UPDATE ON dividas
FOR EACH ROW
EXECUTE FUNCTION validar_total_dividas();

/* A trigger abaixo é acionada sempre ANTES
da inserção ou update de um cliente e chama
a função verifica_data_nascimento() */
CREATE TRIGGER trigger_verifica_data_nascimento
BEFORE INSERT OR UPDATE ON clientes
FOR EACH ROW
EXECUTE FUNCTION validar_data_nascimento();

/* A trigger abaixo é acionada sempre ANTES
da inserção ou update de um cliente e chama
a função validar_cpf() */
CREATE TRIGGER trigger_verifica_cpf
BEFORE INSERT OR UPDATE ON clientes
FOR EACH ROW
EXECUTE FUNCTION validar_cpf();

/* A trigger abaixo é acionada sempre ANTES
da inserção ou update de um cliente e chama
a função setar_padrao_perfil() */
CREATE TRIGGER trigger_seta_imagem_padrao_perfil
BEFORE INSERT OR UPDATE ON clientes
FOR EACH ROW
EXECUTE FUNCTION setar_padrao_perfil();

/* A trigger abaixo é acionada sempre ANTES
da inserção, update ou delete de um cliente e chama
a função atualizar_somatorio_dividas() */
CREATE TRIGGER trigger_atualiza_somatorio_dividas_insert
AFTER INSERT OR UPDATE OR DELETE ON dividas
FOR EACH ROW
EXECUTE FUNCTION atualizar_somatorio_dividas();

------------- INSERT CLIENTES ---------------

INSERT INTO clientes (nome_completo, cpf, data_nascimento, email, profile_url) VALUES
('Cliente 01', '77120005065', '2008-06-01', 'cliente51@teste.com', null),
('Cliente 02', '48350876077', '1959-07-01', 'cliente52@teste.com', null),
('Cliente 03', '10068351054', '1935-08-01', 'cliente53@teste.com', null),
('Cliente 04', '14462563085', '2002-12-25', 'cliente54@teste.com', null),
('Cliente 05', '11265316007', '1957-10-01', 'cliente55@teste.com', null),
('Cliente 06', '68436606060', '1944-11-01', 'cliente56@teste.com', null),
('Cliente 07', '32676983083', '2006-12-01', 'cliente57@teste.com', null),
('Cliente 08', '41087006007', '1995-01-01', 'cliente58@teste.com', null),
('Cliente 09', '03249721050', '2003-02-01', 'cliente59@teste.com', null),
('Cliente 10', '47811148064', '1966-01-01', 'cliente10@teste.com', null),
('Cliente 11', '61637755031', '1949-02-01', 'cliente11@teste.com', null),
('Cliente 12', '62139599047', '1962-03-01', 'cliente12@teste.com', null),
('Cliente 13', '57559315003', '1979-04-01', 'cliente13@teste.com', null),
('Cliente 14', '78456336076', '1986-05-01', 'cliente14@teste.com', null),
('Cliente 15', '79372405043', '1998-06-01', 'cliente15@teste.com', null),
('Cliente 16', '30250729032', '2001-07-01', 'cliente16@teste.com', null),
('Cliente 17', '93076257005', '1968-08-01', 'cliente17@teste.com', null),
('Cliente 18', '40932903002', '1956-09-01', 'cliente18@teste.com', null),
('Cliente 19', '63594256022', '2000-10-01', 'cliente19@teste.com', null),
('Cliente 20', '61221479075', '1954-11-01', 'cliente20@teste.com', null),
('Cliente 21', '13103426011', '1977-12-01', 'cliente21@teste.com', null),
('Cliente 22', '04503698036', '1981-01-01', 'cliente22@teste.com', null),
('Cliente 23', '45867427048', '1990-02-01', 'cliente23@teste.com', null),
('Cliente 24', '14694191063', '1971-03-01', 'cliente24@teste.com', null),
('Cliente 25', '42716710023', '1999-04-01', 'cliente25@teste.com', null),
('Cliente 26', '02310014010', '2003-05-01', 'cliente26@teste.com', null),
('Cliente 27', '95952082050', '1955-06-01', 'cliente27@teste.com', null),
('Cliente 28', '38256267097', '1943-07-01', 'cliente28@teste.com', null),
('Cliente 29', '55116715094', '1972-08-01', 'cliente29@teste.com', null),
('Cliente 30', '80963690086', '1965-09-01', 'cliente30@teste.com', null),
('Cliente 31', '40276271050', '1991-10-01', 'cliente31@teste.com', null),
('Cliente 32', '23739885009', '1974-11-01', 'cliente32@teste.com', null),
('Cliente 33', '49690081080', '1952-12-01', 'cliente33@teste.com', null),
('Cliente 34', '58841830034', '1988-01-01', 'cliente34@teste.com', null),
('Cliente 35', '53493792085', '1970-02-01', 'cliente35@teste.com', null),
('Cliente 36', '87209279083', '1985-03-01', 'cliente36@teste.com', null),
('Cliente 37', '54660159035', '2007-04-01', 'cliente37@teste.com', null),
('Cliente 38', '36696253050', '1966-05-01', 'cliente38@teste.com', null),
('Cliente 39', '75853255096', '1984-06-01', 'cliente39@teste.com', null),
('Cliente 40', '01154904008', '1976-07-01', 'cliente40@teste.com', null),
('Cliente 41', '89452629037', '1987-08-01', 'cliente41@teste.com', null),
('Cliente 42', '76603915006', '1993-09-01', 'cliente42@teste.com', null),
('Cliente 43', '51892787008', '2008-10-01', 'cliente43@teste.com', null),
('Cliente 44', '06159542001', '1978-11-01', 'cliente44@teste.com', null),
('Cliente 45', '94178442023', '1980-12-01', 'cliente45@teste.com', null),
('Cliente 46', '54882125072', '1983-01-01', 'cliente46@teste.com', null),
('Cliente 47', '07546146038', '1984-02-01', 'cliente47@teste.com', null),
('Cliente 48', '11262988080', '1985-03-01', 'cliente48@teste.com', null),
('Cliente 49', '91305474074', '1986-04-01', 'cliente49@teste.com', null),
('Cliente 50', '62452277045', '1987-05-01', 'cliente50@teste.com', null);

------------- INSERT DIVIDAS ---------------

INSERT INTO dividas (id_cliente, valor_divida, situacao, descricao) VALUES

(1, 50.00, FALSE, 'Compra Teste 1.1'),
(1, 70.00, FALSE, 'Compra Teste 1.2'),
(1, 30.00, FALSE, 'Compra Teste 1.3'),

(2, 40.00, FALSE, 'Compra Teste 2.1'),
(2, 60.00, FALSE, 'Compra Teste 2.2'),

(3, 100.00, FALSE, 'Compra Teste 3.1'),
(3, 100.00, FALSE, 'Compra Teste 3.2'),

(4, 150.00, FALSE, 'Compra Teste 4.1'),

(5, 30.00, FALSE, 'Compra Teste 4.1'),
(5, 20.00, FALSE, 'Compra Teste 4.2'),
(5, 40.00, FALSE, 'Compra Teste 4.3'),

(6, 60.00, FALSE, 'Compra Teste 5.1'),
(6, 80.00, FALSE, 'Compra Teste 5.2'),

(7, 70.00, FALSE, 'Compra Teste 6.1'),

(8, 20.00, FALSE, 'Compra Teste 7.1'),
(8, 100.00, FALSE, 'Compra Teste 7.2'),

(9, 50.00, FALSE, 'Compra Teste 8.1'),
(9, 90.00, FALSE, 'Compra Teste 8.2'),

(10, 15.00, FALSE, 'Compra Teste 10.1'),
(10, 10.00, FALSE, 'Compra Teste 10.2'),
(10, 25.00, FALSE, 'Compra Teste 10.3'),

(11, 20.00, FALSE, 'Compra Teste 11.1'),
(11, 30.00, FALSE, 'Compra Teste 11.2'),

(12, 50.00, FALSE, 'Compra Teste 12.1'),

(13, 35.00, FALSE, 'Compra Teste 13.1'),
(13, 45.00, FALSE, 'Compra Teste 13.2'),

(14, 40.00, FALSE, 'Compra Teste 14.1'),

(15, 55.00, FALSE, 'Compra Teste 15.1'),
(15, 25.00, FALSE, 'Compra Teste 15.2'),

(16, 70.00, FALSE, 'Compra Teste 16.1'),

(17, 65.00, FALSE, 'Compra Teste 17.1'),
(17, 35.00, FALSE, 'Compra Teste 17.2'),

(18, 45.00, FALSE, 'Compra Teste 18.1'),

(19, 50.00, FALSE, 'Compra Teste 19.1'),

(20, 75.00, FALSE, 'Compra Teste 20.1'),

(21, 85.00, FALSE, 'Compra Teste 21.1'),
(21, 55.00, FALSE, 'Compra Teste 21.2'),

(22, 30.00, FALSE, 'Compra Teste 22.1'),
(22, 40.00, FALSE, 'Compra Teste 22.2'),

(23, 25.00, FALSE, 'Compra Teste 23.1'),
(23, 30.00, FALSE, 'Compra Teste 23.2'),

(24, 60.00, FALSE, 'Compra Teste 24.1'),
(24, 50.00, FALSE, 'Compra Teste 24.2'),

(25, 35.00, FALSE, 'Compra Teste 25.1'),

(26, 80.00, FALSE, 'Compra Teste 26.1'),
(26, 20.00, FALSE, 'Compra Teste 26.2'),

(27, 45.00, FALSE, 'Compra Teste 27.1'),
(27, 55.00, FALSE, 'Compra Teste 27.2'),

(28, 65.00, FALSE, 'Compra Teste 28.1'),
(28, 35.00, FALSE, 'Compra Teste 28.2'),

(29, 20.00, FALSE, 'Compra Teste 29.1'),
(29, 10.00, FALSE, 'Compra Teste 29.2'),

(30, 70.00, FALSE, 'Compra Teste 30.1'),
(30, 30.00, FALSE, 'Compra Teste 30.2'),

(31, 40.00, FALSE, 'Compra Teste 31.1'),

(32, 25.00, FALSE, 'Compra Teste 32.1'),
(32, 35.00, FALSE, 'Compra Teste 32.2'),

(33, 50.00, FALSE, 'Compra Teste 33.1'),

(34, 45.00, FALSE, 'Compra Teste 34.1'),
(34, 30.00, FALSE, 'Compra Teste 34.2'),

(35, 55.00, FALSE, 'Compra Teste 35.1'),

(36, 60.00, FALSE, 'Compra Teste 36.1'),
(36, 50.00, FALSE, 'Compra Teste 36.2'),

(37, 35.00, FALSE, 'Compra Teste 37.1'),

(38, 85.00, FALSE, 'Compra Teste 38.1'),
(38, 15.00, FALSE, 'Compra Teste 38.2'),

(39, 45.00, FALSE, 'Compra Teste 39.1'),
(39, 30.00, FALSE, 'Compra Teste 39.2'),

(40, 50.00, FALSE, 'Compra Teste 40.1'),

(41, 25.00, FALSE, 'Compra Teste 41.1'),
(41, 35.00, FALSE, 'Compra Teste 41.2'),

(42, 70.00, FALSE, 'Compra Teste 42.1'),
(42, 50.00, FALSE, 'Compra Teste 42.2'),

(43, 60.00, FALSE, 'Compra Teste 43.1'),

(44, 45.00, FALSE, 'Compra Teste 44.1'),
(44, 30.00, FALSE, 'Compra Teste 44.2'),

(45, 55.00, FALSE, 'Compra Teste 45.1'),

(46, 80.00, FALSE, 'Compra Teste 46.1'),
(46, 10.00, FALSE, 'Compra Teste 46.2'),

(47, 45.00, FALSE, 'Compra Teste 47.1'),

(48, 75.00, FALSE, 'Compra Teste 48.1'),
(48, 25.00, FALSE, 'Compra Teste 48.2'),

(49, 35.00, FALSE, 'Compra Teste 49.1'),

(50, 45.00, FALSE, 'Compra Teste 50.1'),
(50, 55.00, FALSE, 'Compra Teste 50.2');