import 'package:xml/xml.dart';

class Restaurant {
  final String name;
  final String access;
  final String logoImage;
  final String address;
  final String open;
  final String genre;
  final String cat;
  final String urls;
  final String budget;
  final String card;
  final String smoking;
  final String parking;
  final String pet;
  final String child;
  final String wifi;
  final String lat;
  final String lng;

  Restaurant({
    required this.name,
    required this.access,
    required this.logoImage,
    required this.address,
    required this.open,
    required this.genre,
    required this.cat,
    required this.urls,
    required this.budget,
    required this.card,
    required this.smoking,
    required this.parking,
    required this.pet,
    required this.child,
    required this.wifi,
    required this.lat,
    required this.lng,

  });

  factory Restaurant.fromXml(XmlElement element) {
    var photoElement = element.findElements('photo').first.firstElementChild;
    var genreElement = element.findElements('genre').first.firstElementChild;
    var budgetElement = element.findElements('budget').single;
    var mobileElement = photoElement!.nextElementSibling;
    var l = mobileElement!.firstElementChild;

    return Restaurant(
        name: element.findElements('name').first.innerText,
        access: element.findElements('mobile_access').first.innerText,
        logoImage: l!.innerText,
        address: element.findElements('address').first.innerText,
        open: element.findElements('open').first.innerText,
        genre: genreElement!.innerText,
        cat: element.findElements('catch').first.innerText,
        urls: element.findElements('urls').first.innerText,
        budget: budgetElement.findElements('name').first.innerText,
        card: element.findElements('card').first.innerText,
        smoking: element.findElements('non_smoking').first.innerText,
        parking: element.findElements('parking').first.innerText,
        pet: element.findElements('pet').first.innerText,
        child: element.findElements('child').first.innerText,
        wifi: element.findElements('wifi').first.innerText,
        lat: element.findElements('lat').first.innerText,
        lng: element.findElements('lng').first.innerText,
    );
  }
}