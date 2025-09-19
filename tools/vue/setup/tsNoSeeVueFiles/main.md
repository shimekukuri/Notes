# Vue Setup - Ts can't see vue files

## Abstract
in order to fix this create a file in the src dir called shims-vue.d.ts with this content:
```typescript
declare module '*.vue' {
  import { DefineComponent } from 'vue'
  const component: DefineComponent<{}, {}, any>
  export default component
}
```

## Directory

## Useful Links

## Tags
