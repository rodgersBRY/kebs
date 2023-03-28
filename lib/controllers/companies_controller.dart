import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/companies_model.dart';

class CompaniesController extends GetxController {
  List<Company> _companies = [];

  Future<List<Company>> fetchCompanies() async {
    try {
      http.Response resp = await http.get(Uri.parse(
          'https://kims.kebs.org:8006/api/v1/migration/anonymous/mobile/companies'));

      if (resp.statusCode == 200) {
        List jsonData = jsonDecode(resp.body);
        
        _companies =
            List<Company>.from(jsonData.map((c) => Company.fromJson(c)));

        _companies.sort(((a, b) => a.companyName.compareTo(b.companyName)));
      } else {
        throw Exception('HTTP Error ${resp.statusCode}');
      }
    } catch (err) {
      throw Exception(err);
    }
    return _companies;
  }
}
