//API key : AIzaSyCyjzSy3eLfRZ0hj0SLFVR2hQqI1shMHAQ
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:location/location.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  String street='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    //getCurrentLocation();
  }

  late GoogleMapController _controller ;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.0324871,31.3733343),
    zoom: 14.4746,
  );

  //

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            markers: markers.values.toSet(),
            mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
             _controller= controller;
            },
            onTap: (latlng)async{
              print(latlng);
              List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(
              latlng.latitude, latlng.longitude
              ,localeIdentifier: 'ar');
              print(placemarks);
              street=placemarks[0].street.toString();
              setState(() {
              });
              addMarker(latlng,placemarks[0].street.toString());
            },
          ),
          Positioned(
            top: 15.sp,
            child: Container(
              width: 80.sp,
              padding: EdgeInsets.all(10.sp),
              margin: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Text(street,style:
              TextStyle(color: Colors.white,
              fontSize: 18.sp),textAlign: TextAlign.end,),
            ),
          ),
          Positioned(
            bottom: 10.sp,
            child: ElevatedButton(onPressed: (){
              getCurrentLocation();
            },
                child:Text('move to my location')
            ),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  addMarker(latlng, String street){
    markers.clear();
    var marker = Marker(
      markerId: MarkerId(latlng.hashCode.toString()),
      position: latlng,
      infoWindow: InfoWindow(
        title: street,
        snippet: 'address',
      ),
    );

    setState(() {
      markers[MarkerId(latlng.hashCode.toString())] = marker;
    });
  }
getCurrentLocation()async{
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  _locationData = await location.getLocation();
  print('current location ${_locationData.latitude}');
  var currentLatlng=LatLng(_locationData.latitude!,
  _locationData.longitude!);
  _controller.animateCamera(CameraUpdate.newLatLngZoom(
      currentLatlng, 15));
}
  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
