import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:yellow_nav/providers/place_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final placeProvider = Provider.of<PlaceProvider>(context, listen: false);
      await placeProvider.fetchCurrentLocation();

      if (placeProvider.currentPosition != null) {
        _mapController.move(placeProvider.currentPosition!, 14);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final placeProvider = Provider.of<PlaceProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: placeProvider.currentPosition ?? LatLng(0, 0),
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              if (placeProvider.osmPolylines
                  .any((polyline) => polyline.points.isNotEmpty))
                PolylineLayer(
                  polylines: placeProvider.osmPolylines
                      .where((polyline) => polyline.points.isNotEmpty)
                      .toList(),
                ),
              MarkerLayer(
                markers: placeProvider.osmMarkers,
              ),
            ],
          ),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Enter destination',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed:
                    
                     () async {
                      await placeProvider.searchDestinationAndDrawRoute(
                          _searchController.text);
                      if (placeProvider.currentPosition != null &&
                          placeProvider.osmMarkers.length > 1) {
                        var bounds = LatLngBounds.fromPoints([
                          placeProvider.currentPosition!,
                          placeProvider.osmMarkers.last.point
                        ]);
                        _mapController.fitCamera(
                          CameraFit.bounds(
                            bounds: bounds,
                            padding: EdgeInsets.all(80),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await placeProvider.fetchCurrentLocation();
          if (placeProvider.currentPosition != null) {
            _mapController.move(placeProvider.currentPosition!, 14);
          }
        },
        child: Icon(Icons.my_location),
      ),
    );
  }
}
