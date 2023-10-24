import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MyPagett extends StatefulWidget {
  const MyPagett({Key? key}) : super(key: key);

  @override
  State<MyPagett> createState() => _MyPagettState();
}

class _MyPagettState extends State<MyPagett> {
  GoogleMapController ?gms;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.037933, 31.381523),
    zoom: 14.4746,

  );
   List <Marker>marks=[
  //   Marker(markerId: MarkerId("1"),position: LatLng(31.037933, 31.381523))
   ];
  StreamSubscription<Position>? positionStream;
   initalStream() async{
     bool serviceEnabled;
     LocationPermission permission;

     // Test if location services are enabled.
     serviceEnabled = await Geolocator.isLocationServiceEnabled();
     if (!serviceEnabled) {
       // Location services are not enabled don't continue
       // accessing the position and request users of the
       // App to enable the location services.
       return Future.error('الرجاء تشغيل خدمه الموقع علي جهازك');

     }

     permission = await Geolocator.checkPermission();
     if (permission == LocationPermission.denied) {
       permission = await Geolocator.requestPermission();
       if (permission == LocationPermission.denied) {
         // Permissions are denied, next time you could try
         // requesting permissions again (this is also where
         // Android's shouldShowRequestPermissionRationale
         // returned true. According to Android guidelines
         // your App should show an explanatory UI now.
         return Future.error('Location permissions are denied');
       }
     }

     if (permission == LocationPermission.deniedForever) {
       // Permissions are denied forever, handle appropriately.
       return Future.error(
           'Location permissions are permanently denied, we cannot request permissions.');
     }
     if(permission==LocationPermission.whileInUse){

   positionStream=      Geolocator.getPositionStream().listen(
               (Position? position) {
                 marks.add(Marker(markerId: MarkerId("mahmoud"),position: LatLng(position!.latitude,position.longitude)));
                 gms!.animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude,position.longitude)));
                 setState(() {

                 });
           });
     }
     // When we reach here, permissions are granted and we can
     // continue accessing the position of the device.
     return await Geolocator.getCurrentPosition();

   }
   @override
  void initState() {
     initalStream();
    super.initState();
  }
  @override
  void dispose() {
    positionStream!.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:GoogleMap(
        onTap: (LatLng latLng)async{
          List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
          print(placemarks[0].name);
          print(placemarks[0].country);
          print(placemarks[0].administrativeArea);
          print(placemarks[0].isoCountryCode);
          print(placemarks[0].locality);
          print(placemarks[0].postalCode);
          print(placemarks[0].street);
          print(placemarks[0].subLocality);
          print(placemarks[0].subThoroughfare);
          print(placemarks[0].thoroughfare);

        },
        markers: marks.toSet(),
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (mapGoogle) {
        gms=mapGoogle;
        },
      ),
    );
  }
}
