import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

import '../utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Get.offNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/front-view.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            color: AppColors.primaryBlueColor.withOpacity(.8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Image(
                  image: AssetImage('assets/logo.png'),
                ),
                Gap(40),
                FittedBox(
                  child: Text(
                    'Kenya Bureau of Standards',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                    ),
                  ),
                ),
                Gap(20),
                Divider(color: Colors.black),
                Gap(20),
                Text(
                  'Standards for Quality Life',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Gap(30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
