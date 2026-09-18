unit cad_comissao_prod_vr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ToolEdit, CurrEdit, ExtCtrls, Grids,dbxpress,
  FMTBcd, DB, SqlExpr, DBGrids, DBClient, Provider, Buttons;

type
  Tfrm_cad_comissao_prod_vr = class(TForm)
    Panel3: TPanel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button6: TButton;
    Button5: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Panel2: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Panel4: TPanel;
    SQLQuery1: TSQLQuery;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit1: TEdit;
    Panel5: TPanel;
    Label6: TLabel;
    ComboBox4: TComboBox;
    Label4: TLabel;
    CurrencyEdit1: TCurrencyEdit;
    Label5: TLabel;
    CurrencyEdit2: TCurrencyEdit;
    DBGrid1: TDBGrid;
    DataSetProvider1: TDataSetProvider;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    SQLQuery2: TSQLQuery;
    ClientDataSet1CONTA: TIntegerField;
    ClientDataSet1NOME_PRODUTO: TStringField;
    ClientDataSet1PERC_COM: TBCDField;
    ClientDataSet1PERC_DESC: TBCDField;
    ClientDataSet1PRODUTOR: TStringField;
    ClientDataSet1NOME: TStringField;
    Button1: TButton;
    BitBtn1: TBitBtn;
    Edit4: TEdit;
    Edit5: TEdit;
    ClientDataSet1CONTROLE: TIntegerField;
    SpeedButton1: TSpeedButton;
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox2Exit(Sender: TObject);
    procedure ComboBox1Exit(Sender: TObject);
    procedure ComboBox3Exit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn1Click(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox4Exit(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);


 // private
    { Private declarations }
 // public
    { Public declarations }
  private
  end;
var
  frm_cad_comissao_prod_vr: Tfrm_cad_comissao_prod_vr;
  t:TTransactionDesc ;
  linha:string;
implementation

uses DM, cad_ft_apolice;

{$R *.dfm}

procedure Tfrm_cad_comissao_prod_vr.Button2Click(Sender: TObject);
begin
  close ;
end;

procedure Tfrm_cad_comissao_prod_vr.Button6Click(Sender: TObject);
var
  X,i:integer;
begin
  ComboBox1.Text := 'VR0001' ;
  ComboBox2.Text := '' ;
  ComboBox3.Text := '' ;
  CheckBox1.Checked := FALSE ;
  CheckBox2.Checked := TRUE ;
  CurrencyEdit1.Value := 0 ;
  CurrencyEdit2.Value := 0 ;
  ComboBox4.Clear ;
  ClientDataSet1.Active := FALSE ;

  Panel1.Enabled := FALSE ;
  Panel2.Enabled := FALSE ;
  Panel4.Enabled := FALSE ;
  Panel5.Enabled := FALSE ;

end;

procedure Tfrm_cad_comissao_prod_vr.Button3Click(Sender: TObject);
begin
  Edit1.Text := 'NOVO' ;
  ComboBox1.Text := 'VR0001' ;
  ComboBox2.Text := '' ;
  ComboBox3.Text := '' ;
  CheckBox1.Checked := FALSE ;
  CheckBox2.Checked := TRUE ;
  CurrencyEdit1.Value := 0 ;
  CurrencyEdit2.Value := 0 ;
  ComboBox4.Clear ;
  CurrencyEdit1.Value := 0 ;
  CurrencyEdit2.Value := 0 ;
  Panel1.Enabled := TRUE ;
  Panel2.Enabled := TRUE ;
  Panel4.Enabled := TRUE ;
  Panel5.Enabled := TRUE ;
  ComboBox4.Enabled := TRUE ;
  ComboBox2.SetFocus ;
end;

procedure Tfrm_cad_comissao_prod_vr.FormShow(Sender: TObject);
begin
 Button6Click(self);

 linha := 'SELECT APO.apolice FROM APOLICES APO';
 linha := linha +' WHERE APO.apolice LIKE '+QuotedStr('VR%')+' AND APO.status = '+QuotedStr('A');
 linha := linha +' GROUP BY APO.apolice' ;
 SQLQuery1.SQL.Text := linha ;
 SQLQuery1.Open ;
 ComboBox1.Clear ;
 while not SQLQuery1.Eof do
   begin
     ComboBox1.Items.Add(SQLQuery1.FieldValues['apolice']);
     SQLQuery1.Next ;
   end ;

 linha := 'SELECT APO.administradora,PES.NOME'+
  ' FROM APOLICES APO LEFT JOIN PESSOAS PES ON PES.pessoa=APO.administradora';
 linha := linha +' WHERE APO.apolice LIKE '+QuotedStr('%VR%')+' AND APO.status = '+QuotedStr('A');
 linha := linha +' GROUP BY APO.administradora,PES.NOME ORDER BY 2';
 SQLQuery1.SQL.Text := linha ;
 SQLQuery1.Open ;
 ComboBox2.Clear ;
 while not SQLQuery1.Eof do
   begin
      ComboBox2.Items.Add(SQLQuery1.FieldValues['nome']);
      SQLQuery1.Next ;
   end ;

end;

procedure Tfrm_cad_comissao_prod_vr.ComboBox2Exit(Sender: TObject);
VAR
  FAVOR,FAVOR2:STRING;
begin

  if Button2.Focused then
    exit;

  if Length(ComboBox2.Text) = 0 then
    begin
       MessageDlg('O Campo Administradora é Obrigatório',mtError, [mbOK], 0);
       ComboBox2.SetFocus ;
       exit ;
    end ;

  FAVOR  := '' ;
  FAVOR2 := '' ;

  Edit2.Text := '' ;
  linha := 'SELECT PES.PESSOA FROM PESSOAS PES WHERE PES.nome='+QuotedStr(ComboBox2.Text) ;
  linha := linha + ' AND PES.STATUS='+QuotedStr('A');
  SQLQuery1.SQL.Text := LINHA ;
  SQLQuery1.Open ;
  IF NOT SQLQuery1.Eof THEN
     Edit2.Text := SQLQuery1.FieldValues['PESSOA'] ;

  linha := 'SELECT APO.FAVOR,APO.FAVOR2 FROM APOLICES APO WHERE APO.apolice = '+QuotedStr(ComboBox1.Text) ;
  linha := linha + ' AND APO.administradora = '+QuotedStr(Edit2.Text);
  linha := linha + ' AND APO.status = '+QuotedStr('A') ;
  SQLQuery1.SQL.Text := LINHA ;
  SQLQuery1.Open ;
  ComboBox3.CLEAR ;
  while NOT SQLQuery1.Eof do
    BEGIN

      IF SQLQuery1.FieldValues['FAVOR'] <> NULL THEN
        IF SQLQuery1.FieldValues['FAVOR'] <> '' THEN
          FAVOR := SQLQuery1.FieldValues['FAVOR'] ;

      IF SQLQuery1.FieldValues['FAVOR2'] <> NULL THEN
        IF SQLQuery1.FieldValues['FAVOR2'] <> '' THEN
          FAVOR2 := SQLQuery1.FieldValues['FAVOR2'] ;

       SQLQuery1.Next ;

    end;

    IF (Length(FAVOR)=0) AND (Length(FAVOR2)=0) THEN
     BEGIN
       MessageDlg('Não existe PRODUTOR cadastrado na Apólice dessa Empresa, cadastre primeiro na Apólice e depois repita esse passo.',mtError, [mbOK], 0);
       ComboBox2.SetFocus ;
       exit ;
     END ;

    IF Length(FAVOR) > 0 THEN
       BEGIN
          linha := 'SELECT PES.NOME FROM PESSOAS PES WHERE PES.PESSOA='+QuotedStr(FAVOR) ;
          linha := linha + ' AND PES.STATUS='+QuotedStr('A');
          SQLQuery1.SQL.Text := LINHA ;
          SQLQuery1.Open ;
          IF NOT SQLQuery1.Eof THEN
             ComboBox3.Items.Add(SQLQuery1.FieldValues['NOME']) ;
        END ;

    IF Length(FAVOR2) > 0 THEN
      BEGIN
        linha := 'SELECT PES.NOME FROM PESSOAS PES WHERE PES.PESSOA='+QuotedStr(FAVOR2) ;
        linha := linha + ' AND PES.STATUS='+QuotedStr('A');
        SQLQuery1.SQL.Text := LINHA ;
        SQLQuery1.Open ;
        IF NOT SQLQuery1.Eof THEN
         ComboBox3.Items.Add(SQLQuery1.FieldValues['NOME']) ;
      END ;

end;

procedure Tfrm_cad_comissao_prod_vr.ComboBox1Exit(Sender: TObject);
begin

  if Button2.Focused then
    exit;

  if Length(ComboBox1.Text) = 0 then
    begin
       MessageDlg('O Campo Apólice é Obrigatório',mtError, [mbOK], 0);
       ComboBox1.SetFocus ;
       exit ;
    end ;

end;

procedure Tfrm_cad_comissao_prod_vr.ComboBox3Exit(Sender: TObject);
var
  i:integer;
begin

  if Button2.Focused then
    exit;

  if Length(ComboBox3.Text) = 0 then
    begin
       MessageDlg('O Campo Produtor é Obrigatório',mtError, [mbOK], 0);
       ComboBox1.SetFocus ;
       exit ;
    end ;

  edit3.Text := '' ;
  linha := 'SELECT PES.PESSOA FROM PESSOAS PES WHERE PES.nome='+QuotedStr(ComboBox3.Text) ;
  linha := linha + ' AND PES.STATUS='+QuotedStr('A');
  SQLQuery1.SQL.Text := LINHA ;
  SQLQuery1.Open ;
  IF NOT SQLQuery1.Eof THEN
     Edit3.Text := SQLQuery1.FieldValues['PESSOA'] ;


  linha := 'select * from nomes_produtos_vr vr' ;
  linha := linha + ' where vr.conta not in (select tca.conta from tab_comissao_adm_vr tca';
  linha := linha + ' where tca.produtor = '+QuotedStr(Edit3.Text)+' and tca.status = '+QuotedStr('A')+')';
  SQLQuery1.SQL.Text := linha ;
  SQLQuery1.Open ;
  ComboBox4.Clear ;
  ComboBox4.Enabled := TRUE ;  
  while not SQLQuery1.Eof do
    begin
       ComboBox4.Items.Add(SQLQuery1.FieldValues['NOME_PRODUTO']) ;
       SQLQuery1.Next ;
    end ;

  linha := 'SELECT TCA.sobre_taxa,TCA.apenas_cond_taxa FROM tab_comissao_adm_vr TCA';
  linha := linha + ' WHERE TCA.administradora ='+QuotedStr(Edit2.Text) ;
  linha := linha + ' AND TCA.produtor ='+QuotedStr(Edit3.Text) ;
  linha := linha + ' AND TCA.STATUS='+QuotedStr('A') ;
  linha := linha + ' GROUP BY TCA.sobre_taxa,TCA.apenas_cond_taxa' ;
  SQLQuery1.SQL.Text := linha ;
  SQLQuery1.Open ;
  CheckBox1.Checked := TRUE ;
  CheckBox1.Checked := TRUE ;
  IF Not SQLQuery1.Eof THEN
     BEGIN
        IF SQLQuery1.FieldValues['APENAS_COND_taxa'] = 'N' THEN
         CheckBox1.Checked := FALSE ;
        IF SQLQuery1.FieldValues['sobre_taxa'] = 'N' THEN
         CheckBox2.Checked := FALSE ;
     END ;

  LINHA := 'SELECT NPV.conta,NPV.nome_produto,TCA.perc_com,TCA.perc_desc'+
           ',tca.produtor,pes.nome,tca.controle'+
           ' FROM nomes_produtos_vr NPV LEFT JOIN tab_comissao_adm_vr TCA'+
           ' ON TCA.conta=NPV.conta'+
           ' left join pessoas pes on pes.pessoa=tca.produtor' ;
  LINHA := LINHA + ' WHERE NPV.status = '+QuotedStr('A');
  LINHA := LINHA + ' AND TCA.administradora = '+QuotedStr(Edit2.Text) ;
  LINHA := LINHA + ' AND TCA.produtor = '+QuotedStr(Edit3.Text) ;
  LINHA := LINHA + ' AND TCA.status = '+QuotedStr('A');
  LINHA := LINHA + ' ORDER BY 1';
  SQLQuery2.SQL.Text := linha ;
  SQLQuery2.Open ;
  ClientDataSet1.Active := false ;
  ClientDataSet1.Active := true ;

end;

procedure Tfrm_cad_comissao_prod_vr.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
 if key = #13 then
  begin
   key:=#0;
   Perform(WM_NEXTDLGCTL,0,0);//Dar Tab pelo ENTER
  end;
end;

procedure Tfrm_cad_comissao_prod_vr.BitBtn1Click(Sender: TObject);
begin
  ComboBox4.Text := '' ;
  CurrencyEdit1.Value := 0 ;
  CurrencyEdit2.Value := 0 ;
end;

procedure Tfrm_cad_comissao_prod_vr.DBGrid1CellClick(Column: TColumn);
begin

  IF DBGrid1.DataSource.DataSet.FieldValues['NOME_PRODUTO'] = NULL THEN
    EXIT   ;
    
  ComboBox4.Text := DBGrid1.DataSource.DataSet.FieldValues['NOME_PRODUTO'] ;
  CurrencyEdit1.Value := DBGrid1.DataSource.DataSet.FieldValues['PERC_COM'] ;
  CurrencyEdit2.Value := DBGrid1.DataSource.DataSet.FieldValues['PERC_DESC'] ;

  Edit5.Text := IntToStr(DBGrid1.DataSource.DataSet.FieldValues['CONTROLE']);

  Button3.Enabled := false ;
  Button4.Enabled := true ;
  Button5.Enabled := true ;

  panel1.Enabled := false ;
  panel2.Enabled := false ;
  panel5.Enabled := false ;

end;

procedure Tfrm_cad_comissao_prod_vr.Button4Click(Sender: TObject);
begin
  Edit1.Text := 'ALTERA' ;
  panel1.Enabled := false ;
  panel2.Enabled := true ;
  panel5.Enabled := true ;
  ComboBox4.Enabled := FALSE ;
end;

procedure Tfrm_cad_comissao_prod_vr.Button1Click(Sender: TObject);
VAR
  tst,mens,mens2,PERC,DESC:STRING;
begin

  if Edit1.Text = 'NOVO' then
    begin
      linha := 'INSERT INTO tab_comissao_adm_vr'+
      '(CONTROLE, ADMINISTRADORA, PRODUTOR, STATUS,'+
      'CONTA, PERC_COM, PERC_DESC, SOBRE_TAXA, APENAS_COND_TAXA)'+
      ' values(';
      linha := linha + 'GEN_ID(CONTROLE_TAB_COMISSAO_VR,1),';
      linha := linha + QuotedStr(Edit2.Text)+',';
      linha := linha + QuotedStr(Edit3.Text)+',';
      linha := linha + QuotedStr('A')+',';
      linha := linha + Edit4.Text+',';
      perc  := StringReplace(CurrencyEdit1.Text,',','.',[rfReplaceAll]);
      desc  := StringReplace(CurrencyEdit2.Text,',','.',[rfReplaceAll]);
      if Length(perc) = 0 then
         perc := '0' ;
      if Length(desc) = 0 then
         desc := '0' ;
      linha := linha + perc + ',' ;
      linha := linha + desc + ',' ;
      if CheckBox1.Checked then
        linha := linha + QuotedStr('S')+','
      else
        linha := linha + QuotedStr('N')+',' ;

      if CheckBox2.Checked then
        linha := linha + QuotedStr('S')
      else
        linha := linha + QuotedStr('N') ;
      linha := linha + ')' ;

      Mens := 'Confirma Inclusão da Comissão?' ;
      Mens2:= 'Inclusão da Comissão realizada com Sucesso.' ;

    end ;

  if Edit1.Text = 'ALTERA' then
    begin
      linha := 'UPDATE tab_comissao_adm_vr SET ' ;
      perc  := StringReplace(CurrencyEdit1.Text,',','.',[rfReplaceAll]);
      desc  := StringReplace(CurrencyEdit2.Text,',','.',[rfReplaceAll]);
      if Length(perc) = 0 then
         perc := '0' ;
      if Length(desc) = 0 then
         desc := '0' ;
      linha := linha +'PERC_COM='+perc+',' ;
      linha := linha +'PERC_DESC='+desc+',' ;
      if CheckBox1.Checked then
        linha := linha +'SOBRE_TAXA='+QuotedStr('S')+','
      else
        linha := linha +'SOBRE_TAXA='+QuotedStr('N')+',';
      if CheckBox2.Checked then
        linha := linha +'APENAS_COND_TAXA='+QuotedStr('S')
      else
        linha := linha +'APENAS_COND_TAXA='+QuotedStr('N');

      linha := linha + ' WHERE CONTROLE='+Edit5.Text ;

      Mens := 'Confirma Alteração da Comissão?' ;
      Mens2:= 'Alteração da Comissão realizada com Sucesso.' ;
    end ;

  if Edit1.Text = 'CANCELA' then
    begin
      linha := 'UPDATE tab_comissao_adm_vr SET ' ;
      linha := linha +'STATUS='+QuotedStr('C');
      linha := linha + ' WHERE CONTROLE='+Edit5.Text ;
      Mens := 'Confirma Cancelamento da Comissão?' ;
      Mens2:= 'Cancelamento da Comissão realizado com Sucesso.' ;
    end ;

   try
     BEGIN
       if MessageBox(Application.Handle,PAnsiChar(mens),'',36) = 6 Then
         begin

           t.TransactionID := 1;
           t.IsolationLevel := xilREADCOMMITTED;
           DataModule1.SQLCON_FAT.StartTransaction(t);

           SQLQuery1.SQL.Text := linha ;
           SQLQuery1.ExecSQL() ;

           DataModule1.SQLCON_FAT.Commit(T);

           MessageDlg(Mens2,mtInformation, [mbOK], 0);


           if Edit1.Text <> 'CANCELA' THEN
             begin

               BitBtn1Click(self);

               LINHA := 'SELECT NPV.conta,NPV.nome_produto,TCA.perc_com,TCA.perc_desc'+
                         ',tca.produtor,pes.nome,tca.controle'+
                         ' FROM nomes_produtos_vr NPV LEFT JOIN tab_comissao_adm_vr TCA'+
                         ' ON TCA.conta=NPV.conta'+
                         ' left join pessoas pes on pes.pessoa=tca.produtor' ;
                LINHA := LINHA + ' WHERE NPV.status = '+QuotedStr('A');
                LINHA := LINHA + ' AND TCA.administradora = '+QuotedStr(Edit2.Text) ;
                LINHA := LINHA + ' AND TCA.produtor = '+QuotedStr(Edit3.Text) ;
                LINHA := LINHA + ' AND TCA.status = '+QuotedStr('A');
                LINHA := LINHA + ' ORDER BY 1';
                SQLQuery2.SQL.Text := linha ;
                SQLQuery2.Open ;
                ClientDataSet1.Active := false ;
                ClientDataSet1.Active := true ;


             end ;

         end ;
      end ;
    except
    on exception do
      begin
         MessageDlg('Problemas na Manutenção da Comissão',mtError, [mbOK], 0);
         DataModule1.SQLCON_FAT.Rollback(T);
         ShortDateFormat := 'DD/MM/YYYY' ;
      end ;
    END ;



end;

procedure Tfrm_cad_comissao_prod_vr.ComboBox4Exit(Sender: TObject);
begin

  Edit4.Text := '' ;

  IF Length(ComboBox4.Text) > 0 THEN
    BEGIN
      linha := 'SELECT * FROM NOMES_PRODUTOS_VR NV WHERE NV.NOME_PRODUTO='+QuotedStr(ComboBox4.Text) ;
      SQLQuery1.SQL.Text := linha ;
      SQLQuery1.Open ;
      if not SQLQuery1.Eof then
        Edit4.Text := SQLQuery1.FieldValues['CONTA'] ;
    END ;

end;

procedure Tfrm_cad_comissao_prod_vr.Button5Click(Sender: TObject);
begin
  Edit1.Text := 'CANCELA' ;
  Button1Click(SELF);
end;

procedure Tfrm_cad_comissao_prod_vr.SpeedButton1Click(Sender: TObject);
begin
  Application.CreateForm(Tfrm_cad_ft_apolice,frm_cad_ft_apolice);
  frm_cad_ft_apolice.ShowModal ;
  frm_cad_ft_apolice.Free ;
end;

end.
