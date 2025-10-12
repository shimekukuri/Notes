# Linux Wayland - Wire Protocol

## Abstract

The wire protocol is a stream of 32-bit values, encoded with the host's byte order usually little endian These values
represent the following primative types

int, uint: 32-bit signed or unsigned integer.

fixed: 24.8 bit signed fixed-point numbers.

object: 32-bit object ID.

new_id: 32-bit object ID which allocates that object when received.

In addition to these primitives, the following other types are used:

string: A string, prefixed with a 32-bit integer specifying its length (in bytes), followed by the string contents and
a NUL terminator, padded to 32 bits with undefined data. The encoding is not specified, but in practice UTF-8 is used.

array: A blob of arbitrary data, prefixed with a 32-bit integer specifying its length (in bytes), then the verbatim
contents of the array, padded to 32 bits with undefined data.

fd: 0-bit value on the primary transport, but transfers a file descriptor to the other end using the ancillary data in
the Unix domain socket message (msg_control).

enum: A single value (or bitmap) from an enumeration of known constants, encoded into a 32-bit integer.

### Object Ids

When a message comes in with a new_id argument, the sender allocates an object ID for it — the interface used for this
object is established through additional arguments, or agreed upon in advance for that request/event. This object ID
can be used in future messages, either as the first word of the header, or as an object_id argument. The client
allocates IDs in the range of [1, 0xFEFFFFFF], and the server allocates IDs in the range of [0xFF000000, 0xFFFFFFFF].
IDs begin at the lower end of this bound and increment with each new object allocation.

An object ID of 0 represents a null object; that is, a non-existent object or the explicit lack of an object

### Unix Socket

## Directory

## Useful Links

## Tags

[[linux-wayland]]
