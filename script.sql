-- TABLES
CREATE TABLE Pessoa(
    cpf CHAR(11) PRIMARY KEY,
    nome VARCHAR(64) NOT NULL,
    dataNasc DATE NOT NULL,
    email VARCHAR(64) NOT NULL,
    nacionalidade CHAR(3) NOT NULL, -- Ex: BRA, USA, MEX
    cep CHAR(8) NOT NULL,
    logradouro VARCHAR(64) NOT NULL,
    bairro VARCHAR(64) NOT NULL,
    cidade VARCHAR(64) NOT NULL, 
    estado CHAR(2) NOT NULL -- Ex.: MG, SP
);

CREATE TABLE TelefonePessoa(
    cpf CHAR(11),
    telefone CHAR(11), -- EX.: 31999999999
    PRIMARY KEY(cpf, telefone)
);

CREATE TABLE Jogador (
    cpf CHAR(11) PRIMARY KEY, 
    numero INT NOT NULL, -- Número da camisa
    multaRecisoria FLOAT NOT NULL,
    posicao CHAR(3) NOT NULL -- Ex: ATA, VOL, GOL
);

CREATE TABLE Treinador(
    cpf CHAR(11) PRIMARY KEY,
    codRegTreinador INT NOT NULL
);

CREATE TABLE Arbitro(
    cpf CHAR(11) PRIMARY KEY, 
    codRegArbitro INT NOT NULL, 
    tipo VARCHAR(32) NOT NULL
);

CREATE TABLE TipoArbitro(
    nome VARCHAR(32) PRIMARY KEY
);

CREATE TABLE Empregado(
    cpf CHAR(11) PRIMARY KEY,
    numCartTrab INT NOT NULL
);

CREATE TABLE Exerce(
    cpfEmpregado CHAR(11),
    nomeFuncao VARCHAR(64), 
    dataInicio DATE NOT NULL DEFAULT CURRENT_DATE, 
    dataFinal DATE,
    PRIMARY KEY(cpfEmpregado, nomeFuncao, dataInicio)
);

CREATE TABLE Funcao(
    nome VARCHAR(64) PRIMARY KEY,
    nivelAcesso INT NOT NULL
);

CREATE TABLE ResponsavelLegal(
    cpfDependente CHAR(11),
    nome VARCHAR(64), 
    relacao VARCHAR(20) NOT NULL,
    PRIMARY KEY(cpfDependente, nome)
);

CREATE TABLE Clube(
    nome VARCHAR(64) PRIMARY KEY, 
    anoFundacao DATE NOT NULL, 
    pontos INT NOT NULL DEFAULT 0, 
    numSociosTorcedores INT NOT NULL DEFAULT 0, 
    idAgenteFinanceiro INT
);

CREATE TABLE JogaEm(
    cpfJogador CHAR(11), 
    nomeClube VARCHAR(64),
    dataIniContrato DATE DEFAULT CURRENT_DATE,
    tempoContrato INT NOT NULL, -- dias de contrato 
    dataFimContrato DATE NOT NULL,
    PRIMARY KEY(cpfJogador, nomeClube, dataIniContrato)
);

CREATE TABLE TreinaEm(
    cpfTreinador CHAR(11),
    nomeClube VARCHAR(64), 
    dataIniContrato DATE DEFAULT CURRENT_DATE, 
    tempoContrato INT NOT NULL, -- dias de contrato  
    dataFimContrato DATE NOT NULL,
    PRIMARY KEY(cpfTreinador, nomeClube, dataIniContrato)
);

CREATE TABLE Empresa(
    cnpj CHAR(14) PRIMARY KEY,
    nome VARCHAR(64) NOT NULL,
    paisOrigem CHAR(3) NOT NULL, -- Ex.: BRA, USA, MEX, ARG, ING, RUS
    ramo VARCHAR(20) NOT NULL, -- Ex.: Petroleo, Apostas, Banco
    pais CHAR(2) NOT NULL, -- Desambiguação: esse atributo se refere a localidade do escritório da empresa.
                           -- Ex.: Uma empresa Inglesa pode ter um escritório no Brasil 
    provincia VARCHAR(32) NOT NULL,
    cidade VARCHAR(32) NOT NULL,
    bairro VARCHAR(32) NOT NULL,
    logradouro VARCHAR(64) NOT NULL,
    codPostal VARCHAR(16) NOT NULL,
    idAgenteFinanceiro INT
);

CREATE TABLE EmailEmpresa(
    cnpj CHAR(14), 
    email VARCHAR(64),
    PRIMARY KEY(cnpj, email)
);

CREATE TABLE TelefoneEmpresa(
    cnpj CHAR(14), 
    telefone CHAR(11), -- EX.: 31999999999
    PRIMARY KEY(cnpj, telefone)
);

CREATE TABLE Patrocina(
    nomeClube VARCHAR(64), 
    cnpjEmpresa CHAR(14), 
    nivel INT NOT NULL, 
    valorMensal FLOAT NOT NULL,
    PRIMARY KEY(nomeClube, cnpjEmpresa)
);

CREATE TABLE AgenteFinanceiro(
    id INT PRIMARY KEY
);

CREATE TABLE Pagamento(
    id INT PRIMARY KEY, 
    cpf CHAR(11) NOT NULL, 
    idAgente INT NOT NULL, 
    valor FLOAT NOT NULL, 
    formato VARCHAR(16) NOT NULL, -- unico, diario, semanal, mensal, anual, especial
    dataPag DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE Estadio(
    nome VARCHAR(64) PRIMARY KEY, 
    capacidade INT NOT NULL, 
    cep CHAR(8) NOT NULL, 
    estado CHAR(2) NOT NULL, 
    cidade VARCHAR(64) NOT NULL,
    bairro VARCHAR(64) NOT NULL,
    logradouro VARCHAR(64) NOT NULL
);

CREATE TABLE PosseEstadio(
    idAgente INT, 
    nomeEstadio VARCHAR(64),
    valorPago FLOAT NOT NULL, 
    percentual INT NOT NULL, 
    dataAquisicao DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY(idAgente, nomeEstadio)
);

CREATE TABLE Partida(
    id INT PRIMARY KEY, 
    dataPartida DATE NOT NULL, 
    nomeEstadio VARCHAR(64) NOT NULL
);

CREATE TABLE Disputa(
    numDisp INT PRIMARY KEY, 
    idPartida INT NOT NULL, 
    nomeClubeCasa VARCHAR(64) NOT NULL, 
    nomeClubeVisitante VARCHAR(64) NOT NULL
);

CREATE TABLE Cartao(
    numDisputa INT, 
    tempo INT, -- 0 - 5400 segundos
    cor VARCHAR(8), -- amarelo OU vermelho
    cpfInfrator CHAR(11) NOT NULL, 
    tipoFalta VARCHAR(32) NOT NULL, -- dois amarelos, carrinho, empurrao, agressao fisica, agressao verbal, outro
    PRIMARY KEY(numDisputa, tempo, cor)
);

CREATE TABLE Gol(
    numDisputa INT, 
    tempo INT, -- 0 - 5400 segundos 
    tipo VARCHAR(32) NOT NULL, -- chute, cabeceio, falta, contra, olimpico, outro
    cpfJogador CHAR(11) NOT NULL,
    PRIMARY KEY(numDisputa, tempo)
);

-- CONSTRAINTS
ALTER TABLE TelefonePessoa ADD CONSTRAINT FK_TelefonePessoa
FOREIGN KEY(cpf) REFERENCES Pessoa(cpf)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Jogador ADD CONSTRAINT FK_Jogador
FOREIGN KEY(cpf) REFERENCES Pessoa(cpf)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Treinador ADD CONSTRAINT FK_Treinador
FOREIGN KEY(cpf) REFERENCES Pessoa(cpf)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Arbitro ADD CONSTRAINT FK_Arbitro_cpf
FOREIGN KEY(cpf) REFERENCES Pessoa(cpf)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Arbitro ADD CONSTRAINT FK_Arbitro_tipo
FOREIGN KEY(tipo) REFERENCES TipoArbitro(nome)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Empregado ADD CONSTRAINT FK_Empregado
FOREIGN KEY(cpf) REFERENCES Pessoa(cpf)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Exerce ADD CONSTRAINT FK_Exerce_cpfEmpregado
FOREIGN KEY(cpfEmpregado) REFERENCES Empregado(cpf)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Exerce ADD CONSTRAINT FK_Exerce_nomeFuncao
FOREIGN KEY(nomeFuncao) REFERENCES Funcao(nome)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE ResponsavelLegal ADD CONSTRAINT FK_ResponsavelLegal
FOREIGN KEY(cpfDependente) REFERENCES Jogador(cpf)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Clube ADD CONSTRAINT FK_Clube
FOREIGN KEY(idAgenteFinanceiro) REFERENCES AgenteFinanceiro(id)
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE EmailEmpresa ADD CONSTRAINT FK_EmailEmpresa
FOREIGN KEY(cnpj) REFERENCES Empresa(cnpj)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE TelefoneEmpresa ADD CONSTRAINT FK_TelefoneEmpresa
FOREIGN KEY(cnpj) REFERENCES Empresa(cnpj)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Empresa ADD CONSTRAINT FK_Empresa
FOREIGN KEY(idAgenteFinanceiro) REFERENCES AgenteFinanceiro(id)
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE Patrocina ADD CONSTRAINT FK_Patrocina_cnpjEmpresa
FOREIGN KEY(cnpjEmpresa) REFERENCES Empresa(cnpj)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Patrocina ADD CONSTRAINT FK_Patrocina_nomeClube
FOREIGN KEY(nomeClube) REFERENCES Clube(nome)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Pagamento ADD CONSTRAINT FK_Pagamento_cpf
FOREIGN KEY(cpf) REFERENCES Pessoa(cpf)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Pagamento ADD CONSTRAINT FK_Pagamento_idAgente
FOREIGN KEY(idAgente) REFERENCES AgenteFinanceiro(id)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE JogaEm ADD CONSTRAINT FK_JogaEm_cpfJogador
FOREIGN KEY(cpfJogador) REFERENCES Jogador(cpf)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE JogaEm ADD CONSTRAINT FK_JogaEm_nomeClube
FOREIGN KEY(nomeClube) REFERENCES Clube(nome)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE TreinaEm ADD CONSTRAINT FK_TreinaEm_cpfTreinador
FOREIGN KEY(cpfTreinador) REFERENCES Treinador(cpf)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE TreinaEm ADD CONSTRAINT FK_TreinaEm_nomeClube
FOREIGN KEY(nomeClube) REFERENCES Clube(nome)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE PosseEstadio ADD CONSTRAINT FK_PosseEstadio_idAgente
FOREIGN KEY(idAgente) REFERENCES AgenteFinanceiro(id)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE PosseEstadio ADD CONSTRAINT FK_PosseEstadio_nomeEstadio
FOREIGN KEY(nomeEstadio) REFERENCES Estadio(nome)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Partida ADD CONSTRAINT FK_Partida
FOREIGN KEY(nomeEstadio) REFERENCES Estadio(nome)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Disputa ADD CONSTRAINT FK_Disputa_idPartida
FOREIGN KEY(idPartida) REFERENCES Partida(id)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Disputa ADD CONSTRAINT FK_Disputa_nomeClubeCasa
FOREIGN KEY(nomeClubeCasa) REFERENCES Clube(nome)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Disputa ADD CONSTRAINT FK_Disputa_nomeClubeVisitante
FOREIGN KEY(nomeClubeVisitante) REFERENCES Clube(nome)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Cartao ADD CONSTRAINT FK_Cartao_numDisputa
FOREIGN KEY(numDisputa) REFERENCES Disputa(numDisp)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Cartao ADD CONSTRAINT FK_Cartao_cpfInfrator
FOREIGN KEY(cpfInfrator) REFERENCES Pessoa(cpf)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Gol ADD CONSTRAINT FK_Gol_numDisputa
FOREIGN KEY(numDisputa) REFERENCES Disputa(numDisp)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Gol ADD CONSTRAINT FK_Gol_cpfJogador
FOREIGN KEY(cpfJogador) REFERENCES Jogador(cpf)
ON DELETE RESTRICT ON UPDATE CASCADE;

-- POPULANDO O BANCO

INSERT INTO Pessoa (cpf, nome, dataNasc, email, nacionalidade, cep, logradouro, bairro, cidade, estado)
VALUES
    ('11111111111', 'João Silva', '1988-05-15', 'joao.silva@gmail.com', 'BR', '12345678', 'Rua Oswald Andrade', 'Vila Jordanopolis', 'São Bernardo do Campo', 'SP'),
    ('22222222222', 'Maria Santos', '2000-11-30', 'maria.santos@outlook.com', 'AR', '98765432', 'Avenida das Flores', 'Centro', 'Rio de Janeiro', 'RJ'),
    ('33333333333', 'Carlos Souza', '2000-07-20', 'carlos.souza@gmail.com', 'BR', '44556677', 'Rua da Água', 'Marçola', 'Belo Horizonte', 'MG'),
    ('44444444444', 'Amanda Costa', '1997-03-10', 'amanda.costa@outlook.com', 'ME', '11223344', 'Rua da Terra', 'Centro', 'Porto Alegre', 'RS'),
    ('55555555555', 'Rafael Ferreira', '1994-09-25', 'rafael.ferreira@gmail.com', 'BR', '99887766', 'Rua das Flores', 'Centro', 'Recife', 'PE'),
    ('66666666666', 'Patricia Oliveira', '2000-12-05', 'patricia.oliveira@outlook.com', 'BR', '88776655', 'Rua Dom Casmurro', 'Centro', 'Curitiba', 'PR'),
    ('77777777777', 'Josep Guardiola', '1971-01-18', 'guardiola.rey.da.champions@gmail.com', 'ES', '55443322', 'Rua da Matilha', 'Centro', 'Salvador', 'BA'),
    ('88888888888', 'Bruna Lima', '1987-06-18', 'bruna.lima@gmail.com', 'BR', '99887766', 'Rua Dona Angelita', 'Centro', 'Manaus', 'AM'),
    ('99999999999', 'Fernando Carvalho', '1993-04-03', 'fernando.carvalho@outlook.com', 'BR', '11223344', 'Rua Julio Prestes', 'Centro', 'Fortaleza', 'CE'),
    ('10101010101', 'Aline Santos', '1995-08-10', 'aline.santos@gmail.com', 'BR', '44556677', 'Avenida Getúlio Vargas', 'Centro', 'Porto Alegre', 'RS'),
    ('12121212121', 'Roberto Almeida', '1989-12-22', 'roberto.almeida@outlook.com', 'BR', '12345678', 'Rua Presidente Kennedy', 'Centro', 'São Paulo', 'SP'),
    ('13131313131', 'Laura Castro', '1986-11-17', 'laura.castro@gmail.com', 'BR', '11223344', 'Rua Dona Lindóia', 'Centro', 'Rio de Janeiro', 'RJ'),
    ('22222222221', 'Yegor Dumbalon', '2006-11-17', 'yeg.d@gmail.com', 'RU', '11223344', 'Rua Canaã', 'Bethânia', 'Itabira', 'MG'),
    ('22266222221', 'Cristiano Ronaldo', '1985-02-05', 'cristiano.ronaldo@gmail.com', 'PT', '11223344', 'Rua Prof. Antonieta Bethônico', 'Amazonas', 'Itabira', 'MG'),
    ('50505050505', 'Paulo Almeida', '1988-12-06', 'paulo.almeida@outlook.com', 'BR', '12345678', 'Rua Dom Paulo', 'Centro', 'São Paulo', 'SP'),
    ('51515151515', 'Carolina Castro', '1992-08-13', 'carolina.castro@gmail.com', 'BR', '11223344', 'Rua Dona Maria', 'Centro', 'Rio de Janeiro', 'RJ'),
    ('52525252525', 'Paul Alin Dakap Hital', '1996-09-28', 'pl.cap@outlook.com', 'SA', '99887766', 'Rua Amazônia', 'Fênix', 'Itabira', 'MG'),
    ('53535353535', 'Sofia Costa', '1993-11-05', 'sofia.costa@gmail.com', 'BR', '44556677', 'Rua 52', 'Centro', 'Belo Horizonte', 'MG'),
    ('54545454545', 'Eduardo Silva', '2007-06-18', 'eduardo.silva@outlook.com', 'BR', '99887766', 'Rua 53', 'Centro', 'Salvador', 'BA'),
    ('14141414141', 'Pedro Oliveira', '1964-07-07', 'pedro.oliveira@outlook.com', 'BR', '99887766', 'Rua das Flores', 'Centro', 'Recife', 'PE'),
    ('11113111111', 'Kylian Mbappé', '1998-12-20', 'kylian.mbappe@gmail.com', 'FR', '99881766', 'Rua das Rosas', 'Centro', 'Teresina', 'PI'),
    ('22222822222', 'Neymar Jr.', '1992-02-05', 'neymarjr@gmail.com', 'BR', '20231050', 'Avenida Rio Branco', 'Centro', 'Rio de Janeiro', 'RJ'),
    ('33322223333', 'Thibaut Courtois', '1992-05-11', 'thibaut.courtois@gmail.com', 'BE', '30190130', 'Rua Goitacazes', 'Barro Preto', 'Belo Horizonte', 'MG'),
    ('41144444444', 'Kevin De Bruyne', '1991-06-28', 'kdb@gmail.com', 'BE', '30111130', 'Rua da Salada', 'Bairro Novo', 'Belém', 'PA'),
    ('15555555555', 'Sassá', '1993-01-05', 'sassagol@gmail.com', 'BR', '30110130', 'Rua Goitacazes', 'Barro Preto', 'Belo Horizonte', 'MG'),
    ('99999999998', 'Virgil van Dijk', '1991-07-08', 'virgil.vandijk@gmail.com', 'NL', '01445001', 'Avenida Paulista', 'Bela Vista', 'São Paulo', 'SP'),
    ('10101811111', 'Robert Lewandowski', '1988-08-21', 'robert.lewandowski@gmail.com', 'PL', '01310100', 'Avenida Ipiranga', 'República', 'São Paulo', 'SP'),
    ('12121555555', 'Sergio Ramos', '1986-03-30', 'sergio.ramos@gmail.com', 'ES', '22280080', 'Rua Marquês de São Vicente', 'Gávea', 'Rio de Janeiro', 'RJ'),
    ('16666556661', 'Lionel Messi', '1987-06-24', 'lionel.messi@gmail.com', 'AR', '30660130', 'Avenida Cristiano Machado', 'Centro', 'Belo Horizonte', 'MG');

INSERT INTO TelefonePessoa(cpf, telefone)
VALUES
    ('11111111111', '31911711188'),
    ('22222222222', '31922722288'),
    ('33333333333', '31933733321'),
    ('44444444444', '31944744433'),
    ('55555555555', '31955755588'),
    ('66666666666', '31966766688'),
    ('77777777777', '31977777788'),
    ('88888888888', '31988788888'),
    ('99999999999', '31999799988'),
    ('10101010101', '31901710189'),
    ('12121212121', '31921712148'),
    ('13131313131', '31931713148'),
    ('22222222221', '31922722248'),
    ('88888888888', '31988765888'),
    ('99999999999', '31999764988'),
    ('10101010101', '31901763189'),
    ('12121212121', '31921768148'),
    ('13131313131', '31931761148'),
    ('22222222221', '31927611248'),
    ('22266222221', '31922762218'),
    ('50505050505', '31905750518'),
    ('51515151515', '21915751518'),
    ('52525252525', '21925752528'),
    ('53535353535', '21935753518'),
    ('54545454545', '21945754588'),
    ('14141414141', '21941714188'),
    ('11113111111', '21911731188'),
    ('22222822222', '21922728255'),
    ('33322223333', '21933722288'),
    ('41144444444', '21911744488'),
    ('15555555555', '11955755511'),
    ('99999999998', '11999799988'),
    ('10101811111', '11901718188'),
    ('12121555555', '11921715585'),
    ('16666556661', '11966765588');

INSERT INTO Jogador (cpf, numero, multaRecisoria, posicao)
VALUES
    ('16666556661', '10', '1000000', 'ATA'),    -- Lionel Messi
    ('12121555555', '5', '500000', 'ZAG'),      -- Sergio Ramos
    ('10101811111', '1', '100', 'ATA'),         -- Robert Lewandowski
    ('99999999998', '66', '20', 'ZAG'),         -- Virgil van Dijk
    ('15555555555', '44', '9990000', 'ATA'),    -- Sassá
    ('41144444444', '88', '0', 'MEI'),          -- Kevin De Bruyne
    ('11113111111', '14', '9999', 'ATA'),       -- Kylian Mbappé
    ('22222822222', '45', '100', 'PON'),        -- Neymar Jr.
    ('33322223333', '11', '98', 'GOL'),         -- Thibaut Courtois
    ('99999999999', '23', '77', 'LAT'),         -- Fernando Carvalho
    ('52525252525', '14', '99', 'PON'),         -- Paul Alin Dakap Hital
    ('22222222221', '2', '85858', 'LAT'),       -- Yegor Dumbalon
    ('22266222221', '7', '100000000', 'ATA'),   -- Cristiano Ronaldo
    ('54545454545', '88', '8784112', 'LAT');    -- Eduardo Silva

INSERT INTO ResponsavelLegal(cpfDependente, nome, relacao)
VALUES
    ('22222222221', 'Nélio', 'Tio'),
    ('54545454545', 'Ronan', 'Pai');

INSERT INTO Treinador (cpf, codRegTreinador)
VALUES
    ('77777777777', '2001'),  -- Josep Guardiola
    ('11111111111', '7'),     -- João Silva
    ('44444444444', '17'),    -- Amanda Costa
    ('55555555555', '11');    -- Rafael Ferreira

INSERT INTO TipoArbitro (nome)
VALUES
    ('Principal'),
    ('Auxiliar'),
    ('De vídeo'),
    ('Bandeirinha');

INSERT INTO Arbitro (cpf, codRegArbitro, tipo)
VALUES
    ('22222222222', '1001', 'Principal'),     -- Maria Santos
    ('51515151515', '1002', 'Auxiliar'),      -- Carolina Castro
    ('14141414141', '1003', 'Principal'),     -- Pedro Oliveira
    ('66666666666', '2000', 'De vídeo'),      -- Patricia Oliveira
    ('10101010101', '3000', 'Bandeirinha'),   -- Aline Santos
    ('53535353535', '1502', 'Principal');     -- Sofia Costa
    

INSERT INTO Empregado (cpf, numCartTrab)
VALUES
    ('33333333333', '789012'), -- Carlos Souza
    ('88888888888', '345678'), -- Bruna Lima
    ('50505050505', '567890'), -- Paulo Almeida
    ('12121212121', '124124'), -- Roberto Almeida
    ('13131313131', '111228'); -- Laura Castro

INSERT INTO Funcao (nome, nivelAcesso)
VALUES
    ('Faxineiro', '2'),
    ('Téc. de som', '3'),
    ('Téc. de luz', '3'),
    ('Vendedor ambulante', '1'),
    ('Vendedor barraca', '2'),
    ('Segurança', '4');
    
INSERT INTO Exerce (cpfEmpregado, nomeFuncao, dataInicio, dataFinal)
VALUES
    ('33333333333', 'Faxineiro', '2015-05-01', '2015-07-22'),          -- Carlos Souza
    ('33333333333', 'Vendedor ambulante', '2015-11-01', '2016-07-10'), -- Carlos Souza
    ('33333333333', 'Téc. de som', '2020-11-01', NULL),                -- Carlos Souza
    ('88888888888', 'Téc. de luz', '2020-07-14', NULL),                -- Bruna Lima
    ('50505050505', 'Segurança', '2020-07-14', NULL),                  -- Paulo Almeida
    ('12121212121', 'Segurança', '2020-07-14', '2020-09-14'),          -- Roberto Almeida
    ('12121212121', 'Segurança', '2022-03-11', NULL),                  -- Roberto Almeida
    ('13131313131', 'Téc. de luz', '2022-01-17', NULL);                -- Laura Castro

INSERT INTO AgenteFinanceiro(id)
VALUES
    ('1'),
    ('2'),
    ('3'),
    ('4'),
    ('5'),
    ('6');

INSERT INTO Clube (nome, anoFundacao, pontos, numSociosTorcedores, idAgenteFinanceiro)
VALUES
    ('Atlético Mineiro', '1908-03-25', '0', '10', '6'),
    ('Botafogo', '1904-07-01', '1', '10000', '2'),
    ('Cruzeiro', '1921-01-02', '9', '5000000', '1'),
    ('Vasco da Gama', '1898-08-21', '1', '2000000', NULL);

INSERT INTO Empresa(cnpj, nome, paisOrigem, ramo, pais, provincia, cidade, bairro, logradouro, codPostal, idAgenteFinanceiro)
VALUES
    ('11111111111111', 'TechCorp', 'US', 'Tecnologia', 'BR', 'SP', 'São Paulo', 'Centro', 'Avenida Paulista', '01234567', NULL),
    ('22222222222222', 'GreenEnergy', 'BR', 'Energia', 'BR', 'MG', 'Belo Horizonte', 'Savassi', 'Rua das Flores', '98765432', NULL),
    ('33333333333333', 'GlobalBank', 'US', 'Banco', 'BR', 'RJ', 'Rio de Janeiro', 'Centro', 'Avenida Presidente Vargas', '54321098', '3'),
    ('44444444444444', 'BioMed', 'BR', 'Saúde', 'BR', 'SP', 'São Paulo', 'Liberdade', 'Rua das Palmeiras', '76859034', NULL),
    ('44444444444442', 'Vale', 'BR', 'Mineração', 'BR', 'MG', 'Belo Horizonte', 'Centro', 'Rua das Palmeiras', '76859034', '4'),
    ('55555555555555', 'FashionStyle', 'IT', 'Moda', 'BR', 'SC', 'Florianópolis', 'Lagoa da Conceição', 'Rua dos Artistas', '45783109', '5');

INSERT INTO TelefoneEmpresa(cnpj, telefone)
VALUES
    ('11111111111111', '31911441111'),
    ('22222222222222', '11922222222'),
    ('33333333333333', '21933223333'),
    ('11111111111111', '31917271111'),
    ('22222222222222', '11927712222'),
    ('33333333333333', '21935773333'),
    ('44444444444444', '85944154444'),
    ('44444444444442', '31941111444'),
    ('55555555555555', '85955657555');

INSERT INTO EmailEmpresa(cnpj, email)
VALUES
    ('11111111111111', 'tech.corp@gmail.com'),
    ('22222222222222', 'green.energy@outlook.com' ),
    ('22222222222222', 'green.energy@gmail.com' ),
    ('33333333333333', 'g.bank@outlook.com'),
    ('44444444444444', 'bio.med@outlook.com'),
    ('44444444444442', 'vale.rio.doce@bol.com'),
    ('44444444444442', 'vale@valemail.com'),
    ('55555555555555', 'fashion.style@outlook.com');

INSERT INTO Patrocina(nomeClube, cnpjEmpresa, nivel, valorMensal)
VALUES
    ('Cruzeiro', '44444444444442', '10', '100000000'),   -- Vale
    ('Cruzeiro', '44444444444444', '5', '50000000'),     -- BioMed
    ('Botafogo', '44444444444444', '10', '50000000'),    -- BioMed
    ('Vasco da Gama', '44444444444444', '4', '4000000'), -- BioMed
    ('Vasco da Gama', '33333333333333', '6', '5000000'), -- GlobalBank
    ('Botafogo', '55555555555555', '6', '100000');       -- FashionStyle

INSERT INTO JogaEm(cpfJogador, nomeClube, dataIniContrato, tempoContrato, dataFimContrato)
VALUES
    ('16666556661', 'Vasco da Gama', '2022-01-01', '365', '2023-01-01'),     -- Lionel Messi
    ('12121555555', 'Vasco da Gama', '2021-12-15', '90', '2022-03-15'),      -- Sergio Ramos
    ('12121555555', 'Botafogo', '2022-05-05', '20', '2022-05-20'),           -- Sergio Ramos
    ('10101811111', 'Atlético Mineiro', '2021-01-01', '365', '2022-01-01'),  -- Robert Lewandowski
    ('10101811111', 'Cruzeiro', '2023-01-01', '1095', '2026-01-01'),         -- Robert Lewandowski
    ('99999999998', 'Cruzeiro', '2023-01-01', '1095', '2026-01-01'),         -- Virgil van Dijk
    ('15555555555', 'Cruzeiro', '2010-01-01', '3650', '2015-09-01'),         -- Sassá
    ('15555555555', 'Botafogo', '2016-01-01', '30', '2016-02-01'),           -- Sassá
    ('15555555555', 'Botafogo', '2020-11-11', '3650', '2030-11-11'),         -- Sassá
    ('41144444444', 'Botafogo', '2020-11-11', '3650', '2022-11-11'),         -- Kevin De Bruyne
    ('41144444444', 'Vasco da Gama', '2022-11-20', '90', '2023-2-20'),       -- Kevin De Bruyne
    ('11113111111', 'Cruzeiro', '2023-01-01', '1095', '2026-01-01'),         -- Kylian Mbappé
    ('22222822222', 'Cruzeiro', '2023-01-01', '365', '2024-01-01'),          -- Neymar Jr.
    ('33322223333', 'Botafogo', '2016-01-01', '3680', '2026-02-01'),         -- Thibaut Courtois
    ('99999999999', 'Botafogo', '2016-01-01', '3650', '2026-01-01'),         -- Fernando Carvalho
    ('52525252525', 'Vasco da Gama', '2023-01-01', '365', '2024-01-01'),     -- Paul Alin Dakap Hital
    ('22222222221', 'Vasco da Gama', '2023-05-22', '365', '2024-05-22'),     -- Yegor Dumbalon
    ('22266222221', 'Cruzeiro', '2010-11-02', '365', '2011-11-02'),          -- Cristiano Ronaldo
    ('22266222221', 'Cruzeiro', '2020-02-02', '365', '2020-04-02'),          -- Cristiano Ronaldo
    ('22266222221', 'Cruzeiro', '2023-07-20', '90', '2023-10-20'),           -- Cristiano Ronaldo
    ('54545454545', 'Vasco da Gama', '2023-01-01', '365', '2024-01-01');     -- Eduardo Silva

INSERT INTO TreinaEm(cpfTreinador, nomeClube, dataIniContrato, tempoContrato, dataFimContrato)
VALUES
    ('77777777777', 'Cruzeiro', '2023-01-01', '365', '2024-01-01'),           -- Josep Guardiola
    ('11111111111', 'Vasco da Gama', '2023-01-01', '365', '2024-01-01'),      -- João Silva
    ('44444444444', 'Botafogo', '2023-01-01', '365', '2024-01-01'),           -- Amanda Costa
    ('44444444444', 'Atlético Mineiro', '2018-05-01', '30', '2018-05-25'),    -- Amanda Costa
    ('55555555555', 'Botafogo', '2021-01-01', '365', '2022-01-01');           -- Rafael Ferreira

INSERT INTO Pagamento(id, cpf, idAgente, valor, formato, dataPag)
VALUES
    ('5', '22266222221', '1', '50000', 'mensal', '2023-07-20'),     -- Cristiano Ronaldo
    ('2', '22266222221', '3', '5000', 'unico', '2023-07-28'),       -- Cristiano Ronaldo
    ('4', '50505050505', '5', '100', 'mensal', '2023-07-29'),       -- Paulo Almeida
    ('1', '16666556661', '4', '30000', 'especial', '2022-07-28'),   -- Lionel Messi
    ('6', '16666556661', '4', '15000', 'especial', '2022-09-28'),   -- Lionel Messi
    ('7', '15555555555', '2', '1000000', 'anual', '2019-01-01'),    -- Sassá
    ('8', '15555555555', '1', '1000000', 'anual', '2020-01-01'),    -- Sassá
    ('11', '51515151515', '2', '500' , 'unico', '2023-05-01'),      -- Carolina Castro
    ('111', '14141414141', '2', '550' , 'unico', '2020-08-01'),     -- Pedro Oliveira
    ('1111', '66666666666', '2', '8800', 'unico', '2023-06-21'),    -- Patricia Oliveira
    ('11111', '10101010101', '4', '100' , 'unico', '2023-07-29');   -- Aline Santos

INSERT INTO Estadio(nome, capacidade, cep, estado, cidade, bairro, logradouro)
VALUES
    ('Mineirão', '100000', '32200909', 'MG', 'Belo Horizonte', 'São José', 'Av. Antônio Abrahão Caram'),
    ('Itakera', '5000', '12415222', 'SP', 'São Paulo', 'Gaviões', 'Rua do Coringa'),
    ('Arena MRV', '2000', '21515666', 'MG', 'Ribeirão das Neves', 'Longe', 'Rua Torta'),
    ('São Januário', '9000', '21212102', 'RJ', 'Rio de Janeiro', 'Flamengo', 'Rua da Vitória'),
    ('Maracanã', '7000', '21021021', 'RJ', 'Rio de Janeiro', 'Dom Haindabe Be', 'Avenida do Segredo');

INSERT INTO PosseEstadio(idAgente, nomeEstadio, valorPago, percentual, dataAquisicao)
VALUES
    ('1', 'Mineirão', '2000000', '100', '2018-05-04'),
    ('1', 'Itakera', '10000', '100', '2018-10-17'),
    ('6', 'Arena MRV', '1000000000', '100', '2015-07-25'),
    ('4', 'São Januário', '50000', '50', '2018-08-21'),
    ('5', 'São Januário', '40000', '50', '2017-08-21'),
    ('3', 'Maracanã', '20000', '30', '2020-08-21'),
    ('4', 'Maracanã', '20000', '30', '2020-08-21'),
    ('5', 'Maracanã', '20000', '30', '2020-08-21'),
    ('1', 'Maracanã', '10000', '10', '2020-09-22');

INSERT INTO Partida(id, dataPartida, nomeEstadio)
VALUES
    ('1', '2023-07-29', 'Mineirão'),
    ('4', '2023-08-2', 'Mineirão'),
    ('2', '2023-07-29', 'Itakera'),
    ('3', '2023-08-02', 'São Januário');

INSERT INTO Disputa(numDisp, idPartida, nomeClubeCasa, nomeClubeVisitante)
VALUES
    ('1', '1', 'Cruzeiro', 'Botafogo'),
    ('2', '4', 'Cruzeiro', 'Vasco da Gama'),
    ('3', '2', 'Botafogo', 'Vasco da Gama'), -- Empate
    ('4', '3', 'Vasco da Gama', 'Cruzeiro');

INSERT INTO Gol(numDisputa, tempo, tipo, cpfJogador)
VALUES
    ('1', '300', 'cabeceio', '22266222221'),
    ('1', '422', 'cabeceio', '22266222221'),
    ('1', '540', 'chute', '22266222221'),
    ('1', '3301', 'chute', '22222822222'),
    ('1', '4020', 'falta', '22222822222'),
    ('1', '5221', 'falta', '22222822222'),
    ('2', '5204', 'falta', '22222822222'),
    ('2', '4060', 'cabeceio', '22222822222'),
    ('2', '4650', 'chute', '16666556661'),
    ('4', '2205', 'olimpico', '11113111111');

INSERT INTO Cartao(numDisputa, tempo, cor, cpfInfrator, tipoFalta)
VALUES
    ('3', '3301', 'amarelo', '16666556661', 'carrinho'),
    ('3', '4020', 'amarelo', '16666556661', 'agressao fisica'),
    ('3', '5221', 'vermelho', '16666556661', 'dois amarelos'),
    ('3', '5204', 'amarelo', '33322223333', 'agressao verbal'),
    ('1', '422', 'amarelo', '33322223333', 'agressao verbal');