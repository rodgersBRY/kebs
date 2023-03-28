// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kebs_app/screens/ism_page.dart';

import './controllers/bindings.dart';
import './screens/screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KEBS App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: getPages,
    );
  }

  List<GetPage> getPages = [
    GetPage(
      name: '/',
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/home',
      page: () => Homepage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/std-page',
      page: () => const SMarksPage(),
      transition: Transition.fade,
      binding: MyBindings(),
    ),
    GetPage(
      name: '/verify-staff',
      page: () => const VerifyStaffPage(),
      transition: Transition.fade,
      binding: MyBindings(),
    ),
    GetPage(
      name: '/fortification-mark',
      page: () => const FortificationPage(),
      transition: Transition.fade,
      binding: MyBindings(),
    ),
    GetPage(
      name: '/companies',
      page: () => const CompaniesPage(),
      transition: Transition.fade,
      binding: MyBindings(),
    ),
    GetPage(
      name: '/diamond-page',
      page: () => const DiamondMarkPage(),
      transition: Transition.fade,
      binding: MyBindings(),
    ),
    GetPage(
      name: '/company-details',
      page: () => const CompanyDetailsPage(),
      transition: Transition.fade,
      binding: MyBindings(),
    ),
    GetPage(
      name: '/contact',
      page: () => const ContactPage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: '/mark-details-page',
      page: () => const MarkDetailsPage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: '/dmark-details-page',
      page: () => const DMarkDetailsPage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: '/ism-page',
      page: () => ISMPage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: '/complaints',
      page: () => ComplaintsPage(),
      transition: Transition.fade,
    ),
    // GetPage(
    //   name: '/test-page',
    //   page: () => TestVerifyPage(),
    //   transition: Transition.fade,
    // ),
  ];
}
