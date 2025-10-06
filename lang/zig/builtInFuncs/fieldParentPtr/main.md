# Zig Built In Functions - fieldParentPtr

## Abstract
```zig
@fieldParentPtr(comptime field_name: []const u8, field_ptr: *T) anytype
```

Given a pointer to a struct or union field, returns a pointer to the struct or union containaing that field. The return
type (pointer to the parent struct or union in questions) is the inferred result type.

IF field_ptr does not point to the field_name field of an instance of the result type, and the result type has
ill-defined layout, invokes uncheck illegal bheavior
## Directory

## Useful Links

## Tags
