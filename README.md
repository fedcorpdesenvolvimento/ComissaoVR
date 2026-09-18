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

- Selecionar administradora de apolices VR.
- Selecionar produtor relacionado a `FAVOR` ou `FAVOR2` da apolice.
- Selecionar produtos ainda nao cadastrados para o produtor.
- Informar percentual de comissao.
- Informar percentual de desconto, inclusive zero ou vazio.
- Definir:
  - `SOBRE_TAXA`
  - `APENAS_COND_TAXA`
- Consultar comissoes ja cadastradas para a administradora.
- Alterar uma comissao existente.
- Cancelar uma comissao logicamente usando `STATUS = 'C'`.

As regras sao gravadas na tabela `TAB_COMISSAO_ADM_VR`.

### Relatorio de comissoes automaticas

Disponivel no menu **Operacoes > Relatorio de comissoes**.

Permite:

- Selecionar administradora.
- Selecionar produtor.
- Selecionar a competencia usando um calendario.
- Gerar os pre-vouchers.
- Visualizar os registros calculados na grade.
- Gerar um PDF formatado.
- Exportar os dados para CSV.

Os pre-vouchers sao gravados em `RECIBOS_COMISSAO_VR` com:

```text
NUM_RECIBO = 0
STATUS = 'A'
```

## Estrutura do projeto

```text
.
|-- app.py
|-- database.py
|-- cadastro_comissao.py
|-- relatorio_comissoes.py
|-- .env
|-- Delphi
|   |-- cad_comissao_prod_vr.pas
|   |-- cad_comissao_prod_vr.dfm
|   |-- rel_com_vr_automatico.pas
|   `-- rel_com_vr_automatico.dfm
`-- README.md
```

### `app.py`

Janela principal e menu da aplicacao.

### `database.py`

Carrega o arquivo `.env` e abre a conexao com o Firebird usando
`firebird-driver`.

### `cadastro_comissao.py`

Implementa a tela de cadastro e as operacoes de inclusao, alteracao,
cancelamento e consulta.

### `relatorio_comissoes.py`

Implementa a consulta da competencia, o calculo da comissao, a gravacao dos
pre-vouchers, a grade, o PDF e o CSV.

## Requisitos

- Windows.
- Python 3.10 ou superior.
- Acesso de rede ao servidor Firebird.
- Banco Firebird acessivel pelas credenciais do `.env`.

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
publicamente.

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

O produto ja cadastrado para o produtor e ignorado pela lista de novos
produtos quando existe registro ativo em `TAB_COMISSAO_ADM_VR`.

## Fluxo do relatorio

1. Abra **Relatorio de comissoes**.
2. Selecione a administradora.
3. Opcionalmente selecione o produtor.
4. Escolha a competencia no calendario.
5. Clique em **Relatorio de Previa** para gerar o relatorio resumido em
   formato A4 paisagem.
6. Escolha o local do PDF.
7. Clique em **Emissao de Voucher** para gerar o modelo financeiro baseado no
   ReportBuilder Delphi, em formato A4 retrato.
8. Opcionalmente exporte tambem o CSV.

A competencia e enviada ao Firebird como tipo `DATE`, no formato visual
brasileiro `dd/mm/yyyy`.

## Regra de calculo

Os dados sao obtidos de `IMPORTA_VR` e relacionados com:

- `NOMES_PRODUTOS_VR`
- `TAB_COMISSAO_ADM_VR`
- `PESSOAS`

Somente registros da competencia selecionada e com status diferente de `C`
participam do calculo.

### Comissao sobre a tarifa

Quando `SOBRE_TAXA = 'N'`:

```text
base = TARIFA
comissao_bruta = base * PERC_COM / 100
```

### Comissao sobre a taxa

Quando `SOBRE_TAXA = 'S'`:

```text
valor_taxa = TARIFA * TAXA / 100
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

## Organizacao do relatorio

O relatorio e agrupado em dois niveis:

1. Administradora.
2. Produtor.

Para cada produtor sao exibidos:

- Produtos calculados.
- Percentual de comissao.
- Valor de carga.
- Valor das taxas.
- Valor da comissao.
- Quantidade de beneficios.
- Totalizador do produtor.

O PDF mostra o totalizador em negrito, com valor monetario no formato:

```text
Total do produtor: Nome - 8 beneficios - R$ 1.234,50
```

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
- Geracao de PDF com `reportlab`.
