unit Delphi.Arrays;

interface

uses
  Delphi.Arrays.Interfaces.IArray
;

type
  TArrays<T> = class(TInterfacedObject, IArray<T>)
  strict private
    FItems: TArray<T>;

    constructor Create(const NewArray: TArray<T> = []);
    function GetValue(const Index: Integer): T;
  public
    class function From(const NewArray: TArray<T> = []): IArray<T>;

    function Map(const Callback: TMapCallbackFn<T>): IArray<T>; overload;
    function Map(const Callback: TMapCallbackFnElement<T>): IArray<T>; overload;
    function Map(const Callback: TMapCallbackFnElementIndex<T>): IArray<T>; overload;

    function Fill(const Value: T; startIndex: Integer; endIndex: Integer): IArray<T>; overload;
    function Fill(const Value: T; startIndex: Integer): IArray<T>; overload;
    function Fill(const Value: T): IArray<T>; overload;

    function Every(const Callback: TCallbackFn<T>): Boolean; overload;
    function Every(const Callback: TCallbackFnElementIndex<T>): Boolean; overload;
    function Every(const Callback: TCallbackFnElement<T>): Boolean; overload;

    function Filter(const Callback: TCallbackFn<T>): IArray<T>; overload;
    function Filter(const Callback: TCallbackFnElementIndex<T>): IArray<T>; overload;
    function Filter(const Callback: TCallbackFnElement<T>): IArray<T>; overload;

    function Concat(const Value: T): IArray<T>;

    function Reverse(): IArray<T>;
    function Pop(): IArray<T>;
    function Lenght(): Integer;
    function ToArray(): TArray<T>;

    property Items[const Index: Integer]: T read GetValue;
  end;

implementation


{ TArrays<T> }

function TArrays<T>.Concat(const Value: T): IArray<T>;
begin
  const NewLength = Length(FItems) + 1;
  SetLength(FItems, NewLength);
  FItems[NewLength-1] := Value;
  Result := Self;
end;

constructor TArrays<T>.Create(const NewArray: TArray<T>);
begin
  FItems := NewArray;
end;

function TArrays<T>.Fill(const Value: T; startIndex, endIndex: Integer): IArray<T>;
begin
  var FromIndex := startIndex;
  var ToIndex := EndIndex;

  if FromIndex < 0 then
    FromIndex := 0;

  if ToIndex < 0 then
    Exit(Self);

  if ToIndex > Length(FItems) then
    ToIndex := Length(FItems) - 1;

  for var i := FromIndex to ToIndex do
    FItems[i] := Value;

  Result := Self;
end;

function TArrays<T>.Every(const Callback: TCallbackFn<T>): Boolean;
begin
  for var i := 0 to Length(FItems)-1 do
  begin
    Result := Callback(FItems[i], i, FItems);

    if not Result then
      Break;
  end;
end;

function TArrays<T>.Every(const Callback: TCallbackFnElement<T>): Boolean;
begin
  Result :=
    Self.Every(
      function(Item: T; Index: Integer; const Items: TArray<T>): Boolean
      begin
        Result := Callback(Item);
      end
    );
end;

function TArrays<T>.Every(const Callback: TCallbackFnElementIndex<T>): Boolean;
begin
  Result :=
    Self.Every(
      function(Item: T; Index: Integer; const Items: TArray<T>): Boolean
      begin
        Result := Callback(Item, Index);
      end
    );
end;

function TArrays<T>.Fill(const Value: T): IArray<T>;
begin
  Result := Self.Fill(Value, 0, Length(FItems)-1);
end;

function TArrays<T>.Filter(const Callback: TCallbackFn<T>): IArray<T>;
begin
  var NewArray: TArray<T> := [];
  var NewArrayLength := 0;
  for var i := 0 to Length(FItems) - 1 do
  begin
    if Callback(FItems[i], i, FItems) then
    begin
      Inc(NewArrayLength);
      SetLength(NewArray, NewArrayLength);
      NewArray[NewArrayLength-1] := FItems[i];
    end;
  end;
  FItems := NewArray;
  Result := Self;
end;

function TArrays<T>.Filter(const Callback: TCallbackFnElementIndex<T>): IArray<T>;
begin
  Result := Self.Filter(
    function(Element: T; Index: Integer; const Elements: TArray<T>): Boolean
    begin
      Result := Callback(Element, Index);
    end
  );
end;

function TArrays<T>.Filter(const Callback: TCallbackFnElement<T>): IArray<T>;
begin
  Result := Self.Filter(
    function(Element: T; Index: Integer; const Elements: TArray<T>): Boolean
    begin
      Result := Callback(Element);
    end
  );
end;

function TArrays<T>.Fill(const Value: T; startIndex: Integer): IArray<T>;
begin
  Result := Self.Fill(Value, startIndex, Length(FItems)-1);
end;

class function TArrays<T>.From(const NewArray: TArray<T>): IArray<T>;
begin
  Result := TArrays<T>.Create(NewArray);
end;

function TArrays<T>.ToArray: TArray<T>;
begin
  Result := FItems;
end;

function TArrays<T>.GetValue(const Index: Integer): T;
begin
  Result := FItems[Index];
end;

function TArrays<T>.Lenght: Integer;
begin
  Result := Length(FItems);
end;

function TArrays<T>.Map(const Callback: TMapCallbackFnElementIndex<T>): IArray<T>;
begin
  Result := Self.Map(
    function(const Element: T; const Index: Integer; const Elements: TArray<T>): T
    begin
      Result := Callback(Element, Index);
    end
  );
end;

function TArrays<T>.Map(const Callback: TMapCallbackFnElement<T>): IArray<T>;
begin
  Result := Self.Map(
    function(const Element: T; const Index: Integer; const Elements: TArray<T>): T
    begin
      Result := Callback(Element);
    end
  );
end;

function TArrays<T>.Map(const Callback: TMapCallbackFn<T>): IArray<T>;
begin
  for var i := 0 to Length(FItems) -1 do
    FItems[i] := Callback(FItems[i], i, FItems);

  Result := Self;
end;

function TArrays<T>.Pop: IArray<T>;
begin
  const Count = Length(FItems);

  if Count = 0 then
    Exit(Self);

  var NewArray: TArray<T> := [];
  if Count = 1 then
  begin
    FItems := NewArray;
    Exit(Self);
  end;

  SetLength(NewArray, Count-1);
  for var i := 0 to Count-2 do
    NewArray[i] := FItems[i];

  FItems := NewArray;
  Result := Self;
end;

function TArrays<T>.Reverse: IArray<T>;
begin
  var NewArray: TArray<T> := [];
  const Count = Length(FItems) - 1;
  SetLength(NewArray, Length(FItems));

  for var i := 0 to Count do
    NewArray[i] := FItems[Count-i];

  FItems := NewArray;
  Result := Self;
end;

end.
