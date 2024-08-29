-- 1. Quantos chamados foram abertos no dia 01/04/2023?
WITH chamados_selecionados AS (
  SELECT 
    PARSE_DATE('%Y-%m-%d', FORMAT_DATE('%Y-%m-%d', CAST(data_inicio AS DATE))) AS data_formatada
  FROM `datario.adm_central_atendimento_1746.chamado`
)
SELECT COUNT(*) AS total_chamados
FROM chamados_selecionados
WHERE data_formatada = '2023-04-01';