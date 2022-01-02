unit TestArrays;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  System.Generics.Collections,
  Delphi.Arrays,
  Delphi.Arrays.Interfaces.IArray
;

type
  [TestFixture]
  TTestArrays = class
  private
    FSut: IArray<string>;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestFrom;

    [Test]
    procedure TestFrom_Empty;

    [Test]
    procedure TestToArray;

    [Test]
    procedure TestMap_One_Arg;

    [Test]
    procedure TestMap_Two_Args;

    [Test]
    procedure TestMap_Tree_Args;

    [Test]
    procedure TestReverse;

    [Test]
    procedure TestPop;

    [Test]
    procedure TestPop_Only_One_Item;

    [Test]
    procedure TestPop_Empty;

    [Test]
    procedure TestFill;

    [Test]
    procedure TestFill_Only_First_Item;

    [Test]
    procedure TestFill_Only_Last_Item;

    [Test]
    procedure TestFill_From_Middle_To_Last_Item;

    [Test]
    procedure TestFill_StartIndex_Negative;

    [Test]
    procedure TestFill_EndIndex_Negative;

    [Test]
    procedure TestFill_EndIndex_Greater_Length;

    [Test]
    procedure TestEvery_Truthy;

    [Test]
    procedure TestEvery_Falsy;

    [Test]
    procedure TestEvery_Truthy_Two_Args;

    [Test]
    procedure TestEvery_Falsy_Two_Args;

    [Test]
    procedure TestEvery_Truthy_Tree_Args;

    [Test]
    procedure TestEvery_Falsy_Tree_Args;

    [Test]
    procedure TestFilter_One_Arg;

    [Test]
    procedure TestFilter_Two_Args;

    [Test]
    procedure TestFilter_Tree_Args;

    [Test]
    procedure TestFilter_No_Matchs_Found;

    [Test]
    procedure TestConcat_One_Value;

    [Test]
    procedure TestConcat_Multiple_Values;

    [Test]
    procedure TestPush_One_Element;

    [Test]
    procedure TestPush_Multiple_Elements;

    [Test]
    procedure TestShift;

    [Test]
    procedure TestShift_Empty_Array;

    [Test]
    procedure TestShift_One_Element_Array;

    [Test]
    procedure TestSlice;

    [Test]
    procedure TestSlice_Same_Start_and_End_Index;

    [Test]
    procedure TestSlice_Only_StartIndex;

    [Test]
    procedure TestSlice_EndIndex_Greater_Then_Max_Index;

    [Test]
    procedure TestSlice_No_Range;

    [Test]
    procedure TestSlice_Negative_StartIndex;

    [Test]
    procedure TestSlice_Negative_EndIndex;

    [Test]
    procedure TestUnshift;

    [Test]
    procedure TestUnshift_Multiple_Elements;

    [Test]
    procedure TestUnshift_Empty_Array;

  end;

implementation

uses
  System.StrUtils
;

procedure TTestArrays.Setup;
begin
  FSut := TArrays<string>.From(['A', 'B', 'C']);
end;

procedure TTestArrays.TearDown;
begin
end;

procedure TTestArrays.TestConcat_Multiple_Values;
begin
  const NewArray = FSut.Concat(['NEW_ELEMENT', 'ANOTHER_ELEMENT', 'any', '', '123']);

  Assert.AreEqual(8, NewArray.Count);
  Assert.AreEqual('A', NewArray.Values[0]);
  Assert.AreEqual('B', NewArray.Values[1]);
  Assert.AreEqual('C', NewArray.Values[2]);
  Assert.AreEqual('NEW_ELEMENT', NewArray.Values[3]);
  Assert.AreEqual('ANOTHER_ELEMENT', NewArray.Values[4]);
  Assert.AreEqual('any', NewArray.Values[5]);
  Assert.AreEqual('', NewArray.Values[6]);
  Assert.AreEqual('123', NewArray.Values[7]);
end;

procedure TTestArrays.TestConcat_One_Value;
begin
  const NewArray = FSut.Concat('NEW_ELEMENT');

  Assert.AreEqual(4, NewArray.Count);
  Assert.AreEqual('A', NewArray.Values[0]);
  Assert.AreEqual('B', NewArray.Values[1]);
  Assert.AreEqual('C', NewArray.Values[2]);
  Assert.AreEqual('NEW_ELEMENT', NewArray.Values[3]);
end;

procedure TTestArrays.TestEvery_Falsy;
begin
  const Falsy = FSut.Every(
    function (Element: string): Boolean
    begin
      Result := Length(Element) = 2;
    end
  );

  Assert.IsFalse(Falsy);
end;

procedure TTestArrays.TestEvery_Falsy_Tree_Args;
begin
  const Falsy = FSut.Every(
    function (Element: string; Index: Integer; const Elements: TArray<string>): Boolean
    begin
      Result := Elements[Index] <> FSut.Values[Index];
    end
  );

  Assert.IsFalse(Falsy);
end;

procedure TTestArrays.TestEvery_Falsy_Two_Args;
begin
  const Falsy = FSut.Every(
    function (Element: string; Index: Integer): Boolean
    begin
      Result := FSut.Values[Index] <> Element;
    end
  );

  Assert.IsFalse(Falsy);
end;

procedure TTestArrays.TestEvery_Truthy;
begin
  const Truthy = FSut.Every(
    function (Element: string): Boolean
    begin
      Result := Length(Element) = 1;
    end
  );

  Assert.IsTrue(Truthy);
end;

procedure TTestArrays.TestEvery_Truthy_Tree_Args;
begin
  const Falsy = FSut.Every(
    function (Element: string; Index: Integer; const Elements: TArray<string>): Boolean
    begin
      Result := not Element.Equals(FSut.Values[Index]) and not Elements[Index].Equals(FSut.Values[Index]);
    end
  );

  Assert.IsFalse(Falsy);
end;

procedure TTestArrays.TestEvery_Truthy_Two_Args;
begin
  const Sut = TArrays<string>.From(['A', 'B', 'C']);

  const Truthy = Sut.Every(
    function (Item: string; Index: Integer): Boolean
    begin
      Result := Sut.Values[Index] = Item;
    end
  );

  Assert.IsTrue(Truthy);
end;

procedure TTestArrays.TestFill;
begin
  const NewArray = FSut.Fill('D');

  Assert.AreEqual(3, NewArray.Count);
  Assert.AreEqual('D', NewArray.Values[0]);
  Assert.AreEqual('D', NewArray.Values[1]);
  Assert.AreEqual('D', NewArray.Values[2]);
end;

procedure TTestArrays.TestFill_EndIndex_Greater_Length;
begin
  const NewArray = FSut.Fill('D', 0, 5);

  Assert.AreEqual(3, NewArray.Count);
  Assert.AreEqual('D', NewArray.Values[0]);
  Assert.AreEqual('D', NewArray.Values[1]);
  Assert.AreEqual('D', NewArray.Values[2]);

end;

procedure TTestArrays.TestFill_EndIndex_Negative;
begin
  const NewArray = FSut.Fill('D', 0, -1);

  Assert.AreEqual(3, NewArray.Count);
  Assert.AreEqual('A', NewArray.Values[0]);
  Assert.AreEqual('B', NewArray.Values[1]);
  Assert.AreEqual('C', NewArray.Values[2]);
end;

procedure TTestArrays.TestFill_From_Middle_To_Last_Item;
begin
  const NewArray = FSut.Fill('D', 1);

  Assert.AreEqual(3, NewArray.Count);
  Assert.AreEqual('A', NewArray.Values[0]);
  Assert.AreEqual('D', NewArray.Values[1]);
  Assert.AreEqual('D', NewArray.Values[2]);
end;

procedure TTestArrays.TestFill_Only_First_Item;
begin
  const NewArray = FSut.Fill('D', 0, 0);

  Assert.AreEqual(3, NewArray.Count);
  Assert.AreEqual('D', NewArray.Values[0]);
  Assert.AreEqual('B', NewArray.Values[1]);
  Assert.AreEqual('C', NewArray.Values[2]);
end;

procedure TTestArrays.TestFill_Only_Last_Item;
begin
  const NewArray = FSut.Fill('D', 2, 2);

  Assert.AreEqual(3, NewArray.Count);
  Assert.AreEqual('A', NewArray.Values[0]);
  Assert.AreEqual('B', NewArray.Values[1]);
  Assert.AreEqual('D', NewArray.Values[2]);
end;

procedure TTestArrays.TestFill_StartIndex_Negative;
begin
  const NewArray = FSut.Fill('D', -1);

  Assert.AreEqual(3, NewArray.Count);
  Assert.AreEqual('D', NewArray.Values[0]);
  Assert.AreEqual('D', NewArray.Values[1]);
  Assert.AreEqual('D', NewArray.Values[2]);
end;

procedure TTestArrays.TestFilter_No_Matchs_Found;
begin
  const Sut = TArrays<string>.From(['A', 'B', 'C', 'D', 'E']);

  const NewArray = Sut.Filter(
    function (Element: string): Boolean
    begin
      Result := Element = 'NOT_TO_BE_FOUND';
    end
  );

  Assert.AreEqual(0, NewArray.Count);
end;

procedure TTestArrays.TestFilter_One_Arg;
begin
  const Sut = TArrays<string>.From(['A', 'TO_FILTER', 'C', 'TO_FILTER', 'TO_FILTER']);

  const NewArray = Sut.Filter(
    function (Element: string): Boolean
    begin
      Result := Element = 'TO_FILTER';
    end
  );

  Assert.AreEqual(3, NewArray.Count);
  Assert.AreEqual('TO_FILTER', NewArray.Values[0]);
  Assert.AreEqual('TO_FILTER', NewArray.Values[1]);
  Assert.AreEqual('TO_FILTER', NewArray.Values[2]);
end;

procedure TTestArrays.TestFilter_Tree_Args;
begin
  const Sut = TArrays<string>.From(['A', 'B', 'C', 'D', 'TO_FILTER']);

  const NewArray = Sut.Filter(
    function (Element: string; Index: Integer; const Elements: TArray<string>): Boolean
    begin
      Result := (Element = 'TO_FILTER') and (Index = 4) and (Elements[4] = 'TO_FILTER');
    end
  );

  Assert.AreEqual(1, NewArray.Count);
  Assert.AreEqual('TO_FILTER', NewArray.Values[0]);
end;

procedure TTestArrays.TestFilter_Two_Args;
begin
  const Sut = TArrays<string>.From(['A', 'TO_FILTER', 'C', 'D', 'E']);

  const NewArray = Sut.Filter(
    function (Element: string; Index: Integer): Boolean
    begin
      Result := (Element = 'TO_FILTER') and (Index = 1);
    end
  );

  Assert.AreEqual(1, NewArray.Count);
  Assert.AreEqual('TO_FILTER', NewArray.Values[0]);
end;

procedure TTestArrays.TestFrom;
begin
  Assert.AreEqual(3, FSut.Count);
  Assert.AreEqual('A', FSut.Values[0]);
  Assert.AreEqual('B', FSut.Values[1]);
  Assert.AreEqual('C', FSut.Values[2]);
end;

procedure TTestArrays.TestFrom_Empty;
begin
  const Sut: IArray<string> = TArrays<string>.From([]);

  Assert.AreEqual(0, Sut.Count);
end;

procedure TTestArrays.TestPush_One_Element;
begin
  const NewLength = FSut.Push('new_Element');
  Assert.AreEqual(4, NewLength);
  Assert.AreEqual('A', FSut.Values[0]);
  Assert.AreEqual('B', FSut.Values[1]);
  Assert.AreEqual('C', FSut.Values[2]);
  Assert.AreEqual('new_Element', FSut.Values[3]);
end;

procedure TTestArrays.TestPush_Multiple_Elements;
begin
  const NewLength = FSut.Push(['new_element', '', 'another_one']);
  Assert.AreEqual(6, NewLength);
  Assert.AreEqual('A', FSut.Values[0]);
  Assert.AreEqual('B', FSut.Values[1]);
  Assert.AreEqual('C', FSut.Values[2]);
  Assert.AreEqual('new_element', FSut.Values[3]);
  Assert.AreEqual('', FSut.Values[4]);
  Assert.AreEqual('another_one', FSut.Values[5]);
end;

procedure TTestArrays.TestMap_One_Arg;
begin
  const NewArray = FSut.Map(
    function(const Element: string): string
    begin
      Result := Element + '!';
    end
  );

  Assert.AreEqual(3, NewArray.Count);
  Assert.AreEqual('A!', NewArray.Values[0]);
  Assert.AreEqual('B!', NewArray.Values[1]);
  Assert.AreEqual('C!', NewArray.Values[2]);
end;

procedure TTestArrays.TestMap_Tree_Args;
begin
  const NewArray = FSut.Map(
    function(const Element: string; const Index: Integer; const Elements: TArray<string>): string
    begin
      Result := IfThen((Index = 1) and (Elements[Index] = 'B'), Element + '!', Element);
    end
  );

  Assert.AreEqual(3, NewArray.Count);
  Assert.AreEqual('A', NewArray.Values[0]);
  Assert.AreEqual('B!', NewArray.Values[1]);
  Assert.AreEqual('C', NewArray.Values[2]);
end;

procedure TTestArrays.TestMap_Two_Args;
begin
  const NewArray = FSut.Map(
    function(const Element: string; const Index: Integer): string
    begin
      Result := IfThen(Index = 0, Element + '!', Element);
    end
  );

  Assert.AreEqual(3, NewArray.Count);
  Assert.AreEqual('A!', NewArray.Values[0]);
  Assert.AreEqual('B', NewArray.Values[1]);
  Assert.AreEqual('C', NewArray.Values[2]);
end;

procedure TTestArrays.TestPop;
begin
  const NewArray = FSut.Pop();

  Assert.AreEqual(2, NewArray.Count);
  Assert.AreEqual('A', NewArray.Values[0]);
  Assert.AreEqual('B', NewArray.Values[1]);
end;

procedure TTestArrays.TestPop_Empty;
begin
  const Sut = TArrays<string>.From([]);

  const NewArray = Sut.Pop();

  Assert.AreEqual(0, NewArray.Count);
end;

procedure TTestArrays.TestPop_Only_One_Item;
begin
  const Sut = TArrays<string>.From(['A']);

  const NewArray = Sut.Pop();

  Assert.AreEqual(0, NewArray.Count);
end;

procedure TTestArrays.TestReverse;
begin
  const NewArray = FSut.Reverse();

  Assert.AreEqual(3, NewArray.Count);
  Assert.AreEqual('C', NewArray.Values[0]);
  Assert.AreEqual('B', NewArray.Values[1]);
  Assert.AreEqual('A', NewArray.Values[2]);
end;

procedure TTestArrays.TestShift;
begin
  const NewArray = FSut.Shift();

  Assert.AreEqual(2, NewArray.Count);
  Assert.AreEqual('B', NewArray.Values[0]);
  Assert.AreEqual('C', NewArray.Values[1]);
end;

procedure TTestArrays.TestShift_Empty_Array;
begin
  const Sut: IArray<string> = TArrays<string>.From([]);
  const NewArray = Sut.Shift();

  Assert.AreEqual(0, NewArray.Count);
end;

procedure TTestArrays.TestShift_One_Element_Array;
begin
  const Sut: IArray<string> = TArrays<string>.From(['A']);
  const NewArray = Sut.Shift();

  Assert.AreEqual(0, NewArray.Count);
end;

procedure TTestArrays.TestSlice;
begin
  const NewArray: IArray<string> = FSut.Slice(1, 2);

  Assert.AreEqual(1, NewArray.Count);
  Assert.AreEqual('B', NewArray.Values[0]);
  Assert.AreEqual(3, FSut.Count);
  Assert.AreEqual('A', FSut.Values[0]);
  Assert.AreEqual('B', FSut.Values[1]);
  Assert.AreEqual('C', FSut.Values[2]);
end;

procedure TTestArrays.TestSlice_EndIndex_Greater_Then_Max_Index;
begin
  const NewArray: IArray<string> = FSut.Slice(2, 3);

  Assert.AreEqual(1, NewArray.Count);
  Assert.AreEqual('C', NewArray.Values[0]);
  Assert.AreEqual(3, FSut.Count);
  Assert.AreEqual('A', FSut.Values[0]);
  Assert.AreEqual('B', FSut.Values[1]);
  Assert.AreEqual('C', FSut.Values[2]);
end;

procedure TTestArrays.TestSlice_Negative_EndIndex;
begin
  const NewArray: IArray<string> = FSut.Slice(1, -1);

  Assert.AreEqual(2, NewArray.Count);
  Assert.AreEqual('B', NewArray.Values[0]);
  Assert.AreEqual('C', NewArray.Values[1]);
  Assert.AreEqual(3, FSut.Count);
  Assert.AreEqual('A', FSut.Values[0]);
  Assert.AreEqual('B', FSut.Values[1]);
  Assert.AreEqual('C', FSut.Values[2]);
end;

procedure TTestArrays.TestSlice_Negative_StartIndex;
begin
  const NewArray: IArray<string> = FSut.Slice(-1);

  Assert.AreEqual(3, NewArray.Count);
  Assert.AreEqual('A', NewArray.Values[0]);
  Assert.AreEqual('B', NewArray.Values[1]);
  Assert.AreEqual('C', NewArray.Values[2]);
  Assert.AreEqual(3, FSut.Count);
  Assert.AreEqual('A', FSut.Values[0]);
  Assert.AreEqual('B', FSut.Values[1]);
  Assert.AreEqual('C', FSut.Values[2]);
end;

procedure TTestArrays.TestSlice_No_Range;
begin
  const NewArray: IArray<string> = FSut.Slice();

  Assert.AreEqual(3, NewArray.Count);
  Assert.AreEqual('A', NewArray.Values[0]);
  Assert.AreEqual('B', NewArray.Values[1]);
  Assert.AreEqual('C', NewArray.Values[2]);
  Assert.AreEqual(3, FSut.Count);
  Assert.AreEqual('A', FSut.Values[0]);
  Assert.AreEqual('B', FSut.Values[1]);
  Assert.AreEqual('C', FSut.Values[2]);
end;

procedure TTestArrays.TestSlice_Only_StartIndex;
begin
  const NewArray: IArray<string> = FSut.Slice(1);

  Assert.AreEqual(2, NewArray.Count);
  Assert.AreEqual('B', NewArray.Values[0]);
  Assert.AreEqual('C', NewArray.Values[1]);
  Assert.AreEqual(3, FSut.Count);
  Assert.AreEqual('A', FSut.Values[0]);
  Assert.AreEqual('B', FSut.Values[1]);
  Assert.AreEqual('C', FSut.Values[2]);
end;

procedure TTestArrays.TestSlice_Same_Start_and_End_Index;
begin
  const NewArray: IArray<string> = FSut.Slice(1, 1);

  Assert.AreEqual(0, NewArray.Count);
  Assert.AreEqual(3, FSut.Count);
  Assert.AreEqual('A', FSut.Values[0]);
  Assert.AreEqual('B', FSut.Values[1]);
  Assert.AreEqual('C', FSut.Values[2]);
end;

procedure TTestArrays.TestToArray;
begin
  const NewArray = FSut.ToArray();

  Assert.AreEqual(3, Length(NewArray));
  Assert.AreEqual('A', NewArray[0]);
  Assert.AreEqual('B', NewArray[1]);
  Assert.AreEqual('C', NewArray[2]);
end;


procedure TTestArrays.TestUnshift;
begin
  const NewLength = FSut.Unshift('new_Element');
  Assert.AreEqual(4, NewLength);
  Assert.AreEqual('new_Element', FSut.Values[0]);
  Assert.AreEqual('A', FSut.Values[1]);
  Assert.AreEqual('B', FSut.Values[2]);
  Assert.AreEqual('C', FSut.Values[3]);
end;

procedure TTestArrays.TestUnshift_Empty_Array;
begin
  const NewLength = FSut.Unshift([]);
  Assert.AreEqual(3, NewLength);
  Assert.AreEqual('A', FSut.Values[0]);
  Assert.AreEqual('B', FSut.Values[1]);
  Assert.AreEqual('C', FSut.Values[2]);
end;

procedure TTestArrays.TestUnshift_Multiple_Elements;
begin
  const NewLength = FSut.Unshift(['new_element', '', 'another_element']);
  Assert.AreEqual(6, NewLength);
  Assert.AreEqual('new_element', FSut.Values[0]);
  Assert.AreEqual('', FSut.Values[1]);
  Assert.AreEqual('another_element', FSut.Values[2]);
  Assert.AreEqual('A', FSut.Values[3]);
  Assert.AreEqual('B', FSut.Values[4]);
  Assert.AreEqual('C', FSut.Values[5]);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestArrays);

end.
