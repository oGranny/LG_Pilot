class Coordinate {
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? range;
  Coordinate({
    this.range,
    this.altitude,
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() {
    return 'Coordinate(latitude: $latitude, longitude: $longitude, altitude: $altitude)';
  }

  static List<Coordinate> interpolate(
    Coordinate start,
    Coordinate end,
    int number,
  ) {
    List<Coordinate> interpolatedCoordinates = [];
    for (int i = 0; i <= number; i++) {
      double t = i / number;
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
