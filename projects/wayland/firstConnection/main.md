# Projects Wayland - First Connection

## Abstract
struct msghdr msg = {0};
struct iovec iov[1];
char buf[CMSG_SPACE(sizeof(int))];
struct cmsghdr *cmsg;

// Message data (the Wayland protocol message)
iov[0].iov_base = message_buffer;
iov[0].iov_len = message_length;
msg.msg_iov = iov;
msg.msg_iovlen = 1;

// Ancillary data (the file descriptor)
msg.msg_control = buf;
msg.msg_controllen = sizeof(buf);
cmsg = CMSG_FIRSTHDR(&msg);
cmsg->cmsg_level = SOL_SOCKET;
cmsg->cmsg_type = SCM_RIGHTS;
cmsg->cmsg_len = CMSG_LEN(sizeof(int));
memcpy(CMSG_DATA(cmsg), &fd, sizeof(int));

sendmsg(socket_fd, &msg, 0);
```

The file descriptor travels "out of band" - it's not in the protocol message itself, but the protocol message has an argument of type "fd" at that position.

## wl_display: The Root Object

### What is wl_display?

`wl_display` is the **singular, pre-existing object** that represents the connection itself. It always has Object ID 1 and exists immediately upon connection - no message needs to create it.

Think of it as the connection handle and the root of the object tree. Every Wayland connection has exactly one wl_display.

### wl_display Interface Definition

The wl_display interface has these requests (client → compositor):

**Request 0: sync**
```
Create a callback for synchronization
Arguments: [new_id: wl_callback]
```

**Request 1: get_registry**
```
Get the global object registry
Arguments: [new_id: wl_registry]
```

And these events (compositor → client):

**Event 0: error**
```
Fatal error notification
Arguments: [object_id], [code: uint], [message: string]
```

**Event 1: delete_id**
```
Notify that an object ID has been deleted
Arguments: [id: uint]
```

### The Initial Handshake

When the connection is first established, there's no formal "handshake message" in the protocol. The client simply starts using object ID 1 (wl_display) immediately. The first real message is usually `wl_display.get_registry`.

## The Registry: Global Object Discovery

### What is the Registry?

The **registry** (`wl_registry`) is a special object that acts as a **directory service** for global objects. It's the mechanism by which clients discover what interfaces the compositor supports.

When you send `wl_display.get_registry`, you're creating a registry object. The compositor then immediately sends events announcing all available global objects.

### Registry Wire Protocol

**Creating the registry (client sends):**
```
01 00 00 00  // Object ID: 1 (wl_display)
0C 00 01 00  // Size: 12 bytes, Opcode: 1 (get_registry)
02 00 00 00  // Argument: new_id = 2 (the new wl_registry)
```

**Registry announces globals (compositor sends):**
```
02 00 00 00  // Object ID: 2 (wl_registry)
XX XX 00 00  // Size: variable, Opcode: 0 (global event)
01 00 00 00  // Argument 1: name = 1 (unique ID for this global)
0D 00 00 00  // Argument 2: interface string length = 13
77 6C 5F 63  // "wl_c"
6F 6D 70 6F  // "ompo"
73 69 74 6F  // "sito"
72 00 00 00  // "r\0" + padding
06 00 00 00  // Argument 3: version = 6
```

### What are Globals?

**Globals** are singleton objects provided by the compositor that represent system-wide resources:

- **wl_compositor** (name might be 1): Interface for creating surfaces
- **wl_shm** (name might be 2): Shared memory buffer management
- **wl_seat** (name might be 3): Input device collection (keyboard, mouse, touch)
- **wl_output** (name might be 4): Display monitor
- **xdg_wm_base** (name might be 5): XDG shell window management
- **zwp_linux_dmabuf_v1** (name might be 6): DMA-BUF buffer sharing
- **wl_data_device_manager** (name might be 7): Clipboard/drag-and-drop

Each global has:
1. **name**: Unique numeric identifier (compositor chooses these)
2. **interface**: String identifying the protocol interface (e.g., "wl_compositor")
3. **version**: Which version of that interface

### Binding to Globals

To use a global, the client must **bind** to it, creating a local proxy object:

**Binding wire protocol:**
```
02 00 00 00  // Object ID: 2 (wl_registry)
XX XX 00 00  // Size: variable, Opcode: 0 (bind)
01 00 00 00  // Argument 1: name = 1 (from global event)
0D 00 00 00  // Argument 2: interface string length
77 6C 5F 63 6F 6D 70 6F 73 69 74 6F 72 00 00 00  // "wl_compositor\0"
06 00 00 00  // Argument 3: version = 6
03 00 00 00  // Argument 4: new_id = 3 (our local proxy object)
```

After this, object ID 3 is a `wl_compositor` interface that the client can use.

### Why This Design?

The registry pattern allows:
1. **Extensibility**: New globals can be added without protocol changes
2. **Capability negotiation**: Clients discover what's available
3. **Version negotiation**: Clients can bind to older versions they understand
4. **Optional features**: Clients can check if specific extensions exist

## Object Lifecycle and ID Management

### Object ID Allocation

Object IDs are allocated by whoever creates the object:

**Client-allocated IDs:**
- Client chooses IDs for objects it creates via requests
- By convention, clients use sequential IDs: 1, 2, 3, 4...
- ID 1 is always wl_display (pre-allocated)

**Compositor-allocated IDs:**
- Compositor chooses IDs for objects it creates via events
- Uses IDs starting from 0xFF000000 (4,278,190,080)
- This prevents ID collisions

### Object Creation

When a request has a `new_id` argument, it creates a new object. The message format depends on whether we're in the initial connection phase:

**After connection established (most common):**
```
[parent_object_id][opcode+size][new_id]
```
The interface type is implicit from the request signature.

**During connection setup:**
```
[parent_object_id][opcode+size][interface_string][version][new_id]
```
Interface and version are explicitly included.

### Object Destruction

Objects are destroyed in two ways:

**1. Explicit destructor requests:**
Most interfaces have a destructor request (often opcode 0):
```
07 00 00 00  // Object ID: 7 (wl_surface)
08 00 00 00  // Size: 8, Opcode: 0 (destroy)
```

**2. Implicit destruction:**
Some objects are automatically destroyed (e.g., `wl_callback` after it fires).

After destruction, the compositor sends `wl_display.delete_id` to confirm the ID can be reused:
```
01 00 00 00  // Object ID: 1 (wl_display)
0C 00 01 00  // Size: 12, Opcode: 1 (delete_id)
07 00 00 00  // Argument: id = 7

## Directory

## Useful Links

## Tags
