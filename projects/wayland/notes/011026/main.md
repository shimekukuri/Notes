# Projects Wayland Notes - 011026

## Abstract
Coming back and thinking about how I want to make things composable Eventually I think that I want to have my wayland
compostior utilize the server interface that I am going to make. I don't know if that is something that I am going to
do right this second as that is going to require figuring out the entirety of that interface upfront. And I am more
trying to get specific parfts of wayland working first like storying registry objects I can being with simply
seperateing out certain functionality into their own type IE WaylandProtocolService actually handles serialization and
deserialization tasks.

I think that in context to me thinking through this problem last time I had come up with something like this:
pub const Server = struct {
    connectionsManager: Container(BoundedArr, Stream, 1024),
    connectionHandler: ConnectionHandler,
    futureManager: FutureManager,
    unixAddress: UnixAddress,
    io: Io,

I think that one I should remove holding io as part of the struct, and second I need to actually add the application.
The application should hold persistant global inforation that has to exist over the course of the entire life time of
the application, and should provide to handler an application 'instance'.

And instance defined as an interface by which handler can move data from the

connection -> protocol -> instance -> application
and then alternatively
application -> instance -> protocol -> connection

Something else to consider is that while unlikely it may happen that parts of the wayland xml maybe different from out
implimentation. Although the core wayland xml should largely be the same but some type of mechanism may be requried to
version between the same interfcae such as Wl_Display may need sometype of switch statement to know which version to
dispatch

The mental model follows that actually when we are designing the requests and events that really what we are
constructing is the handlers for the other side IE

Request is conventionally thought as something that happens on the server, but it actually isn't it is the means by
which the caller is tranmiting their request.

Event conventionally is thought to be something that happening on the server, when it actuality it is what is being
consumed by the client.


## Directory

## Useful Links

## Tags
