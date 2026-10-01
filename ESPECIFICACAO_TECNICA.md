# Especificacao Tecnica

## 1. Identificacao

| Item | Descricao |
|---|---|
| Sistema | Comissoes de VR |
| Plataforma | Windows |
| Linguagem | Python |
| Interface | Tkinter/ttk |
| Banco de dados | Firebird |
| Entrada principal | `IMPORTA_VR` |
| Tabela de regras | `TAB_COMISSAO_ADM_VR` |
| Tabela de pre-vouchers | `RECIBOS_COMISSAO_VR` |
| Apolice de referencia | `VR0001` (fixa na tela de cadastro) |
| Geradores utilizados | `CONTROLE_TAB_COMISSAO_VR`, `GEN_RECIBO_COMISSAO_VR`, `NUMERO_VOUCHER_VR` |
| Versao de referencia | Reimplementacao dos formularios Delphi de cadastro e geracao automatica |

## 2. Objetivo

O sistema tem como objetivo substituir os formularios Delphi utilizados pelo
setor financeiro para:

1. Cadastrar percentuais e parametros de comissao de VR.
2. Aplicar as regras cadastradas aos beneficios importados.
3. Gerar pre-vouchers de comissao.
4. Exibir os resultados agrupados por administradora e produtor.
5. Gerar relatorio em PDF.
6. Exportar os dados para CSV.

O codigo deve permanecer reutilizavel para futura incorporacao em um sistema
maior, sem depender exclusivamente da interface grafica.

## 3. Escopo

### 3.1 Incluido

- Menu principal.
- Cadastro de regras de comissao.
- Inclusao, alteracao e cancelamento logico de regras.
- Consulta de administradoras, produtores e produtos.
- Consulta de beneficios da competencia.
- Calculo de comissoes.
- Gravacao de pre-vouchers.
- Relatorio visual em grade.
- Exportacao CSV.
- Geracao de PDF formatado.
- Conexao com Firebird por configuracao externa.

### 3.2 Nao incluido

- Alteracao estrutural das tabelas existentes.
- Importacao dos beneficios para `IMPORTA_VR`.
- Emissao definitiva de recibos oficiais (baixa de `NUM_RECIBO`).
- Calculo de retencoes tributarias no voucher.
- Integracao bancaria.
- Controle de usuarios e permissoes.
- Servico web ou API externa.

O formulario Delphi possui um botao para vouchers oficiais, mas a rotina
correspondente nao esta implementada no arquivo Pascal analisado. Por isso,
esta especificacao trata apenas da previa. O voucher gerado pelo sistema
reproduz o layout do ReportBuilder, mas nao altera o status nem o numero
dos pre-vouchers gravados.

## 4. Arquitetura

O sistema utiliza uma arquitetura simples em camadas:

```text
Interface grafica
    |
    +-- CadastroComissaoWindow
    |       |
    |       +-- Consultas e manutencao de TAB_COMISSAO_ADM_VR
    |
    +-- RelatorioComissoesWindow
            |
            +-- Consulta de IMPORTA_VR
            +-- Aplicacao das regras de comissao
            +-- Gravacao de RECIBOS_COMISSAO_VR
            +-- Grade, PDF de previa, PDF de voucher e CSV
    |
    +-- database.py
            |
            +-- Leitura do .env
            +-- Conexao Firebird
```

### 4.1 Organizacao dos arquivos

```text
.
|-- app.py
|-- database.py
|-- cadastro_comissao.py
|-- relatorio_comissoes.py
|-- .env                          (nao versionado)
|-- README.md
|-- ESPECIFICACAO_TECNICA.md
|-- CONTROLE DE PERCENTUAIS DE COMISSAO VR.xlsx
|-- cad_comissao_prod_vr.pas / .dfm / .ddp
`-- Delphi
    |-- rel_com_vr_automatico.pas / .dfm / .ddp
    `-- VoucherVR.pdf
```

Os fontes Delphi sao mantidos apenas como referencia do comportamento
original e do layout do voucher. Nao sao compilados nem executados pelo
sistema Python.

## 5. Componentes

### 5.1 `app.py`

Responsabilidades:

- Criar a janela principal.
- Exibir o menu **Operacoes**.
- Abrir a tela de cadastro.
- Abrir a tela de relatorio.
- Encerrar a aplicacao.

### 5.2 `database.py`

Responsabilidades:

- Ler o arquivo `.env`.
- Montar a URL de conexao Firebird.
- Abrir uma conexao usando `firebird-driver`.
- Ajustar o charset legado para preservar acentuacao.

Quando o `.env` informa `ASCII`, a aplicacao utiliza `WIN1252`, pois os dados
legados possuem caracteres como `a`, `c` e `o` acentuados.

### 5.3 `cadastro_comissao.py`

Responsabilidades:

- Implementar a tela equivalente ao formulario `cad_comissao_prod_vr`
  (classe `CadastroComissaoWindow`).
- Consultar administradoras em `APOLICES` e `PESSOAS` (apolices ativas
  cujo codigo contem `VR`).
- Consultar produtores pelos campos `FAVOR` e `FAVOR2` da apolice fixa
  `VR0001`.
- Consultar produtos em `NOMES_PRODUTOS_VR`.
- Evitar produtos duplicados para o produtor.
- Validar percentuais (0 a 100, formato brasileiro ou ponto decimal).
- Manter as regras em `TAB_COMISSAO_ADM_VR`, obtendo `CONTROLE` do gerador
  `CONTROLE_TAB_COMISSAO_VR`.

Valores padrao da tela: `APENAS_COND_TAXA` marcado, `SOBRE_TAXA`
desmarcado, comissao e desconto em `0,00`.

### 5.4 `relatorio_comissoes.py`

Responsabilidades:

- Implementar a tela equivalente ao formulario `rel_com_vr_automatico`
  (classe `RelatorioComissoesWindow`).
- Selecionar administradora, produtor e vigencia (calendario `tkcalendar`
  em `pt_BR`, com botao **Hoje**).
- Consultar beneficios em `IMPORTA_VR`.
- Aplicar as regras ativas.
- Remover pre-vouchers pendentes da competencia e criar os novos, obtendo
  `CONTROLE_REC` do gerador `GEN_RECIBO_COMISSAO_VR`.
- Exibir agrupamentos e totalizadores na grade.
- Gerar o PDF de previa, o PDF de voucher e o CSV.
- Obter o numero de cada voucher impresso do gerador `NUMERO_VOUCHER_VR`.

## 6. Configuracao

O arquivo `.env` deve estar na mesma pasta de `database.py`.

Exemplo:

```env
FB_HOST=192.168.0.6
FB_PORT=3050
FB_DATABASE=E:\SISTEMA\BASE_CHEQUE\BASE\FATURA.GDB
FB_USER=SYSDBA
FB_PASSWORD=masterkey
FB_CHARSET=ASCII
FB_POOL_SIZE=5
```

### 6.1 Regras de configuracao

- `FB_HOST`: endereco do servidor Firebird.
- `FB_PORT`: porta TCP do Firebird.
- `FB_DATABASE`: caminho do arquivo de banco no servidor.
- `FB_USER`: usuario da conexao.
- `FB_PASSWORD`: senha da conexao.
- `FB_CHARSET`: charset informado pelo ambiente legado.
- `FB_POOL_SIZE`: reservado para compatibilidade com configuracoes futuras.

O `.env` contem dados sensiveis e nao deve ser versionado.

## 7. Dependencias

```text
firebird-driver
tkcalendar
reportlab
```

Instalacao:

```powershell
python -m pip install firebird-driver tkcalendar reportlab
```

O mesmo interpretador Python usado para executar o sistema deve ser usado para
instalar as dependencias.

## 8. Modelo de dados utilizado

### 8.1 `PESSOAS`

Campos utilizados:

- `PESSOA`
- `NOME`
- `STATUS`
- `CPF_CNPJ`
- `OPTOU_SIMPLES`
- `BANCO`
- `AGENCIA`
- `CONTA`

Uso:

- Resolver o nome da administradora.
- Resolver o nome do produtor.
- Obter o codigo interno da pessoa.
- Fornecer documento, opcao pelo Simples e dados bancarios do favorecido
  no voucher.

### 8.2 `APOLICES`

Campos utilizados:

- `APOLICE`
- `ADMINISTRADORA`
- `FAVOR`
- `FAVOR2`
- `STATUS`

Uso:

- Localizar apolices VR ativas.
- Relacionar a administradora aos produtores.
- Obter os dois possiveis produtores da apolice.

### 8.3 `NOMES_PRODUTOS_VR`

Campos utilizados:

- `CONTA`
- `NOME_PRODUTO`
- `STATUS`

Uso:

- Relacionar nome do produto com a conta usada na regra de comissao.
- Listar produtos ainda nao cadastrados para o produtor.

### 8.4 `TAB_COMISSAO_ADM_VR`

Campos utilizados:

- `CONTROLE`
- `ADMINISTRADORA`
- `PRODUTOR`
- `STATUS`
- `CONTA`
- `PERC_COM`
- `PERC_DESC`
- `SOBRE_TAXA`
- `APENAS_COND_TAXA`

Uso:

- Armazenar as regras de comissao por administradora, produtor e produto.

### 8.5 `IMPORTA_VR`

Campos utilizados:

- `ADMINISTRADORA`
- `DT_INI_USO`
- `PRODUTO`
- `TARIFA`
- `TAXA`
- `VALOR`
- `STATUS`

Uso:

- Fornecer os beneficios que serao calculados.
- Filtrar pela administradora e competencia.
- Aplicar a condicao de taxa.

### 8.6 `RECIBOS_COMISSAO_VR`

Campos utilizados:

- `CONTROLE_REC`
- `NUM_RECIBO`
- `DT_EMI_RECIBO`
- `INI_VIGENCIA`
- `ADMINISTRADORA`
- `PRODUTOR`
- `CONTA`
- `PERC_COM`
- `DESC_COM`
- `VALOR_BRUTO`
- `VALOR_TOT_TAXA`
- `VALOR_COM`
- `USU_EMI_RECIBO`
- `STATUS`

Pre-vouchers sao identificados por:

```text
NUM_RECIBO = 0
STATUS = 'A'
```

Na gravacao, `DT_EMI_RECIBO` recebe a data atual e `USU_EMI_RECIBO` e
gravado vazio, pois nao ha controle de usuarios.

### 8.7 `BANCOS`

Campos utilizados:

- `COD_BANCO`
- `NOME_BANCO`

Uso:

- Resolver o nome do banco do favorecido a partir de `PESSOAS.BANCO` na
  emissao do voucher.

### 8.8 Geradores

| Gerador | Uso |
|---|---|
| `CONTROLE_TAB_COMISSAO_VR` | `TAB_COMISSAO_ADM_VR.CONTROLE` na inclusao de regra |
| `GEN_RECIBO_COMISSAO_VR` | `RECIBOS_COMISSAO_VR.CONTROLE_REC` na geracao de pre-voucher |
| `NUMERO_VOUCHER_VR` | Numero impresso em cada pagina de voucher |

O numero obtido de `NUMERO_VOUCHER_VR` e consumido a cada emissao e nao e
gravado em `RECIBOS_COMISSAO_VR`; os registros permanecem com
`NUM_RECIBO = 0`.

## 9. Fluxo do cadastro de comissoes

### 9.1 Novo cadastro

1. Usuario clica em **Novo**.
2. A tela habilita os campos.
3. Administradora e carregada pelas apolices VR ativas.
4. O codigo da administradora e obtido em `PESSOAS`.
5. `FAVOR` e `FAVOR2` da apolice `VR0001` sao consultados em `APOLICES`.
6. Os produtores ativos sao carregados em `PESSOAS`.
7. A grade e preenchida com as regras ativas da administradora.
8. Os produtos disponiveis sao carregados em `NOMES_PRODUTOS_VR`.
9. Contas ja cadastradas para o produtor sao excluidas da lista.
10. Usuario informa percentuais e flags.
11. O registro e inserido em `TAB_COMISSAO_ADM_VR` com `STATUS = 'A'`.

### 9.2 Alteracao

1. Usuario seleciona uma linha da grade.
2. O sistema recupera o controle do registro e habilita os botoes
   **Alterar** e **Excluir/Canc.**.
3. Usuario clica em **Alterar**.
4. Administradora, produtor e produto ficam bloqueados.
5. Percentual, desconto e flags ficam editaveis.
6. O registro e atualizado pelo campo `CONTROLE`.

### 9.3 Cancelamento

O cancelamento pede confirmacao ao usuario e nao exclui fisicamente o
registro:

```sql
UPDATE TAB_COMISSAO_ADM_VR
SET STATUS = 'C'
WHERE CONTROLE = ?
```

## 10. Fluxo de geracao de previa

1. Usuario abre o relatorio.
2. Opcionalmente seleciona administradora. Sem esse filtro, todas as
   administradoras com regra ativa e producao na competencia sao processadas.
3. Opcionalmente seleciona produtor.
4. Seleciona a competencia no calendario ou clica em **Hoje**.
5. Clica em **Relatorio de Previa**.
6. O sistema converte a competencia para `datetime.date`.
6a. O sistema faz a varredura de creditos em duplicidade em `IMPORTA_VR`
    (secao 10.1). Havendo duplicidade, exibe o alerta e so prossegue se o
    usuario confirmar.
7. Pre-vouchers pendentes da mesma competencia sao removidos para evitar
   duplicidade, respeitando os filtros de administradora e produtor.
8. Os registros de `IMPORTA_VR` sao selecionados.
9. Os produtos sao relacionados com `NOMES_PRODUTOS_VR`.
10. As regras ativas sao relacionadas com `TAB_COMISSAO_ADM_VR`.
11. Os beneficios sao agrupados por administradora, produto e regra
    (produtor, percentuais e flags).
12. A comissao e calculada.
13. O resultado e gravado em `RECIBOS_COMISSAO_VR`.
14. A transacao e confirmada.
15. A grade e atualizada com grupos por administradora e produtor e
    subtotal por produtor.
16. O dialogo para salvar o **Relatorio de Previa** e aberto
    automaticamente (A4 paisagem, `relatorio_previa_AAAAMMDD.pdf`).
17. O usuario pode emitir separadamente o **Voucher**, em A4 retrato
    (`VoucherVR_AAAAMMDD.pdf`), usando o modelo visual do ReportBuilder
    Delphi. A emissao exige que a previa tenha sido gerada na mesma
    sessao da tela.
18. O usuario pode exportar o CSV (`relatorio_comissoes_vr.csv`).

Apos gerar cada PDF, o sistema oferece abrir o arquivo.

Quando somente a data de inicio de vigencia estiver preenchida, a consulta
processa o lote completo e ordena as administradoras alfabeticamente. O mesmo
lote e utilizado para a emissao dos vouchers.

Em caso de erro durante a geracao, a transacao e revertida e a mensagem e
exibida ao usuario.

### 10.1 Varredura de creditos em duplicidade

Objetivo: detectar, antes do calculo, lancamentos repetidos em
`IMPORTA_VR`, normalmente causados pela importacao do mesmo arquivo mais
de uma vez.

Criterios:

- Escopo: `DT_INI_USO` igual a competencia informada; `ADMINISTRADORA`
  igual a selecionada, ou todas quando o campo estiver vazio. O filtro de
  produtor nao se aplica, pois `IMPORTA_VR` nao possui produtor.
- Registros com `STATUS = 'C'` sao ignorados.
- Dois registros sao duplicados quando todas as colunas da constante
  `DUPLICATE_COLUMNS` sao identicas. Ficam de fora `CNT_IMPORTA` e
  `DT_IMPORTACAO` (mudam a cada importacao) e `CONTADOR` (posicao da linha
  dentro da importacao, que pode variar entre dois envios do mesmo
  credito). Valores nulos iguais contam como identicos.

Consulta (forma geral):

```sql
SELECT D.ADMINISTRADORA, PES.NOME, COUNT(*) GRUPOS, SUM(D.QTD_LINHAS - 1) EXCEDENTES
FROM (
    SELECT <colunas comparadas>, COUNT(*) QTD_LINHAS
    FROM IMPORTA_VR IV
    WHERE IV.DT_INI_USO = ? AND IV.STATUS <> 'C' [AND IV.ADMINISTRADORA = ?]
    GROUP BY <colunas comparadas>
    HAVING COUNT(*) > 1
) D
LEFT JOIN PESSOAS PES ON PES.PESSOA = D.ADMINISTRADORA
GROUP BY D.ADMINISTRADORA, PES.NOME
ORDER BY PES.NOME
```

Resultado: uma linha por administradora com a quantidade de grupos
duplicados e de registros excedentes (linhas alem da primeira de cada
grupo).

Comportamento na tela (`_confirm_duplicates`):

- Sem duplicidade: a geracao segue sem interrupcao.
- Com duplicidade: alerta com nome da administradora, vigencia e
  quantidades, totalizado ao final, e a pergunta "Anular essas
  duplicidades temporariamente para emissao dos Recibos?", com tres
  respostas. **Sim** executa a anulacao (secao 10.2), confirma a
  transacao e prossegue. **Nao** prossegue sem anular. **Cancelar**
  (opcao padrao) interrompe sem gravar nada.
- Erro na consulta ou na anulacao: a transacao e revertida, a geracao e
  interrompida e o erro exibido.
- Se a quantidade anulada for diferente da quantidade de excedentes
  informada no alerta, um aviso adicional pede conferencia da tabela.

Tempo medido no banco atual: 0,5 a 2 segundos para vigencias com 11 a 17
mil registros.

### 10.2 Anulacao temporaria de duplicidades

Metodo `_annul_duplicates`. Marca com `STATUS = 'D'` os registros
duplicados da vigencia (e da administradora, quando informada). Em cada
grupo de registros identicos, permanece com `STATUS = 'A'` apenas o
importado mais recentemente, pela ordem:

1. Maior `DT_IMPORTACAO`.
2. Em empate, maior `CNT_IMPORTA`.
3. Em novo empate (linha repetida dentro do mesmo arquivo), maior
   `CONTADOR`.

Comando (forma geral):

```sql
UPDATE IMPORTA_VR IV SET STATUS = 'D'
WHERE IV.DT_INI_USO = ? AND IV.STATUS = 'A' [AND IV.ADMINISTRADORA = ?]
  AND EXISTS (
      SELECT 1 FROM IMPORTA_VR NEWER
      WHERE <NEWER.coluna IS NOT DISTINCT FROM IV.coluna, para cada coluna comparada>
        AND (NEWER.DT_IMPORTACAO > IV.DT_IMPORTACAO
         OR (NEWER.DT_IMPORTACAO = IV.DT_IMPORTACAO AND NEWER.CNT_IMPORTA > IV.CNT_IMPORTA)
         OR (NEWER.DT_IMPORTACAO = IV.DT_IMPORTACAO AND NEWER.CNT_IMPORTA = IV.CNT_IMPORTA
             AND NEWER.CONTADOR > IV.CONTADOR))
  )
```

Consequencias do status `D`:

- Todos os filtros de `IMPORTA_VR` em `relatorio_comissoes.py` usam
  `STATUS NOT IN ('C', 'D')`: geracao de pre-vouchers, contagem de
  beneficios, valor de carga e valor de taxa na grade e no voucher, e a
  propria varredura de duplicidade.
- Nenhum registro e apagado. A reversao e manual:
  `UPDATE IMPORTA_VR SET STATUS = 'A' WHERE STATUS = 'D' AND DT_INI_USO = ?`.
- O status `D` e exclusivo deste tratamento; antes dele a tabela possuia
  apenas `A` e `C`.

Validacao realizada na vigencia 01/10/2026, em transacao revertida ao
final: 103 registros anulados de 103 esperados, nenhuma duplicidade
restante, e cada registro `D` possui um registro `A` mais recente no
mesmo grupo.

## 11. Regras de calculo

### 11.1 Condicao de selecao

Somente beneficios com:

```sql
DT_INI_USO = ?
AND STATUS <> 'C'
```

participam do calculo.

Quando `APENAS_COND_TAXA = 'S'`, tambem e aplicada a condicao:

```sql
TAXA > 0
```

### 11.2 Base da comissao

Quando `SOBRE_TAXA = 'N'`:

```text
base = soma(TARIFA)
```

Quando `SOBRE_TAXA = 'S'`:

```text
valor_da_taxa = soma(TARIFA * TAXA / 100)
base = valor_da_taxa
```

### 11.3 Comissao e desconto

```text
comissao_bruta = base * PERC_COM / 100
desconto = comissao_bruta * PERC_DESC / 100
comissao_final = comissao_bruta - desconto
```

`PERC_DESC` igual a zero e valido.

### 11.4 Valores gravados

```text
VALOR_BRUTO    = base (soma da tarifa ou soma da taxa, conforme SOBRE_TAXA)
VALOR_TOT_TAXA = soma(TARIFA * TAXA / 100)
VALOR_COM      = comissao_final
PERC_COM       = PERC_COM da regra
DESC_COM       = PERC_DESC da regra
```

Os calculos usam `Decimal` para evitar erros de arredondamento binario.

## 12. Relatorio

### 12.1 Agrupamento

O relatorio e organizado por:

1. Administradora.
2. Produtor.
3. Produto.

Os nomes sao obtidos em `PESSOAS`.

### 12.2 Totalizador

Para cada produtor sao totalizados:

- Quantidade de beneficios.
- Soma das comissoes.

Formato esperado:

```text
Total do produtor: Nome do produtor - 8 beneficios - R$ 1.234,50
```

### 12.3 PDF

O sistema possui duas saídas PDF independentes:

#### Relatorio de Previa

- Utiliza formato paisagem A4.
- Possui titulo e competencia.
- Possui quebra por administradora e produtor.
- Exibe produtos, percentuais, valores de carga, taxas e comissoes.
- Destaca o total do produtor em negrito.
- Usa formato monetario brasileiro.

#### Emissao de Voucher

Replica o modelo `Delphi/VoucherVR.pdf` do ReportBuilder Delphi:

- Utiliza formato retrato A4.
- Gera uma pagina por administradora, com numero de voucher obtido do
  gerador `NUMERO_VOUCHER_VR`.
- Contem os blocos **AUTORIZACAO PARA PAGAMENTO** e
  **RECIBO DE PAGAMENTO**.
- Apresenta favorecido, CPF/CNPJ formatado, opcao pelo Simples, banco,
  agencia e conta corrente, obtidos de `PESSOAS` e `BANCOS`. O favorecido
  e o produtor do primeiro registro do grupo da administradora.
- Exibe produtos, valor de carga, valor da taxa, percentual de repasse e
  repasse, com linha de total.
- No recibo, o valor bruto e o valor total permanecem iguais ao total do
  repasse enquanto as regras de retencao tributaria nao forem definidas.
- Exibe estorno, ISS, IR, COFINS, CSLL e PIS com valor zero, conforme o
  modelo original.
- Usa formato monetario brasileiro e o aviso de que a impressao nao e
  documento fiscal.
- Nao altera `NUM_RECIBO` nem `STATUS` dos pre-vouchers.

### 12.4 CSV

O CSV:

- Usa codificacao UTF-8 com BOM.
- Usa `;` como separador.
- Inclui cabecalho com as colunas: `CONTROLE_REC`, `NUM_RECIBO`,
  `INI_VIGENCIA`, `ADMINISTRADORA`, `PRODUTOR`, `NOME_PRODUTO`, `PERC_COM`,
  `DESC_COM`, `VALOR_BRUTO`, `VALOR_TAXA`, `VALOR_COM`, `STATUS`,
  `NOME_ADM`, `NOME_PRODUTOR`, `BENEFICIOS`.
- Inclui detalhes, linhas de agrupamento (`ADMINISTRADORA:` e
  `PRODUTOR:`) e totalizadores (`TOTAL PRODUTOR:`).
- Exige que a previa tenha sido gerada antes da exportacao.

## 13. Acentuacao e charset

O banco legado possui dados em pagina de codigo compativel com `WIN1252`.
Quando o `.env` informa `ASCII`, a aplicacao ajusta internamente o charset da
conexao para `WIN1252`.

A aplicacao nao deve remover acentos dos dados. A comparacao de nomes de
produtos, entretanto, depende do texto recebido da importacao e do texto
cadastrado em `NOMES_PRODUTOS_VR`.

Quando houver diferenca entre:

```text
ALIMENTACAO
Alimentacao
Alimentacao
Auxilio Alimentacao
```

o relacionamento literal por nome pode falhar. A evolucao recomendada e criar
uma tabela de equivalencia de produtos ou usar um codigo comum de produto.

## 14. Transacoes e tratamento de erros

Operacoes de escrita devem seguir:

```text
begin
    executar operacoes
    commit
except
    rollback
    informar erro ao usuario
```

Operacoes envolvidas:

- Inclusao de comissao.
- Alteracao de comissao.
- Cancelamento de comissao.
- Exclusao de pre-vouchers pendentes.
- Inclusao de pre-vouchers.

Nenhuma falha de banco deve ser convertida silenciosamente em sucesso.

## 15. Seguranca

- Credenciais ficam fora do codigo fonte.
- O arquivo `.env` nao deve ser publicado.
- Consultas com valores de interface utilizam parametros.
- O cancelamento e logico.
- O usuario deve confirmar operacoes destrutivas ou de cancelamento.
- O acesso ao banco deve ser restrito a usuarios autorizados.

## 16. Instalacao e execucao

Instalar dependencias:

```powershell
python -m pip install firebird-driver tkcalendar reportlab
```

Executar:

```powershell
python "u:\--2021\07-Comissao VR\app.py"
```

O Python usado para instalar as dependencias deve ser o mesmo usado para
executar o aplicativo.

## 17. Validacao tecnica

Devem ser validados:

- Abertura da aplicacao.
- Abertura das duas telas.
- Conexao com o Firebird.
- Leitura de administradoras.
- Leitura de produtores.
- Leitura de produtos.
- Inclusao de regra.
- Alteracao de regra.
- Cancelamento de regra.
- Aceite de desconto zero.
- Selecao da competencia pelo calendario.
- Geracao de pre-vouchers.
- Nao duplicacao de pre-vouchers.
- Varredura de creditos em duplicidade com e sem administradora informada.
- Alerta de duplicidade com as opcoes Sim, Nao e Cancelar.
- Anulacao temporaria (`STATUS = 'D'`) mantendo apenas o registro mais
  recente de cada grupo.
- Exclusao dos registros `D` do calculo, da grade e do voucher.
- Aplicacao de `SOBRE_TAXA`.
- Aplicacao de `APENAS_COND_TAXA`.
- Totalizador por produtor.
- Geracao de PDF.
- Exportacao CSV.
- Preservacao da acentuacao.

## 18. Evolucoes recomendadas

1. Criar uma camada de servicos independente da interface Tkinter.
2. Criar repositorios para consultas Firebird.
3. Criar mapeamento oficial entre produtos importados e produtos de comissao.
4. Implementar vouchers oficiais, gravando o numero obtido de
   `NUMERO_VOUCHER_VR` em `NUM_RECIBO` e alterando o status dos registros.
5. Definir e aplicar as regras de retencao tributaria no recibo.
6. Implementar controle de usuarios e preencher `USU_EMI_RECIBO`.
7. Adicionar testes automatizados para as formulas.
8. Adicionar log de processamento.
9. Adicionar identificador de lote para cada geracao.
10. Adicionar validacao de competencia com lista de datas disponiveis.
11. Permitir escolher o favorecido do voucher quando a administradora
    tiver mais de um produtor na mesma competencia.
