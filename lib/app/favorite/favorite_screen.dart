import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wanderwise/app/favorite/update_fav_place.dart';
import 'package:wanderwise/app/saved/saved_itinerary_screen.dart';
import 'package:wanderwise/db_helper/db_helper.dart';
import 'package:wanderwise/models/place.dart';

import '../../widgets/dotbar_widget.dart';
import '../explore/view_details.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final String apiKey = 'AIzaSyB5zxGGP_ydXAdIptfpjGdmcEEs_i42_KU';
  bool haveInternetConnection = true;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  final List<Map<String, dynamic>> dummyFavoritePlaces = [
    {
      'id': 1,
      'businessStatus': 'OPERATIONAL',
      'lat': 37.7749,
      'lng': -122.4194,
      'viewportNortheastLat': 37.8049,
      'viewportNortheastLng': -122.4094,
      'viewportSouthwestLat': 37.7549,
      'viewportSouthwestLng': -122.4294,
      'icon': 'https://example.com/icon.png',
      'iconBackgroundColor': '#FFFFFF',
      'iconMaskBaseUri': 'https://example.com/mask.png',
      'name': 'Favorite Place 1',
      'placeId': 'place1',
      'rating': 4.5,
      'reference': 'ref1',
      'scope': 'GOOGLE',
      'types': 'restaurant,bar',
      'userRatingsTotal': 120,
      'vicinity': '123 Main St, San Francisco, CA',
      'photos': 'photo1,photo2',
    },
    {
      'id': 2,
      'businessStatus': 'CLOSED_TEMPORARILY',
      'lat': 34.0522,
      'lng': -118.2437,
      'viewportNortheastLat': 34.0622,
      'viewportNortheastLng': -118.2337,
      'viewportSouthwestLat': 34.0422,
      'viewportSouthwestLng': -118.2537,
      'icon': 'https://example.com/icon2.png',
      'iconBackgroundColor': '#000000',
      'iconMaskBaseUri': 'https://example.com/mask2.png',
      'name': 'Favorite Place 2',
      'placeId': 'place2',
      'rating': 3.8,
      'reference': 'ref2',
      'scope': 'GOOGLE',
      'types': 'park,museum',
      'userRatingsTotal': 75,
      'vicinity': '456 Broadway, Los Angeles, CA',
      'photos': 'photo3,photo4',
    },
  ];


  // Future<List<Map<String, dynamic>>> _getFavNews() async {
  //   final dbHelper = DatabaseHelper();
  //   return await dbHelper.getFavPlace();
  // }
  Future<List<Map<String, dynamic>>> _getFavNews() async {
    final dbHelper = DatabaseHelper();
    final places = await dbHelper.getFavPlace();
    if (places.isEmpty) {
      return dummyFavoritePlaces; // Use dummy data if no database entries exist
    }
    return places;
  }


  Future<void> _checkInternetConnection() async {
    bool isConnected = await hasInternetConnection();
    setState(() {
      haveInternetConnection = !isConnected;
    });
  }

  Future<bool> hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false; // No connectivity
    }
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false; // Unable to reach the internet
    }
  }

  Future<void> _deleteFav(int id) async {
    try {
      final dbHelper = DatabaseHelper();
      await dbHelper.deleteFav(id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Favorite deleted!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        ),
      );

      setState(() {});
    } catch (e) {
      print('Error deleting article: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.black,
              Color(0xFF1A1A2E),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.4, 0.4, 0.7, 8],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 60.0, left: 10.0, right: 10.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // const SizedBox(width: 10),
                  if(haveInternetConnection)
                  IconButton(
                    onPressed: () {
                      Get.to(()=> SavedItineraryScreen());
                    },
                    icon: const Icon(Icons.arrow_back, size: 40,),
                    color: Colors.white,
                  ),
                  const Center(
                    child: Text(
                      'FAVORITE',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _getFavNews(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No saved places.'));
                  } else {
                    final favoritePlace = snapshot.data!;

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: favoritePlace.length,
                      itemBuilder: (context, index) {
                        final place = favoritePlace[index];

                        return GestureDetector(
                          onTap: () async {
                            final updated = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateNews(
                                    id: place['id'],
                                    initialTitle: place['name'] ?? '',
                                    initialDescription:
                                        place['description'] ?? '',
                                    businessStatus:
                                        place['businessStatus'] ?? '',
                                    lat: place['lat'] ?? 0.0,
                                    lng: place['lng'] ?? 0.0,
                                    viewportNortheastLat:
                                        place['viewportNortheastLat'] ?? 0.0,
                                    viewportNortheastLng:
                                        place['viewportNortheastLng'] ?? 0.0,
                                    viewportSouthwestLat:
                                        place['viewportSouthwestLat'] ?? 0.0,
                                    viewportSouthwestLng:
                                        place['viewportSouthwestLng'] ?? 0.0,
                                    icon: place['icon'] ?? '',
                                    iconBackgroundColor:
                                        place['iconBackgroundColor'] ?? '',
                                    iconMaskBaseUri:
                                        place['iconMaskBaseUri'] ?? '',
                                    name: place['name'] ?? '',
                                    placeId: place['placeId'] ?? '',
                                    rating: place['rating'] ?? 0.0,
                                    reference: place['reference'] ?? '',
                                    scope: place['scope'] ?? '',
                                    userRatingsTotal:
                                        place['userRatingsTotal'] ?? 0,
                                    vicinity: place['vicinity'] ?? '',
                                  ),
                                ));
                            if (updated == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'News Updated',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 3),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 10.0),
                                ),
                              );
                              setState(() {});
                            }
                          },
                          child: Container(
                            height: 130,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10.0),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (place['photos'] != null &&
                                        place['photos'].isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: Image.network(
                                          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${place['photos']}&key=$apiKey',
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              height: 150,
                                              width: 150,
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.image,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    else if (place['icon'] != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: Image.network(
                                          place['icon']!,
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              height: 150,
                                              width: 150,
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.image,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    else
                                      Container(
                                        height: 150,
                                        width: 150,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image,
                                          size: 40,
                                        ),
                                      ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            place['name'] ?? 'No Title',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                height: 40,
                                                child: TextButton(
                                                  onPressed: () {},
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.black),
                                                    shape: MaterialStateProperty
                                                        .all(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    place['businessStatus'] ??
                                                        'No Source',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  _deleteFav(place['id']);
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
