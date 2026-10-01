# Comissoes de VR

Aplicacao Python para cadastro de percentuais de comissao de VR, geracao de
pre-vouchers e emissao de relatorios em PDF a partir dos dados do Firebird.

O projeto foi criado para substituir os fluxos dos formularios Delphi:

- `cad_comissao_prod_vr`
- `rel_com_vr_automatico`

## Funcionalidades

### Cadastro de percentuais

Disponivel no menu **Operacoes > Cadastrar percentuais de comissao**.

Permite:

- Selecionar administradora de apolices VR (apolices ativas cujo codigo
  contem `VR`).
- Selecionar produtor relacionado a `FAVOR` ou `FAVOR2` da apolice.
- Selecionar produtos ainda nao cadastrados para o produtor.
- Informar percentual de comissao.
- Informar percentual de desconto, inclusive zero ou vazio.
- Definir:
  - `SOBRE_TAXA` (opcao **Calcula comissao sobre as taxas**, desmarcada por
    padrao).
  - `APENAS_COND_TAXA` (opcao **Calcula comissao somente em condicoes com
    taxas**, marcada por padrao).
- Consultar comissoes ja cadastradas para a administradora.
- Alterar uma comissao existente selecionada na grade.
- Cancelar uma comissao logicamente usando `STATUS = 'C'`.

A tela trabalha com a apolice fixa `VR0001`, exibida em campo somente
leitura. Os produtores sao obtidos de `APOLICES.FAVOR` e `APOLICES.FAVOR2`
dessa apolice para a administradora selecionada.

Os percentuais aceitam o formato brasileiro (`12,5`) ou ponto decimal
(`12.5`) e devem estar entre 0 e 100.

As regras sao gravadas na tabela `TAB_COMISSAO_ADM_VR`. O campo `CONTROLE`
e obtido do gerador `CONTROLE_TAB_COMISSAO_VR`.

Botoes da tela: **Novo**, **Alterar**, **Excluir/Canc.**, **Limpa**,
**Sair** e **Aplica**.

### Relatorio de comissoes automaticas

Disponivel no menu **Operacoes > Relatorio de comissoes**.

Permite:

- Selecionar administradora (opcional).
- Selecionar produtor (opcional).
- Selecionar a competencia usando um calendario ou o botao **Hoje**.
- Gerar os pre-vouchers e o **Relatorio de Previa** em PDF.
- Visualizar os registros calculados na grade, com linhas de agrupamento
  por administradora e produtor e subtotal por produtor.
- Emitir o **Voucher** em PDF no modelo do ReportBuilder Delphi.
- Exportar os dados para CSV.

Botoes da tela: **Relatorio de Previa**, **Emissao de Voucher**,
**Exportar relatorio CSV**, **Limpa** e **Sair**.

Os pre-vouchers sao gravados em `RECIBOS_COMISSAO_VR` com:

```text
NUM_RECIBO = 0
STATUS = 'A'
DT_EMI_RECIBO = data atual
USU_EMI_RECIBO = vazio
```

O campo `CONTROLE_REC` e obtido do gerador `GEN_RECIBO_COMISSAO_VR`.

Antes de gerar, os pre-vouchers pendentes (`NUM_RECIBO = 0`) da mesma
competencia sao apagados, respeitando os filtros de administradora e
produtor quando informados. Isso evita duplicidade em novas geracoes.

## Estrutura do projeto

```text
.
|-- app.py
|-- database.py
|-- cadastro_comissao.py
|-- relatorio_comissoes.py
|-- .env                          (nao versionado)
|-- .gitignore
|-- README.md
|-- ESPECIFICACAO_TECNICA.md
|-- CONTROLE DE PERCENTUAIS DE COMISSAO VR.xlsx
|-- cad_comissao_prod_vr.pas      (formulario Delphi de cadastro)
|-- cad_comissao_prod_vr.dfm
|-- cad_comissao_prod_vr.ddp
`-- Delphi
    |-- rel_com_vr_automatico.pas (formulario Delphi de geracao automatica)
    |-- rel_com_vr_automatico.dfm
    |-- rel_com_vr_automatico.ddp
    `-- VoucherVR.pdf             (modelo visual do voucher)
```

A planilha `CONTROLE DE PERCENTUAIS DE COMISSAO VR.xlsx` e o controle
manual usado pelo setor financeiro e serve de referencia para conferencia
dos percentuais cadastrados.

### `app.py`

Janela principal e menu da aplicacao. Usa o tema `vista` do ttk quando
disponivel.

### `database.py`

Carrega o arquivo `.env` e abre a conexao com o Firebird usando
`firebird-driver`.

### `cadastro_comissao.py`

Implementa a tela de cadastro (`CadastroComissaoWindow`) e as operacoes de
inclusao, alteracao, cancelamento e consulta.

### `relatorio_comissoes.py`

Implementa a tela de relatorio (`RelatorioComissoesWindow`): consulta da
competencia, calculo da comissao, gravacao dos pre-vouchers, grade,
PDF de previa, PDF de voucher e CSV.

## Requisitos

- Windows.
- Python 3.10 ou superior.
- Acesso de rede ao servidor Firebird.
- Banco Firebird acessivel pelas credenciais do `.env`.
- Geradores Firebird existentes no banco:
  - `CONTROLE_TAB_COMISSAO_VR`
  - `GEN_RECIBO_COMISSAO_VR`
  - `NUMERO_VOUCHER_VR`

Dependencias Python:

```text
firebird-driver
tkcalendar
reportlab
```

Instalacao:

```powershell
python -m pip install firebird-driver tkcalendar reportlab
```

Caso o aplicativo seja executado com um Python especifico, instale as
dependencias usando o mesmo executavel:

```powershell
& "C:\caminho\python.exe" -m pip install firebird-driver tkcalendar reportlab
```

## Configuracao do Firebird

O arquivo `.env` deve ficar na raiz do projeto.

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

Apesar de o sistema legado informar `ASCII`, os dados do banco possuem
acentuacao. O modulo de conexao converte esse valor para `WIN1252` para
preservar caracteres como:

- `Comissao`
- `Administracao`
- `Alimentacao`
- `Auxilio`

O arquivo `.env` contem credenciais e nao deve ser versionado ou compartilhado
publicamente. Ele ja esta listado no `.gitignore`.

## Execucao

```powershell
python "u:\--2021\07-Comissao VR\app.py"
```

Ou usando o interpretador configurado no ambiente local:

```powershell
& "C:\Users\Alberto\AppData\Local\Python\pythoncore-3.14-64\python.exe" `
  "u:\--2021\07-Comissao VR\app.py"
```

## Fluxo do cadastro

1. Abra **Cadastrar percentuais de comissao**.
2. Clique em **Novo**.
3. Selecione a administradora.
4. Selecione o produtor carregado a partir de `APOLICES.FAVOR` e
   `APOLICES.FAVOR2`.
5. Selecione o produto disponivel.
6. Informe os percentuais.
7. Marque as opcoes de taxa quando aplicavel.
8. Clique em **Aplica**.

Para alterar ou cancelar, selecione a linha na grade **Comissoes
cadastradas**; os botoes **Alterar** e **Excluir/Canc.** sao habilitados.
Na alteracao, administradora, produtor e produto ficam bloqueados; apenas
percentuais e opcoes podem ser editados.

O produto ja cadastrado para o produtor e ignorado pela lista de novos
produtos quando existe registro ativo em `TAB_COMISSAO_ADM_VR`.

## Fluxo do relatorio

1. Abra **Relatorio de comissoes**.
2. Opcionalmente selecione a administradora. Se ela nao for informada, o
   sistema processara todas as administradoras que tenham regras ativas e
   producao na competencia.
3. Opcionalmente selecione o produtor.
4. Escolha a competencia no calendario ou clique em **Hoje**.
5. Clique em **Relatorio de Previa**. O sistema primeiro faz a varredura
   de creditos em duplicidade (veja abaixo). Se nao houver duplicidade, ou
   se o usuario confirmar a continuacao, apaga os pre-vouchers pendentes da
   competencia, gera os novos, carrega a grade e abre o dialogo para salvar
   o PDF resumido em A4 paisagem (`relatorio_previa_AAAAMMDD.pdf`).
6. Clique em **Emissao de Voucher** para gerar o modelo financeiro baseado no
   ReportBuilder Delphi, em A4 retrato (`VoucherVR_AAAAMMDD.pdf`). E
   necessario ter gerado a previa antes.
7. Opcionalmente clique em **Exportar relatorio CSV**
   (`relatorio_comissoes_vr.csv`).

Apos gerar cada PDF, o sistema pergunta se deseja abrir o arquivo.

Quando somente a competencia for informada, o relatorio e a emissao de voucher
serao gerados em lote, em ordem alfabetica de administradora.

A competencia e enviada ao Firebird como tipo `DATE`, no formato visual
brasileiro `dd/mm/yyyy`.

### Varredura de creditos em duplicidade

Antes de gerar os pre-vouchers, o sistema pesquisa `IMPORTA_VR` na
competencia informada, para a administradora selecionada ou para todas
quando o campo estiver vazio.

Dois registros sao considerados duplicados quando **todas** as colunas sao
identicas, exceto `CNT_IMPORTA`, `DT_IMPORTACAO` e `CONTADOR`. Registros com
`STATUS = 'C'` nao participam da comparacao. A lista de colunas comparadas
fica na constante `DUPLICATE_COLUMNS` de `relatorio_comissoes.py`.

Quando ha duplicidade, e exibido um alerta com, para cada administradora,
o nome, a vigencia e a quantidade de registros duplicados (linhas alem da
primeira de cada grupo) e de grupos, seguido da pergunta
**"Anular essas duplicidades temporariamente para emissao dos Recibos?"**:

- **Sim**: os registros duplicados recebem `STATUS = 'D'` e a previa e
  gerada em seguida. Em cada grupo, apenas o registro importado mais
  recentemente permanece com `STATUS = 'A'` (maior `DT_IMPORTACAO`; em
  empate, maior `CNT_IMPORTA`; em novo empate, maior `CONTADOR`).
- **Nao**: a previa e gerada com os duplicados incluidos no calculo.
- **Cancelar**: nada e gravado nem gerado.

Registros com `STATUS = 'D'` sao ignorados pelo calculo da comissao, pela
grade, pelo voucher e por novas varreduras, da mesma forma que os
cancelados (`C`). A anulacao nao apaga nada; para reverter, basta voltar o
status para `A`:

```sql
UPDATE IMPORTA_VR SET STATUS = 'A'
WHERE STATUS = 'D' AND DT_INI_USO = '2026-10-01' /* AND ADMINISTRADORA = '...' */
```

## Regra de calculo

Os dados sao obtidos de `IMPORTA_VR` e relacionados com:

- `NOMES_PRODUTOS_VR`
- `TAB_COMISSAO_ADM_VR`
- `PESSOAS`

Somente registros da competencia selecionada (`DT_INI_USO`) e com status
diferente de `C` participam do calculo. Os beneficios sao agrupados por
administradora, produto e regra de comissao antes do calculo.

### Comissao sobre a tarifa

Quando `SOBRE_TAXA = 'N'`:

```text
base = soma(TARIFA)
comissao_bruta = base * PERC_COM / 100
```

### Comissao sobre a taxa

Quando `SOBRE_TAXA = 'S'`:

```text
valor_taxa = soma(TARIFA * TAXA / 100)
comissao_bruta = valor_taxa * PERC_COM / 100
```

### Desconto

```text
desconto = comissao_bruta * PERC_DESC / 100
comissao_final = comissao_bruta - desconto
```

Desconto vazio, `0` ou `0,00` e aceito e representa zero.

### Condicao com taxa

Quando `APENAS_COND_TAXA = 'S'`, somente linhas de `IMPORTA_VR` com:

```text
TAXA > 0
```

participam do calculo.

### Valores gravados no pre-voucher

```text
VALOR_BRUTO    = base usada no calculo (tarifa ou taxa)
VALOR_TOT_TAXA = soma(TARIFA * TAXA / 100)
VALOR_COM      = comissao_final
```

## Organizacao do relatorio

O relatorio e agrupado em dois niveis:

1. Administradora.
2. Produtor.

Para cada produtor sao exibidos:

- Produtos calculados.
- Percentual de comissao e de desconto.
- Valor de carga.
- Valor das taxas.
- Valor da comissao.
- Quantidade de beneficios.
- Totalizador do produtor.

O PDF mostra o totalizador em negrito, com valor monetario no formato:

```text
Total do produtor: Nome - 8 beneficios - R$ 1.234,50
```

## Emissao de voucher

O voucher replica o modelo `Delphi/VoucherVR.pdf`:

- Uma pagina por administradora, em A4 retrato.
- Numero do voucher obtido do gerador `NUMERO_VOUCHER_VR` a cada pagina.
  Esse numero e apenas impresso; os registros continuam com
  `NUM_RECIBO = 0`.
- Bloco **AUTORIZACAO PARA PAGAMENTO** com favorecido, CPF/CNPJ formatado,
  opcao pelo Simples, banco, agencia e conta corrente. Esses dados vem de
  `PESSOAS` (`CPF_CNPJ`, `OPTOU_SIMPLES`, `BANCO`, `AGENCIA`, `CONTA`) e
  de `BANCOS` (`NOME_BANCO`). O favorecido e o produtor do primeiro
  registro da administradora.
- Tabela de produtos com valor de carga, valor da taxa, percentual de
  repasse e repasse, com linha de total.
- Bloco **RECIBO DE PAGAMENTO** com valor bruto, estorno, ISS, IR, COFINS,
  CSLL, PIS e valor total. Os tributos sao impressos com valor zero, e o
  valor total permanece igual ao bruto ate que as regras de retencao sejam
  definidas.
- Aviso de que a impressao nao e valida como documento fiscal.

## Observacao sobre nomes de produtos

O relacionamento atual depende da correspondencia entre
`IMPORTA_VR.PRODUTO` e `NOMES_PRODUTOS_VR.NOME_PRODUTO`.

Se a importacao usar nomes diferentes, por exemplo:

```text
IMPORTA_VR: ALIMENTACAO
NOMES_PRODUTOS_VR: Auxilio Alimentacao
```

o produto nao sera relacionado automaticamente e nenhuma regra de comissao
sera encontrada para ele.

Nesse caso, deve ser criado um mapeamento de produtos ou padronizada a origem
dos nomes antes da geracao do voucher.

## Seguranca e transacoes

- As consultas usam parametros para valores fornecidos pela interface.
- Inclusoes, alteracoes e cancelamentos usam `commit` e `rollback`.
- O cancelamento de uma regra e logico; o registro nao e apagado.
- O cancelamento pede confirmacao ao usuario.
- Credenciais do banco devem permanecer somente no `.env`.
- O PDF e o CSV sao gerados no caminho escolhido pelo usuario.

## Validacao

Durante o desenvolvimento foram validados:

- Importacao do driver Firebird.
- Conexao com o banco configurado.
- Leitura de `PESSOAS`.
- Leitura de `APOLICES`.
- Leitura de `NOMES_PRODUTOS_VR`.
- Leitura e gravacao de `TAB_COMISSAO_ADM_VR`.
- Consulta de `IMPORTA_VR`.
- Gravacao de `RECIBOS_COMISSAO_VR`.
- Sintaxe e diagnosticos dos modulos Python.
- Geracao de PDF de previa e de voucher com `reportlab`.
