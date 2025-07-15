# TypeScript Utility Type - Partial With Required

## Abstract
```typescript
export type PartialWithRequired<T, K extends keyof T> = Partial<T> & {
    [P in K]-?: T[P];
};
```

## Directory

## Useful Links

## Tags
