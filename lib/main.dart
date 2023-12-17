import 'package:xml/xml.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'package:restaurantsearcher/model/model.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RestaurantSearcher(),
    );
  }
}

class RestaurantSearcher extends StatefulWidget {
  const RestaurantSearcher({super.key});

  @override
  State<RestaurantSearcher> createState() => _RestaurantSearcherState();
}

class _RestaurantSearcherState extends State<RestaurantSearcher> {
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;
  List<Restaurant>? restaurants;

  String _currentAdress = "";
  Future<Position> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if(!servicePermission) {
      print('service disabled');
    }
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition();
  }

  _getAdressFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(_currentLocation!.latitude, _currentLocation!.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAdress = "${place.locality}, ${place.country}";
        _callAPI(_currentLocation!.latitude,_currentLocation!.longitude, http.Client());
      });
    } catch (e) {
      print(e);
    }
  }

  void _callAPI(double latitude, double longtitude, http.Client client) async {
    var url = Uri.parse("https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=23ce9278bcfeaa64&lat=${latitude}&lng=${longtitude}&range=5");
    var response = await client.get(url);
    if (response.statusCode == 200) {
      String data = response.body;
      final document = XmlDocument.parse(data);
      List<XmlElement> restaurantElements = document.findAllElements('shop').toList();
      setState(() {
        restaurants = restaurantElements.map((element) => Restaurant.fromXml(element)).toList();
      });

    } else {
      throw Exception('Faild to Load Restaurant');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent[100],
        title: Text("Restaurant Searcher"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Location coordinates",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text("Latitude = ${_currentLocation?.latitude} ; Longitude = ${_currentLocation?.longitude}"),
            SizedBox(
              height: 30,
            ),
            Text("Location Adress",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text("${_currentAdress}"),
            SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  _currentLocation = await _getCurrentLocation();
                  await _getAdressFromCoordinates();
                },
                child: Text("get Location")
            ),
            
          ],
        ),
      ),
    );
  }
}
