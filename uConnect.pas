unit uConnect;

interface
Uses
FireDAC.Phys.FB, FireDAC.Comp.Client, System.Classes, FireDAC.DApt, FireDAC.Stan.Def, Datasnap.Provider,
  Datasnap.DBClient;

type
TConnection = class(TComponent)
  FBDriver: TFDPhysFBDriverLink;
  Conn: TFDConnection;
  Trans : TFDTransaction;
  Provider : TDataSetProvider;
  public
  function conectar() : Boolean;
  function execQuery(pSQL : string; pCds : TClientDataSet) : boolean;
  constructor Create(AOwner: TComponent); override;
  destructor Destroy();
end;

implementation

uses
  System.SysUtils, FMX.Dialogs;
{ Conect }

function TConnection.conectar: Boolean;
var
path : string;
begin
  Conn.Transaction := Trans;
  FBDriver.VendorLib   := '.\fbclient.dll';
  Conn.Params.Add('DriverID=FB');
  Conn.Params.Add('CharacterSet=win1251');
  path := GetCurrentDir();
  Conn.Params.Add('Database=' + path + '\DataBase\DB.FDB');
  Conn.Params.Add('User_Name=SYSDBA');
  Conn.Params.Add('Password=masterkey');
  Conn.Connected := True;

end;

constructor TConnection.Create(AOwner: TComponent);
begin
  inherited;
  Conn     := TFDConnection.Create(self);
  FBDriver := TFDPhysFBDriverLink.Create(self);
  Trans    := TFDTransaction.Create(self);

end;

destructor TConnection.Destroy;
begin
  if Conn.Connected then
    Conn.Connected := False;

  FreeAndNil(Conn);
  FreeAndNil(FBDriver);
  FreeAndNil(Trans);
end;

function TConnection.execQuery(pSQL : string; pCds : TClientDataSet) : boolean;
var
  Query : TFDQuery;
begin
  try
    Query := TFDQuery.Create(nil);

    Query.Connection := Conn;
    Query.Transaction := Conn.Transaction;
    Query.SQL.Text := pSQL;

    Query.Open(pSQL);

    Provider.DataSet := Query;
    pCds.Data := Provider.Data;

  finally
    Freeandnil(Query);
  end;

end;

end.