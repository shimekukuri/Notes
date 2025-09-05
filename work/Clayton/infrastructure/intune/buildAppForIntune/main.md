# Clayton  Intune - Build Apk

## Abstract
Generating an IPA (iOS App Store Package) file in Xcode involves archiving your project and then exporting the archive. Here are the steps:
Open your project in Xcode:
Launch Xcode and open the .xcodeproj or .xcworkspace file for your iOS application.
Select the Scheme and Destination:
In the top toolbar, ensure the correct scheme (e.g., your app's name) is selected.
Choose "Any iOS Device (arm64)" or "Generic iOS Device" as the build destination, not a specific simulator.
Clean and Archive:
Go to Product > Clean Build Folder to ensure a clean build.
Then, go to Product > Archive. Xcode will build your project and create an archive. The Organizer window will appear, displaying the newly created archive.
Export the Archive:
In the Organizer window, select the archive you just created.
Click the Distribute App button.
Choose a Distribution Method:
Xcode will present several distribution options:
App Store Connect: For submitting your app to the App Store.
Ad Hoc: For distributing the app to a limited number of specific devices (requires device registration in your Apple Developer account).
Enterprise: For internal distribution within an organization (requires an Apple Developer Enterprise Program account).
Development: For testing on registered development devices.
Select the method appropriate for your needs and click Next.
Configure Export Options:
Follow the prompts in the export wizard. This typically involves selecting signing certificates and provisioning profiles, and potentially configuring app thinning options.
Xcode will validate your choices.
Save the IPA File:
Finally, you will be prompted to choose a location and name for the exported IPA file.
Click Export to generate and save the .ipa file.

## Directory

## Useful Links

## Tags
[[clayton-main]]
[[clayton-projects-homebase-inspections-intune]]

