# How to open .ulpt files in place

 - [Building ULPT on Windows](#on-windows)
 - [Building ULPT on iOS](#on-ios)

## On iOS

### Enable custom file type for ulpt files on iOS:

- Go to Project -> Targets -> Runner -> Info tab
- Add `Application supports iTunes file sharing` with value `true` to the key value table or info.plist file
- Add `Supports opening documents in place` with value `true` to the key value table or info.plist file
- Add information about the extension to the `Exported Type Identifiers` Tab.

  - Description: Any description e.g. ULPT Performance Data
  - Identifier: Any identifier that is not reserved. E.g. org.frenchtacodev.ulpt
  - Conforms to: public.data, public.content (content is optional)
  - Extensions: ulpt

- Add information about the extension to the `Document Types` Tab.
  - Name: Any name e.g. ULPT Performance Data
  - Types: Same as identifier e.g. org.frenchtacodev.ulpt
  - Handler Rank: Owner

#### Info.plist entry from ULPT Example:

```xml
<plist version="1.0">
<dict>
	<key>CFBundleDocumentTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeName</key>
			<string>ULPT Performance Data</string>
			<key>LSHandlerRank</key>
			<string>Owner</string>
			<key>LSItemContentTypes</key>
			<array>
				<string>org.frenchtacodev.ulpt</string>
			</array>
		</dict>
	</array>
	<key>LSSupportsOpeningDocumentsInPlace</key>
	<true/>
	<key>UIFileSharingEnabled</key>
	<true/>
	<key>UTExportedTypeDeclarations</key>
	<array>
		<dict>
			<key>UTTypeConformsTo</key>
			<array>
				<string>public.data</string>
				<string>public.content</string>
			</array>
			<key>UTTypeDescription</key>
			<string>ULPT Performance Data</string>
			<key>UTTypeIconFiles</key>
			<array/>
			<key>UTTypeIdentifier</key>
			<string>org.frenchtacodev.ulpt</string>
			<key>UTTypeTagSpecification</key>
			<dict>
				<key>public.filename-extension</key>
				<array>
					<string>ulpt</string>
				</array>
				<key>public.mime-type</key>
				<array>
					<string>application/example</string>
				</array>
			</dict>
		</dict>
	</array>
</dict>
</plist>
```

### Handle app call with arguments from native

Add the following code to the `AppDelegate.swift` file in the Flutter Project:

Define this variable within the file:

```swift
private var commChannel: FlutterMethodChannel? = nil;
```

Add this to the `override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?`

```swift
 	//GeneratedPluginRegistrant.register(with: self)
	let controller: FlutterViewController = window?.rootViewController as! FlutterViewController;
        commChannel = FlutterMethodChannel(name: "nativeCommChannel", binaryMessenger: controller.binaryMessenger);
        //return super.application(application, didFinishLaunchingWithOptions: launchOptions)
```

Override this funtion within the file:

```swift
override func application(_ app: UIApplication, open url: URL, options:[UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if(commChannel == nil){return true;}
        
        var copyUrl: URL?;
        var copyUrlPath: String?;
                
        if #available(iOS 14.0, *) {
            copyUrl = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent, conformingTo: UTType.data);
        } else {
            copyUrl = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent);
        };
        
        if #available(iOS 16, *){
            copyUrlPath = copyUrl?.path();
        }else{
            copyUrlPath = copyUrl?.absoluteString;
        }
        
        if(copyUrl == nil || copyUrlPath == nil){return true;}
        
        do{
            if(FileManager.default.fileExists(atPath: copyUrlPath!)){
                try FileManager.default.removeItem(at: copyUrl!);
            }
            
            //If false, access is not granted
            if(url.startAccessingSecurityScopedResource() == false){return true;}
            try FileManager.default.copyItem(at: url, to: copyUrl!);
            url.stopAccessingSecurityScopedResource();
        }catch{
            url.stopAccessingSecurityScopedResource();
            return true;
        }
        
        commChannel!.invokeMethod("onArgsFromNative", arguments: copyUrlPath!);
        return true;
    }
```

File importing is then handled by ULPT.

## On Windows

To support file opening on windows with the "Right click -> Open with" functionality, the following steps are needed:

- Go into the projects windows folder. This is done on the app site and not in the package. E.g. in this project within the example folder/project.
- The APIEntry wWinMain in the ´main.cpp´ file of the project contains a wchar_t pointer called command_line. We need this information

### Implementation
- open flutter_window.h and add under private:

```c++
private:
 // The project to run.
 flutter::DartProject project_;
 // The Flutter instance hosted by this window.
 std::unique_ptr<flutter::FlutterViewController> flutter_controller_;

 //Arguments passed on starting the win32 App
 std::string args_;
 //Utility function to convert the args into flutter encodable value.
 std::string ConvertArgsToString(const wchar_t* args);
```

- change the constructor to:

```c++
explicit FlutterWindow(const flutter::DartProject& project, const wchar_t* args);
```

- open flutter_window.cpp and add the following function implementation:

```c++
//Converts the arguments passed in from the command line that are represented as a wchar_t pointer. 
//Since flutter can only handle std::strings in method communication, conversion is needed.
std::string FlutterWindow::ConvertArgsToString(const wchar_t* args)
{
    std::string result = std::string();

    if (args == nullptr) return result;

    int length = WideCharToMultiByte(CP_UTF8, 0, args, -1, nullptr, 0, nullptr, nullptr);
    char* buffer = new char[length];
    WideCharToMultiByte(CP_UTF8, 0, args, -1, buffer, length, nullptr, nullptr);
    result = std::string(buffer);
    delete[] buffer;
    return result;   
}
```

- modify the constructor implemenation this way:

```c++
FlutterWindow::FlutterWindow(const flutter::DartProject& project, const wchar_t* args) : project_(project){
    args_ = ConvertArgsToString(args);
}
```

- in the `OnCreate` function add the following code after the `ForceRedraw()` call:

```c++
//Create and Invoke the Communication Channel to the flutter app letting it know about arguments if there are any 
if (args_ == "") return true;
flutter::MethodChannel channel(flutter_controller_->engine()->messenger(), "nativeCommChannel", &flutter::StandardMethodCodec::GetInstance());
channel.InvokeMethod(std::string("onArgsFromNative"), std::make_unique<flutter::EncodableValue>(flutter::EncodableValue(args_)));
```

- in  `main.cpp` function exchange `FlutterWindow window(project);` for `FlutterWindow window(project, command_line);` to call the constructor with the command line arguments.

Now when ULPT is opened from a file, the c++ side provides the path and the import should work.
