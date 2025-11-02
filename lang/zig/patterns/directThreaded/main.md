# Zig Patterns - Direct Threaded

## Abstract

```zig
const Ops = [_]Op{
    .add,        // 0
    .jump(4),    // 1 - jump to IP 4
    .sub,        // 2
    .print,      // 3
    .halt,       // 4
};

pub fn run() void {
    var ip: usize = 0;
    var acc: i32 = 0;

    vm: switch (ip) {
        inline 0...Ops.len - 1 => |IP| {
            const op = Ops[IP];
            switch (op) {
                .add => {
                    acc += 1;
                    continue :vm IP + 1;
                },
                .sub => {
                    acc -= 1;
                    continue :vm IP + 1;
                },
                .print => {
                    std.debug.print("acc={d}\n", .{acc});
                    continue :vm IP + 1;
                },
                .jump => |target| {
                    // Jump to arbitrary target
                    continue :vm target;
                },
                .halt => break :vm,
            }
        },
    }
}

```

## Directory

## Useful Links

## Tags
