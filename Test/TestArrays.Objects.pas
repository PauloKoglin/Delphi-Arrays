unit TestArrays.Objects;

interface

uses
  DUnitX.TestFramework,
  Delphi.Arrays,
  Delphi.Arrays.Interfaces.IArray,
  TestArrays.Helpers.SimpleObject
;

type
  [TestFixture]
  TTestArraysObjects = class
  private
    FSut: IArray<TSimpleObject>;
    FTestObject1: TSimpleObject;
    FTestObject2: TSimpleObject;
    FTestObject3: TSimpleObject;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestFrom;

    [Test]
    procedure TestMap_One_Arg;

    [Test]
    procedure TestReverse;

  end;

implementation

{ TTestArraysObjects }

procedure TTestArraysObjects.Setup;
begin
  FTestObject1 := TSimpleObject.Create('Object1', 10);
  FTestObject2 := TSimpleObject.Create('Object2', 20);
  FTestObject3 := TSimpleObject.Create('Object3', 30);

  FSut := TArrays<TSimpleObject>.From([
    FTestObject1,
    FTestObject2,
    FTestObject3
  ]);
end;

procedure TTestArraysObjects.TearDown;
begin
  FTestObject1.Free();
  FTestObject2.Free();
  FTestObject3.Free();
end;

procedure TTestArraysObjects.TestFrom;
begin
  Assert.AreEqual(3, FSut.Count);
  Assert.AreEqual(FTestObject1, FSut.Values[0]);
  Assert.AreEqual(FTestObject2, FSut.Values[1]);
  Assert.AreEqual(FTestObject3, FSut.Values[2]);
end;

procedure TTestArraysObjects.TestMap_One_Arg;
begin
  const NewArray: IArray<TSimpleObject> = FSut.Map(
    function(const Element: TSimpleObject): TSimpleObject
    begin
      Result := Element;

      if (Element.IntegerProp = 10) then
        Element.StringProp := 'CHANGED';
    end
  );

  Assert.AreEqual(3, NewArray.Count);
  Assert.AreSame(FTestObject1, NewArray.Values[0]);
  Assert.AreSame(FTestObject2, NewArray.Values[1]);
  Assert.AreSame(FTestObject3, NewArray.Values[2]);
end;

procedure TTestArraysObjects.TestReverse;
begin
  const NewArray: IArray<TSimpleObject> = FSut.Reverse();

  Assert.AreEqual(3, NewArray.Count);
  Assert.AreSame(FTestObject3, NewArray.Values[0]);
  Assert.AreSame(FTestObject2, NewArray.Values[1]);
  Assert.AreSame(FTestObject1, NewArray.Values[2]);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestArraysObjects);

end.
