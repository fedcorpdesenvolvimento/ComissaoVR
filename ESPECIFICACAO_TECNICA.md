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
- Emissao definitiva de recibos oficiais.
- Integracao bancaria.
- Controle de usuarios e permissoes.
- Servico web ou API externa.

O formulario Delphi possui um botao para vouchers oficiais, mas a rotina
correspondente nao esta implementada no arquivo Pascal analisado. Por isso,
esta especificacao trata apenas da previa.

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
            +-- Grade, PDF e CSV
    |
    +-- database.py
            |
            +-- Leitura do .env
            +-- Conexao Firebird
```

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

- Implementar a tela equivalente ao formulario `cad_comissao_prod_vr`.
- Consultar administradoras em `APOLICES` e `PESSOAS`.
- Consultar produtores pelos campos `FAVOR` e `FAVOR2`.
- Consultar produtos em `NOMES_PRODUTOS_VR`.
- Evitar produtos duplicados para o produtor.
- Manter as regras em `TAB_COMISSAO_ADM_VR`.

### 5.4 `relatorio_comissoes.py`

Responsabilidades:

- Implementar a tela equivalente ao formulario `rel_com_vr_automatico`.
- Selecionar administradora, produtor e vigencia.
- Consultar beneficios em `IMPORTA_VR`.
- Aplicar as regras ativas.
- Criar pre-vouchers.
- Exibir agrupamentos e totalizadores.
- Gerar PDF e CSV.

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
- Dados bancarios no relatorio legado.

Uso:

- Resolver o nome da administradora.
- Resolver o nome do produtor.
- Obter o codigo interno da pessoa.

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

## 9. Fluxo do cadastro de comissoes

### 9.1 Novo cadastro

1. Usuario clica em **Novo**.
2. A tela habilita os campos.
3. Administradora e carregada pela apolice VR ativa.
4. O codigo da administradora e obtido em `PESSOAS`.
5. `FAVOR` e `FAVOR2` sao consultados em `APOLICES`.
6. Os produtores ativos sao carregados em `PESSOAS`.
7. Os produtos disponiveis sao carregados em `NOMES_PRODUTOS_VR`.
8. Contas ja cadastradas para o produtor sao excluidas da lista.
9. Usuario informa percentuais e flags.
10. O registro e inserido em `TAB_COMISSAO_ADM_VR`.

### 9.2 Alteracao

1. Usuario seleciona uma linha da grade.
2. O sistema recupera o controle do registro.
3. Administradora, produtor e produto ficam bloqueados.
4. Percentual, desconto e flags ficam editaveis.
5. O registro e atualizado pelo campo `CONTROLE`.

### 9.3 Cancelamento

O cancelamento nao exclui fisicamente o registro:

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
4. Seleciona a competencia no calendario.
5. O sistema converte a competencia para `datetime.date`.
6. Pre-vouchers pendentes da mesma competencia sao removidos para evitar
   duplicidade.
7. Os registros de `IMPORTA_VR` sao selecionados.
8. Os produtos sao relacionados com `NOMES_PRODUTOS_VR`.
9. As regras ativas sao relacionadas com `TAB_COMISSAO_ADM_VR`.
10. Os beneficios sao agrupados por administradora, produto e produtor.
11. A comissao e calculada.
12. O resultado e gravado em `RECIBOS_COMISSAO_VR`.
13. A transacao e confirmada.
14. A grade e atualizada.
15. O usuario pode salvar o **Relatorio de Previa**, em A4 paisagem.
16. O usuario pode emitir separadamente o **Voucher**, em A4 retrato,
    usando o modelo visual do ReportBuilder Delphi.

Quando somente a data de inicio de vigencia estiver preenchida, a consulta
processa o lote completo e ordena as administradoras alfabeticamente. O mesmo
lote e utilizado para a emissao dos vouchers.

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

Replica o modelo `VoucherVR.pdf` do ReportBuilder Delphi:

- Utiliza formato retrato A4.
- Gera uma pagina por administradora.
- Contem os blocos **RECIBO DE PAGAMENTO** e
  **AUTORIZACAO PARA PAGAMENTO**.
- Apresenta favorecido, documento, opcao pelo Simples, banco, agencia e
  conta corrente quando esses dados estiverem disponiveis.
- Exibe produtos, valor de carga, valor da taxa, percentual de repasse e
  repasse.
- No recibo, o valor bruto e o valor total permanecem iguais ao total do
  repasse enquanto as regras de retencao tributaria nao forem definidas.
- Exibe os tributos do recibo com valor zero, conforme o modelo original.
- Usa formato monetario brasileiro e o aviso de que a impressao nao e
  documento fiscal.

### 12.4 CSV

O CSV:

- Usa codificacao UTF-8 com BOM.
- Usa `;` como separador.
- Inclui cabecalho.
- Inclui detalhes, agrupamentos e totalizadores.

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
4. Implementar vouchers oficiais.
5. Implementar controle de usuarios.
6. Registrar usuario responsavel pela geracao.
7. Adicionar testes automatizados para as formulas.
8. Adicionar log de processamento.
9. Adicionar identificador de lote para cada geracao.
10. Adicionar validacao de competencia com lista de datas disponiveis.
