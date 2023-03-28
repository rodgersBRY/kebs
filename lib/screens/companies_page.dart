import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controllers/companies_controller.dart';
import '../models/companies_model.dart';
import '../utils/app_colors.dart';
import '../widgets/widgets.dart';

class CompaniesPage extends StatefulWidget {
  const CompaniesPage({super.key});

  @override
  State<CompaniesPage> createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage> {
  late Future<List<Company>> companiesFuture;
  final CompaniesController _companiesController = Get.find();

  final FocusNode _searchNode = FocusNode();
  final TextEditingController _searchTextController = TextEditingController();
  String _searchQuery = '';

  @override
  initState() {
    companiesFuture = _companiesController.fetchCompanies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          _searchNode.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.primaryBlueColor,
            title: const Text('Companies'),
          ),
          body: Column(
            children: [
              const Gap(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    controller: _searchTextController,
                    focusNode: _searchNode,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Enter Company Name',
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const Gap(20),
              Expanded(
                child: FutureBuilder<List<Company>>(
                    future: companiesFuture,
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
                            return const Center(child: CustomErrorWidget());
                          } else {
                            List<Company> data = snapshot.data!;

                            if (_searchQuery.isNotEmpty) {
                              data = data
                                  .where((cp) => cp.companyName
                                      .toLowerCase()
                                      .contains(_searchQuery.toLowerCase()))
                                  .toList();
                            }
                            return _buildListView(context, data);
                          }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(context, data) {
    return ListView.separated(
      itemCount: data.length,
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          onTap: () {
            Get.toNamed(
              '/company-details',
              arguments: {'companyName': data[index].companyName},
            );
          },
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue[200],
            child: Center(
              child: Text(
                '#${index + 1}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          title: Text("${data[index].companyName}"),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }
}
