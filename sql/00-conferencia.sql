SELECT
    COUNT(*) AS itens_na_fato,

    COUNT(DISTINCT numero_controle_pncp)
        AS contratacoes_distintas,

    SUM(valor_total_homologado)
        AS volume_homologado,

    SUM(comparavel = 1)
        AS itens_comparaveis,

    ROUND(AVG(dias_ciclo), 1)
        AS ciclo_medio,

    MAX(dias_ciclo)
        AS ciclo_maximo,

    SUM(dias_ciclo IS NULL)
        AS itens_sem_ciclo

FROM fato_item_contratado;