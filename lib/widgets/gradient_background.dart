import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/widgets.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/monument.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryBlueColor.withOpacity(.1),
                  Colors.white,
                ],
              ),
            ),
          ),
          const Positioned(
            top: 35,
            left: 20,
            child: Image(
              image: AssetImage('assets/logo.png'),
              width: 60,
            ),
          ),
          const Positioned(
            top: 35,
            left: 55,
            child: SizedBox(
              width: 300,
              height: 200,
              child: Carousel(),
            ),
          ),
        ],
      ),
    );
  }
}
