import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kebs_app/utils/app_colors.dart';

class DMarkDetailsPage extends StatelessWidget {
  const DMarkDetailsPage({
    super.key,
  });

  String formatDate(String date) {
    return DateFormat.yMMMMd().format(DateTime.parse(date));
  }

  @override
  Widget build(BuildContext context) {
    final String imagePath = Get.arguments['imagePath'];
    final bool status = Get.arguments['status'];
    final markArg = Get.arguments['mark'];
    final String detailsTitle = Get.arguments['detailsTitle'];

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            // color: Colors.white,
            image: DecorationImage(
              image: AssetImage('assets/kebs_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                foregroundColor: Colors.black,
              ),
              const Gap(10),
              SizedBox(
                height: 90,
                width: 90,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              const Gap(10),
              Text(
                markArg.productId,
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),
              const Gap(5),
              Text(
                markArg.productName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(10),
              Text(
                status ? "Valid" : "Expired",
                style: TextStyle(
                  color: status
                      ? AppColors.validGreenColor
                      : AppColors.expiredRedColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(40),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width * .9,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                  color: AppColors.fadedBlueColor1,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    detailsTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .9,
                color: Colors.grey[300],
                height: 1,
              ),
              Flexible(
                flex: 2,
                child: Container(
                  width: MediaQuery.of(context).size.width * .9,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.fadedBlueColor1,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _builtText('Permit No: ${markArg.productId}'),
                        const Gap(10),
                        _builtText(
                            'Permit Status: ${status ? "Valid" : "Expired"}'),
                        const Gap(10),
                        _builtText('Company Name: ${markArg.companyName}'),
                        const Gap(30),
                        _builtText(
                            'Issue Date: ${formatDate(markArg.issueDate)}'),
                        const Gap(10),
                        _builtText(
                            'Expiry Date: ${formatDate(markArg.expiryDate)}'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text _builtText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, color: Colors.grey[800]),
    );
  }
}
