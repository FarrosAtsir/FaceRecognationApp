import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:lottie/lottie.dart';
import 'package:student_attandance_with_mlkit/ui/attend/attend_screen.dart';
import 'package:student_attandance_with_mlkit/ui/components/custom_snack_bar.dart';
import 'package:student_attandance_with_mlkit/utils/google_ml_kit.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {

  FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
    enableLandmarks: true,
    enableTracking: true
  ));

  List<CameraDescription>? cameras;
  CameraController? controller;
  XFile? image;
  bool isBusy = false;

  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![1], ResolutionPreset.max);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF6C6C6C),
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_enhance_outlined,
              ),
              SizedBox(width: 10),
              Text(
                'No camera found',
                style: TextStyle(color: Colors.white),
              )
            ]
          )
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white)
        ),
        title: const Text(
          'Capture a selfie image',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: size.height, 
            width: size.width,
            child: controller == null 
            ? const Center(
              child: Text(
                'No camera available',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                )
              )
            )
            : !controller!.value.isInitialized 
            ? const Center(
              child: CircularProgressIndicator(),
            ) 
            : CameraPreview(controller!)
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Lottie.asset('assets/raw/face_id_ring.json', fit: BoxFit.cover)
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: size.width,
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)
                )
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Make sure you are in a well-lit area, so your face is clearly visible',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ClipOval(
                      child: Material(
                        color: Colors.blueAccent,
                        child: InkWell(
                          splashColor: Colors.blueAccent,
                          child: const SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(Icons.camera_enhance_outlined, color: Colors.white)
                          ),
                          onTap: () async {
                            final hasPermission = await handleLocationPermission();
                            try {
                              if (controller != null) {
                                if (controller!.value.isInitialized) {
                                  controller!.setFlashMode(FlashMode.off);
                                  image = await controller!.takePicture();
                                  setState(() {
                                    if (hasPermission) {
                                      showLoaderDialog(context);
                                      final inputImage = InputImage.fromFilePath(image!.path);
                                      Platform.isAndroid 
                                      ? processImage(inputImage) 
                                      : Navigator.push(context, MaterialPageRoute(builder: (context)=> AttendScreen(image: image!)));
                                    }else{
                                      customSnackBar(context, 'Please enable location permission', Icons.location_on);
                                    }
                                  });
                                }
                              }
                            } catch (e) {
                              customSnackBar(context, 'Ups, $e', Icons.error_outline);
                            }
                          }
                        )
                      )
                    )
                  )
                ]
              )
            )
          )
        ]
      )
    );
  }
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      customSnackBar(context, 'Location service is disabled. Please enable it', Icons.location_off);
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        customSnackBar(context, 'Location permission denied', Icons.location_off);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        customSnackBar(context, 'Location permission forever', Icons.location_off);
        return false;
      }
    } return true;
  }

  Future<void> processImage(InputImage inputImage) async {
    if(isBusy)return;
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    isBusy = false;

    if (mounted) {
      setState(() {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context)=> AttendScreen(image: image!))
        );
      });
    }else{
      customSnackBar(context, 'Make sure your face is clearly visible', Icons.face);
    }
  }
}
