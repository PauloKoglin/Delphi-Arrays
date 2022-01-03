unit Delphi.Arrays;

interface

uses
  Delphi.Arrays.Interfaces.IArray
  , Delphi.Arrays.Interfaces.CallbackFn
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

    function Fill(const Value: T; const StartIndex: Integer; const EndIndex: Integer): IArray<T>; overload;
    function Fill(const Value: T; const StartIndex: Integer): IArray<T>; overload;
    function Fill(const Value: T): IArray<T>; overload;

    function Every(const Callback: TCallbackFn<T>): Boolean; overload;
    function Every(const Callback: TCallbackFnElementIndex<T>): Boolean; overload;
    function Every(const Callback: TCallbackFnElement<T>): Boolean; overload;

    function Filter(const Callback: TCallbackFn<T>): IArray<T>; overload;
    function Filter(const Callback: TCallbackFnElementIndex<T>): IArray<T>; overload;
    function Filter(const Callback: TCallbackFnElement<T>): IArray<T>; overload;

    function Concat(const Value: T): IArray<T>; overload;
    function Concat(const Values: TArray<T>): IArray<T>; overload;

    function Push(const Element: T): Integer; overload;
    function Push(const Elements: TArray<T>): Integer; overload;

    function Slice(const StartIndex: Integer; const EndIndex: Integer): IArray<T>; overload;
    function Slice(const StartIndex: Integer = 0): IArray<T>; overload;

    function Unshift(const Element: T): Integer; overload;
    function Unshift(const Elements: TArray<T>): Integer; overload;

    procedure ForEach(const Callback: TForEachCallbackFn<T>); overload;
    procedure ForEach(const Callback: TForEachCallbackFnElementIndex<T>); overload;
    procedure ForEach(const Callback: TForEachCallbackFnElement<T>); overload;

    function Reduce(const Callback: TReduceCallbackFn<T,T>): T; overload;
    function Reduce(const Callback: TReduceCallbackFn<T,T>; const InitialValue: T): T; overload;
    function Reduce(const Callback: TReduceCallbackFnWithCurrentIndex<T,T>): T; overload;
    function Reduce(const Callback: TReduceCallbackFnWithCurrentIndex<T,T>; const InitialValue: T): T; overload;
    function Reduce(const Callback: TReduceCallbackFnWithPreviousAndCurrentValue<T,T>): T; overload;
    function Reduce(const Callback: TReduceCallbackFnWithPreviousAndCurrentValue<T,T>; const InitialValue: T): T; overload;

    function ReduceString(const Callback: TReduceCallbackFn<T,string>; const InitialValue: string = ''): string; overload;
    function ReduceString(const Callback: TReduceCallbackFnWithCurrentIndex<T,string>; const InitialValue: string = ''): string; overload;

    function ReduceInteger(const Callback: TReduceCallbackFn<T,Integer>; const InitialValue: Integer = 0): Integer;
    function ReduceDouble(const Callback: TReduceCallbackFn<T,Double>; const InitialValue: Double = 0): Double;

    function Join(const Separator: String = ','): string;
    function Reverse(): IArray<T>;
    function Pop(): IArray<T>;
    function Shift(): IArray<T>;
    function Count(): Integer;
    function ToArray(): TArray<T>;

    property Values[const Index: Integer]: T read GetValue;
  end;

implementation

uses
  RTTI
;

{ TArrays<T> }

function TArrays<T>.Concat(const Value: T): IArray<T>;
begin
  const NewLength = Length(FItems) + 1;
  SetLength(FItems, NewLength);
  FItems[NewLength-1] := Value;
  Result := Self;
end;

function TArrays<T>.Concat(const Values: TArray<T>): IArray<T>;
begin
  const MaxIndex = Length(FItems) - 1;
  const NewLength = Length(FItems) + Length(Values);
  SetLength(FItems, NewLength);

  for var i := 1 to Length(Values) do
    FItems[MaxIndex+i] := Values[i-1];

  Result := Self;
end;

constructor TArrays<T>.Create(const NewArray: TArray<T>);
begin
  FItems := NewArray;
end;

function TArrays<T>.Fill(const Value: T; const StartIndex, EndIndex: Integer): IArray<T>;
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

procedure TArrays<T>.ForEach(const Callback: TForEachCallbackFnElementIndex<T>);
begin
  Self.ForEach(
    procedure(const Element: T; const Index: Integer; const Elements: TArray<T>)
    begin
      Callback(Element, Index);
    end
  );
end;

procedure TArrays<T>.ForEach(const Callback: TForEachCallbackFn<T>);
begin
  for var i := 0 to Length(FItems)-1 do
    Callback(FItems[i], i, FItems);
end;

function TArrays<T>.Fill(const Value: T; const StartIndex: Integer): IArray<T>;
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

function TArrays<T>.Unshift(const Elements: TArray<T>): Integer;
begin
  const CurrentLength = Length(FItems);
  const NewElementsLength = Length(Elements);
  if NewElementsLength = 0 then
    Exit(CurrentLength);

  var NewArray: TArray<T> := [];
  SetLength(NewArray, CurrentLength + NewElementsLength);

  for var i := 0 to NewElementsLength-1 do
    NewArray[i] := Elements[i];

  const StartIndex = NewElementsLength;
  for var i := 0 to CurrentLength-1 do
    NewArray[StartIndex+i] := FItems[i];

  FItems := NewArray;
  Result := Length(FItems);
end;

function TArrays<T>.Unshift(const Element: T): Integer;
begin
  var NewArray: TArray<T> := [];
  SetLength(NewArray, Length(FItems)+1);

  NewArray[0] := Element;
  for var i := 0 to Length(FItems)-1 do
    NewArray[i+1] := FItems[i];

  FItems := NewArray;
  Result := Length(FItems);
end;

function TArrays<T>.GetValue(const Index: Integer): T;
begin
  Result := FItems[Index];
end;

function TArrays<T>.Join(const Separator: String): string;
begin
  if Length(FItems) = 0 then
    Exit('');

  Result := TValue.From<T>(FItems[0]).ToString();
  for var i := 1 to Length(FItems)-1 do
    Result := Result + Separator + TValue.From<T>(FItems[i]).ToString();
end;

function TArrays<T>.Push(const Element: T): Integer;
begin
  const NewArray: IArray<T> = Self.Concat(Element);
  Result := NewArray.Count;
end;

function TArrays<T>.Count: Integer;
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

function TArrays<T>.Push(const Elements: TArray<T>): Integer;
begin
  const NewArray: IArray<T> = Self.Concat(Elements);
  Result := NewArray.Count;
end;

function TArrays<T>.Reduce(const Callback: TReduceCallbackFn<T,T>): T;
begin
  Result := Callback(FItems[0], FItems[1], 1, FItems);
  for var i := 2 to Length(FItems)-1 do
    Result := Callback(Result, FItems[i], i, FItems);
end;

function TArrays<T>.Reduce(const Callback: TReduceCallbackFn<T, T>; const InitialValue: T): T;
begin
  Result := Callback(InitialValue, FItems[0], 0, FItems);
  for var i := 1 to Length(FItems)-1 do
    Result := Callback(Result, FItems[i], i, FItems);
end;

function TArrays<T>.Reduce(const Callback: TReduceCallbackFnWithCurrentIndex<T, T>): T;
begin
  Result := Self.Reduce(
    function(const PreviousValue: T; const CurrentValue: T; const CurrentIndex: Integer; const Elements: TArray<T>): T
    begin
      Result := Callback(PreviousValue, CurrentValue, CurrentIndex);
    end
  );
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

function TArrays<T>.Shift: IArray<T>;
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
  for var i := 1 to Count-1 do
    NewArray[i-1] := FItems[i];

  FItems := NewArray;
  Result := Self;
end;

function TArrays<T>.Slice(const StartIndex: Integer): IArray<T>;
begin
  Result := Self.Slice(StartIndex, Length(FItems));
end;

function TArrays<T>.Slice(const StartIndex, EndIndex: Integer): IArray<T>;
begin
  const Count = Length(FItems);
  var NewArray: TArray<T> := [];

  var FromIndex := StartIndex;
  if FromIndex < 0 then
    FromIndex := 0;

  var ToIndex := EndIndex;
  if (Count-1 < ToIndex) or (ToIndex < 0) then
    ToIndex := Count;

  SetLength(NewArray, ToIndex - FromIndex);
  var Index: Integer := 0;
  for var i := FromIndex to ToIndex-1 do
  begin
    NewArray[Index] := FItems[i];
    Inc(Index);
  end;

  Result := TArrays<T>.From(NewArray);
end;

procedure TArrays<T>.ForEach(const Callback: TForEachCallbackFnElement<T>);
begin
  Self.ForEach(
    procedure(const Element: T; const Index: Integer; const Elements: TArray<T>)
    begin
      Callback(Element);
    end
  );
end;

function TArrays<T>.Reduce(
  const Callback: TReduceCallbackFnWithCurrentIndex<T, T>;
  const InitialValue: T): T;
begin
  Result := Self.Reduce(
    function(const PreviousValue: T; const CurrentValue: T; const CurrentIndex: Integer; const Elements: TArray<T>): T
    begin
      Result := Callback(PreviousValue, CurrentValue, CurrentIndex);
    end,
    InitialValue
  );
end;

function TArrays<T>.Reduce(const Callback: TReduceCallbackFnWithPreviousAndCurrentValue<T, T>): T;
begin
  Result := Self.Reduce(
    function(const PreviousValue: T; const CurrentValue: T; const CurrentIndex: Integer; const Elements: TArray<T>): T
    begin
      Result := Callback(PreviousValue, CurrentValue);
    end
  );
end;

function TArrays<T>.Reduce(const Callback: TReduceCallbackFnWithPreviousAndCurrentValue<T, T>; const InitialValue: T): T;
begin
  Result := Self.Reduce(
    function(const PreviousValue: T; const CurrentValue: T; const CurrentIndex: Integer; const Elements: TArray<T>): T
    begin
      Result := Callback(PreviousValue, CurrentValue);
    end,
    InitialValue
  );
end;

function TArrays<T>.ReduceDouble(const Callback: TReduceCallbackFn<T, Double>; const InitialValue: Double): Double;
begin
  Result := Callback(InitialValue, FItems[0], 0, FItems);
  for var i := 1 to Length(FItems)-1 do
    Result := Callback(Result, FItems[i], i, FItems);
end;

function TArrays<T>.ReduceInteger(const Callback: TReduceCallbackFn<T, Integer>; const InitialValue: Integer): Integer;
begin
  Result := Callback(InitialValue, FItems[0], 0, FItems);
  for var i := 1 to Length(FItems)-1 do
    Result := Callback(Result, FItems[i], i, FItems);
end;

function TArrays<T>.ReduceString(const Callback: TReduceCallbackFnWithCurrentIndex<T, string>; const InitialValue: string): string;
begin
  Result := Self.ReduceString(
    function(const PreviousValue: string; const CurrentValue: T; const CurrentIndex: Integer; const Elements: TArray<T>): string
    begin
      Result := Callback(PreviousValue, CurrentValue, CurrentIndex);
    end,
    InitialValue
  );
end;

function TArrays<T>.ReduceString(const Callback: TReduceCallbackFn<T, string>; const InitialValue: string): string;
begin
  Result := Callback(InitialValue, FItems[0], 0, FItems);
  for var i := 1 to Length(FItems)-1 do
    Result := Callback(Result, FItems[i], i, FItems);
end;

end.
