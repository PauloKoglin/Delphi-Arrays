# Delphi-Arrays

## :warning: Library is on developement!! :warning:

#### Delphi library to manipulate arrays with lambda functions (anonymous methods) and some more common usefull features seen in languages like javascript, java, etc... 👍

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

Concat()
```pascal
  const MyArray = TArrays<string>.From(['A', 'B', 'C']);
  
  MyArray.Concat('new_element');
  // output: ['A', 'B', 'C', 'new_element']
  
  MyArray.Concat(['another_one', 'last_one']);
  // output: ['A', 'B', 'C', 'new_element', 'another_one', 'last_one']
```

Every()
```pascal
  const MyArray = TArrays<string>.From(['A', 'B', 'C']);
  
  MyArray.Every(
    function (const Element: string): Boolean
    begin
      Result := Element.Equals('B');
    end
  );
  // output: true
```

Fill()
```pascal
  const MyArray = TArrays<string>.From(['A', 'B', 'C']);
  
  MyArray.Fill('D');
  // output: ['D', 'D', 'D']
```

Filter()
```pascal
  const MyArray = TArrays<Integer>.From([1, 2, 3, 4, 5]);
  
  MyArray.Filter(
    function(const Element: Integer): Boolean
    begin
      Result := Element >= 3;
    end
  );
  // output: [3, 4, 5]
```

ForEach()
```pascal
  const MyArray = TArrays<Integer>.From([1, 2, 3, 4, 5]);
  
  var Sum: Integer = 0;
  MyArray.ForEach(
    procedure(const Element: Integer)
    begin
      Sum := Sum + Element;
    end
  );
  // Sum = 15
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

Pop()
```pascal
  const MyArray = TArrays<string>.From(['A', 'B', 'C']);
  
  MyArray.Pop();
  // output: ['A', 'B']
```

Reverse()
```pascal
  const MyArray = TArrays<Integer>.From([1, 2, 3]);
  
  MyArray.Reverse();
  // output: [3, 2, 1]
```

Shift()
```pascal
  const MyArray = TArrays<string>.From(['A', 'B', 'C']);
  
  MyArray.Shift();
  // output: ['B', 'C']
```

Slice()
```pascal
  const MyArray = TArrays<string>.From(['A', 'B', 'C']);
  
  const NewArray = MyArray.Slice(1, 2);
  
  // NewArray = ['B']
  // MyArray = ['A', 'B', 'C']
```

Unshift()
```pascal
  const MyArray = TArrays<string>.From(['A', 'B', 'C']);
  
  MyArray.Unshift('new_element');
  // output: ['new_element', 'A', 'B', 'C']
  
  MyArray.Unshift(['another_one', 'last_one']);
  // output: ['new_element', 'another_one', 'last_one', 'A', 'B', 'C']
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
  // resulting output: [40, 80]
```
