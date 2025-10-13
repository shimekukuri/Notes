# Typescript Patterns - templateLiteralSwitching

## Abstract
```typescript
type A = "A" | "B" | undefined;
type D = "E" | "F" | undefined;
type E = () => boolean;

const s: A = "A";
const t: D = "F";
const x: A = "B";
const y: D = "E";

type Try = `${A} [string] ${A} ${D}`;
switch (`${s} [string] ${x} ${y}` as Try) {
    default: {
        break;
    }
    case "A [string] A E":
    case "A [string] A F":
    case "A [string] B E":
    case "A [string] B F":
    case "B [string] A E":
    case "B [string] A F":
    case "B [string] B E":
    case "B [string] B F":
}
```

## Directory

## Useful Links

## Tags
