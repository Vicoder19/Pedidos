unit uConnect;

interface
Uses
FireDAC.Phys.FB, FireDAC.Comp.Client, System.Classes, FireDAC.DApt, FireDAC.Stan.Def, Datasnap.Provider,
  Datasnap.DBClient, System.StrUtils;

type
TStatus = (Insert, Edit, Default, Browse);
TConnection = class(TComponent)
  FBDriver: TFDPhysFBDriverLink;
  Conn: TFDConnection;
  Trans : TFDTransaction;
  Provider : TDataSetProvider;
  public
  function conectar() : Boolean;
  function execQuery(pSQL : string; pCds : TClientDataSet = nil) : boolean;
  function nextId(pTabela, pCampo : string) : Integer;
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
  Provider := TDataSetProvider.Create(Self);

end;

destructor TConnection.Destroy;
begin
  if Conn.Connected then
    Conn.Connected := False;

  FreeAndNil(Conn);
  FreeAndNil(FBDriver);
  FreeAndNil(Trans);
end;

function TConnection.execQuery(pSQL : string; pCds : TClientDataSet = nil) : boolean;
var
  Query : TFDQuery;
begin
  try
    Query := TFDQuery.Create(nil);
    Query.Transaction := Conn.Transaction;
    Query.Connection := Conn;
    Query.SQL.Text := pSQL;

    if (AnsiContainsStr(pSQL,'RETURNING')) or (AnsiContainsStr(pSQL, 'SELECT')) then
    begin
      Query.Open(pSQL);
      Provider.DataSet := Query;
      pCds.Data        := Provider.Data;
    end
    else
      Query.ExecSQL;

  finally
    Freeandnil(Query);
  end;

end;

function TConnection.nextId(pTabela, pCampo: string): Integer;
var
Sql : string;
Cds : TClientDataSet;
begin
  try
    Cds := TClientDataSet.Create(nil);
    Sql := 'SELECT MAX(' + pCampo + ') FROM ' + pTabela;
    execQuery(Sql, Cds);
    Result := Cds.FieldByName(pCampo).AsInteger + 1;
  finally
    FreeAndNil(Cds);
  end;

end;

end.
