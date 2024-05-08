
import 'package:expensemate/screens/Authentication/ui/Authpage.dart';
import 'package:expensemate/screens/Home/ui/Homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
     FirebaseAuth auth = FirebaseAuth.instance;

  // Get the current user
  
     Future.delayed(Duration(seconds: 2), () {
      if(widget.Action=='AuthtoHome'){
Navigator.push(context, 
      MaterialPageRoute(builder: (context)=>HomePage()));
      }
      else if(widget.Action=='HometoAuth'){
Navigator.push(context, 
      MaterialPageRoute(builder: (context)=>AuthPage()));
      }
      else if(widget.Action=='DeleteToHome'){
Navigator.push(context, 
      MaterialPageRoute(builder: (context)=>HomePage()));
      
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