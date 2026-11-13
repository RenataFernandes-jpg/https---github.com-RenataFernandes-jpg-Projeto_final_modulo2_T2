-- Projeto Final - PNCP / Controladoria
-- Star Schema: 4 dimensoes + 1 fato


DROP DATABASE IF EXISTS pncp_controladoria;
CREATE DATABASE pncp_controladoria CHARACTER SET utf8mb4;
USE pncp_controladoria;

-- =====================================================
-- CARGA DA AREA DE STAGING
-- =====================================================

DROP TABLE IF EXISTS stg_compras;
CREATE TABLE stg_compras (
    `numero_controle_pncp`                VARCHAR(255),
    `ano_compra`                          VARCHAR(255),
    `sequencial_compra`                   VARCHAR(255),
    `numero_compra`                       VARCHAR(255),
    `processo`                            VARCHAR(255),
    `objeto_compra`                       TEXT,
    `srp`                                 VARCHAR(255),
    `cnpj_orgao`                          VARCHAR(255),
    `razao_social_orgao`                  VARCHAR(255),
    `poder_id`                            VARCHAR(255),
    `esfera_id`                           VARCHAR(255),
    `uf_sigla`                            VARCHAR(255),
    `uf_nome`                             VARCHAR(255),
    `municipio`                           VARCHAR(255),
    `cod_ibge`                            VARCHAR(255),
    `nome_unidade`                        VARCHAR(255),
    `modalidade_id`                       VARCHAR(255),
    `modalidade_nome`                     VARCHAR(255),
    `modo_disputa`                        VARCHAR(255),
    `situacao_compra`                     VARCHAR(255),
    `valor_total_estimado`                VARCHAR(255),
    `valor_total_homologado`              VARCHAR(255),
    `data_publicacao`                     VARCHAR(255),
    `data_abertura_proposta`              VARCHAR(255),
    `data_encerramento_proposta`          VARCHAR(255)
);


DROP TABLE IF EXISTS stg_itens;
CREATE TABLE stg_itens (
    `numero_controle_pncp`                VARCHAR(255),
    `numero_item`                         VARCHAR(255),
    `descricao`                           TEXT,
    `material_ou_servico`                 VARCHAR(255),
    `categoria_item`                      VARCHAR(255),
    `quantidade`                          VARCHAR(255),
    `unidade_medida`                      VARCHAR(255),
    `valor_unitario_estimado`             VARCHAR(255),
    `valor_total_estimado`                VARCHAR(255),
    `sigiloso`                            VARCHAR(255),
    `situacao_item`                       VARCHAR(255),
    `tem_resultado`                       VARCHAR(255),
    `catalogo_codigo_item`                VARCHAR(255),
    `criterio_julgamento`                 VARCHAR(255)
);


DROP TABLE IF EXISTS stg_resultados;
CREATE TABLE stg_resultados (
    `numero_controle_pncp`                VARCHAR(255),
    `numero_item`                         VARCHAR(255),
    `sequencial_resultado`                VARCHAR(255),
    `ordem_classificacao_srp`             VARCHAR(255),
    `ni_fornecedor`                       VARCHAR(255),
    `tipo_pessoa`                         VARCHAR(255),
    `nome_fornecedor`                     VARCHAR(255),
    `porte`                               VARCHAR(255),
    `quantidade_homologada`               VARCHAR(255),
    `valor_unitario_homologado`           VARCHAR(255),
    `valor_total_homologado`              VARCHAR(255),
    `data_resultado`                      VARCHAR(255),
    `data_cancelamento`                   VARCHAR(255)
);

-- =====================================================
-- DIMENSOES
-- =====================================================

DROP TABLE IF EXISTS dim_orgao;
CREATE TABLE dim_orgao (
    sk_orgao INT NOT NULL AUTO_INCREMENT,
    cnpj_orgao VARCHAR(20) NOT NULL,
    nome_orgao VARCHAR(255) NOT NULL,
    poder VARCHAR(30) NOT NULL,
    PRIMARY KEY (sk_orgao),
    CONSTRAINT uq_dim_orgao_cnpj UNIQUE (cnpj_orgao)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS dim_fornecedor;
CREATE TABLE dim_fornecedor (
    sk_fornecedor INT NOT NULL AUTO_INCREMENT,
    ni_fornecedor VARCHAR(20) NOT NULL,
    nome_fornecedor VARCHAR(255) NOT NULL,
    tipo_pessoa VARCHAR(30),
    porte VARCHAR(50),
    PRIMARY KEY (sk_fornecedor),
    CONSTRAINT uq_dim_fornecedor_ni UNIQUE (ni_fornecedor)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS dim_modalidade;
CREATE TABLE dim_modalidade (
    sk_modalidade INT NOT NULL AUTO_INCREMENT,
    modalidade_id VARCHAR(20) NOT NULL,
    nome_modalidade VARCHAR(150) NOT NULL,
    PRIMARY KEY (sk_modalidade),
    CONSTRAINT uq_dim_modalidade_id UNIQUE (modalidade_id)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS dim_localidade;
CREATE TABLE dim_localidade (
    sk_localidade INT NOT NULL AUTO_INCREMENT,
    uf_sigla CHAR(2) NOT NULL,
    uf_nome VARCHAR(60) NOT NULL,
    regiao VARCHAR(30) NOT NULL,
    PRIMARY KEY (sk_localidade),
    CONSTRAINT uq_dim_localidade_uf UNIQUE (uf_sigla)
) ENGINE=InnoDB;

-- =====================================================
-- FATO: uma linha por item de contratacao
-- Chave natural do grao: numero_controle_pncp + numero_item
-- =====================================================


DROP TABLE IF EXISTS fato_item_contratado;
CREATE TABLE fato_item_contratado (
    sk_fato INT NOT NULL AUTO_INCREMENT,
    numero_controle_pncp VARCHAR(80) NOT NULL,
    numero_item INT NOT NULL,

    sk_orgao INT NOT NULL,
    sk_fornecedor INT NOT NULL,
    sk_modalidade INT NOT NULL,
    sk_localidade INT NOT NULL,

    data_publicacao DATE,
    data_homologacao DATE,

    descricao_item TEXT,
    perfil_gasto VARCHAR(40),

    quantidade DECIMAL(18,4) NOT NULL,
    valor_unitario_estimado DECIMAL(18,4) NOT NULL,
    valor_total_estimado DECIMAL(18,2) NOT NULL,
    valor_unitario_homologado DECIMAL(18,4) NOT NULL,
    valor_total_homologado DECIMAL(18,2) NOT NULL,

    comparavel TINYINT NOT NULL,
    economia_valor DECIMAL(18,2),
    dias_ciclo INT,

    PRIMARY KEY (sk_fato),

    CONSTRAINT uq_fato_item UNIQUE (numero_controle_pncp, numero_item),

    CONSTRAINT fk_fato_orgao
        FOREIGN KEY (sk_orgao) REFERENCES dim_orgao (sk_orgao),

    CONSTRAINT fk_fato_fornecedor
        FOREIGN KEY (sk_fornecedor) REFERENCES dim_fornecedor (sk_fornecedor),

    CONSTRAINT fk_fato_modalidade
        FOREIGN KEY (sk_modalidade) REFERENCES dim_modalidade (sk_modalidade),

    CONSTRAINT fk_fato_localidade
        FOREIGN KEY (sk_localidade) REFERENCES dim_localidade (sk_localidade),

    CONSTRAINT chk_fato_quantidade CHECK (quantidade > 0),
    CONSTRAINT chk_fato_valores CHECK (
        valor_unitario_estimado > 0
        AND valor_total_estimado >= 0
        AND valor_unitario_homologado > 0
        AND valor_total_homologado >= 0
    ),
    CONSTRAINT chk_fato_comparavel CHECK (comparavel IN (0, 1)),
    CONSTRAINT chk_fato_dias_ciclo CHECK (dias_ciclo IS NULL OR dias_ciclo >= 0)
) ENGINE=InnoDB;
