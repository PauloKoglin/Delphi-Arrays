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
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestFrom;

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
  end;

implementation

uses
  System.StrUtils
;

procedure TTestArrays.Setup;
begin
end;

procedure TTestArrays.TearDown;
begin
end;

procedure TTestArrays.TestEvery_Falsy;
begin
  const Sut = TArrays<string>.From(['A', 'B', 'C']);

  const Falsy = Sut.Every(
    function (Item: string): Boolean
    begin
      Result := Length(Item) = 2;
    end
  );

  Assert.IsFalse(Falsy);
end;

procedure TTestArrays.TestEvery_Falsy_Tree_Args;
begin
  const Sut = TArrays<string>.From(['A', 'B', 'C']);

  const Falsy = Sut.Every(
    function (Item: string; Index: Integer; const Items: TArray<string>): Boolean
    begin
      Result := Items[Index] <> Sut.Items[Index];
    end
  );

  Assert.IsFalse(Falsy);
end;

procedure TTestArrays.TestEvery_Falsy_Two_Args;
begin
  const Sut = TArrays<string>.From(['A', 'B', 'C']);

  const Falsy = Sut.Every(
    function (Item: string; Index: Integer): Boolean
    begin
      Result := Sut.Items[Index] <> Item;
    end
  );

  Assert.IsFalse(Falsy);
end;

procedure TTestArrays.TestEvery_Truthy;
begin
  const Sut = TArrays<string>.From(['A', 'B', 'C']);

  const Truthy = Sut.Every(
    function (Item: string): Boolean
    begin
      Result := Length(Item) = 1;
    end
  );

  Assert.IsTrue(Truthy);
end;

procedure TTestArrays.TestEvery_Truthy_Tree_Args;
begin
  const Sut = TArrays<string>.From(['A', 'B', 'C']);

  const Falsy = Sut.Every(
    function (Item: string; Index: Integer; const Elements: TArray<string>): Boolean
    begin
      Result := not Item.Equals(Sut.Items[Index]) and not Elements[Index].Equals(Sut.Items[Index]);
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
      Result := Sut.Items[Index] = Item;
    end
  );

  Assert.IsTrue(Truthy);
end;

procedure TTestArrays.TestFill;
begin
  const Sut = TArrays<string>.From(['A', 'B', 'C']);

  const NewArray = Sut.Fill('D');

  Assert.AreEqual(3, NewArray.Lenght);
  Assert.AreEqual('D', NewArray.Items[0]);
  Assert.AreEqual('D', NewArray.Items[1]);
  Assert.AreEqual('D', NewArray.Items[2]);
end;

procedure TTestArrays.TestFill_EndIndex_Greater_Length;
begin
  const Sut = TArrays<string>.From(['A', 'B', 'C']);

  const NewArray = Sut.Fill('D', 0, 5);

  Assert.AreEqual(3, NewArray.Lenght);
  Assert.AreEqual('D', NewArray.Items[0]);
  Assert.AreEqual('D', NewArray.Items[1]);
  Assert.AreEqual('D', NewArray.Items[2]);

end;

procedure TTestArrays.TestFill_EndIndex_Negative;
begin
  const Sut = TArrays<string>.From(['A', 'B', 'C']);

  const NewArray = Sut.Fill('D', 0, -1);

  Assert.AreEqual(3, NewArray.Lenght);
  Assert.AreEqual('A', NewArray.Items[0]);
  Assert.AreEqual('B', NewArray.Items[1]);
  Assert.AreEqual('C', NewArray.Items[2]);
end;

procedure TTestArrays.TestFill_From_Middle_To_Last_Item;
begin
   const Sut = TArrays<string>.From(['A', 'B', 'C']);

  const NewArray = Sut.Fill('D', 1);

  Assert.AreEqual(3, NewArray.Lenght);
  Assert.AreEqual('A', NewArray.Items[0]);
  Assert.AreEqual('D', NewArray.Items[1]);
  Assert.AreEqual('D', NewArray.Items[2]);
end;

procedure TTestArrays.TestFill_Only_First_Item;
begin
  const Sut = TArrays<string>.From(['A', 'B', 'C']);

  const NewArray = Sut.Fill('D', 0, 0);

  Assert.AreEqual(3, NewArray.Lenght);
  Assert.AreEqual('D', NewArray.Items[0]);
  Assert.AreEqual('B', NewArray.Items[1]);
  Assert.AreEqual('C', NewArray.Items[2]);
end;

procedure TTestArrays.TestFill_Only_Last_Item;
begin
  const Sut = TArrays<string>.From(['A', 'B', 'C']);

  const NewArray = Sut.Fill('D', 2, 2);

  Assert.AreEqual(3, NewArray.Lenght);
  Assert.AreEqual('A', NewArray.Items[0]);
  Assert.AreEqual('B', NewArray.Items[1]);
  Assert.AreEqual('D', NewArray.Items[2]);
end;

procedure TTestArrays.TestFill_StartIndex_Negative;
begin
  const Sut = TArrays<string>.From(['A', 'B', 'C']);

  const NewArray = Sut.Fill('D', -1);

  Assert.AreEqual(3, NewArray.Lenght);
  Assert.AreEqual('D', NewArray.Items[0]);
  Assert.AreEqual('D', NewArray.Items[1]);
  Assert.AreEqual('D', NewArray.Items[2]);
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

  Assert.AreEqual(0, NewArray.Lenght);
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

  Assert.AreEqual(3, NewArray.Lenght);
  Assert.AreEqual('TO_FILTER', NewArray.Items[0]);
  Assert.AreEqual('TO_FILTER', NewArray.Items[1]);
  Assert.AreEqual('TO_FILTER', NewArray.Items[2]);
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

  Assert.AreEqual(1, NewArray.Lenght);
  Assert.AreEqual('TO_FILTER', NewArray.Items[0]);
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

  Assert.AreEqual(1, NewArray.Lenght);
  Assert.AreEqual('TO_FILTER', NewArray.Items[0]);
end;

procedure TTestArrays.TestFrom;
begin
  const Sut = TArrays<string>.From(['A', 'B']);

  Assert.AreEqual(2, Sut.Lenght);
  Assert.AreEqual(Sut.Items[0], 'A');
  Assert.AreEqual(Sut.Items[1], 'B');
end;

procedure TTestArrays.TestMap_One_Arg;
begin
  const Sut = TArrays<string>.From(['A', 'B']);

  const NewArray = Sut.Map(
    function(const Element: string): string
    begin
      Result := Element + '!';
    end
  );

  Assert.AreEqual(2, NewArray.Lenght);
  Assert.AreEqual('A!', NewArray.Items[0]);
  Assert.AreEqual('B!', NewArray.Items[1]);
end;

procedure TTestArrays.TestMap_Tree_Args;
begin
  const Sut = TArrays<string>.From(['A', 'B']);

  const NewArray = Sut.Map(
    function(const Element: string; const Index: Integer; const Elements: TArray<string>): string
    begin
      Result := IfThen((Index = 1) and (Elements[Index] = 'B'), Element + '!', Element);
    end
  );

  Assert.AreEqual(2, NewArray.Lenght);
  Assert.AreEqual('A', NewArray.Items[0]);
  Assert.AreEqual('B!', NewArray.Items[1]);
end;

procedure TTestArrays.TestMap_Two_Args;
begin
  const Sut = TArrays<string>.From(['A', 'B']);

  const NewArray = Sut.Map(
    function(const Element: string; const Index: Integer): string
    begin
      Result := IfThen(Index = 0, Element + '!', Element);
    end
  );

  Assert.AreEqual(2, NewArray.Lenght);
  Assert.AreEqual('A!', NewArray.Items[0]);
  Assert.AreEqual('B', NewArray.Items[1]);
end;

procedure TTestArrays.TestPop;
begin
  const Sut = TArrays<string>.From(['A', 'B', 'C']);

  const NewArray = Sut.Pop();

  Assert.AreEqual(2, NewArray.Lenght);
  Assert.AreEqual('A', NewArray.Items[0]);
  Assert.AreEqual('B', NewArray.Items[1]);
end;

procedure TTestArrays.TestPop_Empty;
begin
  const Sut = TArrays<string>.From([]);

  const NewArray = Sut.Pop();

  Assert.AreEqual(0, NewArray.Lenght);
end;

procedure TTestArrays.TestPop_Only_One_Item;
begin
  const Sut = TArrays<string>.From(['A']);

  const NewArray = Sut.Pop();

  Assert.AreEqual(0, NewArray.Lenght);
end;

procedure TTestArrays.TestReverse;
begin
  const Sut = TArrays<string>.From(['A', 'B']);

  const NewArray = Sut.Reverse();

  Assert.AreEqual(2, NewArray.Lenght);
  Assert.AreEqual('B', NewArray.Items[0]);
  Assert.AreEqual('A', NewArray.Items[1]);
end;

procedure TTestArrays.TestToArray;
begin
  const Sut = TArrays<string>.From(['A', 'B']);

  Assert.AreEqual('A', Sut.ToArray[0]);
  Assert.AreEqual('B', Sut.ToArray[1]);
end;


initialization
  TDUnitX.RegisterTestFixture(TTestArrays);

end.
