import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kebs_app/utils/secret.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/mailgun.dart';

import '../utils/app_colors.dart';

const List<String> list = ["Anonymous", "Enquiry/Feedback"];

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  String dropdownVal = list.first;
  String address = "";
  RxBool isLoading = false.obs;
  RxBool _gpsLoading = false.obs;

  // mailgun
  static String username = mailgunUsername;
  static String password = mailgunPassword;

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _permitNoController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _complainDetailsController =
      TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final FocusNode _subjectNode = FocusNode();
  final FocusNode _permitNoNode = FocusNode();
  final FocusNode _productNameNode = FocusNode();
  final FocusNode _complainDetailsNode = FocusNode();
  final FocusNode _phoneNumberNode = FocusNode();
  final FocusNode _emailNode = FocusNode();

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    _gpsLoading.value = true;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services disabled. request users location access
      await Geolocator.openLocationSettings();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location services are disabled.'),
        ),
      );
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _gpsLoading.value = false;
        // Permissions are denied.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are denied.'),
          ),
        );

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _gpsLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.'),
        ),
      );

      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];

    debugPrint(place.toString());

    _gpsLoading.value = false;

    setState(() {
      address =
          '\t${place.street!.isNotEmpty ? "Street: ${place.street}" : ""} ${place.thoroughfare!.isNotEmpty ? "${place.thoroughfare}\n\t" : ""}${place.postalCode!.isNotEmpty ? "Postal Code: ${place.postalCode}\n\t" : ""}${place.administrativeArea!.isNotEmpty ? "County: ${place.administrativeArea}\n\t" : ""}${place.country!.isNotEmpty ? "County: ${place.country}" : ""}';
    });
  }

  final smtpServer = mailgun(username, password);

  _sendMail() async {
    if (_subjectController.text.isEmpty ||
        _complainDetailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("All fields with * must be filled"),
        backgroundColor: Colors.red,
      ));
    } else if (dropdownVal != "Anonymous" &&
        (_emailController.text.isEmpty ||
            _phoneNoController.text.isEmpty ||
            address == "")) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("All fields with * must be filled"),
        backgroundColor: Colors.red,
      ));
    }

    final message = new Message();

    if (dropdownVal == "Anonymous") {
      message
        ..from = new Address(username, "KEBS Helpline App")
        ..recipients.add('customercare@kebs.org')
        ..bccRecipients.addAll(["kirimij@kebs.org", 'mawirab@kebs.org'])
        ..subject = "$dropdownVal - ${_subjectController.text.trim()}"
        ..text =
            "${_subjectController.text.isNotEmpty ? "Email Subject: ${_subjectController.text.trim()}\n" : ""}${_phoneNoController.text.isNotEmpty ? "Phone Number: ${_phoneNoController.text} \n" : ""}${_emailController.text.isNotEmpty ? "Email Address:  ${_emailController.text} \n" : ""}${address.isNotEmpty ? "Location\n $address \n" : ""}Permit Number: ${_permitNoController.text.trim()}\nProduct Name: ${_productNameController.text.trim()}\nComplain Details: ${_complainDetailsController.text.trim()}";
    } else {
      message
        ..from = new Address(username, "KEBS Helpline App")
        ..recipients.add('customercare@kebs.org')
        ..bccRecipients.addAll(["kirimij@kebs.org", 'mawirab@kebs.org'])
        ..subject = "$dropdownVal - ${_subjectController.text.trim()}"
        ..text =
            "${_subjectController.text.isNotEmpty ? "Email Subject: ${_subjectController.text.trim()}\n" : ""}${_phoneNoController.text.isNotEmpty ? "Phone Number: ${_phoneNoController.text}\n" : ""}${_emailController.text.isNotEmpty ? "Email Address:  ${_emailController.text} \n" : ""}${address.isNotEmpty ? "Location\n $address \n" : ""}Complain Details: ${_complainDetailsController.text.trim()}";
    }

    try {
      isLoading.value = true;
      await send(message, smtpServer);

      isLoading.value = false;

      _subjectController.clear();
      _permitNoController.clear();
      _productNameController.clear();
      _complainDetailsController.clear();
      _phoneNoController.clear();
      _emailController.clear();

      setState(() {
        address = "";
      });

      Get.snackbar(
        "Success",
        "Email has been delivered",
        icon: Icon(Icons.check_circle, color: Colors.green),
        backgroundColor: Colors.white,
      );
    } catch (err) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Email has been delivered",
        icon: Icon(Icons.error_rounded, color: Colors.red),
        backgroundColor: Colors.white,
      );
      throw Exception("Error: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _emailNode.unfocus();
        _phoneNumberNode.unfocus();
        _subjectNode.unfocus();
        _permitNoNode.unfocus();
        _productNameNode.unfocus();
        _complainDetailsNode.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primaryBlueColor,
          title: const Text('Report Complaints'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/kebs_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Center(
                      child: Text(
                    'Complain Details',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  )),
                ),
                Gap(20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.fadedBlueColor1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: dropdownVal,
                      items: list
                          .map<DropdownMenuItem<String>>(
                              (String item) => DropdownMenuItem(
                                    child: Text(item),
                                    value: item,
                                  ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownVal = value!;
                        });
                      },
                    ),
                  ),
                ),
                Gap(20),
                dropdownVal == "Anonymous"
                    ? _buildTextField(
                        hintText: "Email (optional)",
                        controller: _emailController,
                        focusNode: _emailNode,
                      )
                    : _buildTextField(
                        hintText: "Email*",
                        controller: _emailController,
                        focusNode: _emailNode,
                      ),
                Gap(20),
                dropdownVal == "Anonymous"
                    ? _buildTextField(
                        hintText: "Phone Number (optional)",
                        controller: _phoneNoController,
                        focusNode: _phoneNumberNode,
                      )
                    : _buildTextField(
                        hintText: "Phone Number*",
                        controller: _phoneNoController,
                        focusNode: _phoneNumberNode,
                      ),
                Gap(20),
                _buildTextField(
                  hintText: 'Subject*',
                  controller: _subjectController,
                  focusNode: _subjectNode,
                ),
                dropdownVal == "Anonymous"
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: _buildTextField(
                          hintText: 'Permit number*',
                          controller: _permitNoController,
                          focusNode: _permitNoNode,
                        ),
                      )
                    : Container(),
                dropdownVal == "Anonymous"
                    ? _buildTextField(
                        hintText: 'Product Name*',
                        controller: _productNameController,
                        focusNode: _productNameNode,
                      )
                    : Container(),
                Gap(20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.fadedBlueColor1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _complainDetailsController,
                    focusNode: _complainDetailsNode,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Complain Details*',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Gap(20),
                Container(
                  width: 200,
                  child: GestureDetector(
                    onTap: () async {
                      Position position = await _getGeoLocationPosition();
                      getAddressFromLatLong(position);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: const Offset(
                              5.0,
                              5.0,
                            ),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          )
                        ],
                      ),
                      child: Obx(() => Center(
                            child: _gpsLoading.value
                                ? CircularProgressIndicator(color: Colors.black)
                                : Text(
                                    "Send Location?\nClick here (Optional)",
                                    style: TextStyle(),
                                  ),
                          )),
                    ),
                  ),
                ),
                Gap(15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    child: Text(
                      'ADDRESS\n$address',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Gap(20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info,
                      size: 13,
                      color: Colors.red,
                    ),
                    Gap(3),
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        child: Text(
                          'All fields with * are required',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(30),
                GestureDetector(
                  onTap: _sendMail,
                  child: Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlueColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(() => Center(
                          child: !isLoading.value
                              ? Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                )
                              : CircularProgressIndicator(color: Colors.white),
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildTextField({
    required String hintText,
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.fadedBlueColor1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _permitNoController.dispose();
    _productNameController.dispose();
    _complainDetailsController.dispose();

    super.dispose();
  }
}
