// ignore_for_file: file_names

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/marks_model.dart';

class DMarkController extends GetxController {
  List<MarkModel> _dMarks = [];

  List<MarkModel> get dMarks => _dMarks;

  Future<List<MarkModel>> fetchDMarks() async {
    try {
      http.Response resp = await http.get(
        Uri.parse(
            'https://kims.kebs.org:8006/api/v1/migration/anonymous/mobile/Dmarks'),
      );

      if (resp.statusCode == 200) {
        List jsonData = jsonDecode(resp.body);

        _dMarks =
            List<MarkModel>.from(jsonData.map((m) => MarkModel.fromJson(m)));

        // sort by companyName
        _dMarks.sort(((a, b) => a.companyName.compareTo(b.companyName)));
      } else {
        throw Exception('HTTP Error ${resp.statusCode}');
      }
    } catch (err) {
      throw Exception(err);
    }

    return _dMarks;
  }
}
