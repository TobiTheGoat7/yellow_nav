// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;

// class PlaceProvider with ChangeNotifier {
//   Set<Marker> _markers = {};
//   Set<Marker> get markers => _markers;

//   Set<Polyline> _polylines = {};
//   Set<Polyline> get polylines => _polylines;

//   LatLng? _currentPosition;
//   LatLng? get currentPosition => _currentPosition;

//   LatLng? _destination;

//   Future<void> fetchCurrentLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         throw Exception('Location services are disabled');
//       }

//       // Check permissions
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw Exception('Location permissions are denied');
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         throw Exception('Location permissions are permanently denied');
//       }

//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       _currentPosition = LatLng(position.latitude, position.longitude);
//       _markers.add(
//         Marker(markerId: MarkerId("current"), position: _currentPosition!),
//       );
//       notifyListeners();
//     } catch (e) {
//       debugPrint('Location error: $e');
//     }
//   }

//   Future<void> searchDestinationAndDrawRoute(String address) async {
//     if (_currentPosition == null) return;

//     // Geocode destination
//     final geocodeUrl =
//         'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=${dotenv.env['GOOGLE_MAPS_API_KEY']}';
//     final geocodeRes = await http.get(Uri.parse(geocodeUrl));
//     final geocodeData = json.decode(geocodeRes.body);

//     if (geocodeData['status'] != 'OK') {
//       debugPrint("Location not found");
//       return;
//     }

//     final loc = geocodeData['results'][0]['geometry']['location'];
//     _destination = LatLng(loc['lat'], loc['lng']);

//     _markers.add(Marker(
//       markerId: MarkerId("destination"),
//       position: _destination!,
//     ));

//     await _getDirections();
//     notifyListeners();
//   }

//   Future<void> _getDirections() async {
//     if (_currentPosition == null || _destination == null) return;

//     final directionsUrl =
//         'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${_destination!.latitude},${_destination!.longitude}&key=AIzaSyC9ZTkfmBTT95Q0_gbrfck0x5dCaQ8BsfY';

//     final res = await http.get(Uri.parse(directionsUrl));
//     final data = json.decode(res.body);

//     if (data['status'] == 'OK') {
//       final points = PolylinePoints().decodePolyline(
//         data['routes'][0]['overview_polyline']['points'],
//       );

//       _polylines.clear();
//       _polylines.add(
//         Polyline(
//           polylineId: PolylineId("route"),
//           color: Colors.blue,
//           width: 5,
//           points: points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
//         ),
//       );
//       notifyListeners();
//     }
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class PlaceProvider extends ChangeNotifier {
  LatLng? currentPosition;
  List<Marker> osmMarkers = [];
  List<LatLng> polylinePoints = [];
  List<Polyline> get osmPolylines => [
        Polyline(
          points: polylinePoints,
          strokeWidth: 4.0,
          color: Colors.blue,
        ),
      ];

  Future<void> fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPosition = LatLng(position.latitude, position.longitude);

    // Add current location marker
    osmMarkers.add(
      Marker(
        point: currentPosition!,
        width: 80,
        height: 80,
        child: Icon(Icons.location_on, color: Colors.blue, size: 35),
      ),
    );

    notifyListeners();
  }

  Future<void> searchDestinationAndDrawRoute(String address) async {
    // For now, simulate destination — you can replace with real search API
    LatLng destination = LatLng(
        currentPosition!.latitude + 0.01, currentPosition!.longitude + 0.01);

    osmMarkers.add(
      Marker(
        point: destination,
        width: 80,
        height: 80,
        child: Icon(Icons.location_on, color: Colors.red, size: 35),
      ),
    );

    // Draw a simple straight polyline from current to destination
    polylinePoints = [currentPosition!, destination];

    notifyListeners();
  }


  Future<void> fetchDrivingRoute(LatLng start, LatLng end) async {
  final apiKey = 'your_api_key';
  final url = Uri.parse(
      'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf6248e90e26e273574a8e92a8af95d95269fe&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final coordinates = data['features'][0]['geometry']['coordinates'];

    polylinePoints = coordinates
        .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
        .toList();

    notifyListeners();
  }
}

}
