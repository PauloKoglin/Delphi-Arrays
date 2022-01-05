# Delphi-Arrays

## :warning: Library is on developement!! :warning:

#### Delphi library to manipulate arrays like javascript, java, etc... 👍

## Example

Create an array

```pascal
  // Integer Array
  const MyIntegerArray: IArray<Integer> = TArrays<Integer>.From([1, 2, 3, 4, 5, 6, 7, 8, 9]);
  
  // String Array
  const MyStringArray: IArray<string> = TArrays<string>.From(['A', 'B', 'C', 'D', 'E', 'F']);
  
  // Double Array
  const MyStringArray: IArray<Double> = TArrays<Double>.From([1.5, 2.5, 3.5, 4.5, 6.5]);
  
  // Object Array (the object's lifecycle is not managed by TArrays)
  const MyObjectArray: IArray<TMyObject> = TArrays<TMyObject>.From([TMyObject.Create, TMyObject.Create]);
  
  // It works also with type inference
  const MyStringArray = TArrays<string>.From(['with', 'type', 'inference']);
```

Map()
```pascal
  const MyArray = TArrays<string>.From(['A', 'B', 'C']);
  
  MyArray.Map(
    function(const Element: string): string
    begin
      Result := Element + '!';
    end
  );
  // output: ['A!', 'B!', 'C!']
```

Use chained calls
```pascal
  // Instanciate new array
  const MyArray: IArray<Integer> = TArrays<Integer>.From([1, 2, 3, 4, 5, 6, 7, 8, 9]);
  
  // Callback for Map()
  const MultipleByTenWhenLessThanFive: TMapCallbackFnElement<Integer> =
    function(const Element: Integer): Integer
    begin
      Result := Element;

      if Element < 5 then
        Result := Element * 10;
    end;

  // Callback for Filter()
  const GreaterThanThirty: TCallbackFnElement<Integer> =
    function(const Element: Integer): Boolean
    begin
      Result := Element > 30;
    end;

  // Chained calls
  MyArray
    .Map(MultipleByTenWhenLessThanFive) // output: [10, 20, 30, 40, 5, 6, 7, 8, 9]
    .Filter(GreaterThanThirty) // output: [40]
    .Concat([80]); // output: [40, 80]
    
  WriteLn(TObject(MyArray).ToString()); // output: [40, 80]
```
