import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_sphere/service.dart';
import 'package:service_sphere/main.dart';
import 'package:service_sphere/profile.dart';


class TrackPage extends StatefulWidget {
  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    return Scaffold(
      backgroundColor: Color(0xFF2C3E50),
      appBar: AppBar(
        title: Text("Track", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF22303b),
      ),

      // ✅ Scrollable body with carousel + main content
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color((0xFF22303b)),
        currentIndex: 0, // Home is selected
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyHomePage()));
          } else if (index == 1) {

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ServicePage()));
          } else if (index == 2) {

          } else if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>  ProfilePage()),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_repair_service),
            label: 'Service',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
