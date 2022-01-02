unit Delphi.Arrays.Interfaces.CallbackFn;

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

  /// <summary> Callback for ForEach() procedure </summary>
  /// <param name="Element"> Current element being processed in the array </param>
  /// <param name="Index"> Current index being processed in the array </param>
  /// <param name="Elements"> Original array being processed </param>
  TForEachCallbackFn<T> = reference to procedure(const Element: T; const Index: Integer; const Elements: TArray<T>);

  /// <summary> Callback for ForEach() procedure </summary>
  /// <param name="Element"> Current element being processed in the array </param>
  TForEachCallbackFnElement<T> = reference to procedure(const Element: T);

  /// <summary> Callback for ForEach() procedure </summary>
  /// <param name="Element"> Current element being processed in the array </param>
  /// <param name="Index"> Current index being processed in the array </param>
  TForEachCallbackFnElementIndex<T> = reference to procedure(const Element: T; const Index: Integer);

  /// <summary> Callback for ForEach() procedure </summary>
  /// <param name="Element"> Current element being processed in the array </param>
  /// <param name="Index"> Current index being processed in the array </param>
  /// <param name="Elements"> Original array being processed </param>
  TReduceCallbackFn<T,R> = reference to function(const PreviousValue: R; const CurrentValue: T; const CurrentIndex: Integer; const Elements: TArray<T>): R;

implementation

end.
