-- Quais estados e regiões concentram as maiores despesas e quais apresentam os melhores indicadores de desconto?

SELECT
      CASE
        WHEN GROUPING(l.regiao) = 1 THEN 'TOTAL GERAL'
        WHEN GROUPING(l.uf_sigla) = 1 THEN 'TOTAL REGIAO'
       ELSE 'ESTADO'
    END AS nivel_analise,

     COALESCE(l.regiao, 'TODAS') AS regiao,
     COALESCE(l.uf_sigla, 'TODOS') AS estado,

    ROUND(SUM(f.valor_total_homologado), 2)
        AS despesa_total,

    ROUND(
        100 * SUM(f.valor_total_homologado) /
        NULLIF(
            (SELECT SUM(valor_total_homologado)
             FROM fato_item_contratado
             WHERE comparavel = 1), 0
        ), 2
    ) AS percentual_despesa,

    ROUND(
        100 * SUM(f.economia_valor) /
        NULLIF(SUM(f.valor_total_estimado), 0), 2
    ) AS percentual_economia

FROM fato_item_contratado f

INNER JOIN dim_localidade l
    ON f.sk_localidade = l.sk_localidade

WHERE f.comparavel = 1

GROUP BY l.regiao, l.uf_sigla WITH ROLLUP

ORDER BY
    GROUPING(l.regiao),
    l.regiao,
    GROUPING(l.uf_sigla),
    despesa_total DESC;

-- Quais modalidades licitatórias trazem maior deságio/economia e quais concentram o maior volume de recursos?

SELECT
    m.nome_modalidade,

    COUNT(DISTINCT f.numero_controle_pncp)
        AS quantidade_contratacoes,

    COUNT(*) AS quantidade_itens,

    ROUND(
        SUM(CASE
            WHEN f.comparavel = 1
            THEN f.economia_valor
            ELSE 0
        END), 2
    ) AS economia_nominal,

    ROUND(
        100 * SUM(CASE
            WHEN f.comparavel = 1
            THEN f.economia_valor
            ELSE 0
        END) /
        NULLIF(
            SUM(CASE
                WHEN f.comparavel = 1
                THEN f.valor_total_estimado
                ELSE 0
            END), 0
        ), 2
    ) AS economia_percentual,

    ROUND(SUM(f.valor_total_homologado), 2)
        AS volume_homologado,

    ROUND(
        100 * SUM(f.valor_total_homologado) /
        NULLIF(
            (SELECT SUM(valor_total_homologado)
             FROM fato_item_contratado), 0
        ), 2
    ) AS percentual_volume

FROM fato_item_contratado f

INNER JOIN dim_modalidade m
    ON f.sk_modalidade = m.sk_modalidade

GROUP BY m.nome_modalidade

ORDER BY volume_homologado DESC;


-- Qual a duração média (em dias) entre o lançamento do edital e a sua homologação final, segmentada por órgão?

SELECT
    resultado.cnpj_orgao,
    resultado.nome_orgao,
    COUNT(*) AS quantidade_contratacoes,
    ROUND(AVG(resultado.dias_homologacao), 1)
        AS media_dias_homologacao

FROM (
    SELECT
        f.numero_controle_pncp,
        o.cnpj_orgao,
        o.nome_orgao,

        DATEDIFF(
            MAX(f.data_homologacao),
            MIN(f.data_publicacao)
        ) AS dias_homologacao

    FROM fato_item_contratado f

    INNER JOIN dim_orgao o
        ON f.sk_orgao = o.sk_orgao

    WHERE f.data_publicacao IS NOT NULL
      AND f.data_homologacao IS NOT NULL

    GROUP BY
        f.numero_controle_pncp,
        o.cnpj_orgao,
        o.nome_orgao

    HAVING MAX(f.data_homologacao) >= MIN(f.data_publicacao)

) AS resultado

GROUP BY
    resultado.cnpj_orgao,
    resultado.nome_orgao

HAVING COUNT(*) >= 5

ORDER BY media_dias_homologacao DESC;

-- Quais estados e regiões concentram as maiores despesas e quais apresentam os melhores indicadores de desconto?

SELECT
    'ESTADO' AS nivel,
    l.regiao,
    l.uf_sigla AS uf,

    ROUND(SUM(f.valor_total_homologado), 2) AS despesas_homologadas,

    ROUND(
        100 * SUM(f.valor_total_homologado) /
        (SELECT SUM(valor_total_homologado)
         FROM fato_item_contratado
         WHERE comparavel = 1),
        2
    ) AS participacao_despesas_pct,

    ROUND(
        100 * SUM(f.economia_valor) /
        NULLIF(SUM(f.valor_total_estimado), 0),
        2
    ) AS economia_percentual,

    ROUND(SUM(f.economia_valor), 2) AS economia_nominal,

    COUNT(*) AS quantidade_itens

FROM fato_item_contratado f
INNER JOIN dim_localidade l
    ON f.sk_localidade = l.sk_localidade

WHERE f.comparavel = 1

GROUP BY l.regiao, l.uf_sigla

UNION ALL

SELECT
    'REGIAO' AS nivel,
    l.regiao,
    'TODOS' AS uf,

    ROUND(SUM(f.valor_total_homologado), 2),

    ROUND(
        100 * SUM(f.valor_total_homologado) /
        (SELECT SUM(valor_total_homologado)
         FROM fato_item_contratado
         WHERE comparavel = 1),
        2
    ),

    ROUND(
        100 * SUM(f.economia_valor) /
        NULLIF(SUM(f.valor_total_estimado), 0),
        2
    ),

    ROUND(SUM(f.economia_valor), 2),

    COUNT(*)

FROM fato_item_contratado f
INNER JOIN dim_localidade l
    ON f.sk_localidade = l.sk_localidade

WHERE f.comparavel = 1

GROUP BY l.regiao

UNION ALL

SELECT
    'TOTAL' AS nivel,
    'TODAS' AS regiao,
    'TODOS' AS uf,

    ROUND(SUM(valor_total_homologado), 2),
    100.00,

    ROUND(
        100 * SUM(economia_valor) /
        NULLIF(SUM(valor_total_estimado), 0),
        2
    ),

    ROUND(SUM(economia_valor), 2),

    COUNT(*)

FROM fato_item_contratado

WHERE comparavel = 1

ORDER BY
    FIELD(nivel, 'REGIAO', 'ESTADO', 'TOTAL'),
    despesas_homologadas DESC;

-- Como os recursos se distribuem entre bens, serviços e obras e engenharia?

SELECT
    perfil_gasto,

    COUNT(*) AS quantidade_itens,

    ROUND(
        SUM(valor_total_homologado), 2
    ) AS valor_homologado,

    ROUND(
        100 * SUM(valor_total_homologado) /
        SUM(SUM(valor_total_homologado)) OVER (),
        2
    ) AS participacao_percentual

FROM fato_item_contratado

GROUP BY perfil_gasto

ORDER BY valor_homologado DESC;