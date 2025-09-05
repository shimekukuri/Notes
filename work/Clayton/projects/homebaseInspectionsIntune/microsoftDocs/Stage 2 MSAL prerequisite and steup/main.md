# Clayton Projects - Homebase Inspections Intune - Microsoft Documentation Stage 2

## Abstract

### Stage Goals
- Register your application with Microsoft Entra ID.
- Integrate MSAL into your iOS application.
- Verify that your application can obtain a token that granta access to protected resources.

### Set up and configufe a Microsoft Entra app registration

MSAL requries apps to register with MIcrosfot Entra ID and create a unique client ID and redirect URI, to guarantee
the security of the token gratned to the app. If your application already uses MAL for its own authentication, then
there should already be a Microsoft Entra pp registration/client ID/redirect URI

Client is unique to the entra application, Vincent is going to need to make a new Entra app for the poc for testing
purposes.
AZURE_CLIENT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
AZURE_TENANT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

//This is the redirect URL
APP_URL=com.claytonhomes.com.HomebaseMobileDev
//this is for the POC
com.claytonhomes.com.rmkdiscovery


pbxproj
		13B07F941A680F5B00A75B9A /* Debug */ = {
			isa = XCBuildConfiguration;
			baseConfigurationReference = E5F26CE9BF2DF914BBD76BDE /* Pods-Homebase.debug.xcconfig */;
			buildSettings = {
				APP_DISPLAY_NAME = "ITG Inspections";
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				CLANG_ENABLE_MODULES = YES;
				CODE_SIGN_IDENTITY = "Apple Development";
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1.12.3;
				DEVELOPMENT_TEAM = P5H998WW37;
				ENABLE_BITCODE = NO;
				INFOPLIST_FILE = Homebase/Info.plist;
				INFOPLIST_KEY_CFBundleDisplayName = Inspections;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 25.07.29;
				OTHER_LDFLAGS = (
					"$(inherited)",
					"-ObjC",
					"-lc++",
				);
				PRODUCT_BUNDLE_IDENTIFIER = com.claytonhomes.com.HomebaseMobileDev;
				PRODUCT_NAME = Homebase;
				PROVISIONING_PROFILE_SPECIFIER = "";
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
				SWIFT_VERSION = 5.0;
				VERSIONING_SYSTEM = "apple-generic";
			};
			name = Debug;
		};

plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	<key>CFBundleDisplayName</key>
	<string>$(APP_DISPLAY_NAME)</string>
	<key>CFBundleExecutable</key>
	<string>$(EXECUTABLE_NAME)</string>
	<key>CFBundleIdentifier</key>
	<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>$(PRODUCT_NAME)</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>$(MARKETING_VERSION)</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleURLTypes</key>
    HEY RIGHT HERE
	<array>
		<dict>
			<key>CFBundleURLName</key>
			<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>msauth.$(PRODUCT_BUNDLE_IDENTIFIER)</string>
				<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
			</array>
		</dict>
	</array>
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>msauthv2</string>
		<string>msauthv3</string>
	</array>
    TO HERE
	<key>CFBundleVersion</key>
	<string>$(CURRENT_PROJECT_VERSION)</string>
	<key>LSRequiresIPhoneOS</key>
	<true/>
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<false/>
		<key>NSAllowsLocalNetworking</key>
		<true/>
	</dict>
    TO RIGHT HERE YOU GOOBER YOU WILL FORGET THIS LATER
	<key>NSCameraUsageDescription</key>
	<string>Homebase needs access to your Camera to take pictures and videos</string>
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>Homebase needs access to your location to see relative location to assets</string>
	<key>NSMicrophoneUsageDescription</key>
	<string>Homebase needs access to your microphone for video sound</string>
	<key>NSPhotoLibraryAddUsageDescription</key>
	<string>Homebase needs to be able to browse and edit photos from your library</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>Homebase needs access to your Photos to select images to upload</string>
	<key>UIAppFonts</key>
	<array>
		<string>AntDesign.ttf</string>
		<string>Entypo.ttf</string>
		<string>EvilIcons.ttf</string>
		<string>Feather.ttf</string>
		<string>FontAwesome.ttf</string>
		<string>FontAwesome5_Brands.ttf</string>
		<string>FontAwesome5_Regular.ttf</string>
		<string>FontAwesome5_Solid.ttf</string>
		<string>FontAwesome6_Brands.ttf</string>
		<string>FontAwesome6_Regular.ttf</string>
		<string>FontAwesome6_Solid.ttf</string>
		<string>Foundation.ttf</string>
		<string>Ionicons.ttf</string>
		<string>MaterialIcons.ttf</string>
		<string>MaterialCommunityIcons.ttf</string>
		<string>SimpleLineIcons.ttf</string>
		<string>Octicons.ttf</string>
		<string>Zocial.ttf</string>
		<string>Fontisto.ttf</string>
		<string>FuturaStd-Bold 2.otf</string>
		<string>FuturaStd-Bold 3.otf</string>
		<string>FuturaStd-Bold 4.otf</string>
		<string>FuturaStd-Bold.otf</string>
		<string>FuturaStd-Book 2.otf</string>
		<string>FuturaStd-Book 3.otf</string>
		<string>FuturaStd-Book 4.otf</string>
		<string>FuturaStd-Book.otf</string>
		<string>FuturaStd-CondensedBold 2.otf</string>
		<string>FuturaStd-CondensedBold 3.otf</string>
		<string>FuturaStd-CondensedBold 4.otf</string>
		<string>FuturaStd-CondensedBold.otf</string>
		<string>FuturaStd-CondensedLight 2.otf</string>
		<string>FuturaStd-CondensedLight 3.otf</string>
		<string>FuturaStd-CondensedLight 4.otf</string>
		<string>FuturaStd-CondensedLight.otf</string>
	</array>
	<key>UILaunchStoryboardName</key>
	<string>LaunchScreen</string>
	<key>UIRequiredDeviceCapabilities</key>
	<array>
		<string>arm64</string>
	</array>
	<key>UISupportedInterfaceOrientations</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>UIViewControllerBasedStatusBarAppearance</key>
	<false/>
</dict>
</plist>

Note: This is probably the Azure related env vars that are available in the initial application.

Link MSAL to your project:
Follow these instructions:
(make sure the project format is a good one I had 16.3 and it broke it and had to go to 16
For native-authentication:

To use the native authentication capabilities provided by MSAL in your iOS or macOS application, you need to specify native-auth as subspec for the MSAL dependency as follows:

```pod
use_frameworks!

target 'your-target-here' do
	pod 'MSAL/native-auth'
end
```
Note: If you're using the native-auth subspec, you must include the use_frameworks! setting in your Podfile.

## Directory

## Useful Links

## Tags
[[clayton-main]]
