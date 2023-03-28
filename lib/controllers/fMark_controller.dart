// ignore_for_file: file_names

import "dart:convert";

import "package:get/get.dart";
import 'package:http/http.dart' as http;

import '../models/marks_model.dart';

class FMarkController extends GetxController {
  List<MarkModel> _fMarks = [];

  List<MarkModel> get fMarks => _fMarks;

  Future<List<MarkModel>> fetchFMarks() async {
    try {
      http.Response resp = await http.get(
        Uri.parse(
            'https://kims.kebs.org:8006/api/v1/migration/anonymous/mobile/Fmarks'),
      );

      if (resp.statusCode == 200) {
        List jsonData = jsonDecode(resp.body);

        _fMarks =
            List<MarkModel>.from(jsonData.map((m) => MarkModel.fromJson(m)));

        // sort by companyName
        _fMarks.sort((a, b) => a.companyName.compareTo(b.companyName));
      } else {
        throw Exception('HTTP Error ${resp.statusCode}');
      }
    } catch (err) {
      throw Exception(err);
    }

    return _fMarks;
  }
}
