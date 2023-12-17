import 'package:flutter/material.dart';
import 'package:restaurantsearcher/model/model.dart';

class RestaurantShow extends StatefulWidget {
  final Restaurant restaurant;
  RestaurantShow({required this.restaurant});

  @override
  State<RestaurantShow> createState() => _RestaurantShowState();
}

class _RestaurantShowState extends State<RestaurantShow> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[400],
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
        title: const Text(
          "店舗詳細",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              widget.restaurant.name,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(40.0),
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(
                    widget.restaurant.logoImage,
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              '住所　${widget.restaurant.address}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              '営業時間',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              '${widget.restaurant.open}',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
          ),
        ],
      ),
    );
  }
}
