# Wayland Xml - Reading Wayland Xml

## Abstract
To determine the interface (and thus the "shape") of au32 object ID returned in a Wayland request, you look at the
interface attribute of the new_id argument in the XML.
1. The Standard Case (Static Shape)
In most requests, the XML explicitly tells you what the u32 ID represents.

    Example: In wl_display.get_registry, the XML is:
    <arg name="registry" type="new_id" interface="wl_registry"/>.
    The Determination: Because the XML says interface="wl_registry", you know that the u32 you receive must be treated as a wl_registry object. Its "shape" (the events it can send) is defined under the <interface name="wl_registry"> block in your XML.

2. The Dynamic Case (Hidden Arguments)
There is one major exception: wl_registry.bind. In its XML, the new_id argument does not have an interface attribute:
<arg name="id" type="new_id"/>.
When the interface attribute is missing, the wire protocol changes shape to include extra data:

    The Shape: Instead of just sending the u32 ID, the wire message expands to include:
        string: The name of the interface (e.g., "wl_compositor").
        uint: The version number.
        u32: The actual new Object ID.
    The Determination: You know what the u32 represents because you (the client) literally just sent the string name of the interface in the same message to tell the server what that ID should be.

Summary of how to read the XML for "Shape":

    Find the <request>: Look for the arg where type="new_id".
    Check for interface="...":
        If it exists: That is the type. Use that interface's <event> list to deserialize future messages for that ID.
        If it's missing: The wire format for that specific request is "special" and includes a string/uint prefix to define the type at runtime.

## Directory

## Useful Links

## Tags
