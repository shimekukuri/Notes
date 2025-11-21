# TypeScript How To - Resolve promiseAllSettled Values Switch


## Abstract
```typescript
        Promise.allSettled([
            query({ accountId: item.loan.loanId }).then((x) => {
                if (x.isError) {
                    DdRum.addError(
                        `Failed to fetch images for ${item.requestId}`,
                        ErrorSource.NETWORK,
                        new Error(JSON.stringify(x.error)).stack,
                    );
                    throw undefined;
                }
                return x;
            }),
            fs.readDownloadedMedia(),
        ])
            .then((x) => {
                type S =
                    `${(typeof x)[number]["status"]} ${(typeof x)[number]["status"]}`;
                switch (`${x[0].status} ${x[1].status}` as S) {
                    default: {
                        break;
                    }
                    case "rejected rejected": {
                        throw "fullFailure";
                    }
                    case "rejected fulfilled": {
                        throw "queryFailed";
                    }

                    case "fulfilled rejected": {
                        throw "fsError";
                    }
                    case "fulfilled fulfilled": {
                        const z = x[0] as PromiseFulfilledResult<Awaited<ReturnType<typeof query>>>;
                    }
                }
            })
            .catch(() => {})
            .finally(() => {});
    };

```

## Directory

## Useful Links

## Tags
