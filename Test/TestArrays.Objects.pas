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

initialization
  TDUnitX.RegisterTestFixture(TTestArraysObjects);

end.
