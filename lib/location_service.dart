import 'dart:async';
import 'package:flutter/services.dart';

class LocationService {
  static const MethodChannel _channel = MethodChannel('native_location_bridge/location');
  static const EventChannel _eventChannel = EventChannel('native_location_bridge/locationStream');

  Future<bool> checkPermission() async =>
      await _channel.invokeMethod<bool>('checkPermission') ?? false;

  Future<bool> requestPermission() async =>
      await _channel.invokeMethod<bool>('requestPermission') ?? false;

  Future<bool> isLocationServiceEnabled() async =>
      await _channel.invokeMethod<bool>('isLocationServiceEnabled') ?? false;

  Stream<String> locationStream() =>
      _eventChannel.receiveBroadcastStream().map((event) => event.toString());

  Future<void> openLocationSettings() async {
    await _channel.invokeMethod('openLocationSettings');
  }

}
