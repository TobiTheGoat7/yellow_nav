import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final String id;
  final String name;
  final String? address;
  final LatLng location;
  final String? placeId;
  final String? photoUrl;
  final double? rating;
  final String? userId; // For saved places
  final DateTime? createdAt;

  Place({
    required this.id,
    required this.name,
    this.address,
    required this.location,
    this.placeId,
    this.photoUrl,
    this.rating,
    this.userId,
    this.createdAt,
  });

  // Convert Firestore Document to Place
  factory Place.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final geoPoint = data['location'] as GeoPoint?;
    
    return Place(
      id: doc.id,
      name: data['name'] ?? 'Unknown',
      address: data['address'],
      location: LatLng(geoPoint?.latitude ?? 0, geoPoint?.longitude ?? 0),
      placeId: data['placeId'],
      photoUrl: data['photoUrl'],
      rating: data['rating']?.toDouble(),
      userId: data['userId'],
      createdAt: data['createdAt']?.toDate(),
    );
  }

  // Convert Place to Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'address': address,
      'location': GeoPoint(location.latitude, location.longitude),
      'placeId': placeId,
      'photoUrl': photoUrl,
      'rating': rating,
      'userId': userId,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // For Google Places API integration
  factory Place.fromGooglePlace(Map<String, dynamic> place, {String? userId}) {
    final geometry = place['geometry'] as Map<String, dynamic>?;
    final location = geometry?['location'] as Map<String, dynamic>?;
    final photos = place['photos'] as List<dynamic>?;

    return Place(
      id: place['place_id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: place['name'] ?? 'Unknown',
      address: place['formatted_address'],
      location: LatLng(
        location?['lat']?.toDouble() ?? 0,
        location?['lng']?.toDouble() ?? 0,
      ),
      placeId: place['place_id'],
      photoUrl: photos?.isNotEmpty == true 
          ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${photos![0]['photo_reference']}&key=YOUR_API_KEY'
          : null,
      rating: place['rating']?.toDouble(),
      userId: userId,
    );
  }
}