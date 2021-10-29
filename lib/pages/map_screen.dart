// @dart=2.9

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:left_style/models/Meter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key key, this.meter}) : super(key: key);
  final Meter meter;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  Marker marker;
  double lat, log;
  bool showMarker = true;

  @override
  void initState() {
    initialMap();
    super.initState();
  }

  void initialMap() {
    lat = double.parse(widget.meter.latitude);
    log = double.parse(widget.meter.longitude);
    marker = Marker(
      visible: showMarker,
      markerId: MarkerId(widget.meter.meterNo),
      position: LatLng(lat, log),
      infoWindow: InfoWindow(
        onTap: () {
          setState(() {
            showMarker = !showMarker;
          });
        },
        title: "${widget.meter.consumerName} (${widget.meter.customerId})",
        snippet: widget.meter.houseNo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(lat, log),
      zoom: 14.4746,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.meter.meterNo}"),
        centerTitle: true,
        backgroundColor: Color(0xFFfa2e73),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController mapcontroller) {
          /*Future.delayed(Duration(milliseconds: 10))
              .then((_) => mapcontroller.showMarkerInfoWindow(marker.markerId));
          _controller.complete(mapcontroller);*/
        },
        markers: [marker].toSet(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheHome,
        label: Text('Auto Adjust!'),
        icon: Icon(Icons.adjust),
      ),
    );
  }

  Future<void> _goToTheHome() async {
    final GoogleMapController controller = await _controller.future;
    double lat = double.parse(widget.meter.latitude);
    double log = double.parse(widget.meter.longitude);
    final CameraPosition _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lat, log),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
