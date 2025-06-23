# Zig How To Check Field Value Dynamically

## Abstract

This is how you would check the value of a field dynamically at compile time. This is useful in situation where you
need to check the value of something via a function parameter IE:

```zig
fn checkThreadStatus(comptime status: []const u8, x: *[192]ThreadStatus) bool {
    for (x.*) |y| {
        if (!@field(y, status)) {
            return false;
        }
    }
    return true;
}

pub const ThreadStatus = struct {
    s1: bool,
    s1Val: ?usize,
};
```

## Directory

## Useful Links

## Tags

[[zig-how-to]]
[[zig-built-in-functions-field]]
