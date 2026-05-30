# Css - Container Queries

## Abstract
Example of a container query: 
```typescript
import { css, html, LitElement } from "lit";
import { customElement } from "lit/decorators.js";

@customElement("app-channel-group")
export class AppChannelGroup extends LitElement {
  static styles = css`
    :host {
      display: flex;
      container-type: inline-size;
      container-name: app-channel-group-container;

      @container app-channel-group-container (width > 700px) {
      }
    }
  `;

  render() {
    return html``;
  }
}
```

## Directory

## Useful Links

## Tags
