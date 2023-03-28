import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/staff_model.dart';

class VerifyStaffController extends GetxController {
  final RxBool _loading = false.obs;
  final RxList<dynamic> _staffInfo = <dynamic>[].obs;

  bool get loading => _loading.value;
  List<dynamic> get staffInfo => _staffInfo;

  Future verifyStaff(String staffNo) async {
    _loading.value = true;

    final uri = Uri.https(
      'connect.kebs.org',
      '/hr/urls/kebs_staff.php',
    );

    try {
      final resp = await http.post(
        uri,
        body: json.encode({
          "request": {"StaffID": staffNo},
          "header": {
            "serviceName": "BSKApp",
            "messageID": "BSK",
            "connectionID": "BskAccount",
            "connectionPassword": "P@\$\$w0rd@kebs"
          },
        }),
        headers: {"Content-Type": "application/json"},
      );

      final respBody = jsonDecode(resp.body);

      _loading.value = false;

      _staffInfo
          .assignAll(respBody.map((staff) => Staff.fromJson(staff)).toList());

      return _staffInfo;
    } catch (err) {
      _loading.value = false;
      Get.snackbar(
        backgroundColor: Colors.white,
        icon: const Icon(Icons.error),
        "No user found",
        "No user with number $staffNo exists in our database",
      );
    }
  }
}
