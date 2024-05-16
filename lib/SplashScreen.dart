// ignore_for_file: file_names

import 'package:docs/Componant/Componant.dart';
import 'package:docs/MainScreen.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
 void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 3000),(){
      navigateAndFinish(context, const MainScreen());

    });


  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/lastLogo.jpg'),fit: BoxFit.fitHeight)),

      ),
    );
  }
}
