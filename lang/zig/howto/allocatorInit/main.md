# Zig How To - Allocator Init

## Abstract

This is an easy and copy and pastable way to initialize the zig alloctaor interface for all projects:

```zig
const builtin = @import("builtin");
const native_os = builtin.target.os.tag;
var debug_allocator: std.heap.DebugAllocator(.{}) = .init;


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

```

## Directory

## Useful Links

## Tags

[[zig-how-to]]
