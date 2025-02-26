import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:student_attandance_with_mlkit/ui/attend/camera_screen.dart';
import 'package:student_attandance_with_mlkit/ui/components/custom_snack_bar.dart';
import 'package:student_attandance_with_mlkit/ui/home_screen.dart';

class AttendScreen extends StatefulWidget {
  const AttendScreen({super.key, this.image});
  final XFile? image;

  @override
  State<AttendScreen> createState() => _AttendScreenState(image);
}

class _AttendScreenState extends State<AttendScreen> {
  _AttendScreenState(this.image);
  XFile? image;
  String? strAddress, strDate, strTime, strDateTime, strStatus = 'Attend';
  bool isLoading = false;
  double dLat = 0.0, dLong = 0.0;
  int dateHours = 0, dateMinutes = 0;
  final controllerName = TextEditingController();
  final CollectionReference dataCollection = FirebaseFirestore.instance.collection('attendance');

  @override
  void initState() {
    handleLocationPermission();
    setDateTime();
    setStatusAbsen();
    super.initState();

    if (image != null) {
      isLoading = true;
      getGeoLocationPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white)
        ),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Attendance Menu',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white
          )
        )
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)
                  ),
                  color: Colors.blueAccent,
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 12),
                    Icon(Icons.face_retouching_natural, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      'Please Make A Selfie Photo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      )
                    )
                  ]
                )
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                child: Text(
                  'Capture Photo!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  )
                )
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const Camera()));
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  width: size.width,
                  height: 150,
                  child: DottedBorder(
                    radius: const Radius.circular(10),
                    borderType: BorderType.RRect,
                    color: Colors.blueAccent,
                    strokeWidth: 1,
                    dashPattern: const [5, 5],
                    child: SizedBox.expand(
                      child: FittedBox(
                        child: image != null
                        ? Image.file(
                          File(image!.path),
                          fit: BoxFit.cover 
                        )
                        : const Icon(
                          Icons.camera_enhance_outlined, 
                          color: Colors.blueAccent
                        )
                      )
                    )
                  )
                )
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  controller: controllerName,
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter your name",
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueAccent
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blueAccent)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blueAccent)
                    )
                  )
                )
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Your location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent
                  )
                )
              ),
              isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent,),
              )
              :Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 5*24,
                  child: TextField(
                    enabled: false,
                    maxLines: 5,
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                      hintText: strAddress != null ? strAddress : strAddress = 'Your Location',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey
                      ),
                      filled: true,
                      fillColor: Colors.transparent
                    ),
                  )
                )
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(30),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueAccent,
                      child: InkWell(
                        splashColor: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                        onTap: (){
                          if (image == null || controllerName.text.isEmpty) {
                            customSnackBar(context, 'Please complete the form', Icons.info);
                          } else {
                            submitAbsen(strAddress, controllerName.text.toString(), strStatus);
                          }
                        },
                        child: const Center(
                          child: Text(
                            'Report Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ]
          )
        )
      )
    );
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      customSnackBar(
        context, 
        'Location service is disabled. Please enable it',
        Icons.location_off
      );
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        customSnackBar(
            context, 
            'Location permission denied', 
            Icons.location_off
          );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        customSnackBar(
            context, 
            'Location permission forever', 
            Icons.location_off
          );
        return false;
      }
    }
    return true;
  }

  void setDateTime() {
    var dateNow = DateTime.now();
    var dateFormat = DateFormat('dd MMMM yyyy');
    var dateTime = DateFormat('HH:mm:ss');
    var dateHour = DateFormat('HH');
    var dateMinute = DateFormat('mm');

    setState(() {
      strDate = dateFormat.format(dateNow);
      strTime = dateTime.format(dateNow);
      strDateTime = "$strDate | $strTime";

      dateHours = int.parse(dateHour.format(dateNow));
      dateMinutes = int.parse(dateMinute.format(dateNow));
    });
  }

  void setStatusAbsen(){
    if (dateHours < 8 || (dateHours == 8 && dateMinutes <= 30)) {
      strStatus = 'Attend';
    } else if((dateHours > 8 && dateHours < 18) || (dateHours == 8 && dateMinutes >= 30)) {
      strStatus = 'Late';
    } else {
      strStatus = 'Absent';
    }
  }

  Future<void> getGeoLocationPosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      isLoading = false;
      getAddressFromLongLat(position);
    });
  }

  Future<void> getAddressFromLongLat(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    setState(() {
      dLat = position.latitude;
      dLong = position.longitude;

      strAddress = "${place.street}, ${place.subLocality}, ${place.postalCode}, ${place.country}";
    });
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert = const AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)
          ),
          SizedBox(width: 10),
          Text('Checking Data...')
        ]
      )
    );
    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (BuildContext context){
        return alert;
      }
    );
  }


  Future<void> submitAbsen(String? strAddress, String name, String? strStatus) async {
    showLoaderDialog(context);

    dataCollection.add({
      'address': strAddress,
      'name': name,
      'status': strStatus,
      'dateTime': strDateTime
    }).then((result){
      setState(() {
        try {
          customSnackBar(context, 'Yeeaay!! Success', Icons.check_circle_outline);
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => HomeScreen()
          ));
        } catch (e) {
          customSnackBar(context, 'Error: $e', Icons.error_outline);
        }
      });
    }).catchError((error){
      customSnackBar(context, 'Error: $error', Icons.error_outline);
      Navigator.pop(context);
    });
  }
}
