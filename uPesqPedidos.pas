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
    procedure FormShow(Sender: TObject);
    procedure grdPedidosDblClick(Sender: TObject);
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

procedure TFrmPesqPedidos.FormShow(Sender: TObject);
var
Sql : string;
begin
  Sql := 'SELECT * FROM ITEM';
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
    FrmPedido.cdsProdutos.Data := cdsPedidos.Data;
    FrmPedido.Pesquisa := True;
    FrmPedido.ShowModal;
  finally

  end;
end;

end.
