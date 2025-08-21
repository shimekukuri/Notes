# Typescript Examples - Tanstack Query Generator pattern

## Abstract
this does a lot of things that I don't fully understand, even though I wrote it and it works. can be used in a lot
of other meta programming.

```typescript
import {
  QueryFunction,
  queryOptions,
  useQuery,
  UseQueryResult,
  UseSuspenseQueryOptions,
} from "@tanstack/react-query";
import { acquireAccessToken } from "../../util/auth/auth";

export const baseQueryFn = async <T>({
  queryKey,
}: {
  queryKey: readonly [string, OptionalRequestInit];
}): Promise<T> => {
  const [path, init] = queryKey;
  const data = await fetchWrapper(path, init ?? {});
  if (!data.ok) {
    throw {
      url: data.url,
      body: data.body,
      type: data.type,
      status: data.status,
      statusText: data.statusText,
    };
  }

  const res = await data.json();
  return res;
};

export const fetchWrapperTest = async (path: string, init: RequestInit) => {
  //todo get auth header stuff here:
  const token = await acquireAccessToken();

  return await fetch(`https://localhost:5001/api/${path}`, {
    headers: {
      Authorization: `Bearer ${token}`,
      ...init?.headers,
    },
    ...init,
  });
};

export const fetchWrapper = async (path: string, init: RequestInit) => {
  //todo get auth header stuff here:
  const token = await acquireAccessToken();

  return await fetch(`${import.meta.env.VITE_API_URL}${path}`, {
    headers: {
      Authorization: `Bearer ${token}`,
      ...init?.headers,
    },
    ...init,
  });
};

export const generateTSQfn = <T, E extends readonly string[]>(
  root: string,
  endpoints: E,
) => {
  const x = generateQueryFn<T, E>(root, endpoints);
  const y = generateQueryOpt<T, E>(root, endpoints);

  console.log(x, y);

  return { ...x, ...y };
};

export const generateQueryFn = <T, E extends readonly string[]>(
  root: string,
  endpoints: E,
) => {
  type Keys = (typeof endpoints)[number];
  type qKeys = `use${Keys}Query`;
  type Endpoints = { [K in qKeys]: () => UseQueryResult<T, Error> };

  const x = endpoints.reduce<Endpoints>((obj, field: Keys) => {
    obj[`use${field}Query` as qKeys] = () =>
      useQuery({
        queryFn: baseQueryFn<T>,
        queryKey: [`${root}/${field}`, undefined],
      });
    return obj;
  }, {} as Endpoints);
  return x;
};

export const generateQueryOpt = <T, E extends readonly string[]>(
  root: string,
  endpoints: E,
) => {
  type Keys = (typeof endpoints)[number];
  type qKeys = `get${Keys}Option`;
  type Endpoints = {
    [K in qKeys]: () => UseSuspenseQueryOptions<
      T,
      Error,
      T,
      readonly [string, OptionalRequestInit]
    >;
  };

  const x = endpoints.reduce<Endpoints>((obj, field: Keys) => {
    obj[`get${field}Option` as qKeys] = () =>
      queryOptions({
        queryFn: baseQueryFn as QueryFunction<
          T,
          readonly [string, OptionalRequestInit]
        >,
        queryKey: [`${root}/${field}`, {}] as const,
      });
    return obj;
  }, {} as Endpoints);
  return x;
};

export type Methods = "GET" | "PUT" | "POST" | "PATCH";
type OptionalRequestInit = RequestInit | undefined;
```

And here is the example usage of it:

```typescript
import { generateTSQfn } from "./base/baseQuery";

type Typetypes = {
  id: string;
  description: string;
};
type NoteReturnType = {
  id: string;
  description: string;
  source: number;
};
type NoteSourceReturnType = {
  id: number;
  code: string;
  description: string;
  isWritable: boolean;
};

const endpoints = [
  "LoanTypes",
  "FoundationTypes",
  "RemarketingStatuses",
  "BSeals",
  "ParkCodes",
  "TitleCodes",
  "AssetLocations",
  "RoofTypes",
  "SidingTypes",
  "MediaTypes",
  "UserTypes",
  "AssetManagers",
  "DocumentCabinets",
] as const;
const notesEndpoints = ["NoteReasons"] as const;
const noteSourcesEndpoint = ["NoteSources"] as const;

const a = generateTSQfn<Typetypes[], typeof endpoints>("LookupData", endpoints);
const b = generateTSQfn<NoteReturnType, typeof notesEndpoints>(
  "LookupData",
  notesEndpoints,
);
const c = generateTSQfn<NoteSourceReturnType, typeof noteSourcesEndpoint>(
  "LookupData",
  noteSourcesEndpoint,
);

export const {
  useLoanTypesQuery,
  useFoundationTypesQuery,
  useBSealsQuery,
  useParkCodesQuery,
  useRoofTypesQuery,
  useUserTypesQuery,
  useMediaTypesQuery,
  useTitleCodesQuery,
  useAssetManagersQuery,
  useSidingTypesQuery,
  useAssetLocationsQuery,
  useRemarketingStatusesQuery,
  getBSealsOption,
  getLoanTypesOption,
  getParkCodesOption,
  getRoofTypesOption,
  getUserTypesOption,
  getMediaTypesOption,
  getTitleCodesOption,
  getSidingTypesOption,
  getAssetManagersOption,
  getAssetLocationsOption,
  getFoundationTypesOption,
  useDocumentCabinetsQuery,
  getDocumentCabinetsOption,
  getRemarketingStatusesOption,
} = a;

export const { useNoteReasonsQuery, getNoteReasonsOption } = b;
export const { useNoteSourcesQuery, getNoteSourcesOption } = c;
```

## Directory

## Useful Links

## Tags
