abstract interface class AccelerometerService {
  Stream<AccelerometerEventModel> accelerometerEvents();
}

class AccelerometerEventModel {
  final double x;
  final double y;
  final double z;

  AccelerometerEventModel({
    required this.x,
    required this.y,
    required this.z,
  });
}