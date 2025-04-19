class Coordinate {
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? range;
  final double totalTime;
  final double timeInterval;
  late final int numberOfCoordinates;

  Coordinate({
    double? totalTime,
    double? timeInterval,
    this.range,
    this.altitude,
    required this.latitude,
    required this.longitude,
  }) : totalTime = totalTime ?? 15,
       timeInterval = timeInterval ?? .4 {
    numberOfCoordinates = this.totalTime ~/ this.timeInterval;
  }

  @override
  String toString() {
    return 'Coordinate(latitude: $latitude, longitude: $longitude, altitude: $altitude)';
  }

  static List<Coordinate> interpolate(Coordinate start, Coordinate end) {
    print(
      'Interpolating between $start and $end, with ${start.numberOfCoordinates} steps, total time: ${start.totalTime}, time interval: ${start.timeInterval}',
    );
    List<Coordinate> interpolatedCoordinates = [];
    for (int i = 0; i <= start.numberOfCoordinates; i++) {
      double t = i / start.numberOfCoordinates;
      double lat = start.latitude + (end.latitude - start.latitude) * t;
      double lon = start.longitude + (end.longitude - start.longitude) * t;
      double? alt =
          start.altitude != null && end.altitude != null
              ? start.altitude! + (end.altitude! - start.altitude!) * t
              : null;
      interpolatedCoordinates.add(
        Coordinate(latitude: lat, longitude: lon, altitude: alt),
      );
    }
    return interpolatedCoordinates;
  }
}
