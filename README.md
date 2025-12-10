# Azure Data Engineering — AdventureWorks

Repositório técnico do projeto de Data Engineering que implementa um pipeline completo 
(Bronze → Curated → Gold) utilizando **Azure Data Factory**, **ADLS Gen2** e **Azure SQL Database**.

Todas as explicações detalhadas sobre arquitetura, decisões técnicas e fundamentos estão disponíveis no artigo publicado no Medium:  
 [Construindo um Pipeline de Dados Moderno no Azure](https://medium.com/p/4d5034364e84)

---
# Tecnologias Utilizadas

- Azure Data Factory (ADF)
- Azure Data Lake Storage Gen2
- Azure SQL Database
- Mapping Data Flows (ADF)
- GitHub Integration com Azure Data Factory

---

## Arquitetura Geral

### Diagrama completo de ponta a ponta:

<img width="1042" height="601" alt="Diagrama Azure AdventureWorks" src="https://github.com/user-attachments/assets/b95e1cd6-abfa-4077-881f-458623651126" />

---

### Modelagem Relacional OLTP:

<img width="1942" height="1781" alt="Untitled" src="https://github.com/user-attachments/assets/a1492a20-7fd0-4eaa-a996-b12c7f4f21ed" />

---

### Modelagem Conceitual dos Dados

<img width="1237" height="621" alt="modelagem conceitual" src="https://github.com/user-attachments/assets/ce261e0c-9cd0-41d6-ba5c-d86513c74a12" />

---

## Estrutura de Pastas do Projeto

A organização a seguir reflete toda a arquitetura desenvolvida no projeto, incluindo pipelines, datasets, dataflows, consultas SQL e arquivos relacionados ao processo de engenharia de dados na Azure.

```markdown
📁 Azure Fabric
│
├── 📂 Analise_de_dados/                # Consultas SQL e análises exploratórias
│   ├── Consulta_1.csv
│   ├── Consulta_2.csv
│   ├── Consulta_3.csv
│   ├── query_1.sql
│   ├── query_2.sql
│   └── query_3.sql
│
├── 📂 Dados_Utilizados/                # Arquivos CSV brutos usados no projeto
│   ├── Person.Person.csv
│   ├── Production.Product.csv
│   ├── Sales.Customer.csv
│   ├── Sales.SalesOrderDetail.csv
│   ├── Sales.SalesOrderHeader.csv
│   └── Sales.SpecialOfferProduct.csv
│
├── 📂 dataflow/                        # Dataflows do ADF (transformações)
│   ├── df_customer.json
│   ├── df_person.json
│   ├── df_product.json
│   ├── df_salesOrderDetail.json
│   ├── df_salesOrderHeader.json
│   └── df_specialOfferProduct.json
│
├── 📂 dataset/                         # Datasets do ADF (raw, staging, curated)
│   ├── ds_raw_customer.json
│   ├── ds_raw_person.json
│   ├── ds_raw_product.json
│   ├── ds_raw_salesOrderDetail.json
│   ├── ds_raw_salesOrderHeader.json
│   ├── ds_raw_specialOfferProduct.json
│   ├── ds_staging_customer.json
│   ├── ds_staging_person.json
│   ├── ds_staging_product.json
│   ├── ds_staging_salesOrderDetail.json
│   ├── ds_staging_salesOrderHeader.json
│   ├── ds_staging_specialOfferProduct.json
│   ├── ds_curated_customer.json
│   ├── ds_curated_person.json
│   ├── ds_curated_product.json
│   ├── ds_curated_salesOrderDetail.json
│   ├── ds_curated_salesOrderHeader.json
│   └── ds_curated_specialOfferProduct.json
│
├── 📂 tabelas_sql/                     # Estrutura das tabelas utilizadas
│   ├── tabelaCustomer.json
│   ├── tabelaPerson.json
│   ├── tabelaProduct.json
│   ├── tabelaSalesOrderDetail.json
│   ├── tabelaSalesOrderHeader.json
│   └── tabelaSpecialOfferProduct.json
│
├── 📂 factory/                         # Configuração da Data Factory exportada
│   └── adf-bigtech-pipeline.json
│
├── 📂 linkedService/                   # Conexões com SQL DB e Data Lake
│   ├── ls_datalake_bigtech.json
│   └── ls_sql_bigtech.json
│
├── 📂 pipeline/                        # Pipelines de ingestão e tratamento
│   ├── CopyAllCSVToLake.json
│   └── PL_Curated_AdventureWorks.json
│
├── publish_config.json                 # Configuração de publicação do ADF
└── README.md                           # Documentação do repositório

```
---
# Estrutura e Arquitetura do Data WareHouse

A arquitetura do Data WareHouse foi organizada em quatro camadas principais, seguindo boas práticas de Engenharia de Dados. Abaixo estão as definições e a relação com os arquivos presentes no repositório.

## Camada RAW
- Armazena os arquivos CSV exatamente como recebidos da fonte.
- Nenhuma transformação é aplicada nesta etapa.
- Útil como camada de auditoria e preservação da integridade dos dados.

Arquivos:
`ds_raw_*.json`

---

## Camada STAGING
- Padronização de nomes de colunas.
- Seleção das colunas relevantes para o negócio.
- Conversão básica de tipos de dados.
- Utilizada como preparação intermediária para limpeza e enriquecimento posterior.

Arquivos:
`ds_staging_*.json`  
`df_*.json`

---

## Camada CURATED
- Dados tratados, limpos e padronizados.
- Etapa utilizada como base para criação de modelos dimensionais e análises.
- Contém os dados finais antes da carga no banco SQL.

Arquivos:
`ds_curated_*.json`

---

## Camada GOLD (SQL Database)
- Implementa o modelo dimensional final.
- Tabelas dimensionais (DimCustomer, DimProduct, DimPerson, etc.).
- Tabela fato central (FactInternetSales).
- Dados preparados para análises, dashboards e consumo por ferramentas BI.

Scripts:
`tabela*.json`

---

# Modelagem Física (Camada GOLD)

A modelagem física contempla:
- Criação de chaves substitutas (surrogate keys).
- Definição de relacionamentos entre dimensões e fatos utilizando foreign keys.
- Tipificação adequada de colunas para otimizar desempenho no SQL.
- Definição do nível de granularidade (grain) da tabela fato.

---

# Fluxo Completo do Pipeline

1. O Azure Data Factory realiza a ingestão dos arquivos CSV para a camada RAW do Data WareHouse.
2. Os dataflows realizam transformações iniciais e enviam os dados para a camada STAGING.
3. Novos dataflows enriquecem, padronizam e entregam os dados na camada CURATED.
4. Scripts SQL são utilizados para gerar tabelas dimensionais e fato na camada GOLD.
5. A tabela fato FactInternetSales consolida o modelo e serve como base para análises.

---

# Analises De Dados

1.	Escreva uma query que retorna a quantidade de linhas na tabela Sales.SalesOrderDetail pelo campo SalesOrderID, desde que tenham pelo menos três linhas de detalhes.
2.	Escreva uma query que ligue as tabelas Sales.SalesOrderDetail, Sales.SpecialOfferProduct e Production.Product e retorne os 3 produtos (Name) mais vendidos (pela soma de OrderQty), agrupados pelo número de dias para manufatura (DaysToManufacture).
3.	Escreva uma query usando as tabelas Sales.SalesOrderHeader, Sales.SalesOrderDetail e Production.Product, de forma a obter a soma total de produtos (OrderQty) por ProductID e OrderDate.


# Recursos Utilizados para criação do Projeto Completo

#### Para o desenvolvimento deste projeto, o ambiente permaneceu ativo durante aproximadamente um mês. Devido à minha rotina de trabalho em outra cidade, não houve a necessidade de desativar ou pausar recursos ao longo desse período, resultando em utilização contínua dos serviços do Azure.

<img width="1420" height="980" alt="costanalysis_charts" src="https://github.com/user-attachments/assets/ddaf16c0-3268-4b20-a5d8-7c73180e33d5" />
