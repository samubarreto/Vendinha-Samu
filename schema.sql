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
    numero_celular VARCHAR(11) NOT NULL,
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
cpf e número de celular tenham lenght diferente
de 11 */
CREATE OR REPLACE FUNCTION validar_cpf_celular()
RETURNS TRIGGER AS $$
DECLARE
    cpf_text VARCHAR(11);
    numero_celular_text VARCHAR(11);
BEGIN
    cpf_text := NEW.cpf;
    numero_celular_text = NEW.numero_celular;

    -- se tem 11 dígitos
    IF LENGTH(cpf_text) <> 11 OR NOT (cpf_text ~ '^[0-9]+$') THEN
        RAISE EXCEPTION 'CPF inválido. O CPF deve conter exatamente 11 dígitos numéricos.';
    END IF;

    IF LENGTH(numero_celular_text) <> 11 THEN
        RAISE EXCEPTION 'Número de Celular inválido. O número deve conter 11 dígitos numéricos (sem máscara)';
    END IF;

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

/* A função abaixo é executada sempre após um update numa dívida,
e se a situação for alterada para true, ela define a data de pagamento
para current date */

CREATE OR REPLACE FUNCTION atualizar_data_pagamento()
RETURNS TRIGGER AS $$
BEGIN
    -- de false para true, define a data de pagamento para current date
    IF NEW.situacao = TRUE AND OLD.situacao = FALSE THEN
        NEW.data_pagamento = CURRENT_DATE;
    -- de true para false, estora exception
    ELSIF NEW.situacao = FALSE AND OLD.situacao = TRUE THEN
        RAISE EXCEPTION 'Não é permitido alterar a situação de uma dívida paga para não paga.';
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
a função validar_cpf_celular() */
CREATE TRIGGER trigger_verifica_cpf_celular
BEFORE INSERT OR UPDATE ON clientes
FOR EACH ROW
EXECUTE FUNCTION validar_cpf_celular();

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

/* A trigger abaixo é acionada sempre antes dum update
numa dívida, chama a função atualizar_data_pagamento() */
CREATE TRIGGER trigger_atualiza_data_pagamento
BEFORE UPDATE ON dividas
FOR EACH ROW
EXECUTE FUNCTION atualizar_data_pagamento();

------------- INSERT CLIENTES ---------------

INSERT INTO clientes (nome_completo, cpf, data_nascimento, email, numero_celular, profile_url) VALUES
('Ana Carolina Silva', '77120005065', '2008-06-01', 'ana.carolina.silva@teste.com', '11234567890', null),
('João da Silva Oliveira', '48350876077', '1959-07-01', 'joao.silva.oliveira@teste.com', '11987654321', null),
('Maria de Fátima Santos', '10068351054', '1935-08-01', 'maria.fatima.santos@teste.com', '11923456789', null),
('Pedro Henrique Souza', '14462563085', '2002-12-25', 'pedro.henrique.souza@teste.com', '11998765432', null),
('Carla Cristina Pereira', '11265316007', '1957-10-01', 'carla.cristina.pereira@teste.com', '11912345678', null),
('Antônio José Santos', '68436606060', '1944-11-01', 'antonio.jose.santos@teste.com', '11987651234', null),
('Luiza da Silva Martins', '32676983083', '2006-12-01', 'luiza.silva.martins@teste.com', '11923451234', null),
('Rafael da Costa', '41087006007', '1995-01-01', 'rafael.da.costa@teste.com', '11998761234', null),
('Amanda de Oliveira Ferreira', '03249721050', '2003-02-01', 'amanda.oliveira.ferreira@teste.com', '11912347654', null),
('Marcos Vinícius Silva', '47811148064', '1966-01-01', 'marcos.vinicius.silva@teste.com', '11987659876', null),
('Juliana Aparecida Oliveira', '61637755031', '1949-02-01', 'juliana.aparecida.oliveira@teste.com', '11923452345', null),
('Fernando Almeida Santos', '62139599047', '1962-03-01', 'fernando.almeida.santos@teste.com', '11998762345', null),
('Carolina da Costa Santos', '57559315003', '1979-04-01', 'carolina.da.costa.santos@teste.com', '11912348765', null),
('Paulo Roberto Lima', '78456336076', '1986-05-01', 'paulo.roberto.lima@teste.com', '11987653456', null),
('Camila Oliveira Santos', '79372405043', '1998-06-01', 'camila.oliveira.santos@teste.com', '11923453456', null),
('Márcio Luiz Pereira', '30250729032', '2001-07-01', 'marcio.luiz.pereira@teste.com', '11998764567', null),
('Ana Paula Alves Costa', '93076257005', '1968-08-01', 'ana.paula.alves.costa@teste.com', '11912349876', null),
('Lucas da Silva Souza', '40932903002', '1956-09-01', 'lucas.da.silva.souza@teste.com', '11987654567', null),
('Tatiana Costa Martins', '63594256022', '2000-10-01', 'tatiana.costa.martins@teste.com', '11923454567', null),
('Diego Oliveira Santos', '61221479075', '1954-11-01', 'diego.oliveira.santos@teste.com', '11998765678', null),
('Patrícia Lima Costa', '13103426011', '1977-12-01', 'patricia.lima.costa@teste.com', '11912340987', null),
('Marcelo Almeida Pereira', '04503698036', '1981-01-01', 'marcelo.almeida.pereira@teste.com', '11987655678', null),
('Aline Oliveira Costa', '45867427048', '1990-02-01', 'aline.oliveira.costa@teste.com', '11923455678', null),
('Rodrigo da Silva', '14694191063', '1971-03-01', 'rodrigo.da.silva@teste.com', '11998766789', null),
('Bianca Costa Martins', '42716710023', '1999-04-01', 'bianca.costa.martins@teste.com', '11912341234', null),
('Retorna8', '84157119053', '1999-04-01', 'a@b.com', '11987656789', null),
('Retorna8', '55875225041', '1999-04-01', 'a@bc.com', '11923456780', null),
('Retorna8', '39332775079', '1999-04-01', 'a@bd.com', '11998767890', null),
('Retorna8', '97406539010', '1999-04-01', 'a@be.com', '11912342345', null),
('Retorna8', '80354947087', '1999-04-01', 'a@bf.com', '11987657890', null),
('Retorna8', '24389309005', '1999-04-01', 'a@bg.com', '11923457890', null),
('Retorna8', '59481692000', '1999-04-01', 'a@bh.com', '11998768901', null),
('Retorna8', '16352159001', '1999-04-01', 'a@bj.com', '11912343456', null),
('Retorna6', '61763933024', '1999-04-01', 'a@6bfa.com', '11987658901', null),
('Retorna6', '71079046046', '1999-04-01', 'a@6bga.com', '11923458901', null),
('Retorna6', '00850016002', '1999-04-01', 'a@6bha.com', '11998769012', null),
('Retorna6', '13572139058', '1999-04-01', 'a@6bja.com', '11912344567', null),
('Retorna6', '12477948067', '1999-04-01', 'a@6bsja.com', '11987660123', null),
('Retorna6', '33415105083', '1999-04-01', 'a@6basja.com', '11923460123', null),
('Retorna4', '67705317044', '1999-04-01', 'a@bfa.com', '11998771234', null),
('Retorna4', '51378882067', '1999-04-01', 'a@bga.com', '11912345601', null),
('Retorna4', '87808178071', '1999-04-01', 'a@bha.com', '11987652345', null),
('Retorna4', '92889612082', '1999-04-01', 'a@bja.com', '11923456701', null),
('Retorna2', '00680103031', '1999-04-01', 'a@baha.com', '11998763456', null),
('Retorna2', '24229766033', '1999-04-01', 'a@bjaa.com', '11912346789', null),
('Retorna1', '12801264008', '1999-04-01', 'a@bjaba.com', '11987651230', null);

------------- INSERT DIVIDAS ---------------

INSERT INTO dividas (id_cliente, valor_divida, situacao, descricao, data_pagamento)
VALUES
-- Dívidas para id_cliente = 1
(1, 50.00, FALSE, 'Camiseta masculina azul tamanho M', NULL),
(1, 70.00, FALSE, 'Tênis esportivo preto número 40', NULL),
(1, 30.00, FALSE, 'Calça jeans feminina skinny', NULL),
(1, 25.00, TRUE, 'Boné de marca famosa', '2024-06-15'),
(1, 40.00, TRUE, 'Óculos de sol estiloso', '2024-06-15'),
(1, 60.00, TRUE, 'Bolsa de couro para laptop', '2024-06-15'),
(1, 20.00, TRUE, 'Carteira de couro', '2024-06-15'),
(1, 30.00, TRUE, 'Relógio analógico clássico', '2024-06-15'),
(1, 15.00, TRUE, 'Meias esportivas', '2024-06-15'),
(1, 25.00, TRUE, 'Cinto de couro', '2024-06-15'),
(1, 15.00, TRUE, 'Caneca personalizada', '2024-06-15'),
(1, 20.00, TRUE, 'Chapéu de palha', '2024-06-15'),
(1, 15.00, TRUE, 'Porta-cartões de metal', '2024-06-15'),
(1, 20.00, TRUE, 'Porta-chaves decorativo', '2024-06-15'),
(1, 10.00, TRUE, 'Porta-retrato simples', '2024-06-15'),

-- Dívidas para id_cliente = 2
(2, 40.00, FALSE, 'Blusa de lã branca com gola alta', NULL),
(2, 60.00, FALSE, 'Jaqueta corta-vento masculina', NULL),
(2, 25.00, TRUE, 'Bolsa térmica para picnic', '2024-06-20'),
(2, 50.00, TRUE, 'Mala de viagem resistente', '2024-06-20'),
(2, 40.00, TRUE, 'Cachecol de lã', '2024-06-20'),
(2, 30.00, TRUE, 'Guarda-chuva automático', '2024-06-20'),
(2, 25.00, TRUE, 'Meias de algodão', '2024-06-20'),
(2, 35.00, TRUE, 'Lenço estampado', '2024-06-20'),
(2, 20.00, TRUE, 'Touca de inverno', '2024-06-20'),
(2, 15.00, TRUE, 'Luvas térmicas', '2024-06-20'),
(2, 10.00, TRUE, 'Porta-documentos', '2024-06-20'),
(2, 25.00, TRUE, 'Porta-guarda-chuva', '2024-06-20'),
(2, 30.00, TRUE, 'Nécessaire para viagem', '2024-06-20'),
(2, 15.00, TRUE, 'Porta-óculos', '2024-06-20'),

-- Dívidas para id_cliente = 3
(3, 100.00, FALSE, 'Bota de couro marrom estilo country', NULL),
(3, 100.00, FALSE, 'Vestido de festa longo azul marinho', NULL),
(3, 40.00, TRUE, 'Gravata de seda', '2024-06-25'),
(3, 60.00, TRUE, 'Pochete esportiva', '2024-06-25'),
(3, 30.00, TRUE, 'Óculos de grau', '2024-06-25'),
(3, 70.00, TRUE, 'Cinto de couro legítimo', '2024-06-25'),
(3, 50.00, TRUE, 'Mochila urbana', '2024-06-25'),
(3, 25.00, TRUE, 'Carteira de couro sintético', '2024-06-25'),
(3, 15.00, TRUE, 'Lenço de seda', '2024-06-25'),
(3, 20.00, TRUE, 'Bijuterias diversas', '2024-06-25'),
(3, 25.00, TRUE, 'Boné esportivo', '2024-06-25'),
(3, 30.00, TRUE, 'Guarda-sol compacto', '2024-06-25'),
(3, 20.00, TRUE, 'Necessaire masculina', '2024-06-25'),
(3, 10.00, TRUE, 'Porta-chaves simples', '2024-06-25'),

-- Dívidas para id_cliente = 4
(4, 150.00, FALSE, 'Mochila escolar resistente', NULL),
(4, 50.00, FALSE, 'Estojo escolar completo', NULL),
(4, 70.00, TRUE, 'Bolsa feminina de couro', '2024-06-30'),
(4, 40.00, TRUE, 'Cinto de tecido', '2024-06-30'),
(4, 25.00, TRUE, 'Meias de algodão coloridas', '2024-06-30'),
(4, 15.00, TRUE, 'Carteira pequena', '2024-06-30'),
(4, 20.00, TRUE, 'Porta-cartões moderno', '2024-06-30'),
(4, 10.00, TRUE, 'Porta-moedas', '2024-06-30'),
(4, 30.00, TRUE, 'Organizador de bolsa', '2024-06-30'),
(4, 25.00, TRUE, 'Porta-celular de couro', '2024-06-30'),
(4, 20.00, TRUE, 'Chaveiro de metal', '2024-06-30'),
(4, 15.00, TRUE, 'Porta-óculos retrátil', '2024-06-30'),
(4, 25.00, TRUE, 'Squeeze personalizada', '2024-06-30'),
(4, 30.00, TRUE, 'Nécessaire de viagem', '2024-06-30'),

-- Dívidas para id_cliente = 5
(5, 30.00, FALSE, 'Agenda executiva 2024', NULL),
(5, 20.00, FALSE, 'Canetas coloridas para desenho', NULL),
(5, 50.00, TRUE, 'Mala de viagem', '2024-07-05'),
(5, 50.00, TRUE, 'Guarda-chuva estampado', '2024-07-05'),
(5, 40.00, TRUE, 'Bolsa térmica para piquenique', '2024-07-05'),
(5, 30.00, TRUE, 'Porta-documentos de couro', '2024-07-05'),
(5, 15.00, TRUE, 'Meias divertidas', '2024-07-05'),
(5, 25.00, TRUE, 'Lenço de seda estampado', '2024-07-05'),
(5, 20.00, TRUE, 'Nécessaire masculina', '2024-07-05'),
(5, 10.00, TRUE, 'Porta-chaves prático', '2024-07-05'),
(5, 15.00, TRUE, 'Porta-óculos elegante', '2024-07-05'),
(5, 20.00, TRUE, 'Chapéu de praia', '2024-07-05'),
(5, 15.00, TRUE, 'Cinto estiloso', '2024-07-05'),
(5, 10.00, TRUE, 'Carteira compacta', '2024-07-05'),

-- Dívidas para id_cliente = 6
(6, 60.00, FALSE, 'Kit de ferramentas básicas para casa', NULL),
(6, 80.00, FALSE, 'Luminária de mesa ajustável', NULL),
(6, 45.00, TRUE, 'Organizador de maquiagem', '2024-07-10'),
(6, 35.00, TRUE, 'Espelho de aumento', '2024-07-10'),
(6, 25.00, TRUE, 'Caixa organizadora', '2024-07-10'),
(6, 30.00, TRUE, 'Porta-jóias', '2024-07-10'),
(6, 20.00, TRUE, 'Escova de cabelo', '2024-07-10'),
(6, 15.00, TRUE, 'Pente de madeira', '2024-07-10'),
(6, 25.00, TRUE, 'Saboneteira decorativa', '2024-07-10'),
(6, 10.00, TRUE, 'Porta-escovas de dente', '2024-07-10'),
(6, 20.00, TRUE, 'Cesto organizador', '2024-07-10'),
(6, 15.00, TRUE, 'Lixeira de metal', '2024-07-10'),
(6, 10.00, TRUE, 'Porta-sabonetes', '2024-07-10'),
(6, 20.00, TRUE, 'Toalheiro de parede', '2024-07-10'),

-- Dívidas para id_cliente = 7
(7, 70.00, FALSE, 'Monitor LED 21.5" Full HD', NULL),
(7, 50.00, FALSE, 'Teclado gamer mecânico', NULL),
(7, 30.00, TRUE, 'Mouse sem fio', '2024-07-15'),
(7, 40.00, TRUE, 'Mousepad gamer', '2024-07-15'),
(7, 20.00, TRUE, 'Headset gamer', '2024-07-15'),
(7, 30.00, TRUE, 'Controle remoto universal', '2024-07-15'),
(7, 15.00, TRUE, 'Hub USB', '2024-07-15'),
(7, 25.00, TRUE, 'Adaptador HDMI', '2024-07-15'),
(7, 10.00, TRUE, 'Cabo de rede', '2024-07-15'),
(7, 20.00, TRUE, 'Pen drive', '2024-07-15'),
(7, 15.00, TRUE, 'Carregador USB', '2024-07-15'),
(7, 10.00, TRUE, 'Adaptador Bluetooth', '2024-07-15'),
(7, 15.00, TRUE, 'Suporte para monitor', '2024-07-15'),
(7, 10.00, TRUE, 'Organizador de cabos', '2024-07-15'),

-- Dívidas para id_cliente = 8
(8, 20.00, FALSE, 'Jogo de copos de vidro temperado', NULL),
(8, 100.00, FALSE, 'Panela elétrica multifuncional', NULL),
(8, 30.00, TRUE, 'Frigideira antiaderente', '2024-07-20'),
(8, 40.00, TRUE, 'Conjunto de talheres', '2024-07-20'),
(8, 20.00, TRUE, 'Assadeira de vidro', '2024-07-20'),
(8, 30.00, TRUE, 'Garrafa térmica', '2024-07-20'),
(8, 15.00, TRUE, 'Avental de cozinha', '2024-07-20'),
(8, 25.00, TRUE, 'Porta-guardanapos', '2024-07-20'),
(8, 10.00, TRUE, 'Escorredor de pratos', '2024-07-20'),
(8, 20.00, TRUE, 'Potes plásticos', '2024-07-20'),
(8, 15.00, TRUE, 'Rodo de pia', '2024-07-20'),
(8, 10.00, TRUE, 'Porta-sabão líquido', '2024-07-20'),
(8, 15.00, TRUE, 'Tábua de corte', '2024-07-20'),
(8, 10.00, TRUE, 'Descanso de panelas', '2024-07-20'),

-- Dívidas para id_cliente = 9
(9, 50.00, FALSE, 'Conjunto de toalhas de banho', NULL),
(9, 90.00, FALSE, 'Cadeira ergonômica para escritório', NULL),
(9, 70.00, TRUE, 'Tapete para banheiro', '2024-07-25'),
(9, 50.00, TRUE, 'Puff decorativo', '2024-07-25'),
(9, 30.00, TRUE, 'Espelho decorativo', '2024-07-25'),
(9, 40.00, TRUE, 'Porta-shampoo', '2024-07-25'),
(9, 25.00, TRUE, 'Kit de acessórios para banheiro', '2024-07-25'),
(9, 15.00, TRUE, 'Organizador de maquiagem', '2024-07-25'),
(9, 20.00, TRUE, 'Sabonete líquido', '2024-07-25'),
(9, 10.00, TRUE, 'Porta-escova de dentes', '2024-07-25'),
(9, 25.00, TRUE, 'Toalheiro de parede', '2024-07-25'),
(9, 20.00, TRUE, 'Lixeira para banheiro', '2024-07-25'),
(9, 10.00, TRUE, 'Cesto organizador', '2024-07-25'),
(9, 15.00, TRUE, 'Suporte para papel higiênico', '2024-07-25'),

-- Dívidas para id_cliente = 10
(10, 15.00, FALSE, 'Fone de ouvido intra-auricular', NULL),
(10, 10.00, FALSE, 'Capa protetora para celular', NULL),
(10, 25.00, FALSE, 'Mouse sem fio', NULL),
(10, 60.00, TRUE, 'Teclado mecânico', '2024-08-01'),
(10, 40.00, TRUE, 'Mouse gamer', '2024-08-01'),
(10, 25.00, TRUE, 'Mousepad estendido', '2024-08-01'),
(10, 30.00, TRUE, 'Headset gamer sem fio', '2024-08-01'),
(10, 20.00, TRUE, 'Suporte para headset', '2024-08-01'),
(10, 15.00, TRUE, 'Tapete para mouse', '2024-08-01'),
(10, 10.00, TRUE, 'Cabo extensor USB', '2024-08-01'),
(10, 25.00, TRUE, 'Hub USB 3.0', '2024-08-01'),
(10, 20.00, TRUE, 'Suporte para celular', '2024-08-01'),
(10, 15.00, TRUE, 'Organizador de cabos', '2024-08-01'),
(10, 10.00, TRUE, 'Capa para mouse', '2024-08-01'),

-- Dívidas para id_cliente = 11
(11, 20.00, FALSE, 'Lanterna recarregável de LED', NULL),
(11, 30.00, FALSE, 'Corda de pular profissional', NULL),
(11, 70.00, TRUE, 'Barraca de camping para 4 pessoas', '2024-08-05'),
(11, 30.00, TRUE, 'Colchonete inflável', '2024-08-05'),
(11, 25.00, TRUE, 'Saco de dormir', '2024-08-05'),
(11, 15.00, TRUE, 'Fogareiro portátil', '2024-08-05'),
(11, 20.00, TRUE, 'Canivete suíço', '2024-08-05'),
(11, 10.00, TRUE, 'Lanterna de cabeça', '2024-08-05'),
(11, 30.00, TRUE, 'Garrafa térmica para camping', '2024-08-05'),
(11, 25.00, TRUE, 'Bússola compacta', '2024-08-05'),
(11, 20.00, TRUE, 'Kit de primeiros socorros', '2024-08-05'),
(11, 15.00, TRUE, 'Repelente de insetos', '2024-08-05'),
(11, 20.00, TRUE, 'Isqueiro resistente ao vento', '2024-08-05'),
(11, 10.00, TRUE, 'Pederneira', '2024-08-05'),

-- Dívidas para id_cliente = 12
(12, 50.00, FALSE, 'Tapete para yoga', NULL),
(12, 50.00, FALSE, 'Almofada de meditação', NULL),
(12, 60.00, TRUE, 'Bola de pilates', '2024-08-10'),
(12, 40.00, TRUE, 'Faixa de resistência', '2024-08-10'),
(12, 30.00, TRUE, 'Bloco de yoga', '2024-08-10'),
(12, 20.00, TRUE, 'Toalha de yoga', '2024-08-10'),
(12, 15.00, TRUE, 'Garrafa para água', '2024-08-10'),
(12, 25.00, TRUE, 'Porta-celular esportivo', '2024-08-10'),
(12, 10.00, TRUE, 'Faixa de cabeça esportiva', '2024-08-10'),
(12, 20.00, TRUE, 'Tapete para exercícios', '2024-08-10'),
(12, 15.00, TRUE, 'Rolo de liberação miofascial', '2024-08-10'),
(12, 10.00, TRUE, 'Pulseira de monitoramento', '2024-08-10'),
(12, 15.00, TRUE, 'Capa protetora para colchonete', '2024-08-10'),
(12, 10.00, TRUE, 'Suporte para garrafa', '2024-08-10'),

-- Dívidas para id_cliente = 13
(13, 35.00, FALSE, 'Relógio de parede decorativo', NULL),
(13, 45.00, FALSE, 'Quadro em canvas para sala de estar', NULL),
(13, 50.00, TRUE, 'Tapete para sala', '2024-08-15'),
(13, 40.00, TRUE, 'Cortina de linho', '2024-08-15'),
(13, 30.00, TRUE, 'Almofadas decorativas', '2024-08-15'),
(13, 20.00, TRUE, 'Porta-retratos', '2024-08-15'),
(13, 15.00, TRUE, 'Vasos decorativos', '2024-08-15'),
(13, 25.00, TRUE, 'Luminária de mesa', '2024-08-15'),
(13, 10.00, TRUE, 'Enfeites de parede', '2024-08-15'),
(13, 20.00, TRUE, 'Espelho decorativo', '2024-08-15'),
(13, 15.00, TRUE, 'Caixa organizadora', '2024-08-15'),
(13, 10.00, TRUE, 'Cesto para roupa suja', '2024-08-15'),
(13, 15.00, TRUE, 'Puffs decorativos', '2024-08-15'),
(13, 10.00, TRUE, 'Tapete para entrada', '2024-08-15'),

-- Dívidas para id_cliente = 14
(14, 40.00, FALSE, 'Chapinha para cabelo', NULL),
(14, 60.00, FALSE, 'Secador de cabelo profissional', NULL),
(14, 70.00, TRUE, 'Modelador de cachos', '2024-08-20'),
(14, 30.00, TRUE, 'Prancha para alisamento', '2024-08-20'),
(14, 20.00, TRUE, 'Escova modeladora', '2024-08-20'),
(14, 40.00, TRUE, 'Condicionador profissional', '2024-08-20'),
(14, 25.00, TRUE, 'Shampoo de tratamento', '2024-08-20'),
(14, 15.00, TRUE, 'Creme para pentear', '2024-08-20'),
(14, 20.00, TRUE, 'Máscara capilar', '2024-08-20'),
(14, 10.00, TRUE, 'Leave-in reparador', '2024-08-20'),
(14, 15.00, TRUE, 'Óleo para cabelos', '2024-08-20'),
(14, 10.00, TRUE, 'Ampola de hidratação', '2024-08-20'),
(14, 15.00, TRUE, 'Spray finalizador', '2024-08-20'),
(14, 10.00, TRUE, 'Gel para penteados', '2024-08-20'),

-- Dívidas para id_cliente = 15
(15, 55.00, FALSE, 'Frigideira antiaderente 24cm', NULL),
(15, 25.00, FALSE, 'Kit de talheres de aço inox', NULL),
(15, 30.00, TRUE, 'Panela de pressão elétrica', '2024-08-25'),
(15, 40.00, TRUE, 'Conjunto de potes de vidro', '2024-08-25'),
(15, 25.00, TRUE, 'Tábua de corte em madeira', '2024-08-25'),
(15, 15.00, TRUE, 'Descascador de legumes', '2024-08-25'),
(15, 20.00, TRUE, 'Afiador de facas', '2024-08-25'),
(15, 10.00, TRUE, 'Coador de café', '2024-08-25'),
(15, 15.00, TRUE, 'Escorredor de louças', '2024-08-25'),
(15, 10.00, TRUE, 'Porta-utensílios de cozinha', '2024-08-25'),
(15, 20.00, TRUE, 'Ralador multifuncional', '2024-08-25'),
(15, 15.00, TRUE, 'Espremedor de frutas', '2024-08-25'),
(15, 10.00, TRUE, 'Pegador de massas', '2024-08-25'),
(15, 20.00, TRUE, 'Descanso de panelas', '2024-08-25'),

-- Dívidas para id_cliente = 16
(16, 70.00, FALSE, 'Escova elétrica para cabelos', NULL),
(16, 50.00, FALSE, 'Modelador de cachos automático', NULL),
(16, 30.00, TRUE, 'Secador de cabelo profissional', '2024-09-01'),
(16, 40.00, TRUE, 'Prancha para alisamento', '2024-09-01'),
(16, 20.00, TRUE, 'Babyliss modelador', '2024-09-01'),
(16, 30.00, TRUE, 'Condicionador reparador', '2024-09-01'),
(16, 15.00, TRUE, 'Shampoo de tratamento', '2024-09-01'),
(16, 25.00, TRUE, 'Máscara capilar hidratante', '2024-09-01'),
(16, 10.00, TRUE, 'Leave-in protetor', '2024-09-01'),
(16, 20.00, TRUE, 'Óleo para cabelos', '2024-09-01'),
(16, 15.00, TRUE, 'Spray fixador', '2024-09-01'),
(16, 10.00, TRUE, 'Gel modelador', '2024-09-01'),
(16, 15.00, TRUE, 'Pente de madeira', '2024-09-01'),
(16, 10.00, TRUE, 'Acessórios para cabelo', '2024-09-01'),

-- Dívidas para id_cliente = 17
(17, 65.00, FALSE, 'Câmera de segurança Wi-Fi', NULL),
(17, 35.00, FALSE, 'Conjunto de pilhas recarregáveis', NULL),
(17, 50.00, TRUE, 'Carregador portátil', '2024-09-05'),
(17, 30.00, TRUE, 'Bateria externa', '2024-09-05'),
(17, 20.00, TRUE, 'Lanterna tática', '2024-09-05'),
(17, 30.00, TRUE, 'Cabo USB resistente', '2024-09-05'),
(17, 15.00, TRUE, 'Adaptador de tomadas', '2024-09-05'),
(17, 25.00, TRUE, 'Fita adesiva elétrica', '2024-09-05'),
(17, 10.00, TRUE, 'Organizador de cabos', '2024-09-05'),
(17, 20.00, TRUE, 'Capa à prova de água para celular', '2024-09-05'),
(17, 15.00, TRUE, 'Suporte veicular para celular', '2024-09-05'),
(17, 20.00, TRUE, 'Suporte magnético para celular', '2024-09-05'),
(17, 10.00, TRUE, 'Capa protetora para câmera', '2024-09-05'),
(17, 15.00, TRUE, 'Tripé flexível para celular', '2024-09-05'),

-- Dívidas para id_cliente = 18
(18, 80.00, FALSE, 'Kit de chaves de precisão', NULL),
(18, 45.00, FALSE, 'Multímetro digital', NULL),
(18, 35.00, TRUE, 'Alicate de precisão', '2024-09-10'),
(18, 30.00, TRUE, 'Jogo de brocas', '2024-09-10'),
(18, 20.00, TRUE, 'Fita isolante', '2024-09-10'),
(18, 25.00, TRUE, 'Chave de fenda', '2024-09-10'),
(18, 10.00, TRUE, 'Nível a laser', '2024-09-10'),
(18, 20.00, TRUE, 'Lanterna LED', '2024-09-10'),
(18, 15.00, TRUE, 'Trena de 5 metros', '2024-09-10'),
(18, 10.00, TRUE, 'Ferramenta multifuncional', '2024-09-10'),
(18, 15.00, TRUE, 'Kit de fixadores', '2024-09-10'),
(18, 10.00, TRUE, 'Caixa de ferramentas', '2024-09-10'),
(18, 20.00, TRUE, 'Maleta organizadora', '2024-09-10'),
(18, 15.00, TRUE, 'Alicate de corte', '2024-09-10');

-- Dívidas para id_cliente = 19
INSERT INTO dividas (id_cliente, valor_divida, situacao, descricao, data_pagamento)
VALUES
(19, 50.00, FALSE, 'Filtro de água para torneira', NULL),
(19, 70.00, TRUE, 'Purificador de água', '2024-09-15'),
(19, 40.00, TRUE, 'Refil para filtro de água', '2024-09-15'),
(19, 30.00, TRUE, 'Jogo de copos para água', '2024-09-15'),
(19, 20.00, TRUE, 'Garrafa térmica', '2024-09-15'),
(19, 15.00, TRUE, 'Jarra de vidro', '2024-09-15'),
(19, 25.00, TRUE, 'Balde de gelo', '2024-09-15'),
(19, 10.00, TRUE, 'Porta-filtros', '2024-09-15'),
(19, 20.00, TRUE, 'Descanso para copos', '2024-09-15'),
(19, 15.00, TRUE, 'Suporte para galão de água', '2024-09-15'),
(19, 10.00, TRUE, 'Torre para garrafão de água', '2024-09-15'),
(19, 15.00, TRUE, 'Copo medidor', '2024-09-15'),
(19, 10.00, TRUE, 'Caneca de porcelana', '2024-09-15'),
(19, 15.00, TRUE, 'Filtro para torneira', '2024-09-15'),
(19, 10.00, TRUE, 'Jarra elétrica', '2024-09-15');

-- Dívidas para id_cliente = 20
INSERT INTO dividas (id_cliente, valor_divida, situacao, descricao, data_pagamento)
VALUES
(20, 75.00, FALSE, 'Ventilador de mesa 40cm', NULL),
(20, 90.00, TRUE, 'Ventilador de teto com controle remoto', '2024-09-20'),
(20, 60.00, TRUE, 'Climatizador de ar', '2024-09-20'),
(20, 50.00, TRUE, 'Umidificador de ar', '2024-09-20'),
(20, 40.00, TRUE, 'Filtro de ar', '2024-09-20'),
(20, 30.00, TRUE, 'Suporte para ventilador', '2024-09-20'),
(20, 25.00, TRUE, 'Capa para ventilador', '2024-09-20'),
(20, 20.00, TRUE, 'Lâmpada LED para ventilador', '2024-09-20'),
(20, 15.00, TRUE, 'Controle remoto para ventilador', '2024-09-20'),
(20, 10.00, TRUE, 'Base para ventilador', '2024-09-20'),
(20, 20.00, TRUE, 'Grades de proteção para ventilador', '2024-09-20'),
(20, 15.00, TRUE, 'Peças para ventilador', '2024-09-20'),
(20, 10.00, TRUE, 'Suporte de parede para ventilador', '2024-09-20'),
(20, 15.00, TRUE, 'Hélice para ventilador', '2024-09-20'),
(20, 10.00, TRUE, 'Protetor para hélice de ventilador', '2024-09-20');

-- Dívidas para id_cliente = 21
INSERT INTO dividas (id_cliente, valor_divida, situacao, descricao, data_pagamento)
VALUES
(21, 85.00, FALSE, 'Tábua de corte em bambu', NULL),
(21, 55.00, FALSE, 'Conjunto de potes plásticos para cozinha', NULL),
(21, 100.00, TRUE, 'Conjunto de panelas antiaderentes', '2024-09-25'),
(21, 50.00, TRUE, 'Assadeiras de alumínio', '2024-09-25'),
(21, 30.00, TRUE, 'Espátulas de silicone', '2024-09-25'),
(21, 40.00, TRUE, 'Conchas para cozinha', '2024-09-25'),
(21, 25.00, TRUE, 'Escumadeiras', '2024-09-25'),
(21, 15.00, TRUE, 'Pegadores de massa', '2024-09-25'),
(21, 20.00, TRUE, 'Descascadores de legumes', '2024-09-25'),
(21, 10.00, TRUE, 'Raladores de queijo', '2024-09-25'),
(21, 20.00, TRUE, 'Batedores de ovos', '2024-09-25'),
(21, 15.00, TRUE, 'Abridores de latas', '2024-09-25'),
(21, 10.00, TRUE, 'Cortadores de pizza', '2024-09-25'),
(21, 15.00, TRUE, 'Sacas de pano', '2024-09-25'),
(21, 10.00, TRUE, 'Organizadores de gaveta', '2024-09-25');

-- Dívidas para id_cliente = 22
INSERT INTO dividas (id_cliente, valor_divida, situacao, descricao, data_pagamento)
VALUES
(22, 30.00, FALSE, 'Organizador de maquiagem acrílico', NULL),
(22, 40.00, FALSE, 'Espelho de aumento com ventosa', NULL),
(22, 50.00, TRUE, 'Estojo de maquiagem profissional', '2024-09-30'),
(22, 30.00, TRUE, 'Pincéis para maquiagem', '2024-09-30'),
(22, 20.00, TRUE, 'Esponjas para maquiagem', '2024-09-30'),
(22, 25.00, TRUE, 'Paletas de sombras', '2024-09-30'),
(22, 15.00, TRUE, 'Batom matte', '2024-09-30'),
(22, 20.00, TRUE, 'Base líquida', '2024-09-30'),
(22, 10.00, TRUE, 'Corretivo facial', '2024-09-30'),
(22, 15.00, TRUE, 'Máscara para cílios', '2024-09-30'),
(22, 10.00, TRUE, 'Blush compacto', '2024-09-30'),
(22, 15.00, TRUE, 'Iluminador facial', '2024-09-30'),
(22, 10.00, TRUE, 'Delineador líquido', '2024-09-30'),
(22, 15.00, TRUE, 'Removedor de maquiagem', '2024-09-30'),
(22, 10.00, TRUE, 'Fixador de maquiagem', '2024-09-30');

-- Dívidas para id_cliente = 23
INSERT INTO dividas (id_cliente, valor_divida, situacao, descricao, data_pagamento)
VALUES
(23, 25.00, FALSE, 'Kit de ferramentas para bicicleta', NULL),
(23, 30.00, FALSE, 'Bomba de ar portátil para pneus', NULL),
(23, 15.00, TRUE, 'Coberturas para os raios da roda', '2024-10-05'),
(23, 10.00, TRUE, 'Adaptador para válvulas', '2024-10-05'),
(23, 15.00, TRUE, 'Suporte para GPS', '2024-10-05'),
(23, 10.00, TRUE, 'Kit de remendos para pneus', '2024-10-05'),
(23, 15.00, TRUE, 'Capa de chuva para bicicleta', '2024-10-05'),
(23, 10.00, TRUE, 'Protetor de quadro para bicicleta', '2024-10-05'),
(23, 15.00, TRUE, 'Sinalizador de direção', '2024-10-05'),
(23, 10.00, TRUE, 'Bagageiro dianteiro', '2024-10-05'),
(23, 15.00, TRUE, 'Bolsa de guidão', '2024-10-05'),
(23, 10.00, TRUE, 'Bomba de ar para pneus sem câmara', '2024-10-05'),
(23, 15.00, TRUE, 'Barras de apoio para bicicleta', '2024-10-05'),
(23, 10.00, TRUE, 'Pedal de alumínio', '2024-10-05');

-- Dívidas para id_cliente = 24
INSERT INTO dividas (id_cliente, valor_divida, situacao, descricao, data_pagamento)
VALUES
(24, 60.00, FALSE, 'Jogo de lençóis 400 fios', NULL),
(24, 50.00, FALSE, 'Edredom de casal de microfibra', NULL),
(24, 100.00, TRUE, 'Colcha de retalhos', '2024-10-10'),
(24, 50.00, TRUE, 'Travesseiros de plumas', '2024-10-10'),
(24, 30.00, TRUE, 'Protetor de colchão impermeável', '2024-10-10'),
(24, 40.00, TRUE, 'Cobertor de microfibra', '2024-10-10'),
(24, 25.00, TRUE, 'Almofadas decorativas', '2024-10-10'),
(24, 15.00, TRUE, 'Saia para cama box', '2024-10-10'),
(24, 20.00, TRUE, 'Jogo de cama infantil', '2024-10-10'),
(24, 10.00, TRUE, 'Cobertura para sofá', '2024-10-10'),
(24, 20.00, TRUE, 'Capa para colchão', '2024-10-10'),
(24, 15.00, TRUE, 'Protetor de travesseiro', '2024-10-10'),
(24, 10.00, TRUE, 'Fronhas avulsas', '2024-10-10'),
(24, 15.00, TRUE, 'Lençol térmico', '2024-10-10'),
(24, 10.00, TRUE, 'Capa de almofada', '2024-10-10');

-- Dívidas para id_cliente = 25
INSERT INTO dividas (id_cliente, valor_divida, situacao, descricao, data_pagamento)
VALUES
(25, 35.00, FALSE, 'Caixa de som portátil Bluetooth', NULL),
(25, 45.00, FALSE, 'Kit de cabos HDMI', NULL),
(25, 100.00, TRUE, 'Smart TV 55 polegadas', '2024-10-15'),
(25, 50.00, TRUE, 'Home Theater', '2024-10-15'),
(25, 30.00, TRUE, 'Suporte para TV', '2024-10-15'),
(25, 40.00, TRUE, 'Cabo óptico digital', '2024-10-15'),
(25, 25.00, TRUE, 'Antena digital', '2024-10-15'),
(25, 15.00, TRUE, 'Controle remoto universal', '2024-10-15'),
(25, 20.00, TRUE, 'Cabo de energia', '2024-10-15'),
(25, 10.00, TRUE, 'Conversor digital', '2024-10-15'),
(25, 20.00, TRUE, 'Suporte de parede para TV', '2024-10-15'),
(25, 15.00, TRUE, 'Protetor de tela para TV', '2024-10-15'),
(25, 10.00, TRUE, 'Limpa telas', '2024-10-15'),
(25, 15.00, TRUE, 'Cabo RCA', '2024-10-15'),
(25, 10.00, TRUE, 'Adaptador HDMI', '2024-10-15');