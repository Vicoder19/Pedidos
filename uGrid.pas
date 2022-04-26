unit uGrid;
interface

uses
   Fmx.Bind.Editors, FMX.Grid, System.Classes;

type
   TFBGrid = class (TGrid)
   private
    FBindingEditor: TBindListGridEditor;
   public
     constructor Create (AOwner: TComponent); override;
     function TruncMoney(const Valor: Currency; const Casas: Integer): Currency;
   end;

Implementation

constructor TFBGrid.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FBindingEditor := TBindListGridEditor.Create (Self);
end;

function TruncMoney(const Valor: Currency;
  const Casas: Integer): Currency;
var
  ValorS: String;
  NumInt, NumFrac, Num: String;
  Y: Integer;
begin
  Result := 0;
  ValorS := CurrToStr(Valor);
  //Pegar a parte fracionária
  Y := Pos(DecimalSeparator, ValorS);
  if Y > 0 then
  begin
    NumInt := Copy(ValorS, 1, Y - 1);
    NumFrac := Copy(ValorS, Y + 1, Casas);
  end//if
  else
  begin
    NumInt := ValorS;
    NumFrac := '';
  end;//if

  //Preenche com zeros se necessário
  while Length(NumFrac) < Casas do
    NumFrac := NumFrac + '0';

  Num := NumInt;
  if Trim(NumFrac) <> '' then
    Num := Num + ',' + NumFrac;

  if not TryStrToCurr(Num, Result) then
    raise Exception.Create(QuotedStr(Num) + ' não é um valor monetário valido.');
end;

end.
