import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class RestaurantMap extends StatefulWidget {
  final String latitude;
  final String longitude;
  final Position currentPosition;
  const RestaurantMap({required this.latitude, required this.longitude, required this.currentPosition});

  @override
  State<RestaurantMap> createState() => _RestaurantMapState();
}

class _RestaurantMapState extends State<RestaurantMap> {


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
        ),
        title: const Text(
          "店舗所在地",
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(double.parse(widget.latitude), double.parse(widget.longitude)),
          initialZoom: 15.0
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
              markers: [
                Marker(
                    point: LatLng(widget.currentPosition.latitude, widget.currentPosition.longitude),
                    child: const Icon(Icons.my_location_outlined,color: Colors.indigo,size: 40,)
                ),
                Marker(
                  point: LatLng(double.parse(widget.latitude), double.parse(widget.longitude)),
                  child: const Icon(Icons.location_pin,color: Colors.redAccent,size: 40,)
                ),
              ],
          ),
        ],
      ),
    );
  }
}