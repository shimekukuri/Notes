# Zig Patterns - Closure

## Abstract
How this works:

This focuses around the usage of the Runnable struct which provides type erasure to the closure and provides a commmon
interface for you to interact with. Essentially the way tha this works is that we store on an arrayList a series of
pointers to Runnables, those runnable are structs with a field called runFn which is a constant pointer to a function
which takes a pointer to a Runnable. This is extremely confusing but essentially what is is allowing us to do is, if we
imbed this in any other struct when we define the Runnable struct inside of the outer struct we can point to a function
that exists on the containing struct that take a pointer to the Runnable inside othe struct. than inside that function when
we call it by passing in the pointer to the runnable field on the enclosing structure through field parent pntr we can
grab the closure which stores our arguments, sense the arguments are not known until run time, but the function is known
at compile time.

```zig
const std = @import("std");
const mem = std.mem;
const Allocator = mem.Allocator;

const ArrayList = std.ArrayList;

const builtin = @import("builtin");
const native_os = builtin.target.os.tag;

var debug_allocator: std.heap.DebugAllocator(.{}) = .init;

const Runnable = struct { runFn: *const fn (*Runnable) void };

const EventLoop = struct {
    allocator: Allocator,
    arrayList: ArrayList(*Runnable),

    pub fn init(allocator: Allocator) EventLoop {
        return .{ .allocator = allocator, .arrayList = ArrayList(*Runnable).initCapacity(allocator, 0) catch unreachable };
    }

    pub fn deinit(self: *EventLoop) void {
        self.arrayList.deinit(self.allocator);
    }

    pub fn push(self: *EventLoop, runnable: *Runnable) !void {
        try self.arrayList.append(self.allocator, runnable);
    }

    pub fn run(self: *EventLoop) void {
        while (self.arrayList.items.len > 0) {
            const runnable = self.arrayList.orderedRemove(0);
            runnable.runFn(runnable);
        }
    }

    pub fn schedule(self: *EventLoop, comptime func: anytype, args: anytype) !void {
        const Closure = struct {
            runnable: Runnable = .{ .runFn = runFn },
            args: @TypeOf(args),
            allocator: Allocator,

            fn runFn(runnable: *Runnable) void {
                const closure: *@This() = @alignCast(@fieldParentPtr("runnable", runnable));
                @call(.auto, func, args);
                closure.allocator.destroy(closure);
            }
        };
        const closure = try self.allocator.create(Closure);
        closure.* = .{ .allocator = self.allocator, .args = args };
        try self.push(&closure.runnable);
    }
};

fn sayHello(name: []const u8) void {
    std.debug.print("Hello, {s}!\n", .{name});
}

fn addNumbers(a: i32, b: i32) void {
    std.debug.print("{d} + {d} = {d}\n", .{ a, b, a + b });
}

fn repeatMessage(msg: []const u8, count: u32) void {
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        std.debug.print("[{d}] {s}\n", .{ i, msg });
    }
}

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

    var eventLoop: EventLoop = .init(gpa);
    defer eventLoop.deinit();

    try eventLoop.schedule(sayHello, .{"Hello!"});
    try eventLoop.schedule(addNumbers, .{ 1, 2 });
    try eventLoop.schedule(repeatMessage, .{ "repeat", 3 });

    eventLoop.run();
}
```

## Directory

## Useful Links

## Tags
