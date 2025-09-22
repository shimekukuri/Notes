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
    function removeExtension(key: string) {
    if (editableItem.value && key !== 'note') {
        const { [key]: removed, ...rest } = editableItem.value.extensions;
        let result: { [key: string]: string } = {};
        const resKeys = Object.keys(rest);
        const hold: Array<string> = [];
        let baseNumber = 0;
        for (let i = 0; i < resKeys.length; i++) {
            const innerKey = resKeys[i];
            if (innerKey.slice(0, 10) === 'extension_') {
                hold.push(innerKey);
                continue;
            }
            result[innerKey] = rest[innerKey];
            baseNumber++;
        }
        baseNumber++
        for (let i = 0; i < hold.length; i++) {
            result[`extension_${baseNumber + i}`] = rest[hold[i]];
        }
        editableItem.value.extensions = result;
    }
    ```

## Directory

## Useful Links

## Tags

