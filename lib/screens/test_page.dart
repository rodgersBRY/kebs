import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../utils/app_colors.dart';

class TestVerifyPage extends StatefulWidget {
  const TestVerifyPage({super.key});

  @override
  State<TestVerifyPage> createState() => _TestVerifyPageState();
}

class _TestVerifyPageState extends State<TestVerifyPage> {
  TextEditingController bsNoController = TextEditingController();
  FocusNode bsNoFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        bsNoFocusNode.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Check Results"),
            backgroundColor: AppColors.primaryBlueColor,
          ),
          body: Column(
            children: [
              const Gap(150),
              const Text(
                'Test Results Checker',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(40),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlueColor.withOpacity(.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    // onChanged: onChanged(),
                    controller: bsNoController,
                    focusNode: bsNoFocusNode,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.numbers),
                      hintText: "BS Number",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const Gap(50),
              const VerifyButton()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    bsNoController.dispose();
  }
}

class VerifyButton extends StatelessWidget {
  const VerifyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: Colors.blue.withOpacity(.4),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 70,
        width: 250,
        decoration: BoxDecoration(
          color: AppColors.primaryBlueColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
            child: Text(
          'Submit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        )),
      ),
    );
  }
}
