# Zig Reference - Difference between has hasField and hasDecl

## Abstract

In Zig, both @hasField and @hasDecl are comptime builtins used for introspection, but they serve different purposes
related to the members of a type, particularly structs, unions, and enums.

hasField(Type, "fieldName"): This builtin checks if a given Type (typically a struct or union) has an instance field
with the specified "fieldName". It specifically refers to the data members that are part of the instance of the type.

```zig
const MyStruct = struct {
    a: i32,
    b: f32,
};

const has_a = @hasField(MyStruct, "a"); // true
const has_c = @hasField(MyStruct, "c"); // false
```

@hasDecl(Type, "declName"):
This builtin checks if a given Type (struct, union, or enum) has a declaration (e.g., a function, a nested
struct/union/enum, or a constant) with the specified "declName" within its scope. It refers to members that are part
of the type's namespace, not necessarily instance data.


```zig
const MyStruct = struct {
    a: i32,
    fn doSomething() void {}
    const PI = 3.14;
};

const has_doSomething = @hasDecl(MyStruct, "doSomething"); // true
const has_PI = @hasDecl(MyStruct, "PI");             // true
const has_a_as_decl = @hasDecl(MyStruct, "a");      // false (because 'a' is a field, not a declaration in the namespace)
```

In summary:

Use @hasField to check for the existence of instance data members.
Use @hasDecl to check for the existence of functions, nested types, or constants declared within the type's scope.



## Directory

## Useful Links

## Tags
