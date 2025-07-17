import UIKit
import Flutter
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
    private let channelName = "native_location_bridge/location"
    private let eventChannelName = "native_location_bridge/locationStream"
    private var locationManager = CLLocationManager()
    private var eventSink: FlutterEventSink?

    override func application(_ application: UIApplication,
                              didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let controller = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)
        let eventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger: controller.binaryMessenger)

        methodChannel.setMethodCallHandler { [weak self] call, result in
            guard let self = self else { return }
            switch call.method {
            case "checkPermission":
                let status = CLLocationManager.authorizationStatus()
                result(status == .authorizedWhenInUse || status == .authorizedAlways)
            case "requestPermission":
                self.locationManager.requestWhenInUseAuthorization()
                result(true)
            case "isLocationServiceEnabled":
                result(CLLocationManager.locationServicesEnabled())
            case "openLocationSettings":
                if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                result(true)
            } else {
                result(false)
            } 
        }
    } else {
        result(false)
    }    
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        eventChannel.setStreamHandler(self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

extension AppDelegate: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        locationManager.stopUpdatingLocation()
        eventSink = nil
        return nil
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let locData = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        eventSink?(locData)
    }
}
