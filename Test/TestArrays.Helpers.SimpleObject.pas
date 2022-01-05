unit TestArrays.Helpers.SimpleObject;

interface

type
  TSimpleObject = class(TObject)
  private
    FStringProp: string;
    FIntegerProp: Integer;

    function GetStringProp: string;
    function GetIntegerProp: Integer;

    procedure SetStringProp(const Value: string);
    procedure SetIntegerProp(const Value: Integer);
  public
    constructor Create(
      const StringProp: string;
      const IntegerProp: Integer
    );

    property StringProp: string read GetStringProp write SetStringProp;
    property IntegerProp: Integer read GetIntegerProp write SetIntegerProp;
  end;

implementation

{ TSimpleObject }

constructor TSimpleObject.Create(
  const StringProp: string;
  const IntegerProp: Integer);
begin
  inherited Create();

  FStringProp := StringProp;
  FIntegerProp := IntegerProp;
end;

function TSimpleObject.GetIntegerProp: Integer;
begin
  Result := FIntegerProp;
end;

function TSimpleObject.GetStringProp: string;
begin
  Result := FStringProp;
end;

procedure TSimpleObject.SetIntegerProp(const Value: Integer);
begin
  FIntegerProp := Value;
end;

procedure TSimpleObject.SetStringProp(const Value: string);
begin
  FStringProp := Value;
end;

end.
