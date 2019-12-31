import 'package:meta/meta.dart';
import 'Src_Model.dart';

class Photo {
    final int id;
    final int width;
    final int height;
    final String url;
    final String photographer;
    final String photographerUrl;
    final int photographerId;
    final Src src;
    final bool liked;

    Photo({
        @required this.id,
        @required this.width,
        @required this.height,
        @required this.url,
        @required this.photographer,
        @required this.photographerUrl,
        @required this.photographerId,
        @required this.src,
        @required this.liked,
    });

    factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json["id"],
        width: json["width"],
        height: json["height"],
        url: json["url"],
        photographer: json["photographer"],
        photographerUrl: json["photographer_url"],
        photographerId: json["photographer_id"],
        src: Src.fromJson(json["src"]),
        liked: json["liked"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "width": width,
        "height": height,
        "url": url,
        "photographer": photographer,
        "photographer_url": photographerUrl,
        "photographer_id": photographerId,
        "src": src.toJson(),
        "liked": liked,
    };
}