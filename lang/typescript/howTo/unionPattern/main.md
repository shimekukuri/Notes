# Typescript How To - Union Pattern

## Abstract
```typescript
// Utility to extract shared keys between two types
type SharedKeys<A, B> = keyof A & keyof B;

// Core utility type that merges two types with a discriminator
export type MergeWithDiscriminator<
  A,
  B,
  K extends keyof A & keyof B,
  DiscriminatorA extends string,
  DiscriminatorB extends string
> =
  | ({ [P in K]: A[P] } & { kind: DiscriminatorA } & Omit<A, K>)
  | ({ [P in K]: B[P] } & { kind: DiscriminatorB } & Omit<B, K>);

// Convenience wrapper that infers shared keys automatically
export type MergeWithAutoShared<
  A,
  B,
  DiscriminatorA extends string,
  DiscriminatorB extends string
> = MergeWithDiscriminator<A, B, SharedKeys<A, B>, DiscriminatorA, DiscriminatorB>;

```

## Directory

## Useful Links

## Tags
[[typescript-how-to]]
