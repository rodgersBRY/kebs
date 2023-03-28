import 'package:flutter/material.dart';

import '../models/marks_model.dart';

class GlobalFunctions {
  final TextEditingController permitNoController = TextEditingController();

  searchByPermitNumber(List<MarkModel> list) {
    List<MarkModel> result = list
        .where(
          (mark) =>
              mark.productId.toLowerCase() ==
              permitNoController.text.trim().toLowerCase(),
        )
        .toList();

    return result;
  }
}
