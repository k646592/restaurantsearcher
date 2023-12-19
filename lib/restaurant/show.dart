import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:restaurantsearcher/model/model.dart';
import 'package:restaurantsearcher/restaurant/map.dart';
import 'package:url_launcher/link.dart';

class RestaurantShow extends StatefulWidget {
  final Restaurant restaurant;
  final Position currentPosition;
  RestaurantShow({required this.restaurant, required this.currentPosition});

  @override
  State<RestaurantShow> createState() => _RestaurantShowState();
}

class _RestaurantShowState extends State<RestaurantShow> {

  late double distance;

  double distanceBetween(
      double latShop,
      double lngShop,
      double latCurrent,
      double lngCurrent,
      ) {
    toRadians(double degree) => degree * pi / 180;
    const double r = 6378137.0;
    final double f1 = toRadians(latShop);
    final double f2 = toRadians(latCurrent);
    final double l1 = toRadians(lngShop);
    final double l2 = toRadians(lngCurrent);
    final num a = pow(sin((f2-f1) / 2), 2);
    final double b = cos(f1) * cos(f2) * pow(sin((l2-l1) / 2), 2);
    final double d = 2*r*asin(sqrt(a+b));
    return d;
  }


  @override
  void initState() {
    super.initState();
    distance = distanceBetween(double.parse(widget.restaurant.lat), double.parse(widget.restaurant.lng), widget.currentPosition.latitude, widget.currentPosition.longitude);
  }

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
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) {
                      return RestaurantMap(latitude: widget.restaurant.lat, longitude: widget.restaurant.lng, currentPosition: widget.currentPosition,);
                    }
                ),
              );
            },
            label: const Text(
              '店舗所在地',
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
            ),
            icon: const Icon(Icons.map,color: Colors.white,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
            const Padding(
              padding: EdgeInsets.only(left: 15.0,bottom: 5,top: 15.0,),
              child: Text(
                '住所',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0,bottom: 10),
              child: Text(
                widget.restaurant.address,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0,bottom: 5),
              child: Text(
                '営業時間',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0,bottom: 10),
              child: Text(
                '${widget.restaurant.open}',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10,bottom: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(-10, -10),
                            color: Colors.white24,
                          ),
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(10, 10),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            // アイコン
                            const Icon(
                              Icons.place_sharp,
                              color: Colors.green,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            // タイトル
                            Text(
                              'アクセス',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            // 説明文
                            Text(
                              widget.restaurant.access,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(-10, -10),
                            color: Colors.white24,
                          ),
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(10, 10),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            // アイコン
                            const Icon(
                              Icons.restaurant,
                              color: Colors.green,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            // タイトル
                            Text(
                              'ジャンル',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            // 説明文
                            Text(
                              widget.restaurant.genre,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(-10, -10),
                            color: Colors.white24,
                          ),
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(10, 10),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            // アイコン
                            const Icon(
                              Icons.map_rounded,
                              color: Colors.green,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            // タイトル
                            Text(
                              '現在地〜店舗',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            // 説明文
                            Text(
                              '約${distance.ceil()}メートル',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(-10, -10),
                            color: Colors.white24,
                          ),
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(10, 10),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            // アイコン
                            const Icon(
                              Icons.paid_outlined,
                              color: Colors.green,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            // タイトル
                            Text(
                              '予算',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            // 説明文
                            Text(
                              widget.restaurant.budget,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(-10, -10),
                            color: Colors.white24,
                          ),
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(10, 10),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Link(
                              uri: Uri.parse(widget.restaurant.urls),
                              target: LinkTarget.self,
                              builder: (BuildContext ctx, FollowLink? openLink) {
                                return IconButton(
                                  tooltip: '詳細リンクを開く',
                                  onPressed: openLink,
                                  icon: const Icon(
                                    Icons.link,
                                    color: Colors.green,
                                    size: 48,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            // タイトル
                            Text(
                              '詳細情報リンク',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            // 説明文
                            Text(
                              'アイコンをクリック',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(-10, -10),
                            color: Colors.white24,
                          ),
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(10, 10),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            // アイコン
                            const Icon(
                              Icons.credit_card,
                              color: Colors.green,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            // タイトル
                            Text(
                              'カード',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            // 説明文
                            Text(
                              widget.restaurant.card,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(-10, -10),
                            color: Colors.white24,
                          ),
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(10, 10),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            // アイコン
                            const Icon(
                              Icons.smoking_rooms,
                              color: Colors.green,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            // タイトル
                            Text(
                              widget.restaurant.smoking,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            // 説明文
                            Text(
                              widget.restaurant.smoking,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(-10, -10),
                            color: Colors.white24,
                          ),
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(10, 10),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            // アイコン
                            const Icon(
                              Icons.local_parking,
                              color: Colors.green,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            // タイトル
                            Text(
                              '駐車場',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            // 説明文
                            Text(
                              widget.restaurant.parking,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(-10, -10),
                            color: Colors.white24,
                          ),
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(10, 10),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            // アイコン
                            const Icon(
                              Icons.pets_outlined,
                              color: Colors.green,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            // タイトル
                            Text(
                              'ペット',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            // 説明文
                            Text(
                              widget.restaurant.pet,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(-10, -10),
                            color: Colors.white24,
                          ),
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(10, 10),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            // アイコン
                            const Icon(
                              Icons.child_care,
                              color: Colors.green,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            // タイトル
                            Text(
                              '子供',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            // 説明文
                            Text(
                              widget.restaurant.child,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(-10, -10),
                            color: Colors.white24,
                          ),
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(10, 10),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            // アイコン
                            const Icon(
                              Icons.wifi,
                              color: Colors.green,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            // タイトル
                            Text(
                              'WiFi',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            // 説明文
                            Text(
                              widget.restaurant.wifi,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(-10, -10),
                            color: Colors.white24,
                          ),
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(10, 10),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            // アイコン
                            const Icon(
                              Icons.assistant,
                              color: Colors.green,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            // タイトル
                            Text(
                              'その他',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            // 説明文
                            Text(
                              widget.restaurant.cat,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
