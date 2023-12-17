import 'package:xml/xml.dart';

class Restaurant {
  final String name;
  final String access;
  final String logoImage;
  final String address;
  final String open;

  Restaurant({
    required this.name,
    required this.access,
    required this.logoImage,
    required this.address,
    required this.open,
  });

  factory Restaurant.fromXml(XmlElement element) {
    var photoElement = element.findElements('photo').first.firstElementChild;
    var mobileElement = photoElement!.nextElementSibling;
    var l = mobileElement!.firstElementChild;

    return Restaurant(
        name: element.findElements('name').first.innerText,
        access: element.findElements('mobile_access').first.innerText,
        logoImage: l!.innerText,
        address: element.findElements('address').first.innerText,
        open: element.findElements('open').first.innerText,
    );
  }
}