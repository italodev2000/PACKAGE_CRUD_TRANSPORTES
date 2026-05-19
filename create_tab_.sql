CREATE TABLE empresa (
    id_empresa    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome          VARCHAR2(100)  NOT NULL,
    cnpj          VARCHAR2(18)   NOT NULL UNIQUE,
    telefone      VARCHAR2(20),
    email         VARCHAR2(100),
    data_fundacao DATE
);
 
CREATE TABLE motorista (
    id_motorista  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_empresa    NUMBER         NOT NULL,
    nome          VARCHAR2(100)  NOT NULL,
    cpf           VARCHAR2(14)   NOT NULL UNIQUE,
    cnh           VARCHAR2(20)   NOT NULL UNIQUE,
    categoria_cnh VARCHAR2(5),
    telefone      VARCHAR2(20),
    data_admissao DATE,
    CONSTRAINT fk_motorista_empresa FOREIGN KEY (id_empresa)
        REFERENCES empresa (id_empresa)
);


CREATE TABLE veiculo (
    id_veiculo    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_empresa    NUMBER         NOT NULL,
    placa         VARCHAR2(10)   NOT NULL UNIQUE,
    modelo        VARCHAR2(50)   NOT NULL,
    marca         VARCHAR2(50),
    ano           NUMBER(4),
    capacidade    NUMBER(5),
    tipo          VARCHAR2(30),  
    status        VARCHAR2(20)   DEFAULT 'ATIVO',
    CONSTRAINT fk_veiculo_empresa FOREIGN KEY (id_empresa)
        REFERENCES empresa (id_empresa)
);
 
CREATE TABLE rota (
    id_rota         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_empresa      NUMBER         NOT NULL,
    descricao       VARCHAR2(200)  NOT NULL,
    origem          VARCHAR2(100)  NOT NULL,
    destino         VARCHAR2(100)  NOT NULL,
    distancia_km    NUMBER(8,2),
    duracao_minutos NUMBER(6),
    ativa           CHAR(1)        DEFAULT 'S',
    CONSTRAINT fk_rota_empresa FOREIGN KEY (id_empresa)
        REFERENCES empresa (id_empresa)
);
 
CREATE TABLE viagem (
    id_viagem      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_rota        NUMBER         NOT NULL,
    id_motorista   NUMBER         NOT NULL,
    id_veiculo     NUMBER         NOT NULL,
    data_saida     DATE           NOT NULL,
    data_chegada   DATE,
    status         VARCHAR2(20)   DEFAULT 'AGENDADA', 
    observacao     VARCHAR2(300),
    CONSTRAINT fk_viagem_rota      FOREIGN KEY (id_rota)      REFERENCES rota (id_rota),
    CONSTRAINT fk_viagem_motorista FOREIGN KEY (id_motorista) REFERENCES motorista (id_motorista),
    CONSTRAINT fk_viagem_veiculo   FOREIGN KEY (id_veiculo)   REFERENCES veiculo (id_veiculo)
);
 
CREATE TABLE passageiro (
    id_passageiro NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome          VARCHAR2(100) NOT NULL,
    cpf           VARCHAR2(14)  NOT NULL UNIQUE,
    telefone      VARCHAR2(20),
    email         VARCHAR2(100),
    data_nasc     DATE
);
 
CREATE TABLE passagem (
    id_passagem   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_viagem     NUMBER         NOT NULL,
    id_passageiro NUMBER         NOT NULL,
    assento       VARCHAR2(5),
    valor         NUMBER(10,2)   NOT NULL,
    data_compra   DATE           DEFAULT SYSDATE,
    status        VARCHAR2(20)   DEFAULT 'ATIVA', 
    CONSTRAINT fk_passagem_viagem     FOREIGN KEY (id_viagem)     REFERENCES viagem (id_viagem),
    CONSTRAINT fk_passagem_passageiro FOREIGN KEY (id_passageiro) REFERENCES passageiro (id_passageiro)
);
 
CREATE TABLE manutencao (
    id_manutencao  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_veiculo     NUMBER         NOT NULL,
    tipo           VARCHAR2(50)   NOT NULL,  
    descricao      VARCHAR2(300),
    data_entrada   DATE           NOT NULL,
    data_saida     DATE,
    custo          NUMBER(10,2),
    oficina        VARCHAR2(100),
    CONSTRAINT fk_manutencao_veiculo FOREIGN KEY (id_veiculo) REFERENCES veiculo (id_veiculo)
);