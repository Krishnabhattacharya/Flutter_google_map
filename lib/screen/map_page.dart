import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  Location location = Location();
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    getLoctionUpdate();
  }

  Future<void> getLoctionUpdate() async {
    bool _serviceEnabled;
    PermissionStatus _permissionStatus;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionStatus = await location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        updateMarkers(locationData.latitude!, locationData.longitude!);
      }
    });
  }

  void updateMarkers(double latitude, double longitude) {
    setState(() {
      markers = {
        Marker(
          markerId: MarkerId("_currentLocation"),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(latitude, longitude),
        ),
        Marker(
          markerId: MarkerId("_anotherLocation"),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(37.3346, -122.0090),
        ),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.4219983, -122.084),
          zoom: 13,
        ),
        markers: markers,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}
