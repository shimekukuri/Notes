# TypeScript Keywords - Infer

## Abstract
infer is a keyword used inside conditional types to capture a type from a structure.

Example:
```typescript
type ReturnTypeOfFunction<T> = T extends (...args: any[]) => infer R ? R : never;
```

This means:
- If T is a function type (ie something like () => string),
- Then infer the return type R from that function.
- And return R
- Otherwise, return never.

So:
```typescript
type A = () => number;
type B = string;

type ResultA = ReturnTypeOfFunction<A> // number
type ResultB = ReturnTypeOfFunction<B> // never
```

```typescript
type UnwrapFunction = T extends (...args: any[]) => infer R ? R : T;
```

If T is a function, return it's return type R
Otherwise, return T itself

think of it this way:

```typescript
type SimplifiedUnwrapFunction = (T extends (...args: any[]) => infer R) ? R : T;
```

## Directory

## Useful Links

## Tags
[[typescript-syntax->keywords]]
