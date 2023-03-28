import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CompanyDetailsController extends GetxController {
  List companyDetails = [];

  Future getCompanyDetails(String companyName) async {
    try {
      http.Response resp = await http.get(
        Uri.parse(
            'https://kims.kebs.org:8006/api/v1/migration/anonymous/mobile/company?companyName=$companyName'),
      );

      if (resp.statusCode == 200) {
        var jsonData = jsonDecode(resp.body);

        companyDetails = jsonData;

        return companyDetails;
      } else {
        throw Exception();
      }
    } catch (err) {
      throw Exception(err);
    }
  }
}
