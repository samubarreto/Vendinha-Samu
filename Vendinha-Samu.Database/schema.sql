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
('Guilherme da Costa', '02310014010', '2003-05-01', 'guilherme.da.costa@teste.com', null),
('Mariana Oliveira Santos', '95952082050', '1955-06-01', 'mariana.oliveira.santos@teste.com', null),
('Felipe da Silva Oliveira', '38256267097', '1943-07-01', 'felipe.da.silva.oliveira@teste.com', null),
('Vanessa Lima Costa', '55116715094', '1972-08-01', 'vanessa.lima.costa@teste.com', null),
('Leonardo Oliveira Souza', '80963690086', '1965-09-01', 'leonardo.oliveira.souza@teste.com', null),
('Gabriela Almeida Costa', '40276271050', '1991-10-01', 'gabriela.almeida.costa@teste.com', null),
('Bruno da Silva Costa', '23739885009', '1974-11-01', 'bruno.da.silva.costa@teste.com', null),
('Marina Oliveira Santos', '49690081080', '1952-12-01', 'marina.oliveira.santos@teste.com', null),
('Gustavo da Silva Santos', '58841830034', '1988-01-01', 'gustavo.da.silva.santos@teste.com', null),
('Renata Lima da Costa', '53493792085', '1970-02-01', 'renata.lima.da.costa@teste.com', null),
('Luciana da Silva', '87209279083', '1985-03-01', 'luciana.da.silva@teste.com', null),
('Victor Oliveira da Costa', '54660159035', '2007-04-01', 'victor.oliveira.da.costa@teste.com', null),
('Caroline Costa Martins', '36696253050', '1966-05-01', 'caroline.costa.martins@teste.com', null),
('Roberto Almeida da Silva', '75853255096', '1984-06-01', 'roberto.almeida.da.silva@teste.com', null),
('Natália da Silva Santos', '01154904008', '1976-07-01', 'natalia.da.silva.santos@teste.com', null),
('Lucas Oliveira da Silva', '89452629037', '1987-08-01', 'lucas.oliveira.da.silva@teste.com', null),
('Ana Clara da Costa', '76603915006', '1993-09-01', 'ana.clara.da.costa@teste.com', null),
('Ricardo da Silva Oliveira', '51892787008', '2008-10-01', 'ricardo.da.silva.oliveira@teste.com', null),
('Isabela da Costa Lima', '06159542001', '1978-11-01', 'isabela.da.costa.lima@teste.com', null),
('Gabriel Alves da Silva', '94178442023', '1980-12-01', 'gabriel.alves.da.silva@teste.com', null),
('Daniela Oliveira Costa', '54882125072', '1983-01-01', 'daniela.oliveira.costa@teste.com', null),
('Fábio da Costa', '07546146038', '1984-02-01', 'fabio.da.costa@teste.com', null),
('Juliana da Silva Santos', '11262988080', '1985-03-01', 'juliana.da.silva.santos@teste.com', null),
('Anderson da Silva', '91305474074', '1986-04-01', 'anderson.da.silva@teste.com', null),
('Mariana da Costa', '62452277045', '1987-05-01', 'mariana.da.costa@teste.com', null);

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

(25, 35.00, FALSE, 'Caixa de som portátil Bluetooth'),

(26, 80.00, FALSE, 'Aspirador de pó vertical'),
(26, 20.00, FALSE, 'Escova dental elétrica'),

(27, 45.00, FALSE, 'Kit de ferramentas para jardinagem'),
(27, 55.00, FALSE, 'Aparador de grama elétrico'),

(28, 65.00, FALSE, 'Impressora multifuncional'),
(28, 35.00, FALSE, 'Papel fotográfico A4'),

(29, 20.00, FALSE, 'Garrafa térmica 1 litro'),
(29, 10.00, FALSE, 'Conjunto de facas de cozinha'),

(30, 70.00, FALSE, 'Kit de copos para cerveja artesanal'),
(30, 30.00, FALSE, 'Abridor de garrafas'),

(31, 40.00, FALSE, 'Churrasqueira portátil'),

(32, 25.00, FALSE, 'Cafeteira elétrica programável'),
(32, 35.00, FALSE, 'Balde de gelo em aço inox'),

(33, 50.00, FALSE, 'Colchonete dobrável para camping'),

(34, 45.00, FALSE, 'Squeeze térmico para bebidas'),
(34, 30.00, FALSE, 'Mochila térmica para piquenique'),

(35, 55.00, FALSE, 'Filtro de ar para purificador'),

(36, 60.00, FALSE, 'Kit de ferramentas para marcenaria'),
(36, 50.00, FALSE, 'Lixa elétrica orbital'),

(37, 35.00, FALSE, 'Escorredor de louças em aço inox'),

(38, 85.00, FALSE, 'Kit de pinceis profissionais para maquiagem'),
(38, 15.00, FALSE, 'Lençol avulso para cama de casal'),

(39, 45.00, FALSE, 'Jogo de taças de cristal para vinho'),
(39, 30.00, FALSE, 'Decanter de vidro para vinho tinto'),

(40, 50.00, FALSE, 'Aparelho elétrico para cachorro-quente'),

(41, 25.00, FALSE, 'Capa de chuva impermeável'),
(41, 35.00, FALSE, 'Guarda-chuva resistente ao vento'),

(42, 70.00, FALSE, 'Massageador elétrico portátil'),
(42, 50.00, FALSE, 'Pulseira inteligente para monitoramento'),

(43, 60.00, FALSE, 'Kit de ferramentas para eletricista'),

(44, 45.00, FALSE, 'Bolsa térmica para transporte de alimentos'),
(44, 30.00, FALSE, 'Cantil de aço inox para camping'),

(45, 55.00, FALSE, 'Cafeteira italiana de alumínio'),

(46, 80.00, FALSE, 'Liquidificador potente'),
(46, 10.00, FALSE, 'Descascador de frutas'),

(47, 45.00, FALSE, 'Cadeado para bicicleta'),

(48, 75.00, FALSE, 'Conjunto de facas profissionais'),
(48, 25.00, FALSE, 'Afiador de facas'),

(49, 35.00, FALSE, 'Kit de tapetes para banheiro'),

(50, 45.00, FALSE, 'Máquina de cortar cabelo profissional'),
(50, 55.00, FALSE, 'Secador de cabelo iônico');
