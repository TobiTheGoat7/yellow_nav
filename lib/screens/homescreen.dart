// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import '../providers/place_provider.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   GoogleMapController? _mapController;
//   final _searchController = TextEditingController();

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   WidgetsBinding.instance.addPostFrameCallback((_) async {
//   //     final placeProvider = Provider.of<PlaceProvider>(context, listen: false);
//   //     await placeProvider.fetchCurrentLocation();

//   //     if (placeProvider.currentPosition != null && _mapController != null) {
//   //       _mapController!.animateCamera(
//   //         CameraUpdate.newLatLng(placeProvider.currentPosition!),
//   //       );
//   //     }
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final placeProvider = Provider.of<PlaceProvider>(context);

//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             polylines: placeProvider.polylines,
//             initialCameraPosition: CameraPosition(
//               target: placeProvider.currentPosition ?? LatLng(0, 0),
//               zoom: 14,
//             ),
//             markers: placeProvider.markers,
//             onMapCreated: (controller) async {
//               _mapController = controller;
//               if (placeProvider.currentPosition != null) {
//                 await Future.delayed(
//                     Duration(milliseconds: 500)); // smoother load
//                 _mapController?.animateCamera(
//                   CameraUpdate.newLatLng(placeProvider.currentPosition!),
//                 );
//               }
//             },
//             myLocationEnabled: true,
//             myLocationButtonEnabled: false,
//             zoomControlsEnabled: false, //removes the zoom controls.
//             mapToolbarEnabled: false,
//           ),
//           Positioned(
//             top: 40,
//             left: 16,
//             right: 16,
//             child: Material(
//               elevation: 4,
//               borderRadius: BorderRadius.circular(8),
//               child: TextField(
//                 controller: _searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Enter destination',
//                   contentPadding:
//                       EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.search),
//                     onPressed: () async {
//                       await placeProvider.searchDestinationAndDrawRoute(
//                           _searchController.text);
//                       if (placeProvider.currentPosition != null &&
//                           placeProvider.markers.length > 1) {
//                         _mapController?.animateCamera(
//                           CameraUpdate.newLatLngBounds(
//                             LatLngBounds(
//                               southwest: placeProvider.currentPosition!,
//                               northeast: placeProvider.markers.last.position,
//                             ),
//                             80,
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await placeProvider.fetchCurrentLocation();
//           if (placeProvider.currentPosition != null) {
//             _mapController?.animateCamera(
//               CameraUpdate.newLatLng(placeProvider.currentPosition!),
//             );
//           }
//         },
//         child: Icon(Icons.my_location),
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_map/flutter_map.dart';
// // import 'package:latlong2/latlong.dart';
// // import 'package:provider/provider.dart';
// // import '../providers/place_provider.dart';

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     Future.microtask(() {
// //       Provider.of<PlaceProvider>(context, listen: false).fetchCurrentLocation();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final placeProvider = Provider.of<PlaceProvider>(context);

// //     return Scaffold(
// //       body: FlutterMap(
// //         options: MapOptions(
// //             initialCenter: placeProvider.currentPosition ?? LatLng(0, 0),
// //             initialZoom: 13.0),
// //         children: [
// //           TileLayer(
// //             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
// //             userAgentPackageName: 'com.company.mapapp',
// //           ),
// //           MarkerLayer(
// //             markers: placeProvider.markers.toList(),
// //           ),
// //         ],
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () => placeProvider.fetchCurrentLocation(),
// //         child: const Icon(Icons.my_location),
// //       ),
// //     );
// //   }
// // }
