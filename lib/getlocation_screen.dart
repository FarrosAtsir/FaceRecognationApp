import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GetlocationScreen extends StatefulWidget {
  const GetlocationScreen({super.key});

  @override
  State<GetlocationScreen> createState() => _GetlocationScreenState();
}

class _GetlocationScreenState extends State<GetlocationScreen> {
  String? latitude;
  String? longitude;
  String? address;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      // check permission maps
      LocationPermission permission = await Geolocator.checkPermission();
      // jika denied maka request permission
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            isLoading = false;
            address = 'Permission Denied';
          });
          return;
        }
      }

      // jika denied forever, buka setting
      if(permission == LocationPermission.deniedForever){
        setState(() {
          isLoading = false;
          address = 'Location services are disabled. To use these features, enable Location Services in your phone';
        });
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high)
      );

      List<Placemark> placemark = await placemarkFromCoordinates(
        position.latitude, 
        position.longitude
      );

      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        isLoading = false;
        address = "${placemark[0].name}, ${placemark[0].locality}, ${placemark[0].administrativeArea}, ${placemark[0].country}";
      });

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geolocator and Geocode'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Latitude: $latitude, $longitude'),
                  const SizedBox(height: 20),
                  Text(address ?? 'No Data')
                ],
              ),
      ),
    );
  }
}
