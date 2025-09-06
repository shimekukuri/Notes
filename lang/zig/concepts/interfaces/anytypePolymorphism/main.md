# Zig Interfaces - anytype polymorphism

## Abstract
Basically you create a function that takes a type that describes the functions that have to exist on on the type that comes into it.
Essentially anything used by this polymorphic function must carry with it it's own implimentation example:

Here we first create the struct definition that has methods that match the same function signatures as what the polymorphic function
expects. The definition for interface (IE just field members that are methods) is genrated by the SmthFnBodes function
at compile time it takes a type and returns a type that is a struct that impliments both foo and bar. When you go to use it. anytype
erases the type of the selement coming in, but then fns asserts that the type of smth has two parameters on it foo and bar and that
those two paramers functions signatures match what is expected.

```zig
const std = @import("std");

pub fn main() !void {
    var x = Smth.init(4);
    x.nonPointer();
    x.modify(4444);
    x.pointer();

    polymorphicFn(x, .{ .bar = Smth.bar, .foo = Smth.foo });
}

fn SmthFnBodes(comptime T: type) type {
    return struct { foo: fn (T) void, bar: fn (T, u32) u32 };
}

fn polymorphicFn(smth: anytype, fns: SmthFnBodes(@TypeOf(smth))) void {
    fns.foo(smth);
    std.debug.print("\n poly bar: {any}", .{fns.bar(smth, 4)});
}

const Smth = struct {
    val: u32,

    fn foo(_: Smth) void {
        std.debug.print("\nfoo", .{});
    }

    fn bar(_: Smth, nb: u32) u32 {
        return nb * 2;
    }

    fn modify(self: *Smth, val: u32) void {
        self.val = self.val + val;
    }

    fn pointer(self: *Smth) void {
        std.debug.print("\nPointer: {any}", .{self.val});
    }

    fn nonPointer(self: Smth) void {
        std.debug.print("\nnon Pointer: {any}", .{self.val});
    }

    fn init(val: u32) Smth {
        return Smth{
            .val = val,
        };
    }
};

```

on a personal note I don't know how often I would use something like this, it is somwhat alright in the sense that we at least
at compile time can assert that at function needs to take a struct that has an implimentation for methods and other fields and
then do operations on those.

You know as I am thinking through it it isn't actually a bad way of doing it because at least what you are really doing is just
composing how things should interact with eachother or creating a procedure that exists in one place or enforces a certain set
of behaviors. Really functionally we could say FmthFnBodes could Really Be Renamed as convention that says Int at the end.

I would say that this would probably be most usefule for when wanting to encapsulate some type of behavior where we are
are cognizant of the return types or the side effects it is  producing.

One thing that might be useful if is a polymorphicFn where the fields that it takes in are actually backed by arrays or
buffers where we can do some type of simd operation over them, IE

## Directory

## Useful Links

## Tags
