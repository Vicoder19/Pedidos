unit uPesqPedidos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, FMX.StdCtrls, FMX.DateTimeCtrls, Data.Bind.Components,
  Data.Bind.DBScope, Data.DB, Datasnap.DBClient, Data.Bind.Grid, System.Actions,
  FMX.ActnList, FMX.Layouts, FMX.Grid, FMX.Controls.Presentation, FMX.Edit,
  uConnect;

type
  TFrmPesqPedidos = class(TForm)
    edtDescricao: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    grdPedidos: TGrid;
    ActionList1: TActionList;
    actSair: TAction;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    cdsPedidos: TClientDataSet;
    BSPedidos: TBindSourceDB;
    dtData1: TDateEdit;
    dtData2: TDateEdit;
    edtCod: TEdit;
    btnfiltrar: TButton;
    Label3: TLabel;
    edtCliente: TEdit;
    Label4: TLabel;
    chbFiltrarData: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure grdPedidosDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnfiltrarClick(Sender: TObject);
    procedure grdPedidosKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
  private
  Conn : TConnection;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPesqPedidos: TFrmPesqPedidos;

implementation

{$R *.fmx}

uses uPedidos;

procedure TFrmPesqPedidos.btnfiltrarClick(Sender: TObject);
var
Filtro : string;
begin
  cdsPedidos.Filtered := False;
  Filtro := ' NUMERO <> 0 ';

  if edtCod.Text.Trim <> EmptyStr then
    Filtro := Filtro + ' AND IDITEM = ' + QuotedStr(edtCod.Text);

  if chbFiltrarData.IsChecked then
    Filtro := Filtro + ' AND DTEMISSAO >= ' + QuotedStr(FormatDateTime('MM/dd/yyyy', dtData1.Date)) + ' AND DTEMISSAO <=' + QuotedStr(FormatDateTime('MM/dd/yyyy', dtData2.Date));

  if edtCliente.Text.Trim <> EmptyStr then
    Filtro := Filtro + ' AND CLIENTE LIKE ' + QuotedStr('%' + edtCliente.Text + '%');

  cdsPedidos.Filter := Filtro;
  cdsPedidos.Filtered := True;
end;

procedure TFrmPesqPedidos.FormCreate(Sender: TObject);
begin
  Conn           := TConnection.Create(self);
  Conn.conectar;
end;

procedure TFrmPesqPedidos.FormShow(Sender: TObject);
var
Sql : string;
begin
  Sql := 'SELECT * FROM PEDIDOCAB INNER JOIN PEDIDOITEM ON PEDIDOCAB.IDPEDIDOCAB = PEDIDOITEM.IDPEDIDOCAB ';
  Conn.execQuery(Sql, cdsPedidos);
  grdPedidos.Columns[0].Width := 100;
  grdPedidos.Columns[1].Width := 220;
end;

procedure TFrmPesqPedidos.grdPedidosDblClick(Sender: TObject);
var
FrmPedido : TFrmPedidos;
begin
  try
    FrmPedido := TFrmPedidos.Create(nil);
    FrmPedido.IdPedido := cdsPedidos.FieldByName('IDPEDIDOCAB').AsString;
    FrmPedido.Status := Browse;
    FrmPedido.ShowModal;
  finally

  end;
end;

procedure TFrmPesqPedidos.grdPedidosKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
    grdPedidosDblClick(Sender);
end;

end.
