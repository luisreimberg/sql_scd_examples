-- Exemplo de SCD 2
-- Simulando tabela bronze/raw

CREATE SCHEMA stg
;

CREATE TABLE stg.funcionarios (
	[ID] [INT] NOT NULL,
	[NOME] [varchar](4000) NOT NULL,
	[CARGO] [varchar](4000) NOT NULL,
	[SALARIO] [numeric](7,2) NOT NULL
)
;

INSERT INTO stg.funcionarios
VALUES	(1, 'Luis', 'Engenheiro de Dados', 15000),
		(2, 'Aniela', 'Gerente de Segurança de Informação', 30000),
		(3, 'Alfredo', 'Analista de BI', 1000),
		(4, 'Luna', 'Advogado(a)', 5000),
		(5, 'Taiga', 'Pesquisador(a)', 2000),
		(6, 'Theo', 'Cientista de Dados', 10000)
;


-- DDL tabela
CREATE TABLE dbo.funcionarios (
	[ID] [INT] NOT NULL,
	[NOME] [varchar](4000) NOT NULL,
	[CARGO] [varchar](4000) NOT NULL,
	[SALARIO] [numeric](7,2) NOT NULL,
	[ATIVO] [INT] NOT NULL
)

-- Desativando os registros na tabela de DESTINO que existem na tabela ORIGEM
MERGE dbo.funcionarios AS DESTINO
USING stg.funcionarios AS ORIGEM
ON DESTINO.ID = ORIGEM.ID
WHEN MATCHED AND ATIVO = 1
	THEN UPDATE
		SET ATIVO = 0;

-- Carga full com os dados da tabela ORIGEM
INSERT INTO dbo.funcionarios (ID, NOME, CARGO, SALARIO, ATIVO)
SELECT ID, NOME, CARGO, SALARIO, 1
FROM stg.funcionarios

-- Simulando alteração e novos dados na tabela ORIGEM
UPDATE stg.funcionarios
SET CARGO = 'CTO', SALARIO = 99999
WHERE ID = 2

INSERT INTO stg.funcionarios
VALUES (7, 'Neuzita', 'CFO', 99999),
	   (8, 'Claudio', 'CEO', 99999)

-- Desativando os registros na tabela de DESTINO que existem na tabela de ORIGEM
MERGE dbo.funcionarios AS DESTINO
USING stg.funcionarios AS ORIGEM
ON DESTINO.ID = ORIGEM.ID
WHEN MATCHED AND ATIVO = 1
	THEN UPDATE
		SET ATIVO = 0;

-- Carga full com os dados da tabela ORIGEM
INSERT INTO dbo.funcionarios (ID, NOME, CARGO, SALARIO, ATIVO)
SELECT ID, NOME, CARGO, SALARIO, 1
FROM stg.funcionarios



SELECT * FROM dbo.funcionarios