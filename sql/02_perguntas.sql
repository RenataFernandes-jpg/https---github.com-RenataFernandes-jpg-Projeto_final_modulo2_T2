-- P1 - Qual é o percentual e o valor financeiro nominal economizado pelo governo (diferença entre valor estimado e valor homologado)?

SELECT
    ROUND(SUM(valor_total_estimado), 2) AS valor_estimado,
    ROUND(SUM(valor_total_homologado), 2) AS valor_homologado,
    ROUND(
        SUM(valor_total_estimado) -
        SUM(valor_total_homologado), 2
    ) AS economia_nominal,
    ROUND(
        100 * (
            SUM(valor_total_estimado) -
            SUM(valor_total_homologado)
        ) / NULLIF(SUM(valor_total_estimado), 0),
        2
    ) AS economia_percentual
FROM fato_item_contratado
WHERE comparavel = 1;

-- P2 - Quem são os maiores fornecedores em volume financeiro e qual percentual do orçamento público está concentrado neles?

SELECT
    fo.ni_fornecedor,
    fo.nome_fornecedor,

    COUNT(DISTINCT f.numero_controle_pncp) AS qtd_contratacoes,

    ROUND(
        SUM(f.valor_total_homologado), 2
    ) AS volume_financeiro,

    ROUND(
        100 * SUM(f.valor_total_homologado) /
        NULLIF(
            (SELECT SUM(valor_total_homologado)
             FROM fato_item_contratado
             WHERE comparavel = 1), 0
        ), 2
    ) AS percentual_orcamento

FROM fato_item_contratado f

INNER JOIN dim_fornecedor fo
    ON f.sk_fornecedor = fo.sk_fornecedor

WHERE f.comparavel = 1

GROUP BY
    fo.ni_fornecedor,
    fo.nome_fornecedor

ORDER BY volume_financeiro DESC

LIMIT 10;

-- P3 - Quais modalidades licitatórias trazem maior deságio/economia e quais concentram o maior volume de recursos?

SELECT
    m.nome_modalidade,

    COUNT(DISTINCT f.numero_controle_pncp) AS qtd_contratacoes,

    ROUND(
        SUM(f.valor_total_estimado), 2
    ) AS valor_estimado,

    ROUND(
        SUM(f.valor_total_homologado), 2
    ) AS valor_homologado,

    ROUND(
        SUM(f.economia_valor), 2
    ) AS economia_nominal,

    ROUND(
        100 * SUM(f.economia_valor) /
        NULLIF(SUM(f.valor_total_estimado), 0), 2
    ) AS percentual_economia,

    ROUND(
        100 * SUM(f.valor_total_homologado) /
        NULLIF(
            (SELECT SUM(valor_total_homologado)
             FROM fato_item_contratado
             WHERE comparavel = 1), 0
        ), 2
    ) AS percentual_recursos

FROM fato_item_contratado f

INNER JOIN dim_modalidade m
    ON f.sk_modalidade = m.sk_modalidade

WHERE f.comparavel = 1

GROUP BY m.nome_modalidade

ORDER BY valor_homologado DESC;

-- P4 - Qual a duração média (em dias) entre o lançamento do edital e a sua homologação final, segmentada por órgão?

WITH processos AS (
    SELECT
        f.numero_controle_pncp,
        o.cnpj_orgao,
        MAX(o.nome_orgao) AS nome_orgao,
        MIN(f.data_publicacao) AS data_publicacao,
        MAX(f.data_homologacao) AS data_homologacao
    FROM fato_item_contratado f
    INNER JOIN dim_orgao o
        ON f.sk_orgao = o.sk_orgao
    WHERE f.data_publicacao IS NOT NULL
      AND f.data_homologacao IS NOT NULL
    GROUP BY
        f.numero_controle_pncp,
        o.cnpj_orgao
)
SELECT
    cnpj_orgao,
    nome_orgao,
    COUNT(*) AS qtd_processos,
    ROUND(
        AVG(DATEDIFF(data_homologacao, data_publicacao)), 2
    ) AS media_dias_homologacao
FROM processos
WHERE data_homologacao >= data_publicacao
GROUP BY
    cnpj_orgao,
    nome_orgao
ORDER BY media_dias_homologacao DESC;

-- P5 - Quais estados e regiões concentram as maiores despesas e quais apresentam os melhores indicadores de desconto?

WITH analise AS (

    -- ANÁLISE POR REGIÃO
    SELECT
        'REGIÃO' AS nivel,
        l.regiao AS localidade,

        COUNT(DISTINCT f.numero_controle_pncp) AS qtd_processos,

        SUM(f.valor_total_estimado) AS valor_estimado,

        SUM(f.valor_total_homologado) AS despesa_homologada,

        SUM(f.valor_total_estimado) -
        SUM(f.valor_total_homologado) AS economia_nominal

    FROM fato_item_contratado f

    INNER JOIN dim_localidade l
        ON f.sk_localidade = l.sk_localidade

    WHERE f.comparavel = 1

    GROUP BY l.regiao

    UNION ALL

    -- ANÁLISE POR ESTADO
    SELECT
        'ESTADO' AS nivel,
        l.uf_sigla AS localidade,

        COUNT(DISTINCT f.numero_controle_pncp) AS qtd_processos,

        SUM(f.valor_total_estimado) AS valor_estimado,

        SUM(f.valor_total_homologado) AS despesa_homologada,

        SUM(f.valor_total_estimado) -
        SUM(f.valor_total_homologado) AS economia_nominal

    FROM fato_item_contratado f

    INNER JOIN dim_localidade l
        ON f.sk_localidade = l.sk_localidade

    WHERE f.comparavel = 1

    GROUP BY l.uf_sigla
)

SELECT
    nivel,
    localidade,
    qtd_processos,

    ROUND(valor_estimado, 2) AS valor_estimado,

    ROUND(despesa_homologada, 2) AS despesa_homologada,

    ROUND(economia_nominal, 2) AS economia_nominal,

    ROUND(
        100 * despesa_homologada /
        NULLIF(SUM(
            CASE
                WHEN nivel = analise.nivel
                THEN despesa_homologada
            END
        ) OVER (PARTITION BY nivel), 0),
        2
    ) AS participacao_despesa_pct,

    ROUND(
        100 * economia_nominal /
        NULLIF(valor_estimado, 0),
        2
    ) AS economia_pct

FROM analise

ORDER BY
    nivel,
    despesa_homologada DESC;


-- P6 - Como os recursos se distribuem entre bens, serviços e obras e engenharia?

SELECT
    perfil_gasto AS tipo_gasto,

    COUNT(*) AS qtd_itens,

    ROUND(SUM(valor_total_homologado), 2)
        AS valor_homologado,

    ROUND(
        100 * SUM(valor_total_homologado) /
        SUM(SUM(valor_total_homologado)) OVER (),
        2
    ) AS participacao_percentual

FROM fato_item_contratado

GROUP BY perfil_gasto

ORDER BY valor_homologado DESC;