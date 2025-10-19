# Zig Concepts - Anytype

## Abstract
Being able to pass types to functions at compile time lets us
generate code that works with multiple types. But it doesn't
help us pass VALUES of different types to a function.

For that, we have the 'anytype' placeholder, which tells Zig
to infer the actual type of a parameter at compile time.

```zig
fn foo(thing: anytype) void { ... }
```

Then we can use builtins such as @TypeOf(), @typeInfo(),
@typeName(), @hasDecl(), and @hasField() to determine more
about the type that has been passed in. All of this logic will
be performed entirely at compile time.


## Directory

## Useful Links

## Tags
