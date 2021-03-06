unit uMenuPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus,
  FMX.Controls.Presentation, FMX.StdCtrls, uConnect, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client;

type
  TfrmMenu = class(TForm)
    mm1: TMainMenu;
    Menu: TMenuItem;
    miPedidos: TMenuItem;
    miItens: TMenuItem;
    miPesqPedidos: TMenuItem;
    procedure miItensClick(Sender: TObject);
    procedure miPedidosClick(Sender: TObject);
    procedure miPesqPedidosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  frmMenu: TfrmMenu;
  Conexao : TConnection;

implementation

uses
  Datasnap.DBClient, uProdutos, uPedidos, uPesqPedidos;

{$R *.fmx}

{ TForm4 }

procedure TfrmMenu.miItensClick(Sender: TObject);
var
frmProdutos : TfrmProdutos;
begin
  try
    frmProdutos := TfrmProdutos.Create(nil);
    frmProdutos.Status := TStatus.Default;
    frmProdutos.ShowModal;
  finally
    FreeAndNil(frmProdutos);
  end;

end;

procedure TfrmMenu.miPedidosClick(Sender: TObject);
var
frmPedidos : TFrmPedidos;
begin
  try
    frmPedidos        := TFrmPedidos.Create(nil);
    frmPedidos.Status := TStatus.Default;
    frmPedidos.ShowModal;
  finally
    FreeAndNil(frmPedidos);
  end;
end;

procedure TfrmMenu.miPesqPedidosClick(Sender: TObject);
var
frmPedidos : TFrmPesqPedidos;
begin
  try
    frmPedidos        := TFrmPesqPedidos.Create(nil);
    //frmPedidos.Status := TStatus.Default;
    frmPedidos.ShowModal;
  finally
    FreeAndNil(frmPedidos);
  end;

end;

end.






