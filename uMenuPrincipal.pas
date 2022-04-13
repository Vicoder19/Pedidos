unit uMenuPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus,
  FMX.Controls.Presentation, FMX.StdCtrls, uConnect;

type
  TForm4 = class(TForm)
    mm1: TMainMenu;
    Menu: TMenuItem;
    miPedidos: TMenuItem;
    miItens: TMenuItem;
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  Form4: TForm4;
  Conexao : TConnection;

implementation

{$R *.fmx}

{ TForm4 }

procedure TForm4.btn1Click(Sender: TObject);
begin
  Conexao := TConnection.Create(Self);
  Conexao.conectar;
  Conexao.execQuery('Teste');
end;

end.





