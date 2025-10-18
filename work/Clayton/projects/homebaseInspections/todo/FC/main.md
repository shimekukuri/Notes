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
✅ Not the highest Priority but probably should come back and redo the Media Cards because they are a fucking mess
✅ Fixed Controled input where it was assumed to have flex 1 on condition report
✅ Fix the header to it navigates to the appropriate root component
✅ Fix the Header For Asset
✅ Once the backend is done verify the role are working properly
✅ Something in the media tab is making a network call when it shouldn't be. It's implicit to even offline functionality
✅ The useMedia hook hastily fetches in the background, maybe it shouldn't do that. Seems like a bit of a side
✅ Clean up useInspectionList (not using this needs to be deleted tho)
* Delete useInspectionLIst
* Come back to do Camera it needs to be it's own story and I either need a test device or something
* In the Homeinspection Haader the camera button, really we just needt redo the header for the old app as well
* Remove the handleSubmit from the submit buttons, already using the hook should probably just grab it out of there,
  that or form should have to be passed in as a whole or the primatives that are required from form from the submit
  buttons.
* Remove array methods for handlers.
    * handleRemoveModalConfirm in features/homseinspections/components/attemptstab.tsx
    * onSubmit in newInspectionsModal looks awful
* Fix Create Patch again (ugh)
* When a request is removed we need to update what all is removed IE we also need to get rid of meta data
* Might need to move sorting for HIfieldUse and LIst into it's own area they are kind of co-dependent

### Upload Stuff
✅ When upload fails inspection needs to be red.
✅ When upload succeeds inspetion needs to be in green
✅ Need to add multistaging uploads IE Group 1 should finish before group 2(Reviewed not needed at this time)
✅ Make it so progress bars update after upload
* Remove all of the succesfully uploaded inspections, probably need either a second button.
* When attempting an upload on any inspection it needs to lock them.
* When Inspections has nothing to upload everything locks up at thend.
* Need to handle error handling for even on the successful paths
* When it is not validated it needs to fail
* Maybe repurpose the status's section of the card to indicate If there where particular failures
* I think that all of the on mount logic in each individual card could be moved up to a common anscestor and we
  itterate through them in one place instead of in each individual card (Need to think about this)

### Upload Individual stuff

### Authentication to do
✅ Need to finish up the authentication stuff at the request layer.
✅ Need to handle the event where they need to log back in.
✅ Condition Report tab still using legacy refresh button
* Need to do a preemtive check to see if auth token is expired if so go ahead and initiate the authentication request


### Inspections Tab
✅ remove validate from everything that isn't an auto generated inspection

### Type Fixes
* Make the setSorted By work right where it doesn't show offline in media tab

### Fix Bugs
✅ Whatever this Text strings must be rendered within text when trying to authentication
✅ Ensure that the initial login screen works as intended after the change
* It seems that the media tab is still making a network calle
* Trying to modify Hud Numbers in an inspection straight breaks everything

### Clean up
❌ Remove all Remove Laters
❌ Remove all console logs
❌ Remove all unsued code via the npm cleaner thing
❌ Retest everything

### BACKEND HOOKED UP LETS GO
*

## Directory

## Useful Links

## Tags
