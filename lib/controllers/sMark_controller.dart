// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/marks_model.dart';

class SMarkController extends GetxController {
  List<MarkModel> _sMarks = [];

  List<MarkModel> get sMarks => _sMarks;

  Future<List<MarkModel>> fetchSMarks() async {
    try {
      http.Response resp = await http.get(
        Uri.parse(
            'https://kims.kebs.org:8006/api/v1/migration/anonymous/mobile/Smarks'),
      );

      List jsonData = jsonDecode(resp.body);

      _sMarks =
          List<MarkModel>.from(jsonData.map((m) => MarkModel.fromJson(m)));

      // sort by companyName
      _sMarks.sort((a, b) => a.companyName.compareTo(b.companyName));
    } catch (err) {
      throw Exception(err);
    }

    return _sMarks;
  }
}
