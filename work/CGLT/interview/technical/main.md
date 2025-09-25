# Common Good Learning CGLT - Interview Technical

## Abstract

### Ticket 1
What I have done:
* Find the update function
* In updateDataInputCard when editing an item notice that when changing the note that editable item actually lacks the proper ext
  But when updating other extensions it actually has all the appropriate extensions, what makes notes special in the reguard?
* There has to be some kind of control flow somehwere involving notes
* follow the function calls and the control flow:
    * find all instances where notes is mentioned
    * find all instances where control flow is being used on an instace that involves notes
    * notice sanitizeExtensions (huh this is an interesting function name given our current bug)
    * note the early return for the notes section
    * notice that we can actually simplify the control flow and remove an entire case
    * we can actually edit sanitizeExtensions function inputs now and remove index.
    * we can also modify and remove itemIndex in handleItemsSanization

### Ticket 2
* create a scratch file just so that its easier to see both at once just delete it later
* Also create the header nav file
* move over the relavent template
* create a ref to the dialog box to interact with it
* make sure you also put the ref on the actual box
* make it so the backdrop can be clicked to exit as well
* move over the mounted code
* after that add into components the AppNavbar so it is registered
* rewrite in ts and setup


### qol
* add rounder edges to the scrollable area on the bottom

### Random found bugs.
* when adding extensions removing a lower number extension and then trying to add after that will result in a state where
  extensions cannot be added
    * updateDataInputCard>addExtension rewrite this to just simply rebuild the extension numbers
    ```typescript
    function addExtension() {
    if (editableItem.value) {
        let extentionCount = 1;
        const extensionsArr: Array<string> = [];
        const result: { [key: string]: string } = {};
        for (let k in editableItem.value.extensions) {
            if (k.slice(0, 10) === `extension_`) {
                extensionsArr.push(editableItem.value.extensions[k]);
                continue;
            }
            result[k] = editableItem.value.extensions[k];
            extentionCount++;
        }
        for (let i = 0; i < extensionsArr.length + 1; i++) {
            result[`extension_${i + extentionCount}`] = extensionsArr[i];
        }
        editableItem.value.extensions = result;
    }
    }

    function removeExtension(key: string) {
        if (editableItem.value && key !== 'note') {
            const { [key]: removed, ...rest } = editableItem.value.extensions;
            const temp: Array<string> = [];
            const result: { [key: string]: string } = {};
            let count = 0;
            for (let k in rest) {
                if (k.slice(0, 10) === `extension_`) {
                    temp.push(rest[k])
                    continue;
                }
                result[k] = rest[k];
                count++;
            }
            for (let i = 0; i < temp.length; i++) {
                result[`extension_${i + count + 1}`] = temp[i] ?? "";
            }
            editableItem.value.extensions = result;
        }
    }

    ```

### architecture improvement for the sanitize function:
```typescript
import { ref } from 'vue'
import { loadFramework, saveFramework, resetFramework } from '@/utils/frameworkLoader'
import type { ExtensionsDefinedKeys, Framework } from '@/utils/frameworkLoader'
import { sanitize } from '@/utils/htmlSanitizer'

const initialFrameworkState = loadFramework()
const framework = ref(initialFrameworkState)
const lastUpdateTimestamp = ref(new Date())

export function useFramework() {
    function updateFramework(updatedData: Framework) {
        type Key = keyof typeof updatedData;
        for (let k in updatedData) {
            switch (k as Key) {
                default: {
                    if (typeof updatedData[k as Key] === "string") {
                        type Narrowed = Exclude<Key, 'items'>;
                        framework.value[k as Narrowed] = sanitize(updatedData[k as Narrowed]);
                    }
                    break;
                }
                case 'items': {
                    handleItemsSanitizationV2(updatedData.items);
                }
            }
        }
        saveFramework(framework.value)
    }

    function handleItemsSanitizationV2(items: Framework['items']) {
        for (let i = 0; i < items.length; i++) {
            type Key = keyof typeof items[number];
            for (let k in items[i]) {
                type Narrowed = Exclude<Key, 'extensions'>
                switch (k as Key) {
                    default: {
                        if (typeof items[i][k as Key] === "string") {
                            framework.value['items'][i][k as Narrowed] = sanitize(items[i][k as Narrowed]);
                        }
                        break;
                    }
                    case 'extensions': {
                        framework.value.items[i].extensions = handleExtentionsSanitizationV2(items[i]['extensions'])
                        break;
                    }
                }
            }

        }
    }

    function handleExtentionsSanitizationV2(extensions: Framework['items'][number]['extensions']) {
        type Key = keyof typeof extensions;
        const result: { [k in ExtensionsDefinedKeys]?: string } = {};
        for (let k in extensions) {
            switch (k as Key) {
                default: {
                    if (typeof extensions[k as Key] === 'string') {
                        result[k as Key] = sanitize(extensions[k as Key]!);
                    }
                    break;
                }
                case 'note': {
                    result['note'] = extensions.note;
                    break;
                }
            }
        }
        return result;
    }

    function reset() {
        framework.value = resetFramework()
        saveFramework(framework.value)
        lastUpdateTimestamp.value = new Date()
    }

    return {
        data: framework,
        lastUpdateTimestamp,
        updateFramework,
        reset,
    }
}
//types
import jsonData from '../data/arizona-framework.json'

export interface Framework {
    id: string;
    name: string;
    description: string;
    version: string;
    gradeLevel: string;
    status: string;
    creator: string;
    items: Item[];
}

export type ExtensionsDefinedKeys = "note" | "source" | "updated";

export interface Item {
    id: string;
    name: string;
    description: string;
    type: string;
    extensions: { [k in ExtensionsDefinedKeys]?: string }
}

const STORAGE_KEY = 'cglt-interview-framework-data'

export function loadFramework(): Framework {
    const savedData = localStorage.getItem(STORAGE_KEY)
    if (savedData) {
        try {
            return JSON.parse(savedData) as Framework
        } catch (error) {
            console.error('Error parsing saved data:', error)
        }
    }

    return jsonData as Framework
}

export function saveFramework(framework: Framework): void {
    try {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(framework, null, 2))
    } catch (error) {
        console.error('Error saving framework:', error)
    }
}

export function resetFramework(): Framework {
    localStorage.removeItem(STORAGE_KEY)
    return jsonData as Framework
}

```

## Directory

## Useful Links

## Tags

