import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_attandance_with_mlkit/ui/components/custom_snack_bar.dart';
import 'package:student_attandance_with_mlkit/ui/home_screen.dart';

class AbsentScreen extends StatefulWidget {
  const AbsentScreen({super.key});

  @override
  State<AbsentScreen> createState() => _AbsentScreenState();
}

class _AbsentScreenState extends State<AbsentScreen> {
  String? strAlamat, strDate, strTime, strDateTime;
  double dLat = 0.0, dLong = 0.0;
  int dateHours = 0, dateMinutes = 0;
  final controllerName = TextEditingController();
  final controllerFrom = TextEditingController();
  final controllerTo = TextEditingController();
  String dropValueCategory = 'Please Select';
  List<String> categoryList = [
    'Please Select',
    'Other',
    'Permission',
    'Sick'
  ];
  final CollectionReference dataCollection = FirebaseFirestore.instance.collection('attendance');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
          'Permission Request Menu',
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
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
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
                  color: Colors.blueAccent
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 12),
                    Icon(Icons.maps_home_work_outlined, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      'Please fill the form',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      )
                    )
                  ]
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20
                ),
                child: TextField(
                  textInputAction: TextInputAction.next,
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
                  'Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent
                  )
                )
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.blueAccent, 
                      style: BorderStyle.solid, 
                      width: 1
                    )
                  ),
                  child: DropdownButton(
                    dropdownColor: Colors.white,
                    value: dropValueCategory,
                    onChanged: (value){
                      setState(() {
                        dropValueCategory = value!;
                      });
                    },
                    items: categoryList.map((value){
                      return DropdownMenuItem(
                        value: value.toString(),
                        child: Text(
                          value.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black
                          )
                        )
                      );
                    }).toList(),
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14
                    ),
                    underline: Container(
                      height: 2,
                      color: Colors.transparent,
                    ),
                    isExpanded: true,
                  )
                )
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Text(
                            "From:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent
                            )
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedData = await showDatePicker(
                                  context: context, 
                                  firstDate: DateTime(2024), 
                                  lastDate: DateTime(2026),
                                  initialDate: DateTime.now(),
                                  builder: (BuildContext context, Widget? child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          onPrimary: Colors.white,
                                          onSurface: Colors.blueAccent,
                                          primary: Colors.blueAccent
                                        ),
                                        datePickerTheme: const DatePickerThemeData(
                                          headerBackgroundColor: Colors.blueAccent,
                                          backgroundColor: Colors.white,
                                          headerForegroundColor: Colors.white,
                                          surfaceTintColor: Colors.white
                                        )
                                      ),
                                      child: child!
                                    );
                                  }
                                );

                                if (pickedData != null) {
                                  controllerFrom.text = DateFormat('dd/MM/yy').format(pickedData);
                                }
                              },
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black
                              ),
                              controller: controllerFrom,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                hintText: 'Starting Form',
                                hintStyle: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 16
                                )
                              )
                            )
                          )
                        ]
                      )
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: Row(
                        children: [
                          const Text(
                            "Until:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent
                            )
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedData = await showDatePicker(
                                  context: context, 
                                  firstDate: DateTime(2024), 
                                  lastDate: DateTime(2026),
                                  initialDate: DateTime.now(),
                                  builder: (BuildContext context, Widget? child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          onPrimary: Colors.white,
                                          onSurface: Colors.blueAccent,
                                          primary: Colors.blueAccent
                                        ),
                                        datePickerTheme: const DatePickerThemeData(
                                          headerBackgroundColor: Colors.blueAccent,
                                          backgroundColor: Colors.white,
                                          headerForegroundColor: Colors.white,
                                          surfaceTintColor: Colors.white
                                        )
                                      ),
                                      child: child!
                                    );
                                  }
                                );

                                if (pickedData != null) {
                                  controllerTo.text = DateFormat('dd/MM/yy').format(pickedData);
                                }
                              },
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black
                              ),
                              controller: controllerTo,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                hintText: 'Ending Until',
                                hintStyle: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 16
                                )
                              )
                            )
                          )
                        ]
                      )
                    )
                  ]
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
                          if (controllerName.text.isEmpty || 
                          controllerFrom.text.isEmpty || 
                          controllerTo.text.isEmpty || 
                          dropValueCategory == "Please Select") {
                            customSnackBar(
                              context, 
                              "Please fill the form", 
                              Icons.info_outline
                            );
                          }else{
                            submitAbsen(
                              '-', 
                              controllerName.text, 
                              dropValueCategory, controllerFrom.text, 
                              controllerTo.text
                            );
                          }
                        },
                        child: const Center(
                          child: Text(
                            'Make A Request',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            )
                          )
                        )
                      )
                    )
                  )
                )
              )
            ]
          )
        )
      )
    );
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


  Future<void> submitAbsen(String strAddress, String name, String strStatus, String from, String until) async {
    showLoaderDialog(context);

    dataCollection.add({
      'address': strAddress,
      'name': name,
      'status': strStatus,
      'dateTime': '$from-$until'
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
