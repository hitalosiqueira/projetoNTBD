--a. Separar e rankear notas de reclamações por assunto
DROP TABLE reclamacao_por_assunto;
DROP TABLE reclamacao_por_assunto_aux;

CREATE TABLE reclamacao_por_assunto_aux (
    id_rpa serial,
    media float,
    quantidade integer,
    assunto char(200),
    primary key(id_rpa)
);

CREATE TABLE reclamacao_por_assunto (
    id_rpa serial,
    media float,
    quantidade integer,
    assunto char(200),
    id_assunto integer references problema,
    primary key(id_rpa)
);

INSERT INTO reclamacao_por_assunto_aux(media, quantidade, assunto)
	SELECT avg(r.notas_consumidor)AS media, count(r.notas_consumidor) AS quantidade, p.assunto
	FROM reclamacao r, problema p
	WHERE r.id_problema = p.id_problema
	GROUP BY p.assunto


INSERT INTO reclamacao_por_assunto(media, quantidade, assunto, id_assunto)
  SELECT r.media, r.quantidade, r.assunto, p.id_problema
  FROM reclamacao_por_assunto_aux r, problema p
  WHERE r.assunto = p.assunto AND p.label = 'assunto'

SELECT * FROM reclamacao_por_assunto

--------------------------------------------------------------------------------
--b. Separar e rankear notas de reclamações por area
DROP TABLE reclamacao_por_area;
DROP TABLE reclamacao_por_area_aux;

CREATE TABLE reclamacao_por_area_aux (
    id_rpa serial,
    media float,
    quantidade integer,
    area char(200),
    primary key(id_rpa)
);

CREATE TABLE reclamacao_por_area (
    id_rpa serial,
    media float,
    quantidade integer,
    area char(200),
    id_area integer references problema,
    primary key(id_rpa)
);

INSERT INTO reclamacao_por_area_aux(media, quantidade, area)
	SELECT avg(r.notas_consumidor)AS media, count(r.notas_consumidor) AS quantidade, p.area
	FROM reclamacao r, problema p
	WHERE r.id_problema = p.id_problema
	GROUP BY p.area


INSERT INTO reclamacao_por_area(media, quantidade, area, id_area)
  SELECT r.media, r.quantidade, r.area, p.id_problema
  FROM reclamacao_por_area_aux r, problema p
  WHERE r.area = p.area AND p.label = 'area'

SELECT * FROM reclamacao_por_area

--------------------------------------------------------------------------------

--c. Média das notas e quantidade de reclamações dos consumidores separadas por mes
DROP TABLE reclamacao_por_mes;
DROP TABLE reclamacao_por_mes_aux;

CREATE TABLE reclamacao_por_mes_aux (
    id_rpm serial,
    media float,
    quantidade integer,
    mes integer,
    ano integer,
    primary key(id_rpm)
);

CREATE TABLE reclamacao_por_mes (
    id_rpm serial,
    media float,
    quantidade integer,
    mes integer,
    ano integer,
    id_mes integer references tempo,
    primary key(id_rpm)
);

INSERT INTO reclamacao_por_mes_aux(media, quantidade, mes, ano)
	SELECT avg(r.notas_consumidor)AS media, count(r.notas_consumidor) AS quantidade, t.mes, t.ano
	FROM reclamacao r, tempo t
	WHERE r.id_data_reclamacao = t.id_tempo
	GROUP BY t.mes, t.ano;


INSERT INTO reclamacao_por_mes(media, quantidade, mes, ano, id_mes)
  SELECT r.media, r.quantidade, t.mes, t.ano, t.id_tempo
  FROM reclamacao_por_mes_aux r, tempo t
  WHERE r.mes = t.mes AND r.ano = t.ano AND t.label = 'mes';

SELECT * FROM reclamacao_por_mes Order by ano, mes

--------------------------------------------------------------------------------

-- d. Média das notas e quantidade de reclamações dos consumidores rankeadas periodos de feriados importantes
DROP TABLE IF EXISTS reclamacao_por_feriado;
DROP TABLE IF EXISTS reclamacao_por_feriado_aux;

CREATE TABLE reclamacao_por_feriado_aux (
    id_rpf serial,
    media float,
    quantidade integer,
    mes integer,
    ano integer,
    feriado varchar(200),
    primary key(id_rpf)
);

CREATE TABLE reclamacao_por_feriado (
    id_rpf serial,
    media float,
    quantidade integer,
    mes integer,
    ano integer,
    feriado varchar(200),
    id_feriado integer references tempo,
    primary key(id_rpf)
);

INSERT INTO reclamacao_por_feriado_aux(media, quantidade, mes, ano, feriado)
	SELECT avg(r.notas_consumidor)AS media, count(r.notas_consumidor) AS quantidade, t.mes, t.ano, t.feriadoimportante
	FROM reclamacao r, tempo t
	WHERE r.id_data_reclamacao = t.id_tempo
	GROUP BY t.feriadoimportante, t.ano;


INSERT INTO reclamacao_por_mes(media, quantidade, mes, ano, id_mes)
  SELECT r.media, r.quantidade, t.mes, t.ano, t.id_tempo
  FROM reclamacao_por_mes_aux r, tempo t
  WHERE r.mes = t.mes AND r.ano = t.ano AND t.label = 'mes';

SELECT * FROM reclamacao_por_mes Order by ano, mes
