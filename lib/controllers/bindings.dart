import 'package:get/get.dart';
import 'fMark_controller.dart';
import 'dMark_controller.dart';
import 'sMark_controller.dart';
import './staff_verify_controller.dart';
import './companies_controller.dart';
import './company_details_controller.dart';

class MyBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SMarkController>(() => SMarkController());
    Get.lazyPut<FMarkController>(() => FMarkController());
    Get.lazyPut<DMarkController>(() => DMarkController());
    Get.lazyPut<VerifyStaffController>(() => VerifyStaffController());
    Get.lazyPut<CompaniesController>(() => CompaniesController());
    Get.lazyPut<CompanyDetailsController>(() => CompanyDetailsController());
  }
}
