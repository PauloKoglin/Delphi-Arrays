unit TestArrays.Performance;

interface

uses
  DUnitX.TestFramework
  , System.Diagnostics
  , Delphi.Arrays
  , Delphi.Arrays.Interfaces.IArray
  ;

type
  [TestFixture]
  TestArraysPerformance = class
  private
    FSut: IArray<Integer>;
    FTimeWatcher: TStopwatch;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestPush;

    [Test]
    procedure TestPush_Array;

    [Test]
    procedure TestUnshift;
  end;

implementation

uses
  System.SysUtils
  ;

procedure TestArraysPerformance.Setup;
begin
  FSut := TArrays<Integer>.New();
  FTimeWatcher.Reset();
end;

procedure TestArraysPerformance.TearDown;
begin
end;

procedure TestArraysPerformance.TestPush;
begin
  FTimeWatcher.Start();

  for var i := 1 to 100000000 do
    FSut.Push(i);

  FTimeWatcher.Stop();
  WriteLn(FTimeWatcher.Elapsed.ToString());
  Assert.Pass();
end;

procedure TestArraysPerformance.TestPush_Array;
begin
  var NewArray: TArray<Integer>;
  SetLength(NewArray, 100000000);
  for var i := 1 to 100000000 do
    NewArray[i] := Random(10);

  FTimeWatcher.Start();

  FSut.Push(NewArray);

  FTimeWatcher.Stop();
  WriteLn(FTimeWatcher.Elapsed.ToString());
  Assert.Pass();
end;

procedure TestArraysPerformance.TestUnshift;
begin
  for var i := 1 to 100000000 do
    FSut.Push(Random(10));

  FTimeWatcher.Start();

  FSut.Unshift(999);

  FTimeWatcher.Stop();
  WriteLn(FTimeWatcher.Elapsed.ToString());
  Assert.Pass();
end;

initialization
  TDUnitX.RegisterTestFixture(TestArraysPerformance);

end.
