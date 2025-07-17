import 'dart:async';
import 'package:flutter/material.dart';
import 'location_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LocationScreen(),
    );
  }
}

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _locService = LocationService();
  StreamSubscription<String>? _sub;
  String _location = 'Not started';
  bool _isRunning = false;
  bool _isChecking = false;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> initializeAndStartLocation() async {
    setState(() {
      _isChecking = true;
      _location = 'Checking permissions...';
    });

    bool permissionGranted = await _locService.checkPermission();
    if (!permissionGranted) {
      final granted = await _locService.requestPermission();
      permissionGranted = granted;
      if (!permissionGranted) {
        setState(() {
          _location = 'Permission Denied ❌';
          _isChecking = false;
        });
        return;
      }
    }

    final enabled = await _locService.isLocationServiceEnabled();
 if (!enabled) {
  setState(() {
    _location = 'Location Services Disabled ❌';
    _isChecking = false;
  });
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Enable Location Services'),
      content: const Text('Location is disabled, would you like to open settings to enable it?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await _locService.openLocationSettings();
          },
          child: const Text('Open Settings'),
        ),
      ],
    ),
  );
  return;
}


    setState(() {
      _isChecking = false;
    });

    startRealTime();
  }

  void startRealTime() {
    _sub?.cancel();
    _location = 'Starting realtime location...';
    _isRunning = true;

    _sub = _locService.locationStream().listen((loc) {
      setState(() {
        _location = loc;
      });
    });

    setState(() {});
  }


  void stopRealTime() {
    _sub?.cancel();
    setState(() {
      _isRunning = false;
      _location = 'Stopped';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Native Realtime Location')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Current Location:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                _location,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              if (_isChecking) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 10),
                const Text('Checking...'),
              ] else if (_isRunning) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 10),
                const Text('Realtime Location Active ✅', style: TextStyle(color: Colors.green)),
              ],
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isRunning ? null : initializeAndStartLocation,
                child: const Text('Start Realtime with Check'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _isRunning ? stopRealTime : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Stop Realtime Location'),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
