
# native_location_bridge

A Flutter plugin to fetch **current location** and **real-time continuous location updates** using **native Android (Kotlin)** and **iOS (Swift)** code — without any third-party dependencies like geolocator or location.

---

## 🚀 Features

- ✅ Check location permissions
- ✅ Request location permissions if denied
- ✅ Detect if location services (GPS) are enabled or disabled
- ✅ Open location settings screen if services are disabled
- ✅ Fetch real-time continuous location updates
- ✅ Zero third-party location dependencies
- ✅ Native Android/iOS code (Kotlin + Swift)

---

## 📱 Platform Support

| Platform | Supported |
|-----------|-----------|
| Android   | ✅ Yes |
| iOS       | ✅ Yes |

---

## 🛠️ Getting Started

### Add dependency
```yaml
dependencies:
  native_location_bridge: ^1.0.0
```

### Import the package
```dart
import 'package:native_location_bridge/location_service.dart';
```

---

## ✅ Usage Example

```dart
final locationService = LocationService();

// ✅ Check permission
bool permissionGranted = await locationService.checkPermission();
if (!permissionGranted) {
  permissionGranted = await locationService.requestPermission();
}

// ✅ Check location services status
bool serviceEnabled = await locationService.isLocationServiceEnabled();
if (!serviceEnabled) {
  await locationService.openLocationSettings();
}

// ✅ Start realtime location stream
locationService.locationStream().listen((location) {
  print('Realtime Location: $location');
});
```

---

## 📂 Example App

You can find a complete working example inside the [`example/`](example/) directory.

---

## 📜 License

This plugin is licensed under the [MIT License](LICENSE).

---

## 💬 Contribution

Contributions are welcome! Feel free to open issues or submit pull requests.  
If you find this plugin useful, please consider giving it a ⭐️ on [GitHub](https://github.com/shubhamdevgupta/native_location_bridge)!

---

## 🙏 Acknowledgement

This plugin uses pure native Kotlin (Android) and Swift (iOS) code for reliable and battery-efficient location fetching.

---
