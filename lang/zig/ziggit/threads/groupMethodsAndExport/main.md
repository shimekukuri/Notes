# Zig Ziggit Thread - Grouping methods and outsourcing them to another file

## Abstract
Hi,

I want to define a struct with some methods. However I would like to group the methods and put them into a separate
file. For example have different algorithms to solve the same problem, but have them available.

My goal is to be able to call them like

mymatrix_a.matmul.naive(mymatrix_b);
mymatrix_a.matmul.strassen(mymatrix_b);
...

How would I go about it?
My idea was to write a file that simply contains the functions:

```zig
/// matmul.zig
pub fn strassen(...) {
    ...
}
pub fn naive(...) {
    ...
}

Then I define the main struct in another file like:

/// mystruct.zig
const MyStruct = struct {
    ...,
    const Self = @This();
    const matmul = @import("matmul.zig");
    pub fn init() Self {
        return Self{
            ...
        };
    }
    pub fn deinit(self: *Self) void {
        _ = self;
    }
};
```

Apart from the fact that I need to figure out how I would access the fields from mystruct in the external functions, i have the problem that the compiler complains the field matmul would not exist if I try to access it.
I would appreciate your help. Thanks

## Directory

## Useful Links
[Grouping methods and outsourcing them to another file link]("https://ziggit.dev/t/grouping-methods-and-outsourcing-them-to-another-file/12352")

## Tags
[[zig-ziggit-threads]]
