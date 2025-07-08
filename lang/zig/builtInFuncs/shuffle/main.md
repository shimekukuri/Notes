# Zig Built In Functions Shuffle

## Abstract
@shuffle
@shuffle(comptime E: type, a: @Vector(a_len, E), b: @Vector(b_len, E), comptime mask: @Vector(mask_len, i32))
@Vector(mask_len, E)
Constructs a new vector by selecting elements from a and b based on mask.

Each element in mask selects an element from either a or b. Positive numbers select from a starting at 0. Negative
values select from b, starting at -1 and going down. It is recommended to use the ~ operator for indexes from b so
that both indexes can start from 0 (i.e. ~@as(i32, 0) is -1).

For each element of mask, if it or the selected value from a or b is undefined, then the resulting element is undefined.

a_len and b_len may differ in length. Out-of-bounds element indexes in mask result in compile errors.

If a or b is undefined, it is equivalent to a vector of all undefined with the same length as the other vector. If
both vectors are undefined, @shuffle returns a vector with all elements undefined.

E must be an integer, float, pointer, or bool. The mask may be any vector length, and its length determines the result
length.

test_shuffle_builtin.zig
```zig
const std = @import("std");
const expect = std.testing.expect;

test "vector @shuffle" {
    const a = @Vector(7, u8){ 'o', 'l', 'h', 'e', 'r', 'z', 'w' };
    const b = @Vector(4, u8){ 'w', 'd', '!', 'x' };

    // To shuffle within a single vector, pass undefined as the second argument.
    // Notice that we can re-order, duplicate, or omit elements of the input vector
    const mask1 = @Vector(5, i32){ 2, 3, 1, 1, 0 };
    const res1: @Vector(5, u8) = @shuffle(u8, a, undefined, mask1);
    try expect(std.mem.eql(u8, &@as([5]u8, res1), "hello"));

    // Combining two vectors
    const mask2 = @Vector(6, i32){ -1, 0, 4, 1, -2, -3 };
    const res2: @Vector(6, u8) = @shuffle(u8, a, b, mask2);
    try expect(std.mem.eql(u8, &@as([6]u8, res2), "world!"));
}
```
```bash
$ zig test test_shuffle_builtin.zig
1/1 test_shuffle_builtin.test.vector @shuffle...OK
All 1 tests passed.
```
## Directory

## Useful Links

## Tags
[[zig-built-in-functions]]
