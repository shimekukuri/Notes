# Zig How To - IO Writer

## Abstract

enrtry point for Zig Pallindrome notes

```zig
const std = @import("std");

pub fn main() !void {
    const letsTry: struct { hello: []const u8 } = .{ .hello = "world" };
    var buffer: [1028]u8 = undefined;

    const stdout: std.fs.File = .stdout();

    var file_writer: std.fs.File.Writer = stdout.writer(&buffer);

    try std.json.Stringify.value(letsTry, .{ .whitespace = .indent_2 }, &file_writer.interface);

    try file_writer.interface.flush();
}
```

## Directory

## Useful Links
[Carl on the New std io writer](https://www.openmymind.net/Zigs-New-Writer/)
[ziggit helpful for understanding](https://ziggit.dev/t/zig-0-15-1-reader-writer-dont-make-copies-of-fieldparentptr-based-interfaces/11719)

## Tags
