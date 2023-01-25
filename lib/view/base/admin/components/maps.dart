import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
    Function(GoogleMapController)? mapController; //contrller for Google map

  CameraPosition initialCameraPosition = const CameraPosition(
      target: LatLng(39.99416282971196, 32.93656166349589), zoom: 5);
  LatLng? selectedLocation = const LatLng(39.99416282971196, 32.93656166349589);
  Set<Marker> markers = {};
  @override
  Widget build(BuildContext context) {
    return  GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        onTap: (argument) {
          setState(() {
            selectedLocation = argument;
            markers.add(
              Marker(
                markerId: const MarkerId(Unicode.ALM),
                position: selectedLocation!
              ),
            );
          });
          print(selectedLocation);
        },
        onMapCreated: mapController,
    );
  }
}
