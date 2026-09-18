object frm_cad_comissao_prod_vr: Tfrm_cad_comissao_prod_vr
  Left = 192
  Top = 107
  Width = 666
  Height = 532
  Caption = 'Cadastro de Comiss'#245'es de VR'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 8
    Top = 3
    Width = 633
    Height = 54
    TabOrder = 0
    object Button2: TButton
      Left = 506
      Top = 14
      Width = 107
      Height = 25
      Caption = '&Sair'
      TabOrder = 3
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 19
      Top = 14
      Width = 107
      Height = 25
      Caption = '&Novo'
      TabOrder = 0
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 140
      Top = 14
      Width = 107
      Height = 25
      Caption = '&Alterar'
      Enabled = False
      TabOrder = 1
      OnClick = Button4Click
    end
    object Button6: TButton
      Left = 384
      Top = 14
      Width = 107
      Height = 25
      Caption = '&Limpa'
      TabOrder = 2
      OnClick = Button6Click
    end
    object Button5: TButton
      Left = 262
      Top = 14
      Width = 107
      Height = 25
      Caption = '&Excluir/Canc.'
      Enabled = False
      TabOrder = 4
      OnClick = Button5Click
    end
  end
  object Panel1: TPanel
    Left = 8
    Top = 58
    Width = 633
    Height = 89
    Enabled = False
    TabOrder = 1
    object Label1: TLabel
      Left = 39
      Top = 13
      Width = 38
      Height = 13
      Caption = 'Apolice:'
    end
    object Label2: TLabel
      Left = 8
      Top = 37
      Width = 69
      Height = 13
      Caption = 'Administradora'
    end
    object Label3: TLabel
      Left = 34
      Top = 61
      Width = 43
      Height = 13
      Caption = 'Produtor:'
    end
    object SpeedButton1: TSpeedButton
      Left = 539
      Top = 34
      Width = 23
      Height = 22
      Caption = 'Ap.'
      OnClick = SpeedButton1Click
    end
    object ComboBox1: TComboBox
      Left = 80
      Top = 9
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnExit = ComboBox1Exit
    end
    object ComboBox2: TComboBox
      Left = 80
      Top = 33
      Width = 457
      Height = 21
      CharCase = ecUpperCase
      ItemHeight = 13
      TabOrder = 1
      OnExit = ComboBox2Exit
    end
    object ComboBox3: TComboBox
      Left = 80
      Top = 57
      Width = 457
      Height = 21
      CharCase = ecUpperCase
      ItemHeight = 13
      TabOrder = 2
      OnExit = ComboBox3Exit
    end
    object Edit2: TEdit
      Left = 568
      Top = 0
      Width = 57
      Height = 21
      TabOrder = 3
      Text = 'Edit2'
      Visible = False
    end
    object Edit3: TEdit
      Left = 567
      Top = 21
      Width = 57
      Height = 21
      TabOrder = 4
      Text = 'Edit3'
      Visible = False
    end
    object Edit1: TEdit
      Left = 504
      Top = 0
      Width = 57
      Height = 21
      TabOrder = 5
      Text = 'Edit1'
      Visible = False
    end
    object Edit4: TEdit
      Left = 567
      Top = 40
      Width = 57
      Height = 21
      TabOrder = 6
      Text = 'Edit4'
      Visible = False
    end
  end
  object Panel2: TPanel
    Left = 8
    Top = 148
    Width = 633
    Height = 37
    Enabled = False
    TabOrder = 2
    object CheckBox1: TCheckBox
      Left = 8
      Top = 8
      Width = 273
      Height = 17
      Caption = 'Calcula Comiss'#227'o somentes em Cond. com Taxas'
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Left = 276
      Top = 8
      Width = 193
      Height = 17
      Caption = 'Calcula Comiss'#227'o sobre as TAXAS'
      TabOrder = 1
    end
  end
  object Panel4: TPanel
    Left = 8
    Top = 253
    Width = 633
    Height = 228
    Enabled = False
    TabOrder = 3
    object DBGrid1: TDBGrid
      Left = 16
      Top = 16
      Width = 601
      Height = 193
      DataSource = DataSource1
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnCellClick = DBGrid1CellClick
      Columns = <
        item
          Expanded = False
          FieldName = 'CONTA'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOME_PRODUTO'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PERC_COM'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PERC_DESC'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOME'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PRODUTOR'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CONTROLE'
          Visible = True
        end>
    end
  end
  object Panel5: TPanel
    Left = 8
    Top = 186
    Width = 633
    Height = 65
    TabOrder = 4
    object Label6: TLabel
      Left = 26
      Top = 12
      Width = 40
      Height = 13
      Caption = 'Produto:'
    end
    object Label4: TLabel
      Left = 18
      Top = 40
      Width = 48
      Height = 13
      Caption = 'Comiss'#227'o:'
    end
    object Label5: TLabel
      Left = 159
      Top = 40
      Width = 49
      Height = 13
      Caption = 'Desconto:'
    end
    object ComboBox4: TComboBox
      Left = 72
      Top = 8
      Width = 497
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnExit = ComboBox4Exit
    end
    object CurrencyEdit1: TCurrencyEdit
      Left = 72
      Top = 36
      Width = 73
      Height = 21
      AutoSize = False
      DisplayFormat = ',0.00%;- ,0.00%'
      TabOrder = 1
    end
    object CurrencyEdit2: TCurrencyEdit
      Left = 214
      Top = 36
      Width = 73
      Height = 21
      AutoSize = False
      DisplayFormat = ',0.00%;- ,0.00%'
      TabOrder = 2
    end
    object Button1: TButton
      Left = 312
      Top = 34
      Width = 75
      Height = 25
      Caption = 'A&plica'
      TabOrder = 3
      OnClick = Button1Click
    end
    object BitBtn1: TBitBtn
      Left = 569
      Top = 8
      Width = 59
      Height = 20
      Caption = 'Limpa'
      TabOrder = 4
      OnClick = BitBtn1Click
    end
    object Edit5: TEdit
      Left = 567
      Top = 40
      Width = 57
      Height = 21
      TabOrder = 5
      Text = 'Edit5'
      Visible = False
    end
  end
  object SQLQuery1: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = DataModule1.SQLCON_FAT
    Left = 504
    Top = 66
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = SQLQuery2
    Left = 432
    Top = 285
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider1'
    Left = 464
    Top = 285
    object ClientDataSet1CONTA: TIntegerField
      FieldName = 'CONTA'
      Required = True
    end
    object ClientDataSet1NOME_PRODUTO: TStringField
      FieldName = 'NOME_PRODUTO'
    end
    object ClientDataSet1PERC_COM: TBCDField
      FieldName = 'PERC_COM'
      Precision = 9
      Size = 2
    end
    object ClientDataSet1PERC_DESC: TBCDField
      FieldName = 'PERC_DESC'
      Precision = 9
      Size = 2
    end
    object ClientDataSet1PRODUTOR: TStringField
      FieldName = 'PRODUTOR'
      Size = 10
    end
    object ClientDataSet1NOME: TStringField
      FieldName = 'NOME'
      Size = 50
    end
    object ClientDataSet1CONTROLE: TIntegerField
      FieldName = 'CONTROLE'
    end
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 496
    Top = 285
  end
  object SQLQuery2: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT NPV.conta,NPV.nome_produto,TCA.perc_com,TCA.perc_desc,'
      'tca.produtor,pes.nome,TCA.controle'
      'FROM nomes_produtos_vr NPV LEFT JOIN tab_comissao_adm_vr TCA'
      
        '                            left join pessoas pes on pes.pessoa=' +
        'tca.produtor'
      ' ON TCA.conta=NPV.conta'
      'where tca.status = '#39'A'#39
      '  and npv.status = '#39'A'#39
      'order by tca.produtor,npv.conta'
      '')
    SQLConnection = DataModule1.SQLCON_FAT
    Left = 400
    Top = 285
  end
end
