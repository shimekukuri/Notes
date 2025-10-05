# Zig STD Meta - DeclEnum

## Abstract
std.meta.DeclEnum examines all pub const declarations in that struct at compile time

Returns an enum type (a type with named values) where each variant corresponds to a declaration name

EXAMPLE:

```zig
pub const demoGrammar = struct {
    const R = std.meta.DeclEnum(@This());
    pub const Value = Match(union(enum) {
        integer: Call(R.Integer),
        array: Call(R.Array),
    });
    pub const Integer = Match(struct {
        d: Char(CharClass.range('1', '9'), .one),
        ds: Char(CharClass.range('0', '9'), .kleene),
        _skip: Hide(Call(R.Skip)),
    });
    pub const Array = Match(struct {
        open: Hide(CharSet("[", .one)),
        skip1: Hide(Call(R.Skip)),
        values: Kleene(R.Value),
        close: Hide(CharSet("]", .one)),
        skip2: Hide(Call(R.Skip)),
    });
    pub const Skip = CharSet(" \t\n\r", .kleene);
};
```

R becomes this:

```zig
enum { Value, Integer, Array, Skip }
```

## Directory

## Useful Links

## Tags
[[zig-std-meta]]
