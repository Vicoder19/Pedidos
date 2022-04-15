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
   end;

Implementation

constructor TFBGrid.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FBindingEditor := TBindListGridEditor.Create (Self);
end;

end.
