unit uPedidos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.DBScope, Data.DB,
  Datasnap.DBClient, Data.Bind.Grid, System.Actions, FMX.ActnList, FMX.Layouts,
  FMX.Grid, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, uConnect, uBinds,
  FMX.Objects, FMX.DateTimeCtrls;

type
  TFrmPedidos = class(TForm)
    edtCod: TEdit;
    btnAdd: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    btnSalvar: TButton;
    Label2: TLabel;
    ActionList1: TActionList;
    actSair: TAction;
    BindingsList1: TBindingsList;
    cdsProdutos: TClientDataSet;
    BSprodutos: TBindSourceDB;
    Label1: TLabel;
    edtDescricao: TEdit;
    grdProd: TGrid;
    LinkGridToDataSourceBSprodutos: TLinkGridToDataSource;
    btnIncluir: TButton;
    Label3: TLabel;
    edtValUnit: TEdit;
    rctDados: TRectangle;
    Label4: TLabel;
    edtQtde: TEdit;
    Label5: TLabel;
    edtTotalProd: TEdit;
    edtCliente: TEdit;
    Label6: TLabel;
    cdsPedido: TClientDataSet;
    BSPedido: TBindSourceDB;
    dtEmissao: TDateEdit;
    Label7: TLabel;
    Label8: TLabel;
    edtNumero: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure actSairExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure edtCodExit(Sender: TObject);
    procedure edtQtdeExit(Sender: TObject);
    procedure edtValUnitExit(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure edtCodKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnExcluirClick(Sender: TObject);
  private
  Bind : TBinds;
  BindPedido : TBinds;
  Conn : TConnection;
  procedure controlaBotoes();
  procedure bindCampos();
  function validaProduto() : Boolean;
  procedure calculaTotal();
    { Private declarations }
  public
    { Public declarations }
  Status : TStatus;
  Pesquisa : Boolean;
  IdPedido : string;

  end;

var
  FrmPedidos: TFrmPedidos;

implementation

{$R *.fmx}

uses uProdutos;

{ TForm1 }

procedure TFrmPedidos.actSairExecute(Sender: TObject);
begin
  if (Status in [Insert, Edit]) then
  begin
    CdsProdutos.Cancel;
    Status := Default;
    ControlaBotoes();
  end;
end;

procedure TFrmPedidos.bindCampos;
begin
  Bind.BindControlToField(edtDescricao, 'DESCITEM');
  Bind.BindControlToField(edtCod, 'IDITEM');
  Bind.BindControlToField(edtQtde, 'QUANTIDADE');
  Bind.BindControlToField(edtValUnit, 'VALORUNIT');
  Bind.BindControlToField(edtTotalProd, 'VALORTOTAL');
  Bind.AtivaBind(True);

  BindPedido.BindControlToField(edtCliente, 'CLIENTE');
  BindPedido.BindControlToField(dtEmissao, 'DTEMISSAO');
  BindPedido.BindControlToField(edtNumero, 'NUMERO');
  BindPedido.AtivaBind(True);
end;

procedure TFrmPedidos.btnEditarClick(Sender: TObject);
begin
  if CdsProdutos.RecordCount > 0 then
  begin
    Status := Edit;
    ControlaBotoes();
    CdsProdutos.Edit;
    edtCod.SetFocus;
  end;
end;

procedure TFrmPedidos.btnExcluirClick(Sender: TObject);
begin
  if (Pesquisa = False) and (cdsProdutos.RecordCount > 0) then
    cdsProdutos.Delete;
end;

procedure TFrmPedidos.btnAddClick(Sender: TObject);
begin
  if edtQtde.Text.Trim = EmptyStr then
  begin
    ShowMessage('A quantidade deve ser preenchida');
    edtQtde.SetFocus;
    Exit;
  end;

  if edtValUnit.Text.Trim = EmptyStr then
  begin
    ShowMessage('O valor unit?rio deve ser preenchido');
    edtValUnit.SetFocus;
    Exit;
  end;

  cdsProdutos.Post;
  Status := Default;
  controlaBotoes();
  grdProd.SetFocus;
end;

procedure TFrmPedidos.btnIncluirClick(Sender: TObject);
begin
  Status := Insert;
  ControlaBotoes();
  CdsProdutos.Append;
  edtCod.SetFocus;
end;

procedure TFrmPedidos.btnSalvarClick(Sender: TObject);
var
Cds : TClientDataSet;
Sql : string;
Qtde, ValorUnit, ValorTotal : Double;
begin
  cdsProdutos.First;
  if Pesquisa = True then
  begin
    Sql := 'UPDATE PEDIDOCAB SET (DTEMISSAO, CLIENTE, NUMERO) = ('+
            QuotedStr(FormatDateTime('MM/dd/yyyy', cdsPedido.FieldByName('DTEMISSAO').AsDateTime)) + ',' + QuotedStr(edtCliente.Text) + ',' + QuotedStr(edtNumero.Text)+ ')';
    Conn.execQuery(Sql);
    while not cdsProdutos.Eof do
    begin
      Qtde       := cdsProdutos.FieldByName('QUANTIDADE').AsInteger;
      ValorUnit  := cdsProdutos.FieldByName('VALORUNIT').AsFloat;
      ValorTotal := cdsProdutos.FieldByName('VALORTOTAL').AsFloat;
      Sql := 'UPDATE PEDIDOITEM SET (IDITEM, QUANTIDADE, VALORUNIT, VALORTOTAL) = (' + QuotedStr(cdsProdutos.FieldByName('IDITEM').AsString) + ',' +
              QuotedStr(FloatToStr(Qtde)) + ',' + QuotedStr(FloatToStr(ValorUnit)) + ',' +QuotedStr(FloatToStr(ValorTotal)) + ')'+
              'WHERE IDPEDIDOITEM = ' + QuotedStr(cdsProdutos.FieldByName('IDPEDIDOITEM').AsString);

      Conn.execQuery(Sql);
      cdsProdutos.Next;
    end;

  end
  else
  begin
    try
      Cds := TClientDataSet.Create(nil);

      Sql := 'INSERT INTO PEDIDOCAB (DTEMISSAO, CLIENTE, NUMERO) VALUES ('+ QuotedStr(FormatDateTime('MM/dd/yyyy', cdsPedido.FieldByName('DTEMISSAO').AsDateTime)) + ',' + QuotedStr(edtCliente.Text) + ',' +
              QuotedStr(edtNumero.Text)+ ') RETURNING IDPEDIDOCAB';
      Conn.execQuery(Sql, Cds);
      cdsPedido.Edit;
      cdsPedido.FieldByName('IDPEDIDOCAB').AsString := Cds.FieldByName('IDPEDIDOCAB').AsString;
      cdsPedido.Post;
    finally
      FreeAndNil(Cds);
    end;

    cdsProdutos.First;
    while not cdsProdutos.Eof do
    begin
      Qtde       := cdsProdutos.FieldByName('QUANTIDADE').AsInteger;
      ValorUnit  := cdsProdutos.FieldByName('VALORUNIT').AsFloat;
      ValorTotal := cdsProdutos.FieldByName('VALORTOTAL').AsFloat;
      Sql := 'INSERT INTO PEDIDOITEM (IDITEM, QUANTIDADE, VALORUNIT, VALORTOTAL, IDPEDIDOCAB) VALUES ('+ QuotedStr(cdsProdutos.FieldByName('IDITEM').AsString) + ',' +
              QuotedStr(FloatToStr(Qtde)) + ',' + QuotedStr(FloatToStr(ValorUnit)) + ',' +QuotedStr(FloatToStr(ValorTotal)) + ',' +QuotedStr(cdsPedido.FieldByName('IDPEDIDOCAB').AsString)+')';

      Conn.execQuery(Sql);
      cdsProdutos.Next;
    end;

  end;

  try
    try

      ShowMessage('Opera??o Conclu?da');

      Status := Default;
      ControlaBotoes();

    except
      on E: Exception do
      ShowMessage(E.Message);
    end;

  finally
    FreeAndNil(Cds);
  end;

end;

procedure TFrmPedidos.calculaTotal;
begin
  cdsProdutos.FieldByName('VALORTOTAL').AsFloat := cdsProdutos.FieldByName('QUANTIDADE').AsFloat * cdsProdutos.FieldByName('VALORUNIT').AsFloat;
end;

procedure TFrmPedidos.controlaBotoes;
begin
  case Status of
    Insert:
    begin
      btnEditar.Enabled   := False;
      btnIncluir.Enabled  := False;
      btnExcluir.Enabled  := False;
      btnSalvar.Enabled   := False;
      rctDados.Enabled    := True;
    end;

    Edit:
    begin
      btnEditar.Enabled   := False;
      btnIncluir.Enabled  := False;
      btnExcluir.Enabled  := False;
      btnSalvar.Enabled   := True;
      rctDados.Enabled    := True;
    end;

    Default:
    begin
      btnEditar.Enabled   := True;
      btnIncluir.Enabled  := True;
      btnExcluir.Enabled  := True;
      btnSalvar.Enabled   := True;
      rctDados.Enabled    := False;
    end;

  end;
end;

procedure TFrmPedidos.edtCodExit(Sender: TObject);
begin
//  if (Status in [Edit, Insert]) then
//  begin
//    if not validaProduto() then
//    begin
//      (TEdit(Sender) as IControl).DoEnter;
//      abort
//    end;
//  end;
end;

procedure TFrmPedidos.edtCodKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
    validaProduto();
end;

procedure TFrmPedidos.edtQtdeExit(Sender: TObject);
begin
  TFloatField(cdsProdutos.FieldByName('QUANTIDADE')).DisplayFormat  :=  '###,###,##0.00';
  calculaTotal();
end;

procedure TFrmPedidos.edtValUnitExit(Sender: TObject);
begin
  TFloatField(cdsProdutos.FieldByName('VALORUNIT')).DisplayFormat  :=  '###,###,##0.00';
  calculaTotal();
end;

procedure TFrmPedidos.FormCreate(Sender: TObject);
begin
  IdPedido := '0';
  Conn           := TConnection.Create(self);
  Conn.conectar;
  Bind           := TBinds.Create(CdsProdutos);
  BindPedido     := TBinds.Create(cdsPedido);
  Status         := Default;
end;

procedure TFrmPedidos.FormShow(Sender: TObject);
var
Sql : string;
begin
  ControlaBotoes();

  Sql := 'SELECT P.IDITEM, I.DESCITEM, P.QUANTIDADE, P.VALORUNIT, P.VALORTOTAL FROM PEDIDOITEM AS P INNER JOIN ITEM AS I ON P.IDITEM = I.IDITEM WHERE P.IDITEM = ' + QuotedStr(IdPedido);
  Conn.execQuery(Sql, CdsProdutos);
  cdsProdutos.Fields.FindField('DESCITEM').ReadOnly := False;
  Sql := 'SELECT * FROM PEDIDOCAB WHERE IDPEDIDOCAB = ' + QuotedStr(IdPedido);
  Conn.execQuery(Sql, cdsPedido);

  if cdsPedido.IsEmpty = True then
    cdsPedido.Insert;

  BindCampos();
  grdProd.Columns[0].Width := 100;
  grdProd.Columns[1].Width := 164;
  grdProd.Columns[2].Width := 80;
  grdProd.Columns[3].Width := 100;
  grdProd.Columns[4].Width := 100;
end;

function TFrmPedidos.validaProduto: Boolean;
var
Sql : string;
CdsAux : TClientDataSet;
frmProdutos : TfrmProdutos;
begin
  Result := False;

  if edtCod.Text.Trim <> EmptyStr then
  begin
    try
      CdsAux := TClientDataSet.Create(nil);
      Sql := 'SELECT * FROM ITEM WHERE IDITEM = ' + QuotedStr(edtCod.Text);
      Conn.execQuery(Sql, CdsAux);
      if CdsAux.RecordCount > 0 then
      begin
        cdsProdutos.FieldByName('IDITEM').AsString   := CdsAux.FieldByName('IDITEM').AsString;
        cdsProdutos.FieldByName('DESCITEM').AsString := CdsAux.FieldByName('DESCITEM').AsString;
        Result := True;
      end
      else
        ShowMessage('N?o foi encontrado nenhum produto com esse c?digo.');
    finally
      FreeAndNil(CdsAux);
    end;

  end
  else
  begin
    try
      frmProdutos := TfrmProdutos.Create(nil);
      frmProdutos.Status := Browse;
      frmProdutos.ShowModal;
      if frmProdutos.ModalResult = mrOk then
      begin
        cdsProdutos.FieldByName('IDITEM').AsString   := frmProdutos.cdsProdutos.FieldByName('IDITEM').AsString;
        cdsProdutos.FieldByName('DESCITEM').AsString := frmProdutos.cdsProdutos.FieldByName('DESCITEM').AsString;
        Result := True;
      end;
    finally
      FreeAndNil(frmProdutos);
    end;
  end;


end;

end.
