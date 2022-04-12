program Pedidos;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMenuPrincipal in 'uMenuPrincipal.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
