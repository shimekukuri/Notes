# Zig How To - Allocator And Io Init

## Abstract

Easy copy and paste of inits of for async and allocator

```zig
const std = @import("std");

const builtin = @import("builtin");
const native_os = builtin.target.os.tag;
var debug_allocator: std.heap.DebugAllocator(.{}) = .init;

const Io = std.Io;
const Threaded = Io.Threaded;

pub fn main() !void {
    const gpa, const is_debug = gpa: {
        if (native_os == .wasi) break :gpa .{ std.heap.wasm_allocator, false };
        break :gpa switch (builtin.mode) {
            .Debug, .ReleaseSafe => .{ debug_allocator.allocator(), true },
            .ReleaseFast, .ReleaseSmall => .{ std.heap.smp_allocator, false },
        };
    };
    defer if (is_debug) {
        _ = debug_allocator.deinit();
    };

    var threaded: std.Io.Threaded = .init(gpa);
    defer threaded.deinit();

    const io = Threaded.io();
}

```

## Directory

## Useful Links

## Tags

[[zig-how-to]]
