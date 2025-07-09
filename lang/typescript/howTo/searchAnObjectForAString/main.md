# TypeScript How To - Search an Object for a string

## Abstract
```typescript
export function isObject(value: any): boolean {
    return Object.prototype.toString.call(value) === "[object Object]";

export const searchObject = (input: any, searchValue: string): boolean => {
    if (typeof input === "string") {
        return input.toLowerCase().includes(searchValue.toLowerCase());
    } else if (Array.isArray(input)) {
        return input.some((item) => searchObject(item, searchValue));
    } else if (isObject(input)) {
        return Object.values(input).some((value) =>
            searchObject(value, searchValue),
        );
    }
    return false;
};
```

## Directory

## Useful Links

## Tags
[[typescript]] [[typescript-how-to]][[typescript-how-to-check-of-a-value-is-an-object]]
