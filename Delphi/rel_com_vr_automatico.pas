unit rel_com_vr_automatico;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ToolEdit, ExtCtrls, FMTBcd, DB, SqlExpr,dbxpress,
  Grids, DBGrids, DBClient, Provider, ppBands, ppClass, ppPrnabl, ppCtrls,
  ppCache, ppDB, ppProd, ppReport, ppComm, ppRelatv, ppDBPipe, ppVar,
  ppStrtch, ppRegion, ppParameter, ppModule, raCodMod;

type
  Tfrm_rel_com_vr_automatico = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    ComboBox2: TComboBox;
    Label3: TLabel;
    DateEdit1: TDateEdit;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SQLQuery3: TSQLQuery;
    SQLQuery4: TSQLQuery;
    SQLQuery5: TSQLQuery;
    DBGrid1: TDBGrid;
    DataSetProvider1: TDataSetProvider;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    ClientDataSet1CONTROLE_REC: TIntegerField;
    ClientDataSet1NUM_RECIBO: TIntegerField;
    ClientDataSet1DT_EMI_RECIBO: TDateField;
    ClientDataSet1INI_VIGENCIA: TDateField;
    ClientDataSet1ADMINISTRADORA: TStringField;
    ClientDataSet1PRODUTOR: TStringField;
    ClientDataSet1CONTA: TIntegerField;
    ClientDataSet1PERC_COM: TBCDField;
    ClientDataSet1DESC_COM: TBCDField;
    ClientDataSet1VALOR_BRUTO: TFMTBCDField;
    ClientDataSet1VALOR_COM: TFMTBCDField;
    ClientDataSet1USU_EMI_RECIBO: TStringField;
    ClientDataSet1STATUS: TStringField;
    ClientDataSet1NOME_PRODUTO: TStringField;
    ClientDataSet1NOME_ADM: TStringField;
    ClientDataSet1NOME_PRODUTOR: TStringField;
    ppDBPipeline1: TppDBPipeline;
    ppReport1: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppFooterBand1: TppFooterBand;
    ppGroup1: TppGroup;
    ppGroupHeaderBand1: TppGroupHeaderBand;
    ppGroupFooterBand1: TppGroupFooterBand;
    ppLabel14: TppLabel;
    ppShape2: TppShape;
    ppShape1: TppShape;
    ppShape8: TppShape;
    ppShape10: TppShape;
    ppDBText1: TppDBText;
    ppLabel1: TppLabel;
    ppShape3: TppShape;
    ppDBText2: TppDBText;
    ppLabel2: TppLabel;
    ppLabel3: TppLabel;
    ppLabel4: TppLabel;
    ppDBText3: TppDBText;
    ppDBText4: TppDBText;
    ClientDataSet1VALOR_TOT_TAXA: TFMTBCDField;
    ppLabel5: TppLabel;
    ppDBText5: TppDBText;
    ppDBText6: TppDBText;
    ppLabel40: TppLabel;
    ppSystemVariable1: TppSystemVariable;
    ppLabel13: TppLabel;
    ppDBText7: TppDBText;
    ClientDataSet1DOC_PRODUTOR: TStringField;
    ppLabel32: TppLabel;
    ppLabel10: TppLabel;
    ppDBText15: TppDBText;
    ppLabel11: TppLabel;
    ppLine1: TppLine;
    ppLabel6: TppLabel;
    ppDBText8: TppDBText;
    ppDBText21: TppDBText;
    ppDBText94: TppDBText;
    ppLabel15: TppLabel;
    ppDBText16: TppDBText;
    ppLabel12: TppLabel;
    ppDBText17: TppDBText;
    ClientDataSet1OPTOU_SIMPLES: TStringField;
    ClientDataSet1NOME_BANCO: TStringField;
    ClientDataSet1BANCO: TStringField;
    ClientDataSet1AGENCIA: TStringField;
    ClientDataSet1CONTA_CORRENTE: TStringField;
    ppDBText9: TppDBText;
    ppLabel7: TppLabel;
    ppDBText10: TppDBText;
    ppLine2: TppLine;
    ppDBCalc1: TppDBCalc;
    ppDBCalc2: TppDBCalc;
    ppDBCalc3: TppDBCalc;
    ppLabel8: TppLabel;
    ppDBCalc4: TppDBCalc;
    ppRegion1: TppRegion;
    ppShape11: TppShape;
    ppShape9: TppShape;
    ppLabel27: TppLabel;
    ppLabel28: TppLabel;
    ppLine13: TppLine;
    ppLine14: TppLine;
    ppLine15: TppLine;
    ppLabel33: TppLabel;
    ppLine16: TppLine;
    ppVariable8: TppVariable;
    ppLine18: TppLine;
    ppLabel35: TppLabel;
    ppLabel36: TppLabel;
    ppLine19: TppLine;
    ppVariable9: TppVariable;
    ppVariable10: TppVariable;
    ppVariable11: TppVariable;
    ppLine20: TppLine;
    ppLabel68: TppLabel;
    ppLabel72: TppLabel;
    ppLabel79: TppLabel;
    ppLine35: TppLine;
    ppLine51: TppLine;
    ppLine52: TppLine;
    ppVariable15: TppVariable;
    ppVariable16: TppVariable;
    ppVariable17: TppVariable;
    ppLabel103: TppLabel;
    ppLine57: TppLine;
    ppVariable22: TppVariable;
    ppLine59: TppLine;
    ppLabel126: TppLabel;
    ppDBText23: TppDBText;
    ppDBText19: TppDBText;
    ppDBText28: TppDBText;
    ppSystemVariable3: TppSystemVariable;
    ppLabel115: TppLabel;
    ClientDataSet1CEDENTE: TStringField;
    ClientDataSet1NOME_CEDENTE: TStringField;
    ClientDataSet1CNPJ_CEDENTE: TStringField;
    ppShape7: TppShape;
    raCodeModule1: TraCodeModule;
    ppParameterList1: TppParameterList;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_rel_com_vr_automatico: Tfrm_rel_com_vr_automatico;
  linha:string;
  t:TTransactionDesc ;
implementation

uses DM;

{$R *.dfm}

procedure Tfrm_rel_com_vr_automatico.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
 if key = #13 then
   begin
    key:=#0;
    Perform(WM_NEXTDLGCTL,0,0);//Dar Tab pelo ENTER
  end;
end;

procedure Tfrm_rel_com_vr_automatico.FormShow(Sender: TObject);
begin

  linha := 'SELECT PES.nome FROM APOLICES APO LEFT JOIN PESSOAS PES ';
  linha := linha + ' ON PES.pessoa=APO.administradora';
  linha := linha + ' WHERE APO.apolice LIKE '+QuotedStr('%VR%');
  linha := linha + ' AND PES.nome <> '+QuotedStr('');
  linha := linha + ' and APO.STATUS='+QuotedStr('A');
  linha := linha + ' GROUP BY pes.nome';
  linha := linha + ' ORDER BY 1';
  SQLQuery1.SQL.Text := linha ;
  SQLQuery1.Open ;
  ComboBox1.Clear ;
  while NOT SQLQuery1.Eof DO
    BEGIN
      ComboBox1.Items.Add(SQLQuery1.FieldValues['nome']) ;
      SQLQuery1.Next ;
    END ;

  linha := 'SELECT PES.nome FROM APOLICES APO LEFT JOIN PESSOAS PES ';
  linha := linha + ' ON PES.pessoa=APO.favor';
  linha := linha + ' WHERE APO.apolice LIKE '+QuotedStr('%VR%');
  linha := linha + ' AND PES.nome <> '+QuotedStr('');
  linha := linha + ' and APO.STATUS='+QuotedStr('A');
  linha := linha + ' GROUP BY pes.nome';
  linha := linha + ' UNION ALL' ;
  linha := linha + ' SELECT PES.nome FROM APOLICES APO LEFT JOIN PESSOAS PES ';
  linha := linha + ' ON PES.pessoa=APO.favor';
  linha := linha + ' WHERE APO.apolice LIKE '+QuotedStr('%VR%');
  linha := linha + ' AND PES.nome <> '+QuotedStr('');
  linha := linha + ' and APO.STATUS='+QuotedStr('A');
  linha := linha + ' GROUP BY pes.nome';
  linha := linha + ' ORDER BY 1';
  SQLQuery1.SQL.Text := linha ;
  SQLQuery1.Open ;
  ComboBox2.Clear ;
  while NOT SQLQuery1.Eof DO
    BEGIN
      ComboBox2.Items.Add(SQLQuery1.FieldValues['nome']) ;
      SQLQuery1.Next ;
    END ;

  Button3.Click ;

end;

procedure Tfrm_rel_com_vr_automatico.Button3Click(Sender: TObject);
begin
  ComboBox1.Text := '' ;
  ComboBox2.Text := '' ;
  DateEdit1.Clear ;
  ShortDateFormat := 'dd/mm/yyyy' ;
  ComboBox1.SetFocus ;
  ClientDataSet1.Close ;
end;

procedure Tfrm_rel_com_vr_automatico.Button1Click(Sender: TObject);
var
  VALOR,cnt,SOBRETAXA,APENASCTX,ADM,PROD:string;
  VLDESC,VLTAXA,VLBRUTO,VLCOM:Real ;
begin

  ADM  := '' ;
  PROD := '' ;
  if Length(ComboBox1.Text) > 0 then
    begin
       linha := 'SELECT * FROM PESSOAS PES WHERE PES.NOME='+QuotedStr(ComboBox1.Text) ;
       SQLQuery1.SQL.Text := linha ;
       SQLQuery1.Open ;
       if not SQLQuery1.Eof then
          adm := SQLQuery1.FieldValues['PESSOA'] ;
    end ;

  if Length(ComboBox2.Text) > 0 then
    begin
       linha := 'SELECT * FROM PESSOAS PES WHERE PES.NOME='+QuotedStr(ComboBox2.Text) ;
       SQLQuery1.SQL.Text := linha ;
       SQLQuery1.Open ;
       if not SQLQuery1.Eof then
          PROD := SQLQuery1.FieldValues['PESSOA'] ;
    end ;


  IF (Length(ADM) = 0) AND (Length(PROD)=0) AND (DateEdit1.Date=0) THEN
    BEGIN
      MessageDlg('Alguns dos paramentros devem ser preenchidos',mtError, [mbOK], 0);
      ComboBox1.SetFocus ;
      exit ;
    END ;

  if (Length(adm) = 0) and (DateEdit1.Date > 0) then
    begin

       LINHA := 'delete from RECIBOS_COMISSAO_VR rcv ';
       ShortDateFormat := 'MM/DD/YYYY' ;
       linha := linha + ' where rcv.ini_vigencia = '+QuotedStr(DateToStr(DateEdit1.Date)) ;
       linha := linha + ' and rcv.num_recibo=0';
       ShortDateFormat := 'DD/MM/YYYY' ;
       SQLQuery1.SQL.Text := LINHA ;
       SQLQuery1.ExecSQL() ;

       linha := 'SELECT iv.administradora';
       linha := linha + ' FROM importa_vr IV join tab_comissao_adm_vr tca on ';
       linha := linha + ' tca.administradora = iv.administradora' ;
       ShortDateFormat := 'MM/DD/YYYY' ;
       linha := linha + ' where iv.dt_ini_uso = '+QuotedStr(DateToStr(DateEdit1.Date)) ;
       ShortDateFormat := 'DD/MM/YYYY' ;
       linha := linha + ' and iv.status = '+QuotedStr('A');
       linha := linha + ' GROUP BY iv.administradora ';
       SQLQuery1.SQL.Text := LINHA ;
       SQLQuery1.Open ;
       WHILE NOT SQLQuery1.Eof DO
          BEGIN

            ADM := SQLQuery1.FieldValues['ADMINISTRADORA'] ;
            APENASCTX := 'S' ;
            SOBRETAXA := 'N' ;

            LINHA := 'SELECT TCA.SOBRE_TAXA,TCA.apenas_cond_taxa FROM tab_comissao_adm_vr TCA';
            LINHA := LINHA + ' where TCA.administradora = '+QuotedStr(ADM) ;
            LINHA := LINHA + ' GROUP BY TCA.SOBRE_TAXA,TCA.apenas_cond_taxa';
            SQLQuery2.SQL.Text := LINHA ;
            SQLQuery2.Open ;
            IF NOT SQLQuery2.Eof THEN
              BEGIN
                 APENASCTX := SQLQuery2.FieldValues['apenas_cond_taxa'] ;
                 SOBRETAXA := SQLQuery2.FieldValues['SOBRE_TAXA'] ;
              END ;

            LINHA := 'SELECT iv.administradora,IV.produto,NPV.conta,';
            linha := linha + 'COUNT(*) BENEFICIOS,SUM(IV.valor) VALOR_CREDITO,SUM(IV.taxa) VLR_TAXA';
            linha := linha + ' FROM importa_vr IV LEFT JOIN nomes_produtos_vr NPV on NPV.nome_produto=IV.produto';
            linha := linha + ' where iv.administradora = '+QuotedStr(adm) ;
            linha := linha + ' and iv.status <> '+QuotedStr('C') ;
            ShortDateFormat := 'MM/DD/YYYY' ;
            linha := linha + ' and iv.dt_ini_uso = '+QuotedStr(DateToStr(DateEdit1.Date));
            ShortDateFormat := 'DD/mm/YYYY' ;
            if APENASCTX = 'S' THEN
              linha := linha + ' and iv.taxa > 0' ;
            linha := linha + ' GROUP BY iv.administradora,IV.produto,NPV.conta';
            SQLQuery2.SQL.Text := LINHA ;
            SQLQuery2.Open ;
            WHILE NOT SQLQuery2.Eof DO
              BEGIN

                IF SQLQuery2.FieldValues['CONTA'] <> NULL THEN
                   BEGIN
                     linha := 'SELECT * FROM tab_comissao_adm_vr TCA';
                     linha := linha + ' WHERE TCA.administradora ='+QuotedStr(ADM);
                     linha := linha + ' AND TCA.conta ='+IntToStr(SQLQuery2.FieldValues['CONTA']) ;
                     linha := linha + ' AND TCA.status = '+QuotedStr('A');
                     SQLQuery3.SQL.Text := LINHA ;
                     SQLQuery3.Open ;

                     IF NOT SQLQuery3.Eof THEN
                        BEGIN
                          VLBRUTO := 0.00 ;
                          VLTAXA  := 0.00 ;

                          IF SQLQuery2.FieldValues['VALOR_CREDITO'] <> NULL THEN
                            VLBRUTO := SQLQuery2.FieldValues['VALOR_CREDITO'] ;
                          IF SQLQuery2.FieldValues['VLR_TAXA'] <> NULL THEN
                            VLTAXA  := SQLQuery2.FieldValues['VLR_TAXA'] ;

                          VLCOM := 0.00 ;
                          IF SOBRETAXA = 'S' THEN
                             VLCOM := (VLTAXA * (SQLQuery3.FieldValues['PERC_COM']/100));
                          IF SOBRETAXA = 'N' THEN
                             VLCOM := (VLBRUTO * (SQLQuery3.FieldValues['PERC_COM']/100));

                          VLDESC := 0.00 ;
                          IF SQLQuery3.FieldValues['PERC_DESC'] <> NULL THEN
                             IF SQLQuery3.FieldValues['PERC_DESC'] > 0 THEN
                                VLDESC := (VLCOM * (SQLQuery3.FieldValues['PERC_DESC']/100));

                          VLCOM := VLCOM - VLDESC ;

                          cnt := '1' ;
                          linha := 'select gen_id(GEN_RECIBO_COMISSAO_VR,1) conta from rdb$DataBase' ;
                          SQLQuery4.SQL.Text := LINHA ;
                          SQLQuery4.Open ;
                          if not SQLQuery4.Eof then
                             cnt := IntToStr(SQLQuery4.FieldValues['CONTA']) ;

                          ShortDateFormat := 'MM/DD/YYYY' ;

                          linha := 'INSERT INTO RECIBOS_COMISSAO_VR(CONTROLE_REC,';
                          linha := linha + 'NUM_RECIBO,DT_EMI_RECIBO,INI_VIGENCIA,';
                          linha := linha + 'ADMINISTRADORA,PRODUTOR,CONTA,PERC_COM,';
                          linha := linha + 'DESC_COM,VALOR_BRUTO,VALOR_COM,USU_EMI_RECIBO,';
                          linha := linha + 'STATUS) VALUES(';
                          linha := linha + CNT +',' ; // CONTROLE
                          linha := linha + '0'+','; // NUM_RECIBO
                          linha := linha + QuotedStr(DateToStr(NOW()))+',';
                          linha := linha + QuotedStr(DateToStr(DateEdit1.Date))+',';
                          linha := linha + QuotedStr(ADM)+','; // ADMINISTRADORA
                          linha := linha + QuotedStr(SQLQuery3.FieldValues['PRODUTOR'])+','; // PRODUTOR
                          linha := linha + IntToStr(SQLQuery3.FieldValues['CONTA'])+','; // CODIGO DO PRODUTO

                          VALOR := FloatToStr(SQLQuery3.FieldValues['perc_com']) ;
                          VALOR := StringReplace(VALOR,'.','',[rfReplaceall]);
                          VALOR := StringReplace(VALOR,',','.',[rfReplaceall]);
                          LINHA := LINHA + VALOR + ',' ;

                          VALOR := FloatToStr(SQLQuery3.FieldValues['perc_desc']) ;
                          VALOR := StringReplace(VALOR,'.','',[rfReplaceall]);
                          VALOR := StringReplace(VALOR,',','.',[rfReplaceall]);
                          LINHA := LINHA + VALOR + ',' ;

                          VALOR := FloatToStr(VLBRUTO) ;
                          IF SOBRETAXA = 'S' THEN
                             VALOR := FloatToStr(VLTAXA);

                          VALOR := StringReplace(VALOR,'.','',[rfReplaceall]);
                          VALOR := StringReplace(VALOR,',','.',[rfReplaceall]);
                          LINHA := LINHA + VALOR + ',' ;

                          VALOR := FloatToStr(VLCOM) ;
                          VALOR := StringReplace(VALOR,'.','',[rfReplaceall]);
                          VALOR := StringReplace(VALOR,',','.',[rfReplaceall]);
                          LINHA := LINHA + VALOR + ',' ;

                          linha := linha + QuotedStr('')+','; // usuario
                          linha := linha + QuotedStr('A'); // STATUS

                          linha := linha + ')' ;
                          SQLQuery4.SQL.Text := LINHA ;
                          SQLQuery4.ExecSQL() ;

                          ShortDateFormat := 'DD/MM/YYYY' ;
                        END ;

                   END ;

                SQLQuery2.Next ;
              END ;
            SQLQuery1.Next ; // NEXT DA QUERY DE ADMINISTRADORAS ;
          END ;

       // Impressão de Recibos
       ////////////////////////
       LINHA := 'SELECT RCV.controle_rec,rcv.num_recibo,rcv.dt_emi_recibo,rcv.ini_vigencia,'+
                 'rcv.administradora,rcv.produtor,rcv.conta,rcv.perc_com,rcv.desc_com,'+
                 'rcv.valor_bruto,rcv.valor_tot_taxa,rcv.valor_com,rcv.usu_emi_recibo,rcv.status,'+
                 'NPV.nome_produto,';
       LINHA := LINHA + '(SELECT PES.NOME FROM PESSOAS PES WHERE PES.pessoa=RCV.administradora) NOME_ADM,';
       LINHA := LINHA + 'PP.NOME NOME_PRODUTOR,PP.cpf_cnpj DOC_PRODUTOR,';
       LINHA := LINHA + 'PP.optou_simples,BAN.nome_banco,PP.BANCO,PP.AGENCIA,PP.conta CONTA_CORRENTE,';
       LINHA := LINHA + 'APO.cedente,(SELECT CC.cedente FROM cedente CC WHERE CC.codigo=APO.cedente) NOME_CEDENTE,';
       LINHA := LINHA + '(SELECT CC.cnpj FROM cedente CC WHERE CC.codigo=APO.cedente) CNPJ_CEDENTE';
       LINHA := LINHA + ' FROM recibos_comissao_vr RCV LEFT JOIN nomes_produtos_vr NPV ON NPV.conta=RCV.conta';
       LINHA := LINHA + ' LEFT JOIN PESSOAS PP ON PP.pessoa=RCV.produtor';
       LINHA := LINHA + ' LEFT JOIN BANCOS BAN ON BAN.cod_banco=PP.banco';
       LINHA := LINHA + ' LEFT JOIN apolices apo on apo.apolice = '+QuotedStr('VR0001')+' AND APO.administradora=rcv.administradora';
       LINHA := LINHA + ' WHERE RCV.status ='+QuotedStr('A');
       LINHA := LINHA + ' AND RCV.NUM_RECIBO=0';
       IF DateEdit1.Date > 0 THEN
         BEGIN
            ShortDateFormat := 'MM/DD/YYYY' ;
            LINHA := LINHA + ' AND RCV.INI_VIGENCIA='+QuotedStr(DateToStr(DateEdit1.Date)) ;
            ShortDateFormat := 'DD/MM/YYYY' ;
         END ;
       LINHA := LINHA + ' ORDER BY RCV.ADMINISTRADORA,NPV.NOME_PRODUTO';
       SQLQuery5.SQL.Text := LINHA ;
       SQLQuery5.Open ;
       ClientDataSet1.Active := FALSE ;
       ClientDataSet1.Active := TRUE ;

       ppReport1.AllowPrintToArchive := TRUE ;
       ppReport1.AllowPrintToFile    := TRUE ;
       ppReport1.PDFSettings.OpenPDFFile := TRUE ;
       ppReport1.EmailSettings.Enabled   := TRUE ;
       ppReport1.Print ;


////////////////////////////////

    end
  else if (Length(adm) > 0) and (DateEdit1.Date > 0) then
    begin
      // MESMO PROCESSO FIXO COM A ADMINISTRADORA
    end ;



end;

procedure Tfrm_rel_com_vr_automatico.Button4Click(Sender: TObject);
begin
  close ;
end;

end.
