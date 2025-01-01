import 'dart:convert';

class Place {
  final String businessStatus;
  final double lat;
  final double lng;
  final double viewportNortheastLat;
  final double viewportNortheastLng;
  final double viewportSouthwestLat;
  final double viewportSouthwestLng;
  final String icon;
  final String iconBackgroundColor;
  final String iconMaskBaseUri;
  final String name;
  final String placeId;
  final double rating;
  final String reference;
  final String scope;
  final List<String> types;
  final int userRatingsTotal;
  final String vicinity;
  final List<Photo> photos;

  Place({
    required this.businessStatus,
    required this.lat,
    required this.lng,
    required this.viewportNortheastLat,
    required this.viewportNortheastLng,
    required this.viewportSouthwestLat,
    required this.viewportSouthwestLng,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconMaskBaseUri,
    required this.name,
    required this.placeId,
    required this.rating,
    required this.reference,
    required this.scope,
    required this.types,
    required this.userRatingsTotal,
    required this.vicinity,
    required this.photos,
  });

  // Factory constructor to create a Place from JSON
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      businessStatus: json['business_status'] ?? '', // Default empty string if null
      lat: json['geometry']['location']['lat']?.toDouble() ?? 0.0, // Safely convert to double
      lng: json['geometry']['location']['lng']?.toDouble() ?? 0.0, // Safely convert to double
      viewportNortheastLat: json['geometry']['viewport']['northeast']['lat']?.toDouble() ?? 0.0,
      viewportNortheastLng: json['geometry']['viewport']['northeast']['lng']?.toDouble() ?? 0.0,
      viewportSouthwestLat: json['geometry']['viewport']['southwest']['lat']?.toDouble() ?? 0.0,
      viewportSouthwestLng: json['geometry']['viewport']['southwest']['lng']?.toDouble() ?? 0.0,
      icon: json['icon'] ?? '', // Default empty string if null
      iconBackgroundColor: json['icon_background_color'] ?? '', // Default empty string if null
      iconMaskBaseUri: json['icon_mask_base_uri'] ?? '', // Default empty string if null
      name: json['name'] ?? '', // Default empty string if null
      placeId: json['place_id'] ?? '', // Default empty string if null
      rating: (json['rating'] ?? 0).toDouble(), // Default rating to 0 if null
      reference: json['reference'] ?? '', // Default empty string if null
      scope: json['scope'] ?? '', // Default empty string if null
      types: List<String>.from(json['types'] ?? []), // Default to empty list if null
      userRatingsTotal: json['user_ratings_total'] ?? 0, // Default to 0 if null
      vicinity: json['vicinity'] ?? '', // Default empty string if null
      photos: (json['photos'] as List<dynamic>?)
          ?.map((photoJson) => Photo.fromJson(photoJson))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'business_status': businessStatus,
      'geometry': {
        'location': {
          'lat': lat,
          'lng': lng,
        },
        'viewport': {
          'northeast': {
            'lat': viewportNortheastLat,
            'lng': viewportNortheastLng,
          },
          'southwest': {
            'lat': viewportSouthwestLat,
            'lng': viewportSouthwestLng,
          },
        },
      },
      'icon': icon,
      'icon_background_color': iconBackgroundColor,
      'icon_mask_base_uri': iconMaskBaseUri,
      'name': name,
      'place_id': placeId,
      'rating': rating,
      'reference': reference,
      'scope': scope,
      'types': types,
      'user_ratings_total': userRatingsTotal,
      'vicinity': vicinity,
      'photos': photos.isNotEmpty
          ? photos.map((photo) => photo.toJson()).toList()
          : [],
    };
  }



  @override
  String toString() {
    return 'Place(name: $name, rating: $rating)';
  }
}


class Photo {
  final int height;
  final List<String> htmlAttributions;
  final String photoReference;
  final int width;

  Photo({
    required this.height,
    required this.htmlAttributions,
    required this.photoReference,
    required this.width,
  });

  // Factory constructor to create a Photo from JSON
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      height: json['height'] ?? 0,
      htmlAttributions: List<String>.from(json['html_attributions'] ?? []),
      photoReference: json['photo_reference'] ?? '',
      width: json['width'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'html_attributions': htmlAttributions,
      'photo_reference': photoReference,
      'width': width,
    };
  }
}
