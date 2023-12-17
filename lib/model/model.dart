import 'package:xml/xml.dart';

class Restaurant {
  final String name;
  final String access;
  final String logoImage;

  Restaurant({
    required this.name,
    required this.access,
    required this.logoImage,
  });

  factory Restaurant.fromXml(XmlElement element) {
    return Restaurant(
        name: element.findElements('name').first.innerText,
        access: element.findElements('access').first.innerText,
        logoImage: element.findElements('logo_image').first.innerText,
    );
  }
}