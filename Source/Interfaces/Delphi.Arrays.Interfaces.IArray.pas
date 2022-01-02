unit Delphi.Arrays.Interfaces.IArray;

interface

uses
  Delphi.Arrays.Interfaces.CallbackFn
;

type
  IArray<T> = interface ['{3E6066DF-F75D-47A5-8CF4-50777236CC14}']
    function GetValue(const Index: Integer): T;

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
    function Unshift(const Element: TArray<T>): Integer; overload;

    procedure ForEach(const Callback: TForEachCallbackFn<T>); overload;
    procedure ForEach(const Callback: TForEachCallbackFnElementIndex<T>); overload;
    procedure ForEach(const Callback: TForEachCallbackFnElement<T>); overload;

    function Join(const Separator: String = ','): string;
    function Reverse(): IArray<T>;
    function Pop(): IArray<T>;
    function Shift(): IArray<T>;
    function Count(): Integer;
    function ToArray(): TArray<T>;

    property Values[const Index: Integer]: T read GetValue;
  end;

implementation

end.
