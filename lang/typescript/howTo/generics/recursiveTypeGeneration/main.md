# TypeScript How To - Recursive Type Generation

## Abstract
```typescript
import {
    DocumentDirectoryPath,
    readDir,
    unlink,
    write,
    downloadFile,
    mkdir,
    ReadDirResItemT,
} from "@dr.pogodin/react-native-fs";
import { isObject } from "../createPatch";
import React from "react";

type HookReturn<T> = [
    () => Promise<void>,
    {
        isLoading: boolean;
        isError: boolean;
        data: T | undefined;
        error: Error | undefined;
    },
];

type RemoveFirstArg<T extends (...args: any) => any> = T extends (
    arg1: any,
    ...rest: infer R
) => infer Ret
    ? (...args: R) => Ret
    : never;

type RemoveCtx<T extends (...args: any) => any> = T extends (
    arg1: any,
    arg2: any,
    ...rest: infer R
) => infer Ret
    ? (...args: R) => Ret
    : never;

type Base<T> = {
    [K in keyof T as T[K] extends object
        ? `dir${Capitalize<string & K>}`
        : K]: T[K] extends (...args: any[]) => any
        ? RemoveFirstArg<T[K]>
        : T[K] extends Array<any>
        ? {
              select: (
                  ...x: Parameters<RemoveFirstArg<typeof select>>
              ) => T[K][number] | undefined;
          }
        : T[K] extends object
        ? Base<T[K]> & {
              readDir: (
                  ...x: Parameters<RemoveFirstArg<typeof readDir>>
              ) => Promise<ReadDirResItemT[]>;
              useReadDir: (
                  ...x: Parameters<RemoveFirstArg<typeof readDir>>
              ) => HookReturn<ReturnType<typeof readDir>>;
              write: (
                  ...x: Parameters<RemoveFirstArg<typeof write>>
              ) => Promise<void>;
              useWrite: (
                  ...x: Parameters<RemoveFirstArg<typeof write>>
              ) => HookReturn<typeof write>;
              unlink: (
                  ...x: Parameters<RemoveFirstArg<typeof unlink>>
              ) => Promise<void>;
              downloadFile: typeof downloadFile;
          }
        : T[K];
};

function select(path: string, name: string) {
    // This should check to make sure that something exists IE that the asset exists in Redux
    const p = async () => {
        try {
            const res = await readDir(path + name);
            return res[0];
        } catch (e) {
            throw new Error(e);
        }
    };
}

const exampleFs = {
    remarketing: {
        asset: [
            {
                media: {
                    primary: {
                        setUpPrimary: async (
                            _path: string,
                            { yolo: string },
                        ) => {
                            return 8;
                        },
                    },
                    pending: {},
                    uploaded: {},
                    downloaded: {},
                },
            },
        ],
        temp: {},
    },
    servicing: {
        media: {
            pending: {},
            uploaded: {},
            downloaded: {},
        },
        temp: {},
    },
};

const useHookifyPromise = <T>(x: () => Promise<T>) => {
    const [isLoading, setIsLoading] = React.useState<boolean>(false);
    const [isError, setIsError] = React.useState<boolean>(false);
    const [error, setError] = React.useState<Error | undefined>(undefined);
    const [data, setData] = React.useState<T | undefined>(undefined);

    const trigger = async () => {
        setIsLoading(() => true);
        setIsError(() => false);
        setError(() => undefined);
        setData(() => undefined);
        console.log("yolo");
        try {
            console.log("before");
            const res = await x();
            console.log("res:", res);
            setData(() => res);
        } catch (e) {
            console.log("x", x());
            console.log(e);
            setIsError(() => true);
            setError(() => new Error(e));
        }
        setIsLoading(() => false);
    };

    return [trigger, { isLoading, isError, error, data }];
};

export const FS = <T extends object>(fs: T): Base<T> => {
    const enhance = (obj: any, path = DocumentDirectoryPath + "/"): any => {
        const init = async () => {
            return await mkdir(path);
        };
        const result: any = {};
        for (const key in obj) {
            if (typeof obj[key] === "function") {
                result[key] = (args: any) => obj[key](path, ...args);
            } else if (isObject(obj[key])) {
                result[`dir${key.slice(0, 1).toUpperCase()}${key.slice(1)}`] = {
                    ...enhance(obj[key], key + "/"),
                    readDir: async () => {
                        await init();
                        return await readDir(path);
                    },
                    useReadDir: (
                        args: Parameters<RemoveFirstArg<typeof readDir>>,
                    ) =>
                        useHookifyPromise(async () => {
                            await init();
                            return await readDir(path, ...args);
                        }),
                    write: async (
                        args: Parameters<RemoveFirstArg<typeof write>>,
                    ) => {
                        await init();
                        return await write(path, ...args);
                    },
                    useWrite: (
                        args: Parameters<RemoveFirstArg<typeof write>>,
                    ) =>
                        useHookifyPromise(async () => {
                            await init();
                            return await write(path, ...args);
                        }),
                    unlink: async (
                        args: Parameters<RemoveFirstArg<typeof unlink>>,
                    ) => {
                        await init();
                        return await unlink(path, ...args);
                    },
                    downloadFile: async (
                        args: Parameters<typeof downloadFile>,
                    ) => {
                        await init();
                        return downloadFile(...args);
                    },
                };
            } else if (Array.isArray(obj[key])) {
                result[`dir${key.slice(0, 1).toUpperCase()}${key.slice(1)}`] = {
                    select: select,
                };
            } else {
                result[key] = obj[key];
            }
        }
        return result;
    };
    return enhance(fs);
};

export const SystemFs = FS(exampleFs);
console.log(
    "test",
    SystemFs.dirRemarketing.dirAsset.select("").media.primary.setUpPrimary(),
);

```

## Directory

## Useful Links

## Tags
