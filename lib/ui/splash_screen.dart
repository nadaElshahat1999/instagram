import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'home.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(milliseconds: 1500), (){
      if(FirebaseAuth.instance.currentUser==null){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> LoginScreen()));
      }
      else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomeScreen()));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome',style: TextStyle(color: Colors.black54,
        fontSize: 33.sp),),
      ),
    );
  }
}
