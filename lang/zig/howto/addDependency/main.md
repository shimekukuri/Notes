# Zig How To - Add a Dependency

## Abstract
First go out and git the url of the package that you wish to add. and execute a zig fetch command at the root of the
the project:
```bash
zig fetch --save git+https://github.com/shimekukuri/vii
```
than inside zig zon add it to the graph and also pass along the optimiztions and target:
```zig
    const dep_opt = .{ .target = target, .optimize = optimize };
    const vii_module = b.dependency("vii", dep_opt).module("vii");

    const zlir_module = b.addModule("zlir", .{ .root_source_file = b.path("src/zlir.zig"), .target = target, .imports = &.{.{ .name = "vii", .module = vii_module }} });

    const exe = b.addExecutable(.{
        .name = "zlir",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "zlir", .module = zlir_module },
            },
        }),
    });

```


## Directory

## Useful Links

## Tags
[[zig-how-to]]
