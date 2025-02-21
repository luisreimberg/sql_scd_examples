-- Exemplo de SCD 1
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

-- DDL tabela silver
CREATE TABLE dbo.funcionarios (
	[ID] [INT] NOT NULL,
	[NOME] [varchar](4000) NOT NULL,
	[CARGO] [varchar](4000) NOT NULL,
	[SALARIO] [numeric](7,2) NOT NULL
)
;

-- Carga inicial
INSERT INTO dbo.funcionarios (ID, NOME, CARGO, SALARIO)
SELECT ID, NOME, CARGO, SALARIO
FROM stg.funcionarios
;

-- Simulando alteração na tabela ORIGEM
UPDATE stg.funcionarios
SET CARGO = 'CTO', SALARIO = 99999
WHERE ID = 2
;

-- Atualizando a tabela destino
MERGE dbo.funcionarios AS DESTINO
USING stg.funcionarios AS ORIGEM
ON DESTINO.ID = ORIGEM.ID
WHEN MATCHED THEN
    UPDATE
    SET DESTINO.NOME = ORIGEM.NOME,
        DESTINO.CARGO = ORIGEM.CARGO,
        DESTINO.SALARIO = ORIGEM.SALARIO
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ID, NOME, CARGO, SALARIO)
    VALUES (ORIGEM.ID, ORIGEM.NOME, ORIGEM.CARGO, ORIGEM.SALARIO)
;