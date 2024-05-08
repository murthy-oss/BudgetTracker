
// ignore_for_file: file_names, non_constant_identifier_names

import 'package:expensemate/screens/Authentication/ui/Authpage.dart';
import 'package:expensemate/screens/Home/ui/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatefulWidget {
  final String Action;
  const LoadingScreen(this.Action, {super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  // Get the current user
  
     Future.delayed(const Duration(seconds: 2), () {
      if(widget.Action=='AuthtoHome'  || widget.Action=='AddElementToHome' || widget.Action=='EditElementToHome' ){
Navigator.push(context, 
      MaterialPageRoute(builder: (context)=>const HomePage()));
      }
      else if(widget.Action=='HometoAuth'){
Navigator.push(context, 
      MaterialPageRoute(builder: (context)=>const AuthPage()));
      }
     
      
    });
    
  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:  LoadingAnimationWidget.waveDots(
        color: Colors.black,
        size: 50,
      ),
      ),
    );
  }
}