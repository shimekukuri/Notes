# Zig Built In Functions - This

## Abstract
Returns the innermost struct, enum, or union that this functions call is inside. This can be useful for an anonymous
struct that needs to refer to itself.

Example:
```zig
const std = @import("std");
const expect = std.testing.expect;

test "@This()" {
    var items = [_]i32{ 1, 2, 3, 4 };
    const list = List(i32){ .items = items[0..] };
    try expect(list.length() == 4);
}

fn List(comptime T: type) type {
    return struct {
        const Self = @This();

        items: []T,

        fn length(self: Self) usize {
            return self.items.len;
        }
    };
}
```

When @This() is used at file scope, it returns a reference to the struct that corresponds to the current file.

## Directory

## Useful Links

## Tags
