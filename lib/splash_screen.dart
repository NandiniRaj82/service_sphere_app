import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_sphere/Login.dart';
import 'package:service_sphere/main.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
   Timer(Duration(seconds: 3),() {
     Navigator.pushReplacement(
         context, MaterialPageRoute(builder: (context) => Login(),
     ));
   });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/Animation/Animation - 1746804065616.json',
          height: 300,
          width: 300,
          repeat: true,
          animate: true,
        ),
      ),
    );
  }
}