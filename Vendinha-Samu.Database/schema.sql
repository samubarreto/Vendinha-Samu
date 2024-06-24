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
    somatorio_dividas_abertas DECIMAL(8,2) NOT NULL DEFAULT 0,
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
        NEW.profile_url := 'https://127.0.0.1:7258/profile_pics/profile_placeholder.png';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/* A função abaixo é executada sempre antes da
inserção, update ou delete de uma dívida e atualiza
o somatório de dívidas na tabela de clientes kkkkk rachei */
CREATE OR REPLACE FUNCTION atualizar_somatorio_dividas_abertas()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        -- SE FOR DELETE
        UPDATE clientes
        SET somatorio_dividas_abertas = (
            SELECT COALESCE(SUM(valor_divida), 0)
            FROM dividas
            WHERE id_cliente = OLD.id_cliente
            AND situacao = false
        )
        WHERE id_cliente = OLD.id_cliente;
    ELSE
        -- SE FOR UPDATE OU INSERT
        UPDATE clientes
        SET somatorio_dividas_abertas = (
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
a função atualizar_somatorio_dividas_abertas() */
CREATE TRIGGER trigger_atualiza_somatorio_dividas_abertas
AFTER INSERT OR UPDATE OR DELETE ON dividas
FOR EACH ROW
EXECUTE FUNCTION atualizar_somatorio_dividas_abertas();

------------- INSERT CLIENTES ---------------

INSERT INTO clientes (nome_completo, cpf, data_nascimento, email, profile_url) VALUES
('Ana Carolina Silva', '77120005065', '2008-06-01', 'ana.carolina.silva@teste.com', null),
('João da Silva Oliveira', '48350876077', '1959-07-01', 'joao.silva.oliveira@teste.com', null),
('Maria de Fátima Santos', '10068351054', '1935-08-01', 'maria.fatima.santos@teste.com', null),
('Pedro Henrique Souza', '14462563085', '2002-12-25', 'pedro.henrique.souza@teste.com', null),
('Carla Cristina Pereira', '11265316007', '1957-10-01', 'carla.cristina.pereira@teste.com', null),
('Antônio José Santos', '68436606060', '1944-11-01', 'antonio.jose.santos@teste.com', null),
('Luiza da Silva Martins', '32676983083', '2006-12-01', 'luiza.silva.martins@teste.com', null),
('Rafael da Costa', '41087006007', '1995-01-01', 'rafael.da.costa@teste.com', null),
('Amanda de Oliveira Ferreira', '03249721050', '2003-02-01', 'amanda.oliveira.ferreira@teste.com', null),
('Marcos Vinícius Silva', '47811148064', '1966-01-01', 'marcos.vinicius.silva@teste.com', null),
('Juliana Aparecida Oliveira', '61637755031', '1949-02-01', 'juliana.aparecida.oliveira@teste.com', null),
('Fernando Almeida Santos', '62139599047', '1962-03-01', 'fernando.almeida.santos@teste.com', null),
('Carolina da Costa Santos', '57559315003', '1979-04-01', 'carolina.da.costa.santos@teste.com', null),
('Paulo Roberto Lima', '78456336076', '1986-05-01', 'paulo.roberto.lima@teste.com', null),
('Camila Oliveira Santos', '79372405043', '1998-06-01', 'camila.oliveira.santos@teste.com', null),
('Márcio Luiz Pereira', '30250729032', '2001-07-01', 'marcio.luiz.pereira@teste.com', null),
('Ana Paula Alves Costa', '93076257005', '1968-08-01', 'ana.paula.alves.costa@teste.com', null),
('Lucas da Silva Souza', '40932903002', '1956-09-01', 'lucas.da.silva.souza@teste.com', null),
('Tatiana Costa Martins', '63594256022', '2000-10-01', 'tatiana.costa.martins@teste.com', null),
('Diego Oliveira Santos', '61221479075', '1954-11-01', 'diego.oliveira.santos@teste.com', null),
('Patrícia Lima Costa', '13103426011', '1977-12-01', 'patricia.lima.costa@teste.com', null),
('Marcelo Almeida Pereira', '04503698036', '1981-01-01', 'marcelo.almeida.pereira@teste.com', null),
('Aline Oliveira Costa', '45867427048', '1990-02-01', 'aline.oliveira.costa@teste.com', null),
('Rodrigo da Silva', '14694191063', '1971-03-01', 'rodrigo.da.silva@teste.com', null),
('Bianca Costa Martins', '42716710023', '1999-04-01', 'bianca.costa.martins@teste.com', null),
('Retorna8', '84157119053', '1999-04-01', 'a@b.com', null),
('Retorna8', '55875225041', '1999-04-01', 'a@bc.com', null),
('Retorna8', '39332775079', '1999-04-01', 'a@bd.com', null),
('Retorna8', '97406539010', '1999-04-01', 'a@be.com', null),
('Retorna8', '80354947087', '1999-04-01', 'a@bf.com', null),
('Retorna8', '24389309005', '1999-04-01', 'a@bg.com', null),
('Retorna8', '59481692000', '1999-04-01', 'a@bh.com', null),
('Retorna8', '16352159001', '1999-04-01', 'a@bj.com', null),
('Retorna4', '67705317044', '1999-04-01', 'a@bfa.com', null),
('Retorna4', '51378882067', '1999-04-01', 'a@bga.com', null),
('Retorna4', '87808178071', '1999-04-01', 'a@bha.com', null),
('Retorna4', '92889612082', '1999-04-01', 'a@bja.com', null),
('Retorna2', '00680103031', '1999-04-01', 'a@baha.com', null),
('Retorna2', '24229766033', '1999-04-01', 'a@bjaa.com', null),
('Retorna1', '12801264008', '1999-04-01', 'a@bjaba.com', null);

------------- INSERT DIVIDAS ---------------

INSERT INTO dividas (id_cliente, valor_divida, situacao, descricao) VALUES

(1, 50.00, FALSE, 'Camiseta masculina azul tamanho M'),
(1, 70.00, FALSE, 'Tênis esportivo preto número 40'),
(1, 30.00, FALSE, 'Calça jeans feminina skinny'),

(2, 40.00, FALSE, 'Blusa de lã branca com gola alta'),
(2, 60.00, FALSE, 'Jaqueta corta-vento masculina'),

(3, 100.00, FALSE, 'Bota de couro marrom estilo country'),
(3, 100.00, FALSE, 'Vestido de festa longo azul marinho'),

(4, 150.00, FALSE, 'Mochila escolar resistente'),

(5, 30.00, FALSE, 'Agenda executiva 2024'),
(5, 20.00, FALSE, 'Canetas coloridas para desenho'),
(5, 40.00, FALSE, 'Livro de receitas culinárias'),

(6, 60.00, FALSE, 'Kit de ferramentas básicas para casa'),
(6, 80.00, FALSE, 'Luminária de mesa ajustável'),

(7, 70.00, FALSE, 'Monitor LED 21.5" Full HD'),

(8, 20.00, FALSE, 'Jogo de copos de vidro temperado'),
(8, 100.00, FALSE, 'Panela elétrica multifuncional'),

(9, 50.00, FALSE, 'Conjunto de toalhas de banho'),
(9, 90.00, FALSE, 'Cadeira ergonômica para escritório'),

(10, 15.00, FALSE, 'Fone de ouvido intra-auricular'),
(10, 10.00, FALSE, 'Capa protetora para celular'),
(10, 25.00, FALSE, 'Mouse sem fio'),

(11, 20.00, FALSE, 'Lanterna recarregável de LED'),
(11, 30.00, FALSE, 'Corda de pular profissional'),

(12, 50.00, FALSE, 'Tapete para yoga'),

(13, 35.00, FALSE, 'Relógio de parede decorativo'),
(13, 45.00, FALSE, 'Quadro em canvas para sala de estar'),

(14, 40.00, FALSE, 'Chapinha para cabelo'),

(15, 55.00, FALSE, 'Frigideira antiaderente 24cm'),
(15, 25.00, FALSE, 'Kit de talheres de aço inox'),

(16, 70.00, FALSE, 'Escova elétrica para cabelos'),

(17, 65.00, FALSE, 'Câmera de segurança Wi-Fi'),
(17, 35.00, FALSE, 'Conjunto de pilhas recarregáveis'),

(18, 45.00, FALSE, 'Máquina de café expresso'),

(19, 50.00, FALSE, 'Filtro de água para torneira'),

(20, 75.00, FALSE, 'Ventilador de mesa 40cm'),

(21, 85.00, FALSE, 'Tábua de corte em bambu'),
(21, 55.00, FALSE, 'Conjunto de potes plásticos para cozinha'),

(22, 30.00, FALSE, 'Organizador de maquiagem acrílico'),
(22, 40.00, FALSE, 'Espelho de aumento com ventosa'),

(23, 25.00, FALSE, 'Kit de ferramentas para bicicleta'),
(23, 30.00, FALSE, 'Bomba de ar portátil para pneus'),

(24, 60.00, FALSE, 'Jogo de lençóis 400 fios'),
(24, 50.00, FALSE, 'Edredom de casal de microfibra'),

(25, 35.00, FALSE, 'Caixa de som portátil Bluetooth');