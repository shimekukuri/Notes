# Zig Syntax Struct

## Abstract

Defining a Struct in Zig:

```zig
const ExampleStruct = struct {
    x: u64
    y: i64
    z: bool
}
```

Instantiating a struct in Zig:

```zig
const exampleStruct = ExampleStruct{
    .x = 1,
    .y = -4,
    .z = false
}
```

It is also worth mentioning that zig automatically does one layer of automatic dereferencing when acceing memembers of the struct
IE:

```zig
const Stuff = struct {
    x: i32,
    y: i32,
    fn swap(self: *Stuff) void {
        const tmp = self.x;
        self.x = self.y;
        self.y = tmp;
    }
};

test "automatic dereference" {
    var thing = Stuff{ .x = 10, .y = 20 };
    thing.swap();
    try expect(thing.x == 20);
    try expect(thing.y == 10);
}
```

## Directory

## Useful Links

## Tags
