import 'package:meta/meta.dart';

class Coord {
  final double lon;
  final double lat;

  Coord({
    @required this.lon,
    @required this.lat,
  });

  factory Coord.fromJson(Map<String, dynamic> json) => Coord(
        lon: json["lon"].toDouble(),
        lat: json["lat"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lon": lon,
        "lat": lat,
      };
}
