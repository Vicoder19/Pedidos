unit uProdutos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.StdCtrls, FMX.Layouts, FMX.Grid, FMX.Controls.Presentation, FMX.Edit, uConnect, uMenuPrincipal, uBinds,
  Datasnap.DBClient, System.Actions, FMX.ActnList, Data.Bind.Grid,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,
  uGrid, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, Data.DB;

type
  TfrmProdutos = class(TForm)
    edtDescricao: TEdit;
    Label1: TLabel;
    btnIncluir: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    btnSalvar: TButton;
    Label2: TLabel;
    ActionList1: TActionList;
    actSair: TAction;
    BindingsList1: TBindingsList;
    grdProd: TGrid;
    cdsProdutos: TClientDataSet;
    BSprodutos: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure actSairExecute(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
  private
    Conn : TConnection;
    Bind : TBinds;
    BSProdutos2 : TBindSourceDB;
    LinkGrid : TLinkGridToDataSource;
    procedure BindCampos();
    procedure BindGrid();
    procedure ControlaBotoes();
    { Private declarations }
  public
    { Public declarations }
  Status : TStatus;
  end;


implementation

{$R *.fmx}

procedure TfrmProdutos.actSairExecute(Sender: TObject);
begin
  if (Status in [Insert, Edit]) then
  begin
    CdsProdutos.Cancel;
    Status := Default;
    ControlaBotoes();
  end;

end;

procedure TfrmProdutos.BindCampos;
begin
  Bind.BindControlToField(edtDescricao, 'DESCITEM');
  Bind.AtivaBind(True);
end;

procedure TfrmProdutos.BindGrid;
begin
end;

procedure TfrmProdutos.btnEditarClick(Sender: TObject);
begin
  if CdsProdutos.RecordCount > 0 then
  begin
    Status := Edit;
    ControlaBotoes();
    CdsProdutos.Edit;
    edtDescricao.SetFocus;
  end;
end;

procedure TfrmProdutos.btnIncluirClick(Sender: TObject);
begin
  Status := Insert;
  ControlaBotoes();
  CdsProdutos.Append;
  edtDescricao.SetFocus;
end;

procedure TfrmProdutos.btnSalvarClick(Sender: TObject);
var
Sql : string;
Cds : TClientDataSet;
begin
  try
    try
      Cds := TClientDataSet.Create(nil);

      if Status = Insert then
        Sql := 'INSERT INTO ITEM(DESCITEM) VALUES ('+QuotedStr(edtDescricao.Text)+') RETURNING IDITEM'
      else
        Sql := 'UPDATE ITEM SET DESCITEM = '+ QuotedStr(edtDescricao.Text) +
               ' WHERE IDITEM = '+ QuotedStr(CdsProdutos.FieldByName('IDITEM').AsString);

      Conn.execQuery(Sql, Cds);

      if Status = Insert then
        CdsProdutos.FieldByName('IDITEM').AsString := Cds.FieldByName('IDITEM').AsString;

      ShowMessage('Opera��o Conclu�da');

      CdsProdutos.Post;

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

procedure TfrmProdutos.ControlaBotoes;
begin
  case Status of
    Insert:
    begin
      btnEditar.Enabled  := False;
      btnIncluir.Enabled := False;
      btnExcluir.Enabled := False;
      btnSalvar.Enabled  := True;
    end;
    Edit:
    begin
      btnEditar.Enabled  := False;
      btnIncluir.Enabled := False;
      btnExcluir.Enabled := False;
      btnSalvar.Enabled  := True;
    end;
    Default:
    begin
      btnEditar.Enabled  := True;
      btnIncluir.Enabled := True;
      btnExcluir.Enabled := True;
      btnSalvar.Enabled  := False;
    end;

  end;

end;

procedure TfrmProdutos.FormCreate(Sender: TObject);
var
Sql : string;
begin
  Conn           := TConnection.Create(self);
  Conn.conectar;
  Bind           := TBinds.Create(CdsProdutos);
  Status         := Default;
end;

procedure TfrmProdutos.FormShow(Sender: TObject);
var
Sql : string;
begin
  ControlaBotoes();
  Sql := 'SELECT * FROM ITEM';
  Conn.execQuery(Sql, CdsProdutos);
  BindCampos();
  grdProd.Columns[0].Width := 100;
  grdProd.Columns[1].Width := 220;
end;

end.
