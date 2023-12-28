import UIKit
import UniformTypeIdentifiers
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private var commChannel: FlutterMethodChannel? = nil;
    
    override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController;
        commChannel = FlutterMethodChannel(name: "nativeCommChannel", binaryMessenger: controller.binaryMessenger);
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
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
}
