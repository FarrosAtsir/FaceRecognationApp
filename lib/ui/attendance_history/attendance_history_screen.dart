import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final CollectionReference dataCollection = FirebaseFirestore.instance.collection('attendance');
  @override
  Widget build(BuildContext context) {
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
          'Attendance History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white
          )
        )
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: dataCollection.get(), 
        builder: (context, snapshot){
          if (snapshot.hasData) {
            var data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: () {
                    AlertDialog deleteDialog = AlertDialog(
                      title: const Text(
                        'INFO', 
                        style: TextStyle(
                          color: Colors.black, 
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      content: const Text(
                        'are you sure want to delete?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                        )
                      ),
                      actions: [
                        TextButton(
                          onPressed: (){
                            Navigator.of(context).pop(false);
                          },
                          child: const Text(
                            'NO',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black
                            )
                          )
                        ),
                        TextButton(
                          onPressed: (){
                            setState(() {
                              dataCollection.doc(data[index].id).delete();
                              Navigator.pop(context);
                            });
                          },
                          child: const Text(
                            'YES',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black
                            )
                          )
                        )
                      ]
                    );
                    showDialog(context: context, builder: (context)=>AlertDialog());
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.all(10),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                              borderRadius: BorderRadius.circular(50)
                            ),
                            child: Center(
                              child: Text(
                                data[index]['name'][0],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white
                                )
                              )
                            )
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Expanded(
                                      flex: 4,
                                      child: Text(
                                        'Name',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                        )
                                      )
                                    ),
                                    const Expanded(
                                      flex: 1,
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                        )
                                      )
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                        data[index]['name'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                        )
                                      )
                                    )
                                  ]
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Expanded(
                                      flex: 4,
                                      child: Text(
                                        'Address',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                        )
                                      )
                                    ),
                                    const Expanded(
                                      flex: 1,
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                        )
                                      )
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                        data[index]['address'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                        )
                                      )
                                    )
                                  ]
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Expanded(
                                      flex: 4,
                                      child: Text(
                                        'Description',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                        )
                                      )
                                    ),
                                    const Expanded(
                                      flex: 1,
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                        )
                                      )
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                        data[index]['status'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                        )
                                      )
                                    )
                                  ]
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Expanded(
                                      flex: 4,
                                      child: Text(
                                        'Date',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                        )
                                      )
                                    ),
                                    const Expanded(
                                      flex: 1,
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                        )
                                      )
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                        data[index]['dateTime'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                        )
                                      )
                                    )
                                  ]
                                )
                              ]
                            )
                          )
                        ]
                      )
                    )
                  ),
                );
              }
            );
          }else{
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              )
            );
          }
        }
      )
    );
  }
}