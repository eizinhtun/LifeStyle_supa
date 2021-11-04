// @dart=2.9
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({Key key}) : super(key: key);

  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  LocationData _locationData;
  double lat, log;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Current Location"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                Location location = new Location();

                bool _serviceEnabled;
                PermissionStatus _permissionGranted;

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
                setState(() {
                  lat = _locationData.latitude;
                  log = _locationData.longitude;
                });
              },
              child: Text(
                "Get Current Location",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Lat: ${_locationData?.latitude.toString()}"),
            SizedBox(
              height: 20,
            ),
            Text("Log: ${_locationData?.longitude.toString()}"),
          ],
        ),
      ),
    );
  }
}
