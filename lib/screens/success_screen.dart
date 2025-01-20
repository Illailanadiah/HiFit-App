import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hifit/screens/home_screen.dart';
import 'package:lottie/lottie.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(milliseconds: 3000),
      () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
      child: Center(
        child: Container(
          child: Center(
            child: LottieBuilder.asset("assets/animation.success_animation.json"),
          ),
        ),
      ),
    );
  }
}
