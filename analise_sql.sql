-- 1. Quantos chamados foram abertos no dia 01/04/2023?
WITH chamados_selecionados AS (
  SELECT 
    PARSE_DATE('%Y-%m-%d', FORMAT_DATE('%Y-%m-%d', CAST(data_inicio AS DATE))) AS data_formatada
  FROM `datario.adm_central_atendimento_1746.chamado`
)
SELECT COUNT(*) AS total_chamados
FROM chamados_selecionados
WHERE data_formatada = '2023-04-01';

-- 2. Qual o tipo de chamado com mais registros no dia 01/04/2023?
WITH chamados_selecionados AS (
  SELECT 
    tipo,
    PARSE_DATE('%Y-%m-%d', FORMAT_DATE('%Y-%m-%d', CAST(data_inicio AS DATE))) AS data_formatada
  FROM `datario.adm_central_atendimento_1746.chamado`
)
SELECT tipo, COUNT(*) AS total_chamados
FROM chamados_selecionados
WHERE data_formatada = '2023-04-01'
GROUP BY tipo
ORDER BY total_chamados DESC
LIMIT 1;


-- 3. Nomes dos 3 bairros com mais chamados no dia 01/04/2023
WITH chamados_selecionados AS (
  SELECT 
    id_bairro,
    PARSE_DATE('%Y-%m-%d', FORMAT_DATE('%Y-%m-%d', CAST(data_inicio AS DATE))) AS data_formatada
  FROM `datario.adm_central_atendimento_1746.chamado`
)
SELECT b.nome, COUNT(*) AS total_chamados
FROM chamados_selecionados c
JOIN `datario.dados_mestres.bairro` b
ON c.id_bairro = b.id_bairro
WHERE c.data_formatada = '2023-04-01'
GROUP BY b.nome
ORDER BY total_chamados DESC
LIMIT 3;

-- 4. Nome da subprefeitura com mais chamados no dia 01/04/2023
WITH chamados_selecionados AS (
  SELECT 
    id_bairro,
    PARSE_DATE('%Y-%m-%d', FORMAT_DATE('%Y-%m-%d', CAST(data_inicio AS DATE))) AS data_formatada
  FROM `datario.adm_central_atendimento_1746.chamado`
)
SELECT b.subprefeitura, COUNT(*) AS total_chamados
FROM chamados_selecionados c
JOIN `datario.dados_mestres.bairro` b
ON c.id_bairro = b.id_bairro
WHERE c.data_formatada = '2023-04-01'
GROUP BY b.subprefeitura
ORDER BY total_chamados DESC
LIMIT 1;


-- 5. Chamados sem bairro ou subprefeitura no dia 01/04/2023
WITH chamados_selecionados AS (
  SELECT 
    id_bairro,
    PARSE_DATE('%Y-%m-%d', FORMAT_DATE('%Y-%m-%d', CAST(data_inicio AS DATE))) AS data_formatada
  FROM datario.adm_central_atendimento_1746.chamado
  WHERE PARSE_DATE('%Y-%m-%d', FORMAT_DATE('%Y-%m-%d', CAST(data_inicio AS DATE))) = '2023-04-01'
)
SELECT 
  COUNT(*) AS total_chamados_sem_bairro
FROM chamados_selecionados c
LEFT JOIN datario.dados_mestres.bairro b
ON c.id_bairro = b.id_bairro
WHERE b.id_bairro IS NULL;


-- 6. Quantos chamados com o subtipo "Perturbação do sossego" foram abertos de 01/01/2022 a 31/12/2023?
SELECT COUNT(*) AS total_chamados
FROM `datario.adm_central_atendimento_1746.chamado`
WHERE subtipo = 'Perturbação do sossego'
AND data_inicio BETWEEN '2022-01-01' AND '2023-12-31';


-- 7. Chamados com subtipo "Perturbação do sossego" durante eventos específicos
SELECT 
    c.*, 
    CASE 
        WHEN c.data_inicio BETWEEN e.data_inicial AND e.data_final 
            AND e.evento = 'Reveillon' THEN 'Reveillon'
        WHEN c.data_inicio BETWEEN e.data_inicial AND e.data_final 
            AND e.evento = 'Carnaval' THEN 'Carnaval'
        WHEN c.data_inicio BETWEEN e.data_inicial AND e.data_final 
            AND e.evento = 'Rock in Rio' THEN 'Rock in Rio'
        ELSE 'Outro Evento'
    END AS evento
FROM 
    `datario.adm_central_atendimento_1746.chamado` c
JOIN 
    `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` e
ON 
    c.data_inicio BETWEEN e.data_inicial AND e.data_final
WHERE 
    c.subtipo = 'Perturbação do sossego'
    AND e.evento IN ('Reveillon', 'Carnaval', 'Rock in Rio');


-- 8 Selecione os chamados com esse subtipo que foram abertos durante os eventos contidos na tabela de eventos (Reveillon, Carnaval e Rock in Rio).

WITH eventos AS (
    SELECT 
        e.evento,
        e.data_inicial,
        e.data_final
    FROM 
        `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` e
    WHERE 
        e.evento IN ('Reveillon', 'Carnaval', 'Rock in Rio')
),

-- Associando chamads com eventos
chamados AS (
    SELECT 
        c.data_inicio,
        c.data_fim,
        CASE
            WHEN c.data_inicio BETWEEN e.data_inicial AND e.data_final THEN e.evento
            WHEN c.data_fim IS NOT NULL AND c.data_fim BETWEEN e.data_inicial AND e.data_final THEN e.evento
            ELSE NULL
        END AS evento
    FROM 
        `datario.adm_central_atendimento_1746.chamado` c
    LEFT JOIN 
        eventos e
    ON 
        (c.data_inicio BETWEEN e.data_inicial AND e.data_final)
        OR 
        (c.data_fim IS NOT NULL AND c.data_fim BETWEEN e.data_inicial AND e.data_final)
    WHERE 
        c.subtipo = 'Perturbação do sossego'
        AND (c.data_inicio IS NOT NULL AND c.data_fim IS NOT NULL)  
)

-- Contagem tota de chamados por evento
SELECT 
    evento,
    COUNT(*) AS total_chamados
FROM 
    chamados
WHERE 
    evento IS NOT NULL 
GROUP BY 
    evento
ORDER BY 
    total_chamados DESC;

--- 9. Qual evento teve a maior média diária de chamados abertos desse subtipo?

WITH eventos AS (
    SELECT 
        e.evento,
        e.data_inicial,
        e.data_final,
        DATE_DIFF(e.data_final, e.data_inicial, DAY) + 1 AS duracao
    FROM 
        `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` e
    WHERE 
        e.evento IN ('Reveillon', 'Carnaval', 'Rock in Rio')
),

chamados_eventos AS (
    SELECT 
        CASE
            WHEN c.data_inicio BETWEEN e.data_inicial AND e.data_final THEN e.evento
            ELSE NULL
        END AS evento,
        COUNT(*) AS total_chamados
    FROM 
        `datario.adm_central_atendimento_1746.chamado` c
    JOIN 
        eventos e
    ON 
        c.data_inicio BETWEEN e.data_inicial AND e.data_final
    WHERE 
        c.subtipo = 'Perturbação do sossego'
    GROUP BY 
        evento
    HAVING 
        evento IS NOT NULL
),

media_diaria_eventos AS (
    SELECT 
        e.evento,
        SUM(ce.total_chamados) / e.duracao AS media_diaria
    FROM 
        eventos e
    LEFT JOIN 
        chamados_eventos ce
    ON 
        e.evento = ce.evento
    GROUP BY 
        e.evento, e.duracao
)

SELECT 
    evento,
    media_diaria
FROM 
    media_diaria_eventos
ORDER BY 
    media_diaria DESC
LIMIT 4;



