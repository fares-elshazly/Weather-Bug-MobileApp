import 'package:meta/meta.dart';

class WeatherElement {
  final int id;
  final String main;
  final String description;
  final String icon;

  WeatherElement({
    @required this.id,
    @required this.main,
    @required this.description,
    @required this.icon,
  });

  factory WeatherElement.fromJson(Map<String, dynamic> json) => WeatherElement(
        id: json["id"],
        main: json["main"],
        description: json["description"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "main": main,
        "description": description,
        "icon": icon,
      };
}
