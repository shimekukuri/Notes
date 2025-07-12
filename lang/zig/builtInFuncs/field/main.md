# Zig Built In Functions Field

## Abstract

@field(lhs: anytype, comptime field_name: []const u8) (field)
Performs field access by a compile-time string. Works on both fields and declarations.

```zig
test_field_builtin.zig
const std = @import("std");

const Point = struct {
x: u32,
y: u32,

    pub var z: u32 = 1;

};

test "field access by string" {
const expect = std.testing.expect;
var p = Point{ .x = 0, .y = 0 };

    @field(p, "x") = 4;
    @field(p, "y") = @field(p, "x") + 1;

    try expect(@field(p, "x") == 4);
    try expect(@field(p, "y") == 5);

}

test "decl access by string" {
const expect = std.testing.expect;

    try expect(@field(Point, "z") == 1);

    @field(Point, "z") = 2;
    try expect(@field(Point, "z") == 2);

}
```

```Shell
$ zig test test_field_builtin.zig
1/2 test_field_builtin.test.field access by string...OK
2/2 test_field_builtin.test.decl access by string...OK
All 2 tests passed.
```

## Directory

## Useful Links

## Tags
[[zig-built-in-functions]]
