-- 3.
-- CRIAÇÃO DA TABELA FATO
----------------------------------------------------------
CREATE TABLE IF NOT EXISTS tabela_fato_python
(
  chegada integer NOT NULL,
  cod_circuito integer NOT NULL,
  cod_piloto integer NOT NULL,
  cod_campeonato integer NOT NULL,
  cod_equipe integer NOT NULL,
  pontos integer NOT NULL,
  CONSTRAINT pk_tabela_fato_python PRIMARY KEY (cod_piloto, cod_circuito, cod_equipe, cod_campeonato),
  CONSTRAINT fk_tabela_fato_python_grid FOREIGN KEY (cod_campeonato, cod_circuito, cod_piloto) REFERENCES grid (cod_campeonato, cod_circuito, cod_piloto),
  CONSTRAINT fk_tabela_fato_python_pontuacao FOREIGN KEY (cod_equipe, cod_piloto, cod_campeonato) REFERENCES pontuacao (cod_equipe, cod_piloto, cod_campeonato)
);
----------------------------------------------------------


-- 4.
-- METODO PARA POPULAR A TABELA FATO
----------------------------------------------------------
delete from tabela_fato_python;
INSERT INTO tabela_fato_python (cod_campeonato, cod_circuito, cod_equipe, cod_piloto, chegada, pontos)
SELECT pontuacao.cod_campeonato, cod_circuito, cod_equipe, pontuacao.cod_piloto, chegada, pontos
FROM pontuacao INNER JOIN grid
ON pontuacao.cod_piloto = grid.cod_piloto AND pontuacao.cod_campeonato = grid.cod_campeonato;
----------------------------------------------------------



-- 5.
-- INDICE
----------------------------------------------------------
CREATE INDEX ind1 ON tabela_fato_python USING btree (cod_piloto);
CREATE INDEX ind2 ON tabela_fato_python USING btree (pontos);
----------------------------------------------------------



-- 6.
-- TRIGGER PRA INSERIR NA TABELA FATO QUANDO É INSERIDO NO GRID
----------------------------------------------------------
CREATE OR REPLACE FUNCTION insere_tabela_fato_python()
RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO tabela_fato_python (cod_campeonato, cod_circuito, cod_equipe, cod_piloto, chegada, pontos)
	SELECT NEW.cod_campeonato, NEW.cod_circuito, cod_equipe, NEW.cod_piloto, chegada, pontos
	FROM pontuacao
	INNER JOIN grid
	ON pontuacao.cod_piloto = NEW.cod_piloto AND pontuacao.cod_campeonato = NEW.cod_campeonato
	LIMIT 1;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insere_tabela_fato_python_trigger
AFTER INSERT ON grid
FOR EACH ROW EXECUTE PROCEDURE insere_tabela_fato_python();

-- TESTE DO TRIGGER

-- 1. Primeiro vamos criar um novo campeonato pois não podemos duplicar dados
INSERT INTO campeonato (ano)
VALUES (2021);

-- Testando que não existe nada ainda na tabela fato
SELECT * FROM tabela_fato_python WHERE cod_campeonato = 2021;

-- 2. Vamos inserir uma pontuação para um piloto neste campeonato
-- Equipe 1: BWM, Piloto 8: Felipe Massa
INSERT INTO pontuacao(cod_equipe, cod_piloto, cod_campeonato, pontos)
VALUES (1,8,2021,100);

-- 3. Agora podemos inserir no grid que o trigger será executado corretamente
-- Circuito 5: BRAZIL
INSERT INTO grid (cod_campeonato, cod_circuito, cod_piloto, largada, chegada)
VALUES (2021, 5, 8, 1, 1);

-- 4. Agora podemos checar que foi inserido na tabela fato
SELECT * FROM tabela_fato_python WHERE cod_campeonato = 2021;
----------------------------------------------


-- 7.
-- RELATORIOS
----------------------------------------------
-- 1 - Posição de chegada de um piloto por prova
CREATE MATERIALIZED VIEW relatorioPilotoProva AS
select cod_piloto, cod_campeonato, cod_circuito, chegada
from tabela_fato_python
order by cod_piloto, cod_campeonato, cod_circuito;

select * from relatorioPilotoProva limit(10);

-- 2 - Posição de chegada de um piloto por equipe
CREATE MATERIALIZED VIEW relatorioPilotoEquipe AS
select cod_equipe, cod_piloto, min(chegada) as MelhorChegada
from tabela_fato_python
group by cod_equipe, cod_piloto
order by cod_equipe,  MelhorChegada, cod_piloto;

select * from relatorioPilotoEquipe limit(10);

-- 3 - Pontuação de um piloto por prova
CREATE MATERIALIZED VIEW relatorioPontosPilotoProva AS
select cod_piloto, cod_campeonato, cod_circuito, pontos
from tabela_fato_python
order by cod_piloto, cod_campeonato, cod_circuito;

select * from relatorioPontosPilotoProva limit(10);

-- 4 - Pontuação da equipe por prova
CREATE MATERIALIZED VIEW relatorioPontosEquipeProva AS
select cod_equipe, cod_campeonato, cod_circuito, sum(pontos) as totalpontos
from tabela_fato_python
group by cod_equipe, cod_campeonato, cod_circuito
order by cod_equipe, cod_campeonato, cod_circuito;

select * from relatorioPontosEquipeProva limit (10);
----------------------------------------------
