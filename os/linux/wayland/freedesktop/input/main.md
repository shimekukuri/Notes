# Wayland Freedesktop - Input

## Abstract
### Definitions
Seat- A Seat repressentsa group of input devices including mice, keyboards and touchscreens.
- Seata are global objects. Pointer events are delivered in suraface-local coordenates.

### Points of Interest
"To avoid race conditions, input events that are likely to trigger further requests (such as button presses, key
events, pointer motions) carry serial numbers, and request such as wl_surface.set_popup require that the serial number
of the triggering event is specified. The server maintains a monotonically increasing counter of these serial numbers


## Directory

## Useful Links
[chapter-4]("https://wayland.freedesktop.org/docs/html/ch04.html")

## Tags
[[linux-wayland]]
