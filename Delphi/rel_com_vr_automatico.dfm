object frm_rel_com_vr_automatico: Tfrm_rel_com_vr_automatico
  Left = 204
  Top = 137
  Width = 659
  Height = 382
  Caption = 'Gera'#231#227'o de Comiss'#227'o Autom'#225'tica'
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
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 617
    Height = 105
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 12
      Width = 72
      Height = 13
      Caption = 'Administradora:'
    end
    object Label2: TLabel
      Left = 45
      Top = 37
      Width = 43
      Height = 13
      Caption = 'Produtor:'
    end
    object Label3: TLabel
      Left = 48
      Top = 60
      Width = 44
      Height = 13
      Caption = 'Vigencia:'
    end
    object ComboBox1: TComboBox
      Left = 96
      Top = 8
      Width = 497
      Height = 21
      CharCase = ecUpperCase
      ItemHeight = 13
      TabOrder = 0
    end
    object ComboBox2: TComboBox
      Left = 96
      Top = 33
      Width = 497
      Height = 21
      CharCase = ecUpperCase
      ItemHeight = 13
      TabOrder = 1
    end
    object DateEdit1: TDateEdit
      Left = 96
      Top = 56
      Width = 121
      Height = 21
      NumGlyphs = 2
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 8
    Top = 120
    Width = 617
    Height = 57
    TabOrder = 1
    object Button1: TButton
      Left = 24
      Top = 16
      Width = 185
      Height = 25
      Caption = 'Vouchers de &Pr'#233'via de Comiss'#227'o'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 224
      Top = 16
      Width = 185
      Height = 25
      Caption = 'Vouchers &Oficiais de Comiss'#227'o'
      TabOrder = 1
    end
    object Button3: TButton
      Left = 432
      Top = 16
      Width = 75
      Height = 25
      Caption = '&Limpa'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 520
      Top = 16
      Width = 75
      Height = 25
      Caption = '&Sair'
      TabOrder = 3
      OnClick = Button4Click
    end
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 184
    Width = 617
    Height = 153
    DataSource = DataSource1
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'CONTROLE_REC'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NUM_RECIBO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DT_EMI_RECIBO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'INI_VIGENCIA'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ADMINISTRADORA'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PRODUTOR'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CONTA'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PERC_COM'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DESC_COM'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VALOR_BRUTO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VALOR_COM'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'USU_EMI_RECIBO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'STATUS'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOME_PRODUTO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOME_ADM'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOME_PRODUTOR'
        Visible = True
      end>
  end
  object SQLQuery1: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = DataModule1.SQLCON_FAT
    Left = 288
    Top = 80
  end
  object SQLQuery2: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = DataModule1.SQLCON_FAT
    Left = 320
    Top = 80
  end
  object SQLQuery3: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = DataModule1.SQLCON_FAT
    Left = 352
    Top = 80
  end
  object SQLQuery4: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = DataModule1.SQLCON_FAT
    Left = 384
    Top = 80
  end
  object SQLQuery5: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      
        'SELECT RCV.controle_rec,rcv.num_recibo,rcv.dt_emi_recibo,rcv.ini' +
        '_vigencia,'
      
        '       rcv.administradora,rcv.produtor,rcv.conta,rcv.perc_com,rc' +
        'v.desc_com,'
      
        '       rcv.valor_bruto,rcv.valor_tot_taxa,rcv.valor_com,rcv.usu_' +
        'emi_recibo,rcv.status,'
      '       NPV.nome_produto,'
      
        '       (SELECT PES.NOME FROM PESSOAS PES WHERE PES.pessoa=RCV.ad' +
        'ministradora) NOME_ADM,'
      '       PP.NOME NOME_PRODUTOR,PP.cpf_cnpj DOC_PRODUTOR,'
      
        '       PP.optou_simples,BAN.nome_banco,PP.BANCO,PP.AGENCIA,PP.co' +
        'nta CONTA_CORRENTE,'
      
        '       APO.cedente,(SELECT CC.cedente FROM cedente CC WHERE CC.c' +
        'odigo=APO.cedente) NOME_CEDENTE,'
      
        '       (SELECT CC.cnpj FROM cedente CC WHERE CC.codigo=APO.ceden' +
        'te) CNPJ_CEDENTE'
      
        'FROM recibos_comissao_vr RCV LEFT JOIN nomes_produtos_vr NPV ON ' +
        'NPV.conta=RCV.conta'
      
        '                             LEFT JOIN PESSOAS PP ON PP.pessoa=R' +
        'CV.produtor'
      
        '                             LEFT JOIN BANCOS BAN ON BAN.cod_ban' +
        'co=PP.banco'
      
        '                             left join apolices apo on apo.apoli' +
        'ce = '#39'VR0001'#39' AND APO.administradora=rcv.administradora'
      'WHERE RCV.ini_vigencia = '#39'06/01/2025'#39
      'AND RCV.status ='#39'A'#39)
    SQLConnection = DataModule1.SQLCON_FAT
    Left = 488
    Top = 80
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = SQLQuery5
    Left = 520
    Top = 80
  end
  object ClientDataSet1: TClientDataSet
    Active = True
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider1'
    Left = 552
    Top = 80
    object ClientDataSet1CONTROLE_REC: TIntegerField
      FieldName = 'CONTROLE_REC'
      Required = True
    end
    object ClientDataSet1NUM_RECIBO: TIntegerField
      FieldName = 'NUM_RECIBO'
    end
    object ClientDataSet1DT_EMI_RECIBO: TDateField
      FieldName = 'DT_EMI_RECIBO'
    end
    object ClientDataSet1INI_VIGENCIA: TDateField
      FieldName = 'INI_VIGENCIA'
    end
    object ClientDataSet1ADMINISTRADORA: TStringField
      FieldName = 'ADMINISTRADORA'
      Size = 10
    end
    object ClientDataSet1PRODUTOR: TStringField
      FieldName = 'PRODUTOR'
      Size = 10
    end
    object ClientDataSet1CONTA: TIntegerField
      FieldName = 'CONTA'
    end
    object ClientDataSet1PERC_COM: TBCDField
      FieldName = 'PERC_COM'
      Precision = 9
      Size = 2
    end
    object ClientDataSet1DESC_COM: TBCDField
      FieldName = 'DESC_COM'
      Precision = 9
      Size = 2
    end
    object ClientDataSet1VALOR_BRUTO: TFMTBCDField
      FieldName = 'VALOR_BRUTO'
      Precision = 15
      Size = 2
    end
    object ClientDataSet1VALOR_COM: TFMTBCDField
      FieldName = 'VALOR_COM'
      Precision = 15
      Size = 2
    end
    object ClientDataSet1USU_EMI_RECIBO: TStringField
      FieldName = 'USU_EMI_RECIBO'
    end
    object ClientDataSet1STATUS: TStringField
      FieldName = 'STATUS'
      Size = 1
    end
    object ClientDataSet1NOME_PRODUTO: TStringField
      FieldName = 'NOME_PRODUTO'
    end
    object ClientDataSet1NOME_ADM: TStringField
      FieldName = 'NOME_ADM'
      Size = 50
    end
    object ClientDataSet1NOME_PRODUTOR: TStringField
      FieldName = 'NOME_PRODUTOR'
      Size = 50
    end
    object ClientDataSet1VALOR_TOT_TAXA: TFMTBCDField
      FieldName = 'VALOR_TOT_TAXA'
      Precision = 15
      Size = 2
    end
    object ClientDataSet1DOC_PRODUTOR: TStringField
      FieldName = 'DOC_PRODUTOR'
      Size = 14
    end
    object ClientDataSet1OPTOU_SIMPLES: TStringField
      FieldName = 'OPTOU_SIMPLES'
      Size = 1
    end
    object ClientDataSet1NOME_BANCO: TStringField
      FieldName = 'NOME_BANCO'
      Size = 100
    end
    object ClientDataSet1BANCO: TStringField
      FieldName = 'BANCO'
      Size = 4
    end
    object ClientDataSet1AGENCIA: TStringField
      FieldName = 'AGENCIA'
      Size = 10
    end
    object ClientDataSet1CONTA_CORRENTE: TStringField
      FieldName = 'CONTA_CORRENTE'
    end
    object ClientDataSet1CEDENTE: TStringField
      FieldName = 'CEDENTE'
      Size = 2
    end
    object ClientDataSet1NOME_CEDENTE: TStringField
      FieldName = 'NOME_CEDENTE'
      Size = 50
    end
    object ClientDataSet1CNPJ_CEDENTE: TStringField
      FieldName = 'CNPJ_CEDENTE'
      Size = 14
    end
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 584
    Top = 80
  end
  object ppDBPipeline1: TppDBPipeline
    DataSource = DataSource1
    UserName = 'DBPipeline1'
    Left = 520
    Top = 112
    object ppDBPipeline1ppField1: TppField
      Alignment = taRightJustify
      FieldAlias = 'CONTROLE_REC'
      FieldName = 'CONTROLE_REC'
      FieldLength = 0
      DataType = dtInteger
      DisplayWidth = 0
      Position = 0
    end
    object ppDBPipeline1ppField2: TppField
      Alignment = taRightJustify
      FieldAlias = 'NUM_RECIBO'
      FieldName = 'NUM_RECIBO'
      FieldLength = 0
      DataType = dtInteger
      DisplayWidth = 10
      Position = 1
    end
    object ppDBPipeline1ppField3: TppField
      FieldAlias = 'DT_EMI_RECIBO'
      FieldName = 'DT_EMI_RECIBO'
      FieldLength = 0
      DataType = dtDate
      DisplayWidth = 10
      Position = 2
    end
    object ppDBPipeline1ppField4: TppField
      FieldAlias = 'INI_VIGENCIA'
      FieldName = 'INI_VIGENCIA'
      FieldLength = 0
      DataType = dtDate
      DisplayWidth = 10
      Position = 3
    end
    object ppDBPipeline1ppField5: TppField
      FieldAlias = 'ADMINISTRADORA'
      FieldName = 'ADMINISTRADORA'
      FieldLength = 10
      DisplayWidth = 10
      Position = 4
    end
    object ppDBPipeline1ppField6: TppField
      FieldAlias = 'PRODUTOR'
      FieldName = 'PRODUTOR'
      FieldLength = 10
      DisplayWidth = 10
      Position = 5
    end
    object ppDBPipeline1ppField7: TppField
      Alignment = taRightJustify
      FieldAlias = 'CONTA'
      FieldName = 'CONTA'
      FieldLength = 0
      DataType = dtInteger
      DisplayWidth = 10
      Position = 6
    end
    object ppDBPipeline1ppField8: TppField
      Alignment = taRightJustify
      FieldAlias = 'PERC_COM'
      FieldName = 'PERC_COM'
      FieldLength = 2
      DataType = dtDouble
      DisplayWidth = 10
      Position = 7
    end
    object ppDBPipeline1ppField9: TppField
      Alignment = taRightJustify
      FieldAlias = 'DESC_COM'
      FieldName = 'DESC_COM'
      FieldLength = 2
      DataType = dtDouble
      DisplayWidth = 10
      Position = 8
    end
    object ppDBPipeline1ppField10: TppField
      Alignment = taRightJustify
      FieldAlias = 'VALOR_BRUTO'
      FieldName = 'VALOR_BRUTO'
      FieldLength = 2
      DataType = dtDouble
      DisplayWidth = 16
      Position = 9
    end
    object ppDBPipeline1ppField11: TppField
      Alignment = taRightJustify
      FieldAlias = 'VALOR_COM'
      FieldName = 'VALOR_COM'
      FieldLength = 2
      DataType = dtDouble
      DisplayWidth = 16
      Position = 10
    end
    object ppDBPipeline1ppField12: TppField
      FieldAlias = 'USU_EMI_RECIBO'
      FieldName = 'USU_EMI_RECIBO'
      FieldLength = 20
      DisplayWidth = 20
      Position = 11
    end
    object ppDBPipeline1ppField13: TppField
      FieldAlias = 'STATUS'
      FieldName = 'STATUS'
      FieldLength = 1
      DisplayWidth = 1
      Position = 12
    end
    object ppDBPipeline1ppField14: TppField
      FieldAlias = 'NOME_PRODUTO'
      FieldName = 'NOME_PRODUTO'
      FieldLength = 20
      DisplayWidth = 20
      Position = 13
    end
    object ppDBPipeline1ppField15: TppField
      FieldAlias = 'NOME_ADM'
      FieldName = 'NOME_ADM'
      FieldLength = 50
      DisplayWidth = 50
      Position = 14
    end
    object ppDBPipeline1ppField16: TppField
      FieldAlias = 'NOME_PRODUTOR'
      FieldName = 'NOME_PRODUTOR'
      FieldLength = 50
      DisplayWidth = 50
      Position = 15
    end
    object ppDBPipeline1ppField17: TppField
      Alignment = taRightJustify
      FieldAlias = 'VALOR_TOT_TAXA'
      FieldName = 'VALOR_TOT_TAXA'
      FieldLength = 2
      DataType = dtDouble
      DisplayWidth = 16
      Position = 16
    end
    object ppDBPipeline1ppField18: TppField
      FieldAlias = 'DOC_PRODUTOR'
      FieldName = 'DOC_PRODUTOR'
      FieldLength = 14
      DisplayWidth = 14
      Position = 17
    end
    object ppDBPipeline1ppField19: TppField
      FieldAlias = 'OPTOU_SIMPLES'
      FieldName = 'OPTOU_SIMPLES'
      FieldLength = 1
      DisplayWidth = 1
      Position = 18
    end
    object ppDBPipeline1ppField20: TppField
      FieldAlias = 'NOME_BANCO'
      FieldName = 'NOME_BANCO'
      FieldLength = 100
      DisplayWidth = 100
      Position = 19
    end
    object ppDBPipeline1ppField21: TppField
      FieldAlias = 'BANCO'
      FieldName = 'BANCO'
      FieldLength = 4
      DisplayWidth = 4
      Position = 20
    end
    object ppDBPipeline1ppField22: TppField
      FieldAlias = 'AGENCIA'
      FieldName = 'AGENCIA'
      FieldLength = 10
      DisplayWidth = 10
      Position = 21
    end
    object ppDBPipeline1ppField23: TppField
      FieldAlias = 'CONTA_CORRENTE'
      FieldName = 'CONTA_CORRENTE'
      FieldLength = 20
      DisplayWidth = 20
      Position = 22
    end
    object ppDBPipeline1ppField24: TppField
      FieldAlias = 'CEDENTE'
      FieldName = 'CEDENTE'
      FieldLength = 2
      DisplayWidth = 2
      Position = 23
    end
    object ppDBPipeline1ppField25: TppField
      FieldAlias = 'NOME_CEDENTE'
      FieldName = 'NOME_CEDENTE'
      FieldLength = 50
      DisplayWidth = 50
      Position = 24
    end
    object ppDBPipeline1ppField26: TppField
      FieldAlias = 'CNPJ_CEDENTE'
      FieldName = 'CNPJ_CEDENTE'
      FieldLength = 14
      DisplayWidth = 14
      Position = 25
    end
  end
  object ppReport1: TppReport
    AutoStop = False
    DataPipeline = ppDBPipeline1
    PrinterSetup.BinName = 'Default'
    PrinterSetup.DocumentName = 'Report'
    PrinterSetup.PaperName = 'A4'
    PrinterSetup.PrinterName = 'Default'
    PrinterSetup.mmMarginBottom = 6350
    PrinterSetup.mmMarginLeft = 6350
    PrinterSetup.mmMarginRight = 6350
    PrinterSetup.mmMarginTop = 6350
    PrinterSetup.mmPaperHeight = 297000
    PrinterSetup.mmPaperWidth = 210000
    PrinterSetup.PaperSize = 9
    DeviceType = 'Screen'
    EmailSettings.ReportFormat = 'PDF'
    OutlineSettings.CreateNode = True
    OutlineSettings.CreatePageNodes = True
    OutlineSettings.Enabled = True
    OutlineSettings.Visible = True
    TextSearchSettings.DefaultString = '<FindText>'
    TextSearchSettings.Enabled = True
    Left = 552
    Top = 112
    Version = '10.09'
    mmColumnWidth = 0
    DataPipelineName = 'ppDBPipeline1'
    object ppHeaderBand1: TppHeaderBand
      mmBottomOffset = 0
      mmHeight = 0
      mmPrintPosition = 0
    end
    object ppDetailBand1: TppDetailBand
      mmBottomOffset = 0
      mmHeight = 7938
      mmPrintPosition = 0
      object ppShape3: TppShape
        UserName = 'Shape101'
        Brush.Color = clSkyBlue
        Pen.Color = clBlue
        Shape = stRoundRect
        mmHeight = 7938
        mmLeft = 5821
        mmTop = 0
        mmWidth = 185209
        BandType = 4
      end
      object ppDBText2: TppDBText
        UserName = 'DBText2'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        DataField = 'NOME_PRODUTO'
        DataPipeline = ppDBPipeline1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsBold]
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 4233
        mmLeft = 13758
        mmTop = 1588
        mmWidth = 55563
        BandType = 4
      end
      object ppDBText3: TppDBText
        UserName = 'DBText3'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        DataField = 'VALOR_BRUTO'
        DataPipeline = ppDBPipeline1
        DisplayFormat = '$#,0.00;($#,0.00)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 8
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 3440
        mmLeft = 82550
        mmTop = 2117
        mmWidth = 21696
        BandType = 4
      end
      object ppDBText4: TppDBText
        UserName = 'DBText4'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        DataField = 'VALOR_TOT_TAXA'
        DataPipeline = ppDBPipeline1
        DisplayFormat = '$#,0.00;($#,0.00)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 8
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 3440
        mmLeft = 113771
        mmTop = 2117
        mmWidth = 17198
        BandType = 4
      end
      object ppDBText5: TppDBText
        UserName = 'DBText5'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        DataField = 'PERC_COM'
        DataPipeline = ppDBPipeline1
        DisplayFormat = '0.00 %'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 8
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 3387
        mmLeft = 139965
        mmTop = 2117
        mmWidth = 17198
        BandType = 4
      end
      object ppDBText6: TppDBText
        UserName = 'DBText6'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        DataField = 'VALOR_COM'
        DataPipeline = ppDBPipeline1
        DisplayFormat = '$#,0.00;($#,0.00)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 8
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 3387
        mmLeft = 166688
        mmTop = 2117
        mmWidth = 17198
        BandType = 4
      end
    end
    object ppFooterBand1: TppFooterBand
      mmBottomOffset = 0
      mmHeight = 114829
      mmPrintPosition = 0
      object ppRegion1: TppRegion
        UserName = 'Region1'
        Brush.Style = bsClear
        Caption = 'Region1'
        Pen.Color = clInactiveCaption
        Transparent = True
        mmHeight = 100542
        mmLeft = 3440
        mmTop = 0
        mmWidth = 192617
        BandType = 8
        mmBottomOffset = 0
        mmOverFlowOffset = 0
        mmStopPosition = 0
        object ppShape11: TppShape
          UserName = 'Shape11'
          Brush.Color = clSkyBlue
          Pen.Color = clBlue
          mmHeight = 86784
          mmLeft = 7144
          mmTop = 12171
          mmWidth = 185209
          BandType = 8
        end
        object ppShape9: TppShape
          UserName = 'Shape9'
          Brush.Color = clSilver
          Pen.Color = clBlue
          Shape = stRoundRect
          mmHeight = 8202
          mmLeft = 157163
          mmTop = 89429
          mmWidth = 33338
          BandType = 8
        end
        object ppLabel27: TppLabel
          UserName = 'Label10'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'RECIBO DE PAGAMENTO'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 4233
          mmLeft = 79640
          mmTop = 7938
          mmWidth = 43127
          BandType = 8
        end
        object ppLabel28: TppLabel
          UserName = 'Label11'
          ReprintOnOverFlow = True
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'RECEBEMOS DE'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3440
          mmLeft = 13229
          mmTop = 14817
          mmWidth = 23019
          BandType = 8
        end
        object ppLine13: TppLine
          UserName = 'Line3'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Pen.Color = clBlue
          Weight = 0.750000000000000000
          mmHeight = 1323
          mmLeft = 8731
          mmTop = 20638
          mmWidth = 183621
          BandType = 8
        end
        object ppLine14: TppLine
          UserName = 'Line14'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Pen.Color = clBlue
          Weight = 0.750000000000000000
          mmHeight = 1323
          mmLeft = 8731
          mmTop = 26458
          mmWidth = 183621
          BandType = 8
        end
        object ppLine15: TppLine
          UserName = 'Line15'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Pen.Color = clBlue
          Weight = 0.750000000000000000
          mmHeight = 1323
          mmLeft = 8731
          mmTop = 34660
          mmWidth = 183621
          BandType = 8
        end
        object ppLabel33: TppLabel
          UserName = 'Label17'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'VALOR BRUTO'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3440
          mmLeft = 9790
          mmTop = 36513
          mmWidth = 20638
          BandType = 8
        end
        object ppLine16: TppLine
          UserName = 'Line4'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Weight = 0.750000000000000000
          mmHeight = 1588
          mmLeft = 41275
          mmTop = 39688
          mmWidth = 115623
          BandType = 8
        end
        object ppVariable8: TppVariable
          UserName = 'Variable8'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          BlankWhenZero = False
          CalcOrder = 8
          DataType = dtCurrency
          DisplayFormat = '$#,0.00;($#,0.00)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetType = veReportStart
          TextAlignment = taRightJustified
          Transparent = True
          mmHeight = 3440
          mmLeft = 175155
          mmTop = 36513
          mmWidth = 12700
          BandType = 8
        end
        object ppLine18: TppLine
          UserName = 'Line6'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Weight = 0.750000000000000000
          mmHeight = 1588
          mmLeft = 41275
          mmTop = 52123
          mmWidth = 115623
          BandType = 8
        end
        object ppLabel35: TppLabel
          UserName = 'Label18'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'IMPOSTO DE RENDA'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3440
          mmLeft = 9790
          mmTop = 56886
          mmWidth = 28575
          BandType = 8
        end
        object ppLabel36: TppLabel
          UserName = 'Label19'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'VALOR TOTAL'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3440
          mmLeft = 10319
          mmTop = 90752
          mmWidth = 19844
          BandType = 8
        end
        object ppLine19: TppLine
          UserName = 'Line7'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Weight = 0.750000000000000000
          mmHeight = 1588
          mmLeft = 41275
          mmTop = 93663
          mmWidth = 114036
          BandType = 8
        end
        object ppVariable9: TppVariable
          UserName = 'Variable9'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          BlankWhenZero = False
          CalcOrder = 1
          DataType = dtDouble
          DisplayFormat = '$#,0.00;($#,0.00)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetType = veReportStart
          TextAlignment = taRightJustified
          Transparent = True
          mmHeight = 3440
          mmLeft = 159809
          mmTop = 50271
          mmWidth = 28046
          BandType = 8
        end
        object ppVariable10: TppVariable
          UserName = 'Variable10'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          BlankWhenZero = False
          CalcOrder = 2
          DataType = dtDouble
          DisplayFormat = '$#,0.00;($#,0.00)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetType = veReportStart
          TextAlignment = taRightJustified
          Transparent = True
          mmHeight = 3440
          mmLeft = 159809
          mmTop = 56886
          mmWidth = 28046
          BandType = 8
        end
        object ppVariable11: TppVariable
          UserName = 'Variable11'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          BlankWhenZero = False
          CalcOrder = 3
          DataType = dtDouble
          DisplayFormat = '$#,0.00;($#,0.00)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 9
          Font.Style = [fsBold]
          ResetType = vePageStart
          TextAlignment = taRightJustified
          Transparent = True
          mmHeight = 3704
          mmLeft = 167217
          mmTop = 91811
          mmWidth = 20638
          BandType = 8
        end
        object ppLine20: TppLine
          UserName = 'Line201'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Pen.Color = clBlue
          Weight = 0.750000000000000000
          mmHeight = 1323
          mmLeft = 7938
          mmTop = 87842
          mmWidth = 184150
          BandType = 8
        end
        object ppLabel68: TppLabel
          UserName = 'Label68'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'COFINS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3440
          mmLeft = 9790
          mmTop = 62971
          mmWidth = 10583
          BandType = 8
        end
        object ppLabel72: TppLabel
          UserName = 'Label72'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'CSLL'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3440
          mmLeft = 9790
          mmTop = 69056
          mmWidth = 7408
          BandType = 8
        end
        object ppLabel79: TppLabel
          UserName = 'Label79'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'PIS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3440
          mmLeft = 9790
          mmTop = 76200
          mmWidth = 4498
          BandType = 8
        end
        object ppLine35: TppLine
          UserName = 'Line35'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Weight = 0.750000000000000000
          mmHeight = 1588
          mmLeft = 41275
          mmTop = 70908
          mmWidth = 115623
          BandType = 8
        end
        object ppLine51: TppLine
          UserName = 'Line51'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Weight = 0.750000000000000000
          mmHeight = 1588
          mmLeft = 41275
          mmTop = 64823
          mmWidth = 115623
          BandType = 8
        end
        object ppLine52: TppLine
          UserName = 'Line52'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Weight = 0.750000000000000000
          mmHeight = 1588
          mmLeft = 41275
          mmTop = 58738
          mmWidth = 115623
          BandType = 8
        end
        object ppVariable15: TppVariable
          UserName = 'Variable15'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          BlankWhenZero = False
          CalcOrder = 4
          DataType = dtDouble
          DisplayFormat = '$#,0.00;($#,0.00)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetType = veReportStart
          TextAlignment = taRightJustified
          Transparent = True
          mmHeight = 3440
          mmLeft = 159809
          mmTop = 76200
          mmWidth = 28046
          BandType = 8
        end
        object ppVariable16: TppVariable
          UserName = 'Variable16'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          BlankWhenZero = False
          CalcOrder = 5
          DataType = dtDouble
          DisplayFormat = '$#,0.00;($#,0.00)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetType = veReportStart
          TextAlignment = taRightJustified
          Transparent = True
          mmHeight = 3440
          mmLeft = 159809
          mmTop = 69056
          mmWidth = 28046
          BandType = 8
        end
        object ppVariable17: TppVariable
          UserName = 'Variable17'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          BlankWhenZero = False
          CalcOrder = 6
          DataType = dtDouble
          DisplayFormat = '$#,0.00;($#,0.00)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetType = veReportStart
          TextAlignment = taRightJustified
          Transparent = True
          mmHeight = 3440
          mmLeft = 159809
          mmTop = 62971
          mmWidth = 28046
          BandType = 8
        end
        object ppLabel103: TppLabel
          UserName = 'Label103'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'ESTORNO'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3440
          mmLeft = 9790
          mmTop = 43127
          mmWidth = 14023
          BandType = 8
        end
        object ppLine57: TppLine
          UserName = 'Line57'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Weight = 0.750000000000000000
          mmHeight = 1588
          mmLeft = 41275
          mmTop = 45773
          mmWidth = 115623
          BandType = 8
        end
        object ppVariable22: TppVariable
          UserName = 'Variable12'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          BlankWhenZero = False
          CalcOrder = 7
          DataType = dtCurrency
          DisplayFormat = '$#,0.00;($#,0.00)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          TextAlignment = taRightJustified
          Transparent = True
          mmHeight = 3440
          mmLeft = 173567
          mmTop = 43127
          mmWidth = 14288
          BandType = 8
        end
        object ppLine59: TppLine
          UserName = 'Line59'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Weight = 0.750000000000000000
          mmHeight = 1588
          mmLeft = 41275
          mmTop = 78052
          mmWidth = 115623
          BandType = 8
        end
        object ppLabel126: TppLabel
          UserName = 'Label126'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'I . S . S'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3440
          mmLeft = 9790
          mmTop = 50271
          mmWidth = 9525
          BandType = 8
        end
        object ppDBText23: TppDBText
          UserName = 'DBText22'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          DataField = 'CNPJ_CEDENTE'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '00\.000\.000\-0000\-00;0; '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          Visible = False
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3969
          mmLeft = 115359
          mmTop = 21960
          mmWidth = 43656
          BandType = 8
        end
        object ppDBText19: TppDBText
          UserName = 'DBText19'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          DataField = 'NOME_CEDENTE'
          DataPipeline = ppDBPipeline1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          Visible = False
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 4233
          mmLeft = 13758
          mmTop = 21696
          mmWidth = 96309
          BandType = 8
        end
        object ppDBText28: TppDBText
          UserName = 'DBText24'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          DataField = 'OPTOU_SIMPLES'
          DataPipeline = ppDBPipeline1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          Visible = False
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3440
          mmLeft = 64823
          mmTop = 14817
          mmWidth = 17198
          BandType = 8
        end
      end
      object ppSystemVariable3: TppSystemVariable
        UserName = 'SystemVariable2'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        VarType = vtPageSetDesc
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 8
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 3440
        mmLeft = 1588
        mmTop = 111390
        mmWidth = 18256
        BandType = 8
      end
      object ppLabel115: TppLabel
        UserName = 'Label115'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Caption = 'ESTA IMPRESS'#195'O N'#195'O '#201' VALIDA COMO DOCUMENTO FISCAL'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 8
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 3440
        mmLeft = 50800
        mmTop = 111390
        mmWidth = 85725
        BandType = 8
      end
    end
    object ppGroup1: TppGroup
      BreakName = 'ADMINISTRADORA'
      DataPipeline = ppDBPipeline1
      OutlineSettings.CreateNode = True
      NewPage = True
      UserName = 'Group1'
      mmNewColumnThreshold = 0
      mmNewPageThreshold = 0
      DataPipelineName = 'ppDBPipeline1'
      object ppGroupHeaderBand1: TppGroupHeaderBand
        mmBottomOffset = 0
        mmHeight = 64294
        mmPrintPosition = 0
        object ppShape2: TppShape
          UserName = 'Shape2'
          Brush.Color = clSkyBlue
          Pen.Color = clBlue
          Shape = stRoundRect
          mmHeight = 10054
          mmLeft = 5821
          mmTop = 14288
          mmWidth = 185209
          BandType = 3
          GroupNo = 0
        end
        object ppShape1: TppShape
          UserName = 'Shape1'
          Brush.Color = clSkyBlue
          Pen.Color = clBlue
          Shape = stRoundRect
          mmHeight = 14288
          mmLeft = 5556
          mmTop = 25135
          mmWidth = 185209
          BandType = 3
          GroupNo = 0
        end
        object ppShape8: TppShape
          UserName = 'Shape8'
          Brush.Color = clSkyBlue
          Pen.Color = clBlue
          Shape = stRoundRect
          mmHeight = 7938
          mmLeft = 5556
          mmTop = 40217
          mmWidth = 185209
          BandType = 3
          GroupNo = 0
        end
        object ppShape10: TppShape
          UserName = 'Shape10'
          Brush.Color = clSkyBlue
          Pen.Color = clBlue
          Shape = stRoundRect
          mmHeight = 7938
          mmLeft = 5821
          mmTop = 48948
          mmWidth = 185209
          BandType = 3
          GroupNo = 0
        end
        object ppLabel14: TppLabel
          UserName = 'Label14'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'AUTORIZA'#199#195'O PARA PAGAMENTO'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 14
          Font.Style = [fsBold, fsUnderline]
          Transparent = True
          mmHeight = 5821
          mmLeft = 57679
          mmTop = 4498
          mmWidth = 87048
          BandType = 3
          GroupNo = 0
        end
        object ppDBText1: TppDBText
          UserName = 'DBText1'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          DataField = 'NOME_PRODUTOR'
          DataPipeline = ppDBPipeline1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 4233
          mmLeft = 38365
          mmTop = 26723
          mmWidth = 89429
          BandType = 3
          GroupNo = 0
        end
        object ppLabel1: TppLabel
          UserName = 'Label1'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'FAVORECIDO:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 4233
          mmLeft = 12435
          mmTop = 26723
          mmWidth = 24606
          BandType = 3
          GroupNo = 0
        end
        object ppLabel2: TppLabel
          UserName = 'Label2'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'VAL. CARGA'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 4191
          mmLeft = 82815
          mmTop = 59002
          mmWidth = 21505
          BandType = 3
          GroupNo = 0
        end
        object ppLabel3: TppLabel
          UserName = 'Label3'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'TAXA ADM.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 4233
          mmLeft = 137319
          mmTop = 59002
          mmWidth = 19315
          BandType = 3
          GroupNo = 0
        end
        object ppLabel4: TppLabel
          UserName = 'Label4'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'REPASSE'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 4233
          mmLeft = 164836
          mmTop = 59002
          mmWidth = 16669
          BandType = 3
          GroupNo = 0
        end
        object ppLabel5: TppLabel
          UserName = 'Label5'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'VAL. TAXA'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 4191
          mmLeft = 112713
          mmTop = 59002
          mmWidth = 18203
          BandType = 3
          GroupNo = 0
        end
        object ppLabel40: TppLabel
          UserName = 'Label40'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'DATA DE PAGAMENTO'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 4233
          mmLeft = 8202
          mmTop = 17198
          mmWidth = 39158
          BandType = 3
          GroupNo = 0
        end
        object ppSystemVariable1: TppSystemVariable
          UserName = 'SystemVariable1'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          DisplayFormat = 'DD/MM/YYYY'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 4233
          mmLeft = 52123
          mmTop = 17198
          mmWidth = 17463
          BandType = 3
          GroupNo = 0
        end
        object ppLabel13: TppLabel
          UserName = 'Label13'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'VOUCHER:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold, fsItalic, fsUnderline]
          Transparent = True
          mmHeight = 4233
          mmLeft = 139171
          mmTop = 17198
          mmWidth = 18785
          BandType = 3
          GroupNo = 0
        end
        object ppDBText7: TppDBText
          UserName = 'DBText7'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          DataField = 'NUM_RECIBO'
          DataPipeline = ppDBPipeline1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 4233
          mmLeft = 160338
          mmTop = 17198
          mmWidth = 25665
          BandType = 3
          GroupNo = 0
        end
        object ppLabel32: TppLabel
          UserName = 'Label16'
          ReprintOnOverFlow = True
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'CR'#201'DITO CONTA CORRENTE:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 4233
          mmLeft = 12171
          mmTop = 42069
          mmWidth = 51329
          BandType = 3
          GroupNo = 0
        end
        object ppLabel10: TppLabel
          UserName = 'Label20'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'FATURA:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 4233
          mmLeft = 23019
          mmTop = 51065
          mmWidth = 15346
          BandType = 3
          GroupNo = 0
        end
        object ppDBText15: TppDBText
          UserName = 'DBText14'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          DataField = 'CONTROLE_REC'
          DataPipeline = ppDBPipeline1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 4233
          mmLeft = 38629
          mmTop = 51065
          mmWidth = 17198
          BandType = 3
          GroupNo = 0
        end
        object ppLabel11: TppLabel
          UserName = 'Label21'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'VIGENCIA:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 4191
          mmLeft = 61119
          mmTop = 51065
          mmWidth = 18034
          BandType = 3
          GroupNo = 0
        end
        object ppLine1: TppLine
          UserName = 'Line1'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Pen.Color = clBlue
          Weight = 0.750000000000000000
          mmHeight = 1588
          mmLeft = 7144
          mmTop = 32279
          mmWidth = 182298
          BandType = 3
          GroupNo = 0
        end
        object ppLabel6: TppLabel
          UserName = 'Label6'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'CNPJ:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 4191
          mmLeft = 26458
          mmTop = 33867
          mmWidth = 10541
          BandType = 3
          GroupNo = 0
        end
        object ppDBText8: TppDBText
          UserName = 'DBText8'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          DataField = 'DOC_PRODUTOR'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '00\.000\.000\-0000\-00;0; '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 4233
          mmLeft = 38365
          mmTop = 33867
          mmWidth = 57150
          BandType = 3
          GroupNo = 0
        end
        object ppDBText21: TppDBText
          UserName = 'DBText20'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          DataField = 'BANCO'
          DataPipeline = ppDBPipeline1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 7
          Font.Style = [fsBold]
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 2910
          mmLeft = 64558
          mmTop = 42863
          mmWidth = 5821
          BandType = 3
          GroupNo = 0
        end
        object ppDBText94: TppDBText
          UserName = 'DBText94'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          DataField = 'NOME_BANCO'
          DataPipeline = ppDBPipeline1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 7
          Font.Style = [fsBold]
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 2910
          mmLeft = 71702
          mmTop = 42863
          mmWidth = 49477
          BandType = 3
          GroupNo = 0
        end
        object ppLabel15: TppLabel
          UserName = 'Label15'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'AGENCIA'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3440
          mmLeft = 123561
          mmTop = 42598
          mmWidth = 12700
          BandType = 3
          GroupNo = 0
        end
        object ppDBText16: TppDBText
          UserName = 'DBText15'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          DataField = 'AGENCIA'
          DataPipeline = ppDBPipeline1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3440
          mmLeft = 137848
          mmTop = 42598
          mmWidth = 17198
          BandType = 3
          GroupNo = 0
        end
        object ppLabel12: TppLabel
          UserName = 'Label12'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'C/C'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3440
          mmLeft = 157692
          mmTop = 42598
          mmWidth = 4763
          BandType = 3
          GroupNo = 0
        end
        object ppDBText17: TppDBText
          UserName = 'DBText16'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          DataField = 'CONTA_CORRENTE'
          DataPipeline = ppDBPipeline1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3440
          mmLeft = 164571
          mmTop = 42598
          mmWidth = 23813
          BandType = 3
          GroupNo = 0
        end
        object ppDBText9: TppDBText
          UserName = 'DBText9'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          DataField = 'INI_VIGENCIA'
          DataPipeline = ppDBPipeline1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 4191
          mmLeft = 81227
          mmTop = 51065
          mmWidth = 17198
          BandType = 3
          GroupNo = 0
        end
        object ppLabel7: TppLabel
          UserName = 'Label7'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'OPTANTE SIMPLES:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 4191
          mmLeft = 135202
          mmTop = 34131
          mmWidth = 34375
          BandType = 3
          GroupNo = 0
        end
        object ppDBText10: TppDBText
          UserName = 'DBText10'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          DataField = 'OPTOU_SIMPLES'
          DataPipeline = ppDBPipeline1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 4233
          mmLeft = 171980
          mmTop = 34396
          mmWidth = 9790
          BandType = 3
          GroupNo = 0
        end
      end
      object ppGroupFooterBand1: TppGroupFooterBand
        mmBottomOffset = 0
        mmHeight = 27252
        mmPrintPosition = 0
        object ppShape7: TppShape
          UserName = 'Shape7'
          Brush.Color = clSkyBlue
          Pen.Color = clBlue
          Shape = stRoundRect
          mmHeight = 10054
          mmLeft = 4498
          mmTop = 12171
          mmWidth = 185209
          BandType = 5
          GroupNo = 0
        end
        object ppLine2: TppLine
          UserName = 'Line2'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Weight = 0.750000000000000000
          mmHeight = 1323
          mmLeft = 35719
          mmTop = 1588
          mmWidth = 156898
          BandType = 5
          GroupNo = 0
        end
        object ppDBCalc1: TppDBCalc
          UserName = 'DBCalc1'
          BlankWhenZero = True
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          DataField = 'VALOR_BRUTO'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '$#,0.00;($#,0.00)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup1
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3387
          mmLeft = 87048
          mmTop = 4498
          mmWidth = 21696
          BandType = 5
          GroupNo = 0
        end
        object ppDBCalc2: TppDBCalc
          UserName = 'DBCalc2'
          BlankWhenZero = True
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          DataField = 'VALOR_TOT_TAXA'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '$#,0.00;($#,0.00)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup1
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3387
          mmLeft = 113771
          mmTop = 4498
          mmWidth = 17198
          BandType = 5
          GroupNo = 0
        end
        object ppDBCalc3: TppDBCalc
          UserName = 'DBCalc3'
          BlankWhenZero = True
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          DataField = 'VALOR_COM'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '$#,0.00;($#,0.00)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup1
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3440
          mmLeft = 161925
          mmTop = 4498
          mmWidth = 21960
          BandType = 5
          GroupNo = 0
        end
        object ppLabel8: TppLabel
          UserName = 'Label8'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          Caption = 'VALOR TOTAL DO REPASSE:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          TextAlignment = taRightJustified
          Transparent = True
          mmHeight = 4191
          mmLeft = 14627
          mmTop = 15081
          mmWidth = 49911
          BandType = 5
          GroupNo = 0
        end
        object ppDBCalc4: TppDBCalc
          UserName = 'DBCalc4'
          Border.BorderPositions = []
          Border.Color = clBlack
          Border.Style = psSolid
          Border.Visible = False
          DataField = 'VALOR_COM'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '$#,0.00;($#,0.00)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 10
          Font.Style = [fsBold]
          ResetGroup = ppGroup1
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 4233
          mmLeft = 67998
          mmTop = 15081
          mmWidth = 27781
          BandType = 5
          GroupNo = 0
        end
      end
    end
    object raCodeModule1: TraCodeModule
      ProgramStream = {
        01060F5472614576656E7448616E646C65720B50726F6772616D4E616D650611
        466F6F7465724265666F72655072696E740B50726F6772616D54797065070B74
        7450726F63656475726506536F75726365147204000070726F63656475726520
        466F6F7465724265666F72655072696E743B0D0A626567696E0D0A0D0A202020
        207B434F46494E537D0D0A202020205661726961626C6531372E56414C554520
        3A3D20285641524941424C45382E56414C5545202D205661726961626C65392E
        56616C756529202A2028332F31303029203B0D0A202020207B43534C4C7D0D0A
        202020205661726961626C6531362E56414C5545203A3D20285641524941424C
        45382E56414C5545202D205661726961626C65392E56616C756529202A202831
        2F31303029203B0D0A202020207B5049537D0D0A202020205661726961626C65
        31352E56414C5545203A3D20285641524941424C45382E56414C5545202D2056
        61726961626C65392E56616C756529202A2028302E36352F313030293B0D0A20
        2020207B4953537D0D0A202020205641524941424C45392E56414C554520203A
        3D20285641524941424C45382E56414C5545202D205661726961626C65392E56
        616C756529202A2028302E303529203B0D0A202020205641524941424C45392E
        56414C554520203A3D2030203B207B736567756E646F206120666174696D6120
        656D2031382F30332F32303231206EC3A36F20C3A9207061726120646573636F
        6E74617220495353207D0D0A0D0A202020207B49527D0D0A202020207B564152
        4941424C4531302E56414C5545203A3D20285641524941424C45382E56414C55
        45202D205661726961626C65342E56616C7565202D205661726961626C65392E
        56616C756529202A2028302E303135293B7D0D0A202020205641524941424C45
        31302E56414C5545203A3D20285641524941424C45382E56414C5545202D2056
        61726961626C65392E56616C756529202A2028302E303135293B0D0A0D0A2020
        20207B44425465787432342E4669656C6456616C75652D2073696D706C65737D
        0D0A0D0A2020202049462044425465787431302E4669656C6456616C7565203D
        20275327205448454E0D0A202020202020424547494E0D0A2020202020202020
        205641524941424C4531352E56414C5545203A3D2030203B0D0A202020202020
        2020205641524941424C4531362E56414C5545203A3D2030203B0D0A20202020
        20202020205641524941424C4531372E56414C5545203A3D2030203B0D0A2020
        202020202020205641524941424C45392E56414C554520203A3D2030203B0D0A
        2020202020202020205641524941424C4531302E56414C5545203A3D2030203B
        0D0A202020202020454E44203B0D0A0D0A202020204946205641524941424C45
        31302E56414C5545203C203130205448454E0D0A202020202020564152494142
        4C4531302E56414C5545203A3D2030203B0D0A0D0A202020205641524941424C
        4531312E56414C554520203A3D205641524941424C45382E56414C5545202D20
        5641524941424C4531372E56414C5545202D205641524941424C4531362E5641
        4C5545202D5641524941424C4531352E56414C5545202D205641524941424C45
        392E56414C5545202D205641524941424C4531302E56414C5545203B0D0A0D0A
        0D0A656E643B0D0A0D436F6D706F6E656E744E616D650606466F6F7465720945
        76656E744E616D65060B4265666F72655072696E74074576656E744944021800
        01060F5472614576656E7448616E646C65720B50726F6772616D4E616D650611
        5265706F72744265666F72655072696E740B50726F6772616D54797065070B74
        7450726F63656475726506536F75726365064570726F63656475726520526570
        6F72744265666F72655072696E743B0D0A626567696E0D0A2020566172696162
        6C65382E56616C756520203A3D20303B0D0A456E643B0D0A0D436F6D706F6E65
        6E744E616D6506065265706F7274094576656E744E616D65060B4265666F7265
        5072696E74074576656E74494402010001060F5472614576656E7448616E646C
        65720B50726F6772616D4E616D65061A47726F7570466F6F74657242616E6431
        41667465725072696E740B50726F6772616D54797065070B747450726F636564
        75726506536F7572636506D070726F6365647572652047726F7570466F6F7465
        7242616E643141667465725072696E743B0D0A626567696E0D0A202020205661
        726961626C65392E56616C756520203A3D202030203B0D0A2020202056617269
        61626C6531372E56414C5545203A3D2020444243616C63342E56616C7565203B
        0D0A202020205661726961626C65382E56616C756520203A3D2020444243616C
        63342E56616C7565203B0D0A202020205661726961626C6531312E56616C7565
        203A3D2020444243616C63342E56616C7565203B0D0A656E643B0D0A0D436F6D
        706F6E656E744E616D65061047726F7570466F6F74657242616E643109457665
        6E744E616D65060A41667465725072696E74074576656E74494402170000}
    end
    object ppParameterList1: TppParameterList
    end
  end
end
