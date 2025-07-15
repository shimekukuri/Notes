# TypeScript How To - Generics: Default Generic Implementation

## Abstract
This is how you essentially force a Generic Parameter to be constructed from another, The usecase being wanting to
construct a generic from T without having to define it IE defining K for the function

```typescript
    interface PageProps<T, K extends keyof T = keyof T> {
        Component: ComponentType<T[K]>;
        name: K;
        props?: T[K];
    }

    const Page = ({
        Component,
        name,
        props,
    }: PageProps<T>) => {

```



## Directory

## Useful Links

## Tags
[[typescript-how-to]]
[[typescript-concepts-generics]]
[[typescript-how-to-generics]]
