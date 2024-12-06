import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:soletra_app/external/sensors/accelerometer_service.dart';

class AccelerometerServiceImpl implements AccelerometerService {
  final MethodChannel platform;

  AccelerometerServiceImpl({required this.platform});
  @override
  Stream<AccelerometerEventModel> accelerometerEvents() {
    final controller = StreamController<AccelerometerEventModel>();
    if(defaultTargetPlatform != TargetPlatform.android) return controller.stream;
    platform.setMethodCallHandler((call) async {
      if (call.method == 'updateAccelerometer') {
        final response = call.arguments as String;
        final data = jsonDecode(response) as Map<String, dynamic>;
        final event = AccelerometerEventModel(
          x: data['x'] as double,
          y: data['y'] as double,
          z: data['z'] as double,
        );
        controller.add(event);
      }
    });
    try {
      platform.invokeMethod('startAccelerometer');
    } on PlatformException catch (e) {
      print('Error: $e');
    }
    return controller.stream;
  }
}