import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kebs_app/utils/app_colors.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 215, 231, 245),
        appBar: AppBar(
          elevation: 0,
          title: const Text('Contact Details'),
          backgroundColor: AppColors.primaryBlueColor,
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(30),
              _buildText('Managing Director'),
              const Gap(10),
              _buildText('Kenya Bureau of Standards'),
              const Gap(40),
              _buildText('Popo road, Off Mombasa Road'),
              const Gap(10),
              _buildText('P.O Box 54974 - 00200'),
              const Gap(10),
              _buildText('Nairobi, Kenya'),
              const Gap(40),
              _buildText('Tel: +254(20) 694 8000'),
              const Gap(10),
              _buildText('Mobile: 0722202137 or 0734600471/2'),
              const Gap(10),
              _buildText('Email: info@kebs.org'),
              const Gap(40),
              _buildText('PVOC: 0724255242'),
              Expanded(
                child: Container(),
              ),
              Container(
                width: double.infinity,
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/toll_image.jpeg'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text _buildText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 17),
    );
  }
}
