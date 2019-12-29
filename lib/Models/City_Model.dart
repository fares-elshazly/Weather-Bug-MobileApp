import 'package:meta/meta.dart';

class City {
  String name;
  String imageURL;

  City({@required this.name, @required this.imageURL});

  factory City.fromJson(Map<String, dynamic> json) =>
      City(name: json['name'], imageURL: json['imageURL']);

  Map<String, dynamic> toJson() => {'name': name, 'imageURL': imageURL};
}
