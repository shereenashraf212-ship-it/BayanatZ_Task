import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_bayanat/core/extention.dart';
import 'package:task_bayanat/features/approvals/presentation/ui/widget/filter_icon_widget.dart';

import '../../../../../core/search_widget.dart';
import '../../../data/model/employee_model.dart';
import '../../controller/requestcubit_cubit.dart';
import '../widget/card_item.dart';
import '../widget/filter.dart';
import '../widget/header_employee.dart';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({super.key});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  bool lightMode = true;
  bool isArabic = false;
  String selectedFilter = 'All';
  String searchQuery = ''; // ✅ Added search query state

  TextEditingController searchController = TextEditingController();
  String? selectedJobTitle;
  String? selectedDepartment;
  String? selectedRequestType;
  @override
  void initState() {
    super.initState();
    // Load requests
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestCubit>().getRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;
    final isLandscape = context.isLandscape;

    return Scaffold(
      body: BlocListener<RequestCubit, RequestcubitState>(
        listener: (context, state) {
          if (state is RequestcubitUploadSuccess) {
            print("success Loading ");
          } else if (state is RequestcubitStatusUpdated) {
            print("request update Loading ");
          } else if (state is RequestcubitError) {
            print("Error Loading ");
          }
        },
        child: BlocBuilder<RequestCubit, RequestcubitState>(
          builder: (context, state) {
            // Get the list of requests
            List<RequestModel> allRequests = [];
            if (state is RequestcubitLoaded) {
              allRequests = state.requests;
            }

            // ✅ Filter requests by status AND search query
            List<RequestModel> filteredRequests = _filterRequests(allRequests);

            return SingleChildScrollView(
              padding: EdgeInsets.all(30.sp),
              child: Container(
                color: lightMode ? Color(0xffF5F5F5) : Colors.black,
                child: Column(
                  children: [
                    // EmployeeHeaderWidget
                    EmployeeHeaderWidget(
                      fullName: "Amro Handousa",
                      title: "Marketing ",
                      departmentName: "Marketing Manger",
                      lightMode: lightMode,
                      isArabic: isArabic,
                      isMobile: isMobile,
                      isTablet: isTablet,
                      isLandscape: isLandscape,
                      onMessagePressed: () {
                        print("Message pressed");
                        _showMessageDialog();
                      },
                    ),

                    // space
                    SizedBox(height: 16.sp),

                    // filter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FilterSectionWidget(
                          requests: allRequests, // Pass all requests for count calculation
                          onFilterChanged: (status) {
                            setState(() {
                              selectedFilter = status; // Update selected filter
                            });
                            print('Selected status: $status');
                          },
                        ),
                      ],
                    ),

                    // space
                    SizedBox(height: 16.sp),

                    // search & Filter
                    // search & Filter
                    Row(
                      children: [
                        CustomSearchWidget(
                          controller: searchController,
                          onChanged: (String value) {
                            setState(() {
                              searchQuery = value.trim().toLowerCase();
                            });
                            print('Search query: $searchQuery');
                          },
                        ),
                        SizedBox(
                          width: 10.sp,
                        ),
                        // ✅ Update this GestureDetector
                        GestureDetector(
                          onTap: () {
                            // Show the filter dialog
                            context.showRequestFilterDialog(
                              initialJobTitle: selectedJobTitle,
                              initialDepartment: selectedDepartment,
                              initialRequestType: selectedRequestType,
                              onApply: (jobTitle, department, requestType) {
                                setState(() {
                                  selectedJobTitle = jobTitle;
                                  selectedDepartment = department;
                                  selectedRequestType = requestType;
                                });
                                print('Filters applied - Job: $jobTitle, Dept: $department, Type: $requestType');
                              },
                            );
                          },
                          child: Container(
                            width: 38.w,
                            height: 38.h,
                            decoration: BoxDecoration(
                              color: lightMode ? Colors.white : Colors.grey[900],
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/images/filter.svg",
                                fit: BoxFit.scaleDown,
                                width: 23.w,
                                height: 23.h,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // space
                    SizedBox(height: 16.sp),

                    // Loading state
                    if (state is RequestcubitLoading)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(50.sp),
                          child: CircularProgressIndicator(),
                        ),
                      ),

                    // Empty state
                    if (state is RequestcubitLoaded && filteredRequests.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(50.sp),
                          child: Text(
                            searchQuery.isNotEmpty
                                ? 'No requests found for "$searchQuery"'
                                : 'No requests found for filter: $selectedFilter',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: lightMode ? Colors.grey : Colors.white70,
                            ),
                          ),
                        ),
                      ),

                    // GridView with filtered requests
                    if (state is RequestcubitLoaded && filteredRequests.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 16.sp),
                        itemCount: filteredRequests.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 1 : isTablet ? 2 : 3,
                          mainAxisExtent: 310.sp,
                          mainAxisSpacing: 15.sp,
                          crossAxisSpacing: 15.sp,
                        ),
                        itemBuilder: (context, index) {
                          final request = filteredRequests[index];
                          return ApprovalRequestCard(
                            request: request, // Pass the request data
                            onRefresh: () {
                              // Reload requests after action
                              context.read<RequestCubit>().getRequests();
                            },
                            onApprove: (requestId) {
                              // Call cubit to update status to approved
                              context
                                  .read<RequestCubit>()
                                  .updateStatus(requestId, 'approved');
                            },
                            onReject: (requestId) {
                              // Call cubit to update status to rejected
                              context
                                  .read<RequestCubit>()
                                  .updateStatus(requestId, 'rejected');
                            },
                            isTablet: isTablet,
                            isMobile: isMobile,
                            isLandscape: isLandscape,
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<RequestModel> _filterRequests(List<RequestModel> requests) {
    List<RequestModel> filtered = requests;

    // First, filter by status
    if (selectedFilter != 'All') {
      filtered = filtered
          .where((request) =>
      request.status.toLowerCase() == selectedFilter.toLowerCase())
          .toList();
    }

    // ✅ Filter by job title
    if (selectedJobTitle != null) {
      filtered = filtered.where((request) {
        return request.jobTitle.toLowerCase() == selectedJobTitle!.toLowerCase();
      }).toList();
    }

    // ✅ Filter by department
    if (selectedDepartment != null) {
      filtered = filtered.where((request) {
        return request.department.toLowerCase() == selectedDepartment!.toLowerCase();
      }).toList();
    }

    // Note: requestType is not in your model, so we skip it
    // If you want to filter by requestType, you need to add it to RequestModel

    // Finally, filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((request) {
        final requestedBy = request.requestedBy.toLowerCase();
        return requestedBy.contains(searchQuery);
      }).toList();
    }

    return filtered;
  }
  void _showMessageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Message'),
        content: const Text('Message functionality will be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}