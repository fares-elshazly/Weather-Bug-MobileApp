import 'package:meta/meta.dart';

class Clouds {
  final int all;

  Clouds({
    @required this.all,
  });

  factory Clouds.fromJson(Map<String, dynamic> json) => Clouds(
        all: json["all"],
      );

  Map<String, dynamic> toJson() => {
        "all": all,
      };
}
