import 'package:meta/meta.dart';
import 'dart:convert';
import 'Photo_Model.dart';

Pexels PexelsFromJson(String str) => Pexels.fromJson(json.decode(str));

String PexelsToJson(Pexels data) => json.encode(data.toJson());

class Pexels {
    final int totalResults;
    final int page;
    final int perPage;
    final List<Photo> photos;

    Pexels({
        @required this.totalResults,
        @required this.page,
        @required this.perPage,
        @required this.photos,
    });

    factory Pexels.fromJson(Map<String, dynamic> json) => Pexels(
        totalResults: json["total_results"],
        page: json["page"],
        perPage: json["per_page"],
        photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total_results": totalResults,
        "page": page,
        "per_page": perPage,
        "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
    };
}

