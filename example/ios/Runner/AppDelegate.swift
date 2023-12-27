import UIKit
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
        
        if #available(iOS 16, *){
            commChannel!.invokeMethod("onArgsFromNative", arguments: url.path());
        }else{
            commChannel!.invokeMethod("onArgsFromNative", arguments: url.absoluteString);
        }
        
        return true;
    }
}
