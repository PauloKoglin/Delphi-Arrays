unit Delphi.Arrays.Interfaces.IArray;

interface

type
  /// <summary> Callback for process each element </summary>
  /// <param name="Element"> Current element being processed in the array </param>
  /// <param name="Index"> Current index being processed in the array </param>
  /// <param name="Elements"> Original array being processed </param>
  /// <returns> Results of callback processing </returns>
  TCallbackFn<T> = reference to function(Element: T; Index: Integer; const Elements: TArray<T>): Boolean;

  /// <summary> Callback for Map() function </summary>
  /// <param name="Element"> Current element being processed in the array </param>
  /// <returns> Results of callback processing </returns>
  TCallbackFnElement<T> = reference to function(Element: T): Boolean;

  /// <summary> Callback for Map() function </summary>
  /// <param name="Element"> Current element being processed in the array </param>
  /// <param name="Index"> Current index being processed in the array </param>
  /// <returns> Results of callback processing </returns>
  TCallbackFnElementIndex<T> = reference to function(Element: T; Index: Integer): Boolean;

  /// <summary> Callback for process each element </summary>
  /// <param name="Element"> Current element being processed in the array </param>
  /// <param name="Index"> Current index being processed in the array </param>
  /// <param name="Elements"> Original array being processed </param>
  /// <returns> Results of callback processing </returns>
  TMapCallbackFn<T> = reference to function(const Element: T; const Index: Integer; const Elements: TArray<T>): T;

  /// <summary> Callback for Map() function </summary>
  /// <param name="Element"> Current element being processed in the array </param>
  /// <returns> Results of callback processing </returns>
  TMapCallbackFnElement<T> = reference to function(const Element: T): T;

  /// <summary> Callback for Map() function </summary>
  /// <param name="Element"> Current element being processed in the array </param>
  /// <param name="Index"> Current index being processed in the array </param>
  /// <returns> Results of callback processing </returns>
  TMapCallbackFnElementIndex<T> = reference to function(const Element: T; const Index: Integer): T;

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

    function Slice(const StartIndex: Integer; const EndIndex: Integer): IArray<T>;

    function Reverse(): IArray<T>;
    function Pop(): IArray<T>;
    function Shift(): IArray<T>;
    function Count(): Integer;
    function ToArray(): TArray<T>;

    property Items[const Index: Integer]: T read GetValue;
  end;

implementation

end.
