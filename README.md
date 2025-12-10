# Azure Data Engineering — AdventureWorks (Bronze → Curated → Gold)

Repositório técnico do projeto de Data Engineering que implementa um pipeline completo (Bronze → Curated → Gold) utilizando **Azure Data Factory**, **ADLS Gen2** e **Azure SQL Database**.

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

### Modelagem Relacional OLTP:

<img width="1942" height="1781" alt="Untitled" src="https://github.com/user-attachments/assets/a1492a20-7fd0-4eaa-a996-b12c7f4f21ed" />

### Modelagem Conceitual dos Dados

<img width="1237" height="621" alt="modelagem conceitual" src="https://github.com/user-attachments/assets/ce261e0c-9cd0-41d6-ba5c-d86513c74a12" />

# Estrutura e Arquitetura do Data Lake

A arquitetura do Data Lake foi organizada em quatro camadas principais, seguindo boas práticas de Engenharia de Dados. Abaixo estão as definições e a relação com os arquivos presentes no repositório.

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

1. O Azure Data Factory realiza a ingestão dos arquivos CSV para a camada RAW do Data Lake.
2. Os dataflows realizam transformações iniciais e enviam os dados para a camada STAGING.
3. Novos dataflows enriquecem, padronizam e entregam os dados na camada CURATED.
4. Scripts SQL são utilizados para gerar tabelas dimensionais e fato na camada GOLD.
5. A tabela fato FactInternetSales consolida o modelo e serve como base para análises.

---

# Consultas SQL Utilizadas
