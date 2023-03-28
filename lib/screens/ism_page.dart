import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../utils/app_colors.dart';

class ISMPage extends StatefulWidget {
  const ISMPage({super.key});

  @override
  State<ISMPage> createState() => _ISMPageState();
}

class _ISMPageState extends State<ISMPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryBlueColor,
        title: const Text('Import Standardization Mark'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.build,
              size: 70,
              color: Colors.grey,
            ),
            Gap(5),
            Text(
              "Coming Soon",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
