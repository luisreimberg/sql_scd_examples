-- Exemplo de SCD 3
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
	[SALARIO] [numeric](7,2) NOT NULL,
    [CARGO_ANTERIOR] [varchar](4000) NULL,
    [SALARIO_ANTERIOR] [numeric](7,2) NULL
)
;

-- Carga inicial
INSERT INTO dbo.funcionarios (ID, NOME, CARGO, SALARIO, CARGO_ANTERIOR, SALARIO_ANTERIOR) 
SELECT ID, NOME, CARGO, SALARIO, NULL AS CARGO_ANTERIOR, NULL AS SALARIO_ANTERIOR
FROM stg.funcionarios
;

-- Simulando alteração na tabela ORIGEM
UPDATE stg.funcionarios
SET CARGO = 'CTO', SALARIO = 99999
WHERE ID = 2
;

-- Atualizando a tabela de destino com o histórico
MERGE dbo.funcionarios AS DESTINO
USING stg.funcionarios AS ORIGEM
ON DESTINO.ID = ORIGEM.ID
WHEN MATCHED AND 
    (ORIGEM.CARGO <> DESTINO.CARGO OR ORIGEM.SALARIO <> DESTINO.SALARIO) THEN
    UPDATE
    SET DESTINO.CARGO_ANTERIOR = DESTINO.CARGO, -- Preserva o cargo atual
        DESTINO.SALARIO_ANTERIOR = DESTINO.SALARIO, -- Preserva o salário atual
        DESTINO.CARGO = ORIGEM.CARGO, -- Atualiza com o novo cargo
        DESTINO.SALARIO = ORIGEM.SALARIO -- Atualiza com o novo salário
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ID, NOME, CARGO, SALARIO)
    VALUES (ORIGEM.ID, ORIGEM.NOME, ORIGEM.CARGO, ORIGEM.SALARIO)
;