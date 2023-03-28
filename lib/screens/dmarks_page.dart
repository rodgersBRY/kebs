import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:kebs_app/utils/global_functions.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controllers/dMark_controller.dart';
import '../models/marks_model.dart';
import '../utils/app_colors.dart';
import '../widgets/widgets.dart';

class DiamondMarkPage extends StatefulWidget {
  const DiamondMarkPage({super.key});

  @override
  State<DiamondMarkPage> createState() => _DiamondMarkPageState();
}

class _DiamondMarkPageState extends State<DiamondMarkPage> {
  final DMarkController _dMarkController = Get.find();
  GlobalFunctions globalFunctions = GlobalFunctions();

  late Future<List<MarkModel>> dMarkBuilder;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchPermitNoController =
      TextEditingController();
  final FocusNode searchNode = FocusNode();

  @override
  void initState() {
    super.initState();

    dMarkBuilder = _dMarkController.fetchDMarks();
  }

  bool confirmValidity(String? expiryDate) {
    if (expiryDate != "null") {
      DateTime today = DateTime.now();
      DateTime date = DateTime.parse(expiryDate!);

      return date.isAfter(today);
    } else {
      return false;
    }
  }

  searchByPermitNo() {
    List<MarkModel> result =
        globalFunctions.searchByPermitNumber(_dMarkController.dMarks);

    if (result.isNotEmpty) {
      // clear the textfield
      globalFunctions.permitNoController.clear();
      // close the dialog box
      Navigator.of(context).pop();
      // navigate to details page
      Get.toNamed(
        '/mark-details-page',
        arguments: {
          'detailsTitle': 'Diamond Mark Details',
          'mark': result[0],
          'imagePath': 'assets/dmark_logo.png',
          "status": confirmValidity(result[0].expiryDate.toString()),
        },
      );
    } else {
      Get.snackbar(
        backgroundColor: Colors.white,
        "Not Found",
        "No permit with that number",
      );
    }
  }

  Future _refreshData() {
    dMarkBuilder = _dMarkController.fetchDMarks();
    return dMarkBuilder;
  }

  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          searchNode.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
             elevation: 0,
            backgroundColor: AppColors.primaryBlueColor,
            title: const Text('Diamond Marks'),
          ),
          body: RefreshIndicator(
            onRefresh: _refreshData,
            child: Column(
              children: [
                const Gap(20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlueColor.withOpacity(.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      controller: searchController,
                      focusNode: searchNode,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Enter Product Name, Permit Number or Brand Name',
                        hintStyle: TextStyle(fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                Expanded(
                  child: FutureBuilder<List<MarkModel>>(
                      future: dMarkBuilder,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center(
                              child: LoadingAnimationWidget.hexagonDots(
                                color: AppColors.primaryBlueColor,
                                size: 30,
                              ),
                            );
                          default:
                            if (snapshot.hasError) {
                              return const CustomErrorWidget();
                            } else {
                              List<MarkModel> data = snapshot.data!;
          
                              if (_searchQuery.isNotEmpty) {
                                data = data
                                    .where((dmark) =>
                                        dmark.productId.toLowerCase().contains(
                                            _searchQuery.toLowerCase()) ||
                                        dmark.productBrand
                                            .toLowerCase()
                                            .contains(
                                                _searchQuery.toLowerCase()) ||
                                        dmark.productName
                                            .toLowerCase()
                                            .contains(
                                                _searchQuery.toLowerCase()))
                                    .toList();
                              }
                              return CustomListView(
                                routeName: '/dmark-details-page',
                                marks: data,
                                imagePath: 'assets/dmark_logo.png',
                                detailsTitle: 'Diamond Mark Details',
                              );
                            }
                        }
                      }),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.lightBlueAccent,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Enter Permit Number'),
                      content: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlueColor.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: globalFunctions.permitNoController,
                          decoration: const InputDecoration(
                            hintText: "DM Permit Number",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            globalFunctions.permitNoController.clear();
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        TextButton(
                          onPressed: searchByPermitNo,
                          child: Text(
                            'Search',
                            style: TextStyle(
                              color: AppColors.primaryBlueColor,
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            },
            child: const Icon(Icons.search),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    globalFunctions.permitNoController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
