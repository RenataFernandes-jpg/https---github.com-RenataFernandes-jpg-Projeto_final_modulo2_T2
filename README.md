# Projeto Final M2 SCTEC

  A Controladoria identificou gargalos operacionais severos nas compras e contratações públicas federais: indícios de sobrepreço em itens homologados, concentração atípica de contratos em determinados grupos econômicos, morosidade excessiva entre a publicação de editais e o fechamento dos certames e baixa adesão competitiva em certas modalidades.
Para complicar o cenário, os sistemas legados de onde os dados são extraídos não possuem travas rígidas de validação na ponta. O resultado é um repositório bruto repleto de anomalias: identificadores corrompidos, campos monetários preenchidos em texto livre, inconsistências lógicas de cronograma e formatos de data despadronizados. A liderança governamental precisa de clareza para a tomada de decisão estratégica e auditoria contínua, mas hoje não confia nos relatórios gerados a partir desses dados brutos.
Sua missão é liderar o desenvolvimento de uma esteira analítica ponta a ponta (End-to-End), transformando esse mar de dados corrompidos em um ambiente analítico confiável, auditável e executivo.
A base oficial é o Portal Nacional de Contratações Públicas (PNCP) / Dados Abertos do Governo Federal (dados.gov.br), com recorte mínimo de 6 meses consecutivos (neste projeto, o ano de 2025 já extraído pelo professor, que você usa por inteiro), cruzando obrigatoriamente os dados de cabeçalho dos certames (órgãos, datas, modalidades) com os dados dos itens licitados (valores unitários estimados e homologados, quantidades e descrições).

#### Perguntas de negócio:

P1 - Qual é o percentual e o valor financeiro nominal economizado pelo governo (diferença entre valor estimado e valor homologado)?

P2 - Quem são os maiores fornecedores em volume financeiro e qual percentual do orçamento público está concentrado neles?

P3 - Quais modalidades licitatórias trazem maior deságio/economia e quais concentram o maior volume de recursos?

P4 - Qual a duração média (em dias) entre o lançamento do edital e a sua homologação final, segmentada por órgão?

P5 - Quais estados e regiões concentram as maiores despesas e quais apresentam os melhores indicadores de desconto?

P6 - Como os recursos se distribuem entre bens, serviços e obras e engenharia?

#### Diagrama estrela:

  <div>
    <img width="726" height="504" alt="Captura de tela 2026-11-17 010250" src="https://github.com/user-attachments/assets/65797809-a708-45a1-954b-0fa24c6faea6" />
  </div>



#### P1 - Qual é o percentual e o valor financeiro nominal economizado pelo governo (diferença entre valor estimado e valor homologado)?

O governo economizou aproximadamente R$ 992,86 milhões (14,46%) nos itens analisados.



#### P2 - Quem são os maiores fornecedores em volume financeiro e qual percentual do orçamento público está concentrado neles?

Os dez maiores fornecedores concentram aproximadamente um terço do volume financeiro analisado (34,53%). A Construtora Cidade Limitada apresenta a maior participação individual, com 8,94%.

  <div>
    <img width="768" height="432" alt="Participação dos 10 maiores fornecedores" src="https://github.com/user-attachments/assets/acbe76e1-f203-408d-bfbd-c3829aac977d" />
  </div>

  
#### P3 - Quais modalidades licitatórias trazem maior deságio/economia e quais concentram o maior volume de recursos?

A Concorrência Eletrônica concentra a maior parcela dos recursos públicos, representando 80% do volume financeiro homologado, aproximadamente R$ 4,70 bilhões. 
O Pregão Eletrônico apresentou o melhor indicador percentual de economia, alcançando 24,02%, o equivalente a aproximadamente R$ 158,70 milhões. 

 <div>
    <img width="768" height="432" alt="Economia e participação financeira por modalidade licitatória" src="https://github.com/user-attachments/assets/87b172ae-9b10-4312-8784-c64694750d4e" />
  </div>

  
#### P4 - Qual a duração média (em dias) entre o lançamento do edital e a sua homologação final, segmentada por órgão?

Em média, os processos analisados levaram aproximadamente 49 dias entre a publicação do edital e a homologação final. Esse valor é uma estimativa calculada de todos o orgãos que estão na nossa base, porém temos orgãos com mais de 400 dias conforme mostra o nosso quadro abaixo.

  <div>
    <img width="1079" height="608" alt="Matplotlib Chart" src="https://github.com/user-attachments/assets/0015db57-260c-4ade-850b-386d4b4a9db0" />
  </div>

#### P5 - Quais estados e regiões concentram as maiores despesas e quais apresentam os melhores indicadores de desconto?

As despesas públicas estão concentradas principalmente nas regiões Centro-Oeste (31,21%) e Nordeste (27,62%). Em relação aos indicadores de economia, a Região Norte apresentou o melhor resultado, com 21,43%, enquanto a Região Sul registrou o menor percentual, de 7,96%. Entre os estados, o Acre obteve o maior percentual de economia (26,71%), seguido por Mato Grosso (25,84%) e Bahia (25,01%).

  
  <div>
    <img width="768" height="432" alt="Despesas homologadas por região (1)" src="https://github.com/user-attachments/assets/41e80fa4-4c3e-4343-82a8-578b44e368dd" />
  </div>


  <div>
    <img width="1500" height="900" alt="tabelas_estados_despesas_economia" src="https://github.com/user-attachments/assets/a66de662-9db6-4ff6-892b-65734ca4e691" />
  </div>


  #### P6 - Como os recursos se distribuem entre bens, serviços e obras e engenharia?

A maior parte dos recursos públicos está concentrada em Obras e Engenharia, que representam 60,82% do valor homologado, aproximadamente R$ 4,89 bilhões. Em seguida, aparecem os Serviços, com 36,56% (R$ 2,94 bilhões). Já a categoria Bens representa apenas 2,63% dos recursos, aproximadamente R$ 211,19 milhões.
  
  <div>
    <img width="846" height="599" alt="Distribuição dos recursos por tipo de gasto" src="https://github.com/user-attachments/assets/d9e6ba82-1637-435d-8421-82d1d407559b" />
  </div>

#### POWER BI

  <div>
    <img width="789" height="449" alt="p1" src="https://github.com/user-attachments/assets/f6cce639-9f2d-4f3d-ab42-5213c01fdab1" />
  </div>

  <div>
    <img width="785" height="449" alt="P2" src="https://github.com/user-attachments/assets/2b2ec981-93d5-46e2-9c18-2054c9e25a17" />
  </div>

  <div>
    <img width="784" height="448" alt="P3" src="https://github.com/user-attachments/assets/0d7f6f92-9760-414a-aedb-6cca75b08a24" />
  </div>

  <div>
    <img width="781" height="448" alt="P4" src="https://github.com/user-attachments/assets/a2194560-6d76-47e6-a3d9-b1f28249420d" />
  </div>

  <div>
    <img width="788" height="449" alt="P5" src="https://github.com/user-attachments/assets/9e4ec56f-27da-4cce-a64f-d151932a593e" />>
  </div>

  <div>
    <img width="779" height="450" alt="P6" src="https://github.com/user-attachments/assets/5d928fa1-adcb-492c-9f66-39191fa97282" />
  </div>
