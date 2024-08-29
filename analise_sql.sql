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

