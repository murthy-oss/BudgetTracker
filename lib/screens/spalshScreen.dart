import 'dart:async';

import 'package:expensemate/screens/Authentication/data/Auth_data.dart';
import 'package:expensemate/screens/Authentication/ui/Authpage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthPage()), // Navigate to your main screen
      );
    });

    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AuthData.AppLogo,
            height: 150.h,),
            Text(AuthData.Appname,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),),
             Text("Your expense manager",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color.fromARGB(255, 97, 97, 97)
            ),),
            LoadingAnimationWidget.waveDots(
        color: Colors.black,
        size: 50,
      ),
          ],
        ), // You can replace this with your splash screen image or animation
      ),
    );
  }
}