# Clayton Homebase Inspections Todo - FC

## Abstract

### Main Todo
✅ Need Error Handling around all of the request layer calls that could throw
✅ Check animated tabs and make sure we set up some kind of key prop
✅ Need to remove all instance of the old implimentation of the error modal
✅ Need to come up with a better interface for the ErrorModal something like I have for the other tabs and such
✅ Remove custom error handling from the application sense we are now using data dog
✅ Can we somehow unify certain things between Assetlist, FClist, and Tasklist components (maybe better not)
✅ Make it so Network Text is green or red depending on the network request status
* Clean up useInspectionList
* Need to finish up the authentication stuff at the request layer.
* Need to handle the event where they need to log back in.
* Need to do a preemtive check to see if auth token is expired if so go ahead and initiate the authentication request
* Not the highest Priority but probably should come back and redo the Media Cards because they are a fucking mess
* The useMedia hook hastily fetches in the background, maybe it shouldn't do that. Seems like a bit of a side

* Come back to do Camera it needs to be it's own story and I either need a test device or something
* In the Homeinspection HEader the camera button, really we just needt redo the header for the old app as well

### Type Fixes
* Make the setSorted By work right where it doesn't show offline in media tab

### Fix Bugs
✅ Whatever this Text strings must be rendered within text when trying to authentication
* Ensure that the initial login screen works as intended after the change

### Clean up
❌ Remove all Remove Laters
❌ Remove all console logs
❌ Remove all unsued code via the npm cleaner thing
❌ Retest everything

### Feedback
* TouchPoint
    * Customer
    *

## Directory

## Useful Links

## Tags
