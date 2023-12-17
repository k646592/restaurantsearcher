import 'package:restaurantsearcher/restaurant/show.dart';
import 'package:scaled_list/scaled_list.dart';
import 'package:xml/xml.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'package:restaurantsearcher/model/model.dart';


class RestaurantSearcher extends StatefulWidget {
  const RestaurantSearcher({super.key});

  @override
  State<RestaurantSearcher> createState() => _RestaurantSearcherState();
}

class _RestaurantSearcherState extends State<RestaurantSearcher> {
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;
  List<Restaurant> restaurants = [];

  String isSelectedValue = '1';

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

  _callAPI(double latitude, double longtitude, http.Client client) async {
    var url = Uri.parse("https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=23ce9278bcfeaa64&lat=${latitude}&lng=${longtitude}&range=${isSelectedValue}");
    var response = await client.get(url);
    if (response.statusCode == 200) {
      String data = response.body;
      final document = XmlDocument.parse(data);
      List<XmlElement> restaurantElements = document.findAllElements('shop').toList();
      setState(() {
        restaurants.clear();
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
        backgroundColor: Colors.green,
        title: const Text(
          "Restaurant Searcher",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('現在地から半径',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(width: 20),
                DropdownButton(
                    items: const[
                      DropdownMenuItem(
                        value: '1',
                        child: Text('300メートル'),
                      ),
                      DropdownMenuItem(
                        value: '2',
                        child: Text('500メートル'),
                      ),
                      DropdownMenuItem(
                        value: '3',
                        child: Text('1000メートル'),
                      ),
                      DropdownMenuItem(
                        value: '4',
                        child: Text('2000メートル'),
                      ),
                      DropdownMenuItem(
                        value: '5',
                        child: Text('3000メートル'),
                      ),
                    ],
                    value: isSelectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        isSelectedValue = value!;
                      });
                    }
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    _currentLocation = await _getCurrentLocation();
                    await _callAPI(_currentLocation!.latitude,_currentLocation!.longitude, http.Client());
                  },
                  child: const Text(
                    "検索",
                    style: TextStyle(
                        color: Colors.green
                    ),
                  ),
                ),
              ],
            ),
            ScaledList(
              itemCount: restaurants.length,
              itemColor: (index) {
                return Colors.green;
              },
              itemBuilder: (index, selectedIndex) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: selectedIndex == index ? 200 : 100,
                      child: selectedIndex == index ? GestureDetector(
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) {
                                  return RestaurantShow(restaurant: restaurants[index]);
                                }
                            ),
                          );
                        },
                        child: Image.network(
                          restaurants[index].logoImage,
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                        ),
                      ) : Image.network(
                        restaurants[index].logoImage,
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) {
                                  return RestaurantShow(restaurant: restaurants[index]);
                                }
                            ),
                          );
                        },
                        child: Text(
                          restaurants[index].name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: selectedIndex == index ? 20 : 15
                          ),),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) {
                                  return RestaurantShow(restaurant: restaurants[index]);
                                }
                            ),
                          );
                        },
                        child: Text(
                          restaurants[index].access,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: selectedIndex == index ? 15 : 10
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
