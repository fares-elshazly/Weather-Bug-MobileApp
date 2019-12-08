import 'package:meta/meta.dart';

class Wind {
  final double speed;
  final int deg;

  Wind({
    @required this.speed,
    @required this.deg,
  });

  factory Wind.fromJson(Map<String, dynamic> json) => Wind(
        speed: json["speed"].toDouble(),
        deg: json["deg"],
      );

  Map<String, dynamic> toJson() => {
        "speed": speed,
        "deg": deg,
      };
}
