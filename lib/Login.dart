import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Login extends StatefulWidget{
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double ScreenHeight = screenSize.height;
    final double ScreenWidth = screenSize.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xFFFD746C),
                  Color(0xFF2C3E50),
                ],
              ),
            ),
          ),
          SingleChildScrollView( // Wrap Column with SingleChildScrollView
            child: Column(
              children: [
                Center(child: SizedBox(height: ScreenHeight * 0.25)),
                Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LoginFont',
                  ),
                ),
                SizedBox(height: ScreenHeight * 0.06),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter email",
                      hintStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  child: TextField(
                    obscureText: true,
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter password",
                      hintStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ScreenHeight * 0.04),
                Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                    children: [
                      TextSpan(
                        text: "Create new account",
                        style: TextStyle(
                          color: Colors.white60, // Make it look like a link
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ScreenHeight * 0.04),
                ElevatedButton(
                  onPressed: () {
                    // Handle login or any action here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white24, // Soft translucent white
                    foregroundColor: Colors.white, // Text/icon color
                    elevation: 4, // Slight elevation
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Smooth rounded corners
                    ),
                  ),
                  child: Container(
                    width: ScreenWidth * 0.15,
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
