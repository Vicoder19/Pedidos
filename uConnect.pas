unit uConnect;

interface
Uses
FireDAC.Phys.FB, FireDAC.Comp.Client, System.Classes, FireDAC.DApt, FireDAC.Stan.Def;

type
TConnection = class(TComponent)
  FBDriver: TFDPhysFBDriverLink;
  Conn: TFDConnection;
  Trans : TFDTransaction;
  public
  function conectar() : Boolean;
  function execQuery(pSQL : string) : boolean;
  constructor Create(AOwner: TComponent); override;
  destructor Destroy();
end;

implementation

uses
  System.SysUtils, FMX.Dialogs;
{ Conect }

function TConnection.conectar: Boolean;
begin
  Conn := TFDConnection.Create(self);
  FBDriver := TFDPhysFBDriverLink.Create(self);
  Trans := TFDTransaction.Create(self);
  Conn.Transaction := Trans;
  FBDriver.VendorLib   := '.\fbclient.dll';
  Conn.Params.Add('DriverID=FB');
  Conn.Params.Add('Server=localhost');
  Conn.Params.Add('Database=D:\AulasDelphi\Pedidos\DataBase\DB.IB');
  Conn.Params.Add('User_Name=sysdba');
  Conn.Params.Add('Password=masterkey');
  Conn.Open();
  Conn.Connected := True;

end;

constructor TConnection.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TConnection.Destroy;
begin

end;

function TConnection.execQuery(pSQL: string): boolean;
var
  Query : TFDQuery;
begin
  try
    try
      Query := TFDQuery.Create(nil);
      Query.Connection := Conn;
      Query.Transaction := Conn.Transaction;
      Query.SQL.Text := 'SELECT * FROM ITEM';
      Query.ExecSQL;
    except
      on E : Exception do
      Showmessage(E.Message);
    end;

  finally
    Freeandnil(Query);
  end;

end;

end.
