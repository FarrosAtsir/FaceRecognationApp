import 'package:flutter/material.dart';
import 'package:student_attandance_with_mlkit/ui/absent/absent_screen.dart';
import 'package:student_attandance_with_mlkit/ui/attend/attend_screen.dart';
import 'package:student_attandance_with_mlkit/ui/attendance_history/attendance_history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (bool diPop){
        if (diPop) {
          return;
        }
        _onWillPop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AttendScreen()));
                    },
                    child: Column(
                      children: [
                        Image.asset('assets/images/ic_absen.png', height: 100, width: 100),
                        const Text(
                          'Absen Kehadiran',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ]
                    )
                  )
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AbsentScreen()));
                    },
                    child: Column(
                      children: [
                        Image.asset('assets/images/ic_leave.png', height: 100, width: 100),
                        const Text(
                          'Cuti / Izin',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AttendanceHistoryScreen()));
                    },
                    child: Column(
                      children: [
                        Image.asset('assets/images/ic_history.png', height: 100, width: 100),
                        const Text(
                          'Riwayat Absensi',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ]
                    )
                  )
                )
              ]
            )
          )
        )
      )
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text(
          'INFO', 
          style: TextStyle(
            color: Colors.black, 
            fontSize: 20,
            fontWeight: FontWeight.bold
          )
        ),
        content: const Text(
          'Do you want to exit the app?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){},
            child: const Text(
              'NO',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black
              )
            ),
          ),
          TextButton(
            onPressed: (){},
            child: const Text(
              'YES',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black
              )
            ),
          )
        ],
      )
    )?? false);
  }
}