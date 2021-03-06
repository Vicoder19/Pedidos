unit uBinds;

interface

uses
  Data.Bind.DBScope, Data.Bind.Components, System.Classes, Datasnap.DBClient;

type
TBinds = class
  BindSource           : TBindSourceDB;
  LinkControlToField   : TLinkControlToField;
  LinkPropertyToField  : TLinkPropertyToField;
  BindingsList         : TBindingsList;
public
  constructor Create(pDataSet : TClientDataSet);
  destructor Destroy; override;

  procedure BindControlToField(pControl: TComponent; pField : string);
  procedure BindPropertyToField(pControl: TComponent; pField, pProperty: string);
  procedure AtivaBind(pValue : Boolean);

end;

implementation

uses
  System.SysUtils;

{ TBinds }

procedure TBinds.AtivaBind(pValue: Boolean);
var
i : integer;
begin
  with BindingsList do
  begin
    for I := 0 to ComponentCount -1 do
    begin

      if Components[i] is TLinkControlToField then
        TLinkControlToField(Components[i]).Active := pValue;

      if Components[i] is TLinkPropertyToField then
        TLinkPropertyToField(Components[i]).Active := pValue;

    end;
  end;
end;

procedure TBinds.BindControlToField(pControl: TComponent; pField: string);
begin
  LinkControlToField              := TLinkControlToField.Create(BindingsList);

  LinkControlToField.Name         := 'lcfi_' + pControl.Name;
  LinkControlToField.Control      := pControl;
  LinkControlToField.DataSource   := BindSource;
  LinkControlToField.FieldName    := pField;
  LinkControlToField.CustomParse  := '';
  LinkControlToField.CustomFormat := '';
  LinkControlToField.AutoActivate := true;

end;

procedure TBinds.BindPropertyToField(pControl: TComponent; pField, pProperty: string);
begin
  LinkPropertyToField      := TLinkPropertyToField.Create(BindingsList);
  LinkPropertyToField.Name := 'lpfi_' + pControl.Name + '_' + pProperty.Replace('[','').Replace(']','').Replace('.','');

  LinkPropertyToField.ComponentProperty := pProperty;
  LinkPropertyToField.FieldName         := pField;
  LinkPropertyToField.Component         := pControl;
  LinkPropertyToField.DataSource        := BindSource;
  LinkPropertyToField.CustomFormat      := '';
end;

constructor TBinds.Create(pDataSet: TClientDataSet);
begin
  BindSource := TBindSourceDB.Create(nil);

  if assigned(pDataSet) then
  begin
    BindSource.DataSet            := (pDataSet);
    BindSource.DataSource.Enabled := true;
  end;

  BindingsList := TBindingsList.Create(BindSource);
end;

destructor TBinds.Destroy;
begin
  if Assigned(BindSource) then
    FreeAndNil(BindSource);

  inherited;
end;

end.
