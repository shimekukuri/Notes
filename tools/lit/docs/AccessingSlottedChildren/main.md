# Lit Documentation - Accessing Slotted Chilren

## Abstract
To access children assigned to slots in your shadow root, you can use the standard slot.assignedNodes or
slot.assignedElements methods with the slotchange event.

For example, you can create a getter to access assigned elements for a particular slot:

```typescript
get _slottedChildren() {
  const slot = this.shadowRoot.querySelector('slot');
  return slot.assignedElements({flatten: true});
}
```

The elements are assigned only after the slot is rendered.

If you need to access assigned elements at startup, you need to wait for firstUpdated or updated. If you want to
access assigned elements when your render changes, you can use slotchange.

You can use the slotchange event to take action when nodes are first assigned or change. The following example
extracts the text content of all of the slotted children.

```typescript
handleSlotchange(e) {
  const childNodes = e.target.assignedNodes({flatten: true});
  // ... do something with childNodes ...
  this.allText = childNodes.map((node) => {
    return node.textContent ? node.textContent : ''
  }).join('');
}

render() {
  return html`<slot @slotchange=${this.handleSlotchange}></slot>`;
}
```

For more information, see HTMLSlotElement on MDN.

It seems that this way is the better way of doing this: 

```typescript
@queryAssignedElements
```

## Directory

## Useful Links

## Tags
