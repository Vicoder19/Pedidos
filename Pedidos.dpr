program Pedidos;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMenuPrincipal in 'uMenuPrincipal.pas' {frmMenu},
  uConnect in 'uConnect.pas',
  uBinds in 'uBinds.pas',
  uProdutos in 'uProdutos.pas' {frmProdutos},
  uPedidos in 'uPedidos.pas' {FrmPedidos},
  uPesqPedidos in 'uPesqPedidos.pas' {FrmPesqPedidos};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMenu, frmMenu);
  Application.Run;
end.
