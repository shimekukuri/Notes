# Zig Reference - Pointer Type Chart

## Abstract
  FREE ZIG POINTER CHEATSHEET! (Using u8 as the example type.)
+---------------+----------------------------------------------+
|  u8           |  one u8                                      |
|  *u8          |  pointer to one u8                           |
|  [2]u8        |  two u8s                                     |
|  [*]u8        |  pointer to unknown number of u8s            |
|  [*]const u8  |  pointer to: unknown number of immutable u8s  |
|  *[2]u8       |  pointer to an array of 2 u8s                |
|  *const [2]u8 |  pointer to an immutable array of 2 u8s      |
|  []u8         |  slice of u8s                                |
|  []const u8   |  slice of immutable u8s                      |
+---------------+----------------------------------------------+

This type can be read from right to left (Zig types are nested that way):

Piece	Meaning
[5]u8	A fixed-size array of 5 bytes (unsigned 8-bit integers). Think of it as a short string literal of length 5.

*const [5]u8	A constant pointer to a [5]u8 array. That means it’s a pointer to a fixed-size byte array, and you
can’t mutate the array through this pointer.

[3]*const [5]u8	An array of 3 constant pointers, each pointing to a [5]u8 (a 5-byte array).

________________________________________________________________________________________________________________________
Excellent question — this touches on a subtle but **important** difference in Zig’s pointer and slice syntax.
Let’s unpack the difference between these two:

---

### 🔹 1. `[:0]const u32`

This is a **sentinel-terminated slice**.

#### Meaning:

* `:` means “slice” — a pointer + length.
* `:0` means “the slice is terminated by a sentinel value `0`”.
* So `[:0]const u32` means:

  > “A slice of constant `u32`s that ends with a sentinel value of `0`.”

#### Example:

```zig
const b: [:0]const u32 = &[4:0]u32{ 1, 2, 3, 4 };
```

Here:

* `&[4:0]u32{ ... }` creates a **sentinel-terminated array pointer** with a sentinel value `0` (after the 4 elements).

  * That means this array is actually 5 `u32`s long: `{1, 2, 3, 4, 0}`.
* Zig automatically knows it’s safe to use this as a `[:0]const u32` slice.

✅ **What you get:**
A slice with **length = 4** and **a sentinel value `0` after it**.
This means functions like `std.mem.len(b)` will stop scanning when they hit the sentinel.

---

### 🔹 2. `[*:0]const u32`

This is a **sentinel-terminated pointer** — **not a slice**.

#### Meaning:

* `*` means “pointer”.
* `*:0` means “pointer to elements terminated by a sentinel value `0`”.
* So `[*:0]const u32` means:

  > “A pointer to a sequence of constant `u32`s ending with sentinel `0`.”

#### Example:

```zig
const c: [*:0]const u32 = &[4:0]u32{ 1, 2, 3, 4 };
```

Here:

* The same array literal is used, but now we’re assigning it to a **pointer** type, not a slice.
* `c` doesn’t know its length — it only knows where it starts, and that a `0` marks the end.

✅ **What you get:**
A **C-style sentinel pointer** — very similar to a C string (`char*` that ends in `'\0'`).

You can still iterate over it safely in Zig because the sentinel tells the compiler where to stop.

---

### 🔸 Summary Table

| Type             | Kind    | Has Length? | Has Sentinel? | Typical Use Case                                                           |
| ---------------- | ------- | ----------- | ------------- | -------------------------------------------------------------------------- |
| `[:0]const u32`  | Slice   | ✅ Yes       | ✅ Yes         | When you want both length and sentinel (e.g. safer iteration).             |
| `[*:0]const u32` | Pointer | ❌ No        | ✅ Yes         | When you just need a pointer to sentinel-terminated data (like C strings). |

---

### 🧠 Analogy

If you think in C terms:

* `[:0]const u32` ≈ `struct { u32* ptr; usize len; }` plus a guarantee that `ptr[len] == 0`.
* `[*:0]const u32` ≈ a plain `u32*` that happens to end with `0`.

---

Would you like me to show how iterating over each of them differs in practice (with code examples)?


## Directory

## Useful Links

## Tags
[[zig-reference]]
