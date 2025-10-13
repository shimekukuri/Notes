# Typescript How To - Union Pattern

## Abstract
```typescript
export type ImageFileUnion =
    | ({ kind?: "ReadDirResItemT" } & ReadDirResItemT)
    | ({ kind?: "Media" } & Media);

f.unction video(x: ImageFileUnion, statuses: LookupResponse): boolean {
    switch (x?.kind) {
        case "ReadDirResItemT": {
            return x.name.split(".")[1] === "mov";
        }
        case "Media": {
            return (
                x.mediaTypeId ===
                statuses?.find((item) => item.description === "video")?.id
            );
        }
        default: {
            return false;
        }
    }
}


```

## Directory

## Useful Links

## Tags
[[typescript-how-to]]
