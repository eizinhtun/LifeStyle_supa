// @dart=2.9
import 'package:flutter/material.dart';
import 'package:left_style/localization/translate.dart';
import 'package:left_style/models/user_location.dart';
import 'package:left_style/services/location_service.dart';
// import 'package:location/location.dart';
import 'package:provider/provider.dart';

// class CurrentLocation extends StatefulWidget {
//   const CurrentLocation({Key key}) : super(key: key);

//   @override
//   _CurrentLocationState createState() => _CurrentLocationState();
// }

// class _CurrentLocationState extends State<CurrentLocation> {
//   LocationData _locationData;
//   double lat, log;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Current Location"),
//         centerTitle: true,
//       ),
//       body: Container(
//         margin: EdgeInsets.all(8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 Location location = new Location();

//                 bool _serviceEnabled;
//                 PermissionStatus _permissionGranted;

//                 _serviceEnabled = await location.serviceEnabled();
//                 if (!_serviceEnabled) {
//                   _serviceEnabled = await location.requestService();
//                   if (!_serviceEnabled) {
//                     return;
//                   }
//                 }

//                 _permissionGranted = await location.hasPermission();
//                 if (_permissionGranted == PermissionStatus.denied) {
//                   _permissionGranted = await location.requestPermission();
//                   if (_permissionGranted != PermissionStatus.granted) {
//                     return;
//                   }
//                 }
//                 if (_permissionGranted == PermissionStatus.granted) {
//                   // If granted listen to the onLocationChanged stream and emit over our controller
//                   location.onLocationChanged.listen((locationData) {
//                     if (locationData != null) {
//                       setState(() {
//                         lat = _locationData.latitude;
//                         log = _locationData.longitude;
//                       });
//                     }
//                   });
//                 }

//                 _locationData = await location.getLocation();
//                 setState(() {
//                   lat = _locationData.latitude;
//                   log = _locationData.longitude;
//                 });
//               },
//               child: Text(
//                 "Get Current Location",
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Text("Lat: ${_locationData?.latitude.toString()}"),
//             SizedBox(
//               height: 20,
//             ),
//             Text("Log: ${_locationData?.longitude.toString()}"),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CurrentLocation extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
      initialData: UserLocation(),
      create: (context) => LocationService().locationStream,
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Tran.of(context).text("current_location"),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                'Location: Lat${userLocation?.latitude}, Long: ${userLocation?.longitude}'),
          ],
        ),
      ),
    );
  }
}
