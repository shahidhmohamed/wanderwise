import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wanderwise/controllers/places_controller.dart';
import 'package:wanderwise/models/place.dart';

import '../../widgets/dotbar_widget.dart';
import '../explore/view_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _HomePageState extends State<HomePage> {
  LatLng myCurrentLocation = const LatLng(7.8731, 80.7718);
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  List<Place> nearbyPlaces = [];
  static const Map<String, String> categoryLabels = {
    'tourist_attraction': 'Tourist Attractions',
    'airport': 'Airports',
    'atm': 'ATMs',
    'bakery': 'Bakeries',
    'bank': 'Banks',
    'bar': 'Bars',
    'bus_station': 'Bus Stations',
    'cafe': 'Cafes',
    'hospital': 'Hospitals',
    'hotel': 'Hotels',
    'lodging': 'Lodging',
    'meal_delivery': 'Meal Delivery',
    'meal_takeaway': 'Meal Takeaways',
    'mosque': 'Mosques',
    'movie_theater': 'Movie Theaters',
    'museum': 'Museums',
    'night_club': 'Night Clubs',
    'park': 'Parks',
    'pharmacy': 'Pharmacies',
    'place_of_worship': 'Places of Worship',
    'police': 'Police Stations',
    'restaurant': 'Restaurants',
    'train_station': 'Train Stations',
    'zoo': 'Zoos',
  };

  static final List<String> list = categoryLabels.keys.toList();

  String selectedDropdownValue = list.first;
  final PlacesController placesController =
      PlacesController(apiKey: 'AIzaSyB5zxGGP_ydXAdIptfpjGdmcEEs_i42_KU');
  final String apiKey = 'AIzaSyB5zxGGP_ydXAdIptfpjGdmcEEs_i42_KU';

  @override
  void initState() {
    super.initState();

    // Initialize with sample data
    _loadSampleData();
  }

  // Sample data (mock data)
  void _loadSampleData() {
    List<Place> samplePlaces = [
      Place(
          businessStatus: "OPERATIONAL",
          lat: 25.2048493,
          lng: 55.2707828,
          viewportNortheastLat: 25.20632440000001,
          viewportNortheastLng: 55.27209489999999,
          viewportSouthwestLat: 25.20042399999999,
          viewportSouthwestLng: 55.26684650000001,
          icon:
              "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
          iconBackgroundColor: "#13B5C7",
          iconMaskBaseUri:
              "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
          name: "Sky view",
          placeId: "ChIJy4iODwBDXz4R0QRgjz-XCTQ",
          reference: "ChIJy4iODwBDXz4R0QRgjz-XCTQ",
          scope: "GOOGLE",
          types: ["tourist_attraction", "point_of_interest", "establishment"],
          vicinity: "673C+W8M - Dubai",
          photos: [
            Photo(
                height: 3472,
                htmlAttributions: [
                  "<a href=\"https://maps.google.com/maps/contrib/112057407089375510985\">Parini Ojha</a>"
                ],
                photoReference:
                    "AWYs27z1LAvvJBfhfQzwzj_U9JZ8UYYpG4FIATU1ZMWkDpPg83KD1tpFojnP3KbsJj9hY_giMlzL9XmffLPoOpUt9D7lGopzPSZdVCxMgsLAEKyOycW_-13DtccEqsbBuZrmpwc8whfk9Cgb7fvsCDmtfOMVlPn-3gVZ0Zq9MVmP33CgmU6s",
                width: 4640),
          ],
          rating: 10, // Rating not provided, set to null
          userRatingsTotal: 10 // User rating count not provided, set to null
          ),
      Place(
          businessStatus: "OPERATIONAL",
          lat: 25.2048493,
          lng: 55.2707828,
          viewportNortheastLat: 25.20632440000001,
          viewportNortheastLng: 55.27209489999999,
          viewportSouthwestLat: 25.20042399999999,
          viewportSouthwestLng: 55.26684650000001,
          icon:
              "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
          iconBackgroundColor: "#13B5C7",
          iconMaskBaseUri:
              "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
          name: "Бурдж халифа",
          placeId: "ChIJAWZwMQBDXz4RqLJx8YA_Lv4",
          reference: "ChIJAWZwMQBDXz4RqLJx8YA_Lv4",
          scope: "GOOGLE",
          types: ["tourist_attraction", "point_of_interest", "establishment"],
          vicinity: "673C+W8M - Dubai",
          photos: [
            Photo(
                height: 4080,
                htmlAttributions: [
                  "<a href=\"https://maps.google.com/maps/contrib/108193528584772319499\">Елена Е</a>"
                ],
                photoReference:
                    "AWYs27ytfCwwQHasZOMIxy40Q1kNn_-QRQMwNsNrglA1zxC4F3CqdsNENYe9jyBzs1BVERYp8bpjl2xrEPhkt9MQGpa0rtYPrHTVOHtHp8hSKZNDEPgBnkxx__r1GsaKUMTSsi8somhyZS2B_eNGZukZM5zoSzqRSsuz_8N1dNBcT4o4P4S_",
                width: 3060),
          ],
          rating: 100, // Rating is not provided, so it's set to null
          userRatingsTotal: 6 // User rating count is not provided, set to null
          ),
      Place(
          businessStatus: "OPERATIONAL",
          lat: 25.2048493,
          lng: 55.2707828,
          viewportNortheastLat: 25.20632440000001,
          viewportNortheastLng: 55.27209489999999,
          viewportSouthwestLat: 25.20042399999999,
          viewportSouthwestLng: 55.26684650000001,
          icon:
              "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
          iconBackgroundColor: "#13B5C7",
          iconMaskBaseUri:
              "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
          name: "Pale S tine Pavilion Global Village",
          placeId: "ChIJO_SDfwdDXz4RNRihdxpn0_k",
          reference: "ChIJO_SDfwdDXz4RNRihdxpn0_k",
          scope: "GOOGLE",
          types: ["tourist_attraction", "point_of_interest", "establishment"],
          vicinity: "673C+W8M - Dubai",
          photos: [
            Photo(
                height: 4000,
                htmlAttributions: [
                  "<a href=\"https://maps.google.com/maps/contrib/111895108072331412523\">Sam Jaroudi</a>"
                ],
                photoReference:
                    "AWYs27zJlDShrrI_BvpechZszAPfDnCZeni3NHIvgllZVb2AtQt_TAoGboqYYVJeYorKzpuk95UHhfLS07EGGrl5rP0f7lCKyVlu0KDJuyN0YeQvnaxBozvFklLq464iFezmBgaVfK4Oul8pxRmzGQgG96wA8ROwaAdXp3chvpHE2u4VA-sS",
                width: 2252),
          ],
          // openingHours: OpeningHours(openNow: true),
          rating: 4.6,
          userRatingsTotal: 5),
      Place(
        businessStatus: "OPERATIONAL",
        lat: 7.873053999999999,
        lng: 80.77179699999999,
        viewportNortheastLat: 7.874565180291501,
        viewportNortheastLng: 80.77271348029151,
        viewportSouthwestLat: 7.871867219708498,
        viewportSouthwestLng: 80.77001551970851,
        icon:
            "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
        iconBackgroundColor: "#FF9E67",
        iconMaskBaseUri:
            "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
        name: "ceylon cafe",
        placeId: "ChIJt79eFACn_DoR85NxbfrE6us",
        rating: 1,
        reference: "ChIJt79eFACn_DoR85NxbfrE6us",
        scope: "GOOGLE",
        types: ["restaurant", "food", "point_of_interest", "establishment"],
        userRatingsTotal: 1,
        vicinity: "VQFC+6PF, الا",
        photos: [
          Photo(
              height: 1280,
              htmlAttributions: [
                "<a href=\"https://maps.google.com/maps/contrib/100691693123718740279\">Sikandar Masie</a>"
              ],
              photoReference:
                  "AWYs27wXDb1gfJX__JH5YNeSYWtRcC1s7XUjyAGhVS6PFRfDTV1aBIkpRREtaDiJolydolj5c3y2BQamGxNh94S7bmtih1aTepijES-shzerq-Efh8Vf_5PHX7aF-ypVXnqvZXhSbBjs9nu3ygp0Q3R51BpsuWdI6x5J60fXPRDOfXshoEKU",
              width: 720),
        ],
      ),

      Place(
          businessStatus: "OPERATIONAL",
          lat: 7.873053999999999,
          lng: 80.77179699999999,
          viewportNortheastLat: 7.874565180291501,
          viewportNortheastLng: 80.77271348029151,
          viewportSouthwestLat: 7.871867219708498,
          viewportSouthwestLng: 80.77001551970851,
          icon:
              "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
          iconBackgroundColor: "#13B5C7",
          iconMaskBaseUri:
              "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
          name: "vasanic ship",
          placeId: "ChIJb_nXs9en_DoRXex8nLgemfw",
          rating: 4.5,
          userRatingsTotal: 200,
          reference: "ChIJb_nXs9en_DoRXex8nLgemfw",
          scope: "GOOGLE",
          types: ["tourist_attraction", "point_of_interest", "establishment"],
          vicinity: "VQFC+6PF, Dambulla",
          photos: [
            Photo(
                height: 2576,
                htmlAttributions: [
                  "<a href=\"https://maps.google.com/maps/contrib/102510444988791182364\">Santha Senanayaka</a>"
                ],
                photoReference:
                    "AWYs27xfWiwM6IOk21wyUYanKA1TfFcYQ4J05F-9vID5BIOWxjrRm4OlH2CB85ILjnkheWhWoqQLhjAdzS-oyFY81ky3iS-QdAT1XKo5mH-S-hbLBW-zZVQ_SxFsFwJbJhPSn-ey-q35-GxAxm4BDDbNab5QDIw7sX_Kgmuh7WT1WCX80b0r",
                width: 1932),
          ]),

      Place(
          businessStatus: "OPERATIONAL",
          lat: 7.873053999999999,
          lng: 80.77179699999999,
          viewportNortheastLat: 7.874565180291501,
          viewportNortheastLng: 80.77271348029151,
          viewportSouthwestLat: 7.871867219708498,
          viewportSouthwestLng: 80.77001551970851,
          icon:
              "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
          iconBackgroundColor: "#13B5C7",
          iconMaskBaseUri:
              "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
          name: "Green island",
          placeId: "ChIJP1DwMwCn_DoRhBTSBeTRWhM",
          rating: 5,
          reference: "ChIJP1DwMwCn_DoRhBTSBeTRWhM",
          scope: "GOOGLE",
          types: ["tourist_attraction", "point_of_interest", "establishment"],
          userRatingsTotal: 1,
          vicinity: "VQFC+6PF, Dambulla",
          photos: [
            Photo(
                height: 1280,
                htmlAttributions: [
                  "<a href=\"https://maps.google.com/maps/contrib/100691693123718740279\">Sikandar Masie</a>"
                ],
                photoReference:
                    "AWYs27xjtdMHAAXcs8G7B4zA7Xe76944RyhXverlrF0R5VoLo2TV51juPklGb7-cE-IJ5PTCvN8_CB8W6Dnrcm35uEc6avXPzOphpbXFvrnTNAZJbWB83yji2U70KFCHvk649-sxgh2BzYGA59LggWnreemKXhtjGaLgeXJwD0pMyW-W_kC2",
                width: 720),
          ]),
      // Add more places if needed
      Place(
          businessStatus: "OPERATIONAL",
          lat: 7.8740,
          lng: 80.7730,
          viewportNortheastLat: 7.8750,
          viewportNortheastLng: 80.7740,
          viewportSouthwestLat: 7.8730,
          viewportSouthwestLng: 80.7720,
          icon:
              "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
          iconBackgroundColor: "#13B5C7",
          iconMaskBaseUri:
              "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
          name: "مطعم كاري",
          placeId: "ChIJPcXRAzXP_DoRMx6EoXz0s8k",
          rating: 4.5,
          reference: "ChIJPcXRAzXP_DoRMx6EoXz0s8k",
          scope: "GOOGLE",
          types: ["restaurant", "point_of_interest", "establishment"],
          userRatingsTotal: 200,
          vicinity: "VQFC+8PP, المدينة",
          photos: [
            Photo(
                height: 1280,
                htmlAttributions: [
                  "<a href=\"https://maps.google.com/maps/contrib/100691693123718740279\">Sikandar Masie</a>"
                ],
                photoReference:
                    "AWYs27xSPj_DjfMAT8DX4zJRCKXLM9UIF_F-vswnOxrPnr75lxg7gv1VOWVzRiM5DWpy4jjgNjYmiZn-odRYtskFEZ5uZqDaaTp5nKbDRNNegRX2l0PuuLBohyVBtuPZ72yR4p33i5mb1aU2XrGoSj5D574PavmMcUhLR1Ok3vfWBxPq8eI7",
                width: 720),
          ]),
    ];

    setState(() {
      nearbyPlaces = samplePlaces;
      markers.clear(); // Clear previous markers

      // Add markers for sample places
      for (var place in samplePlaces) {
        markers.add(
          Marker(
            markerId: MarkerId(place.placeId),
            position: LatLng(place.lat, place.lng),
            infoWindow: InfoWindow(title: place.name),
            onTap: () {
              _onPlaceSelected(place);
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
            // Google Map Widget
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(15), // Apply border radius here
              child: SizedBox(
                height: isPortrait ? screenHeight * 0.4 : screenHeight * 0.5,
                child: GoogleMap(
                  myLocationButtonEnabled: false,
                  markers: markers,
                  polylines: polylines,
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: myCurrentLocation,
                    zoom: 14,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Dropdown Menu Button
                Container(
                  width: screenWidth * 0.3,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(0xFA1A1A3F),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Color(0xFA1A1A3F), width: 1),
                  ),
                  child: Center(
                    child: DropdownButton<String>(
                      value: selectedDropdownValue,
                      items: list
                          .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: Center(
                                    child: Text(
                                      categoryLabels[value]!.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  ),
                                )),
                          )
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDropdownValue = newValue!;
                        });
                      },
                      dropdownColor: Color(0xFA1A1A3F),
                      underline: SizedBox(),
                      isExpanded: true,
                    ),
                  ),
                ),

                // Find Nearby Button
                GestureDetector(
                  onTap: () async {
                    Position position = await currentPosition();
                    setState(() {
                      myCurrentLocation =
                          LatLng(position.latitude, position.longitude);
                    });

                    googleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(position.latitude, position.longitude),
                          zoom: 14,
                        ),
                      ),
                    );

                    // Fetch nearby places
                    List<Place> places =
                        await placesController.fetchNearbyPlaces(
                            position.latitude,
                            position.longitude,
                            selectedDropdownValue);
                    setState(() {
                      nearbyPlaces = places;
                      markers.clear();
                      for (var place in places) {
                        markers.add(
                          Marker(
                            markerId: MarkerId(place.placeId),
                            position: LatLng(place.lat, place.lng),
                            infoWindow: InfoWindow(title: place.name),
                            onTap: () {
                              _onPlaceSelected(place);
                            },
                          ),
                        );
                      }
                    });
                  },
                  child: Container(
                    width: screenWidth * 0.6,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(0xFA1A1A3F),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.searchengin,
                              color: Colors.white),
                          SizedBox(width: 5),
                          Center(
                            child: Text(
                              "FIND NEAR ${categoryLabels[selectedDropdownValue]?.toUpperCase() ?? selectedDropdownValue.toUpperCase()}",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 15),

            // Nearby places list
            SizedBox(
              height: 364,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: nearbyPlaces.length,
                itemBuilder: (context, index) {
                  final place = nearbyPlaces[index];
                  final dayInfo = '';

                  String? photoUrl;
                  if (place.photos != null && place.photos!.isNotEmpty) {
                    String photoReference = place.photos![0].photoReference;
                    photoUrl =
                    'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
                  }

                  return Container(
                    width: screenWidth * 0.7,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the ViewPlacePage when the stack is tapped
                        Get.to(
                              () => ViewPlacePage(article: place, dayInfo: dayInfo),
                          transition: Transition.leftToRight,
                          curve: Curves.easeInCirc,
                          duration: Duration(microseconds: 1000),
                        );
                      },
                      child: Stack(
                        children: [
                          // Background Image
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(18)),
                              child: photoUrl != null
                                  ? Image.network(
                                photoUrl,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                                  : Image.network(
                                place.icon,
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // Download button at the top right
                          Positioned(
                            top: 22,
                            right: 22,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  FontAwesomeIcons.heart,
                                  color: Colors.white,
                                  size: 34,
                                ),
                                onPressed: () {
                                  // Implement save functionality if needed
                                },
                              ),
                            ),
                          ),

                          // Details at the bottom
                          Positioned(
                            bottom: 138,
                            left: 18,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name of the place
                                Text(
                                  place.name.toUpperCase(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),

                                // Rating and review count
                                Row(
                                  children: [
                                    DotBar(rating: place.rating),
                                    const SizedBox(width: 5),
                                    Text(
                                      place.userRatingsTotal.toString(),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Share button at the bottom right
                          Positioned(
                            bottom: 118,
                            right: 18,
                            child: IconButton(
                              icon: Icon(CupertinoIcons.share,
                                  color: Colors.white, size: 40.0),
                              onPressed: () {
                                // Implement share functionality if needed
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  // Handle place selection to show directions
  void _onPlaceSelected(Place place) async {
    final directions = await placesController.fetchDirections(
        myCurrentLocation.latitude,
        myCurrentLocation.longitude,
        place.lat,
        place.lng);
    _addPolyline(directions);
    print("Selected Place ${place.lat} ${place.lng}");
    print(
        "My Current Location ${myCurrentLocation.latitude} ${myCurrentLocation.longitude}");
  }

  // Add polyline on map for the directions
  void _addPolyline(List<LatLng> points) {
    polylines.clear();
    polylines.add(Polyline(
      polylineId: PolylineId('route'),
      points: points,
      color: Colors.blue,
      width: 5,
    ));
    setState(() {});
  }

  // Get current location of the user
  Future<Position> currentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }
    return await Geolocator.getCurrentPosition();
  }
}
