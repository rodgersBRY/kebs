import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controllers/fMark_controller.dart';
import '../models/marks_model.dart';
import '../utils/app_colors.dart';
import '../utils/global_functions.dart';
import '../widgets/widgets.dart';

class FortificationPage extends StatefulWidget {
  const FortificationPage({super.key});

  @override
  State<FortificationPage> createState() => _FortificationPageState();
}

class _FortificationPageState extends State<FortificationPage> {
  final FMarkController _fMarkController = Get.find();
  final GlobalFunctions globalFunctions = GlobalFunctions();

  late Future<List<MarkModel>> fMarkFuture;

  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();

  String _searchQuery = "";

  @override
  void initState() {
    super.initState();

    fMarkFuture = _fMarkController.fetchFMarks();
  }

  bool confirmValidity(String expiryDate) {
    DateTime today = DateTime.now();
    DateTime date = DateTime.parse(expiryDate);

    return date.isAfter(today);
  }

  // refresh data upon dragging down
  Future _refreshData() {
    fMarkFuture = _fMarkController.fetchFMarks();
    return fMarkFuture;
  }

  searchByPermitNo() {
    List<MarkModel> result =
        globalFunctions.searchByPermitNumber(_fMarkController.fMarks);

    if (result.isNotEmpty) {
      // clear the textfield
      globalFunctions.permitNoController.clear();
      // close the dialog box
      Navigator.of(context).pop();
      // navigate to details page
      Get.toNamed(
        '/mark-details-page',
        arguments: {
          'detailsTitle': 'Fortification Mark Details',
          'mark': result[0],
          'imagePath': 'assets/fmark_logo.png',
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
            title: const Text('Fortification Marks'),
          ),
          body: RefreshIndicator(
            onRefresh: _refreshData,
            child: Column(
              children: [
                const Gap(20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                      future: fMarkFuture,
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
                                    .where((fmark) =>
                                        fmark.productId.toLowerCase().contains(
                                            _searchQuery.toLowerCase()) ||
                                        fmark.productBrand
                                            .toLowerCase()
                                            .contains(
                                                _searchQuery.toLowerCase()) ||
                                        fmark.productName
                                            .toLowerCase()
                                            .contains(
                                                _searchQuery.toLowerCase()))
                                    .toList();
                              }
                              return CustomListView(
                                marks: data,
                                imagePath: 'assets/fmark_logo.png',
                                detailsTitle: 'Fortification Mark Details',
                              );
                            }
                        }
                      }),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.validGreenColor,
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
                            hintText: "FM Permit Number",
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
}
