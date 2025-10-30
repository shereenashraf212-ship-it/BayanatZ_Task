import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/drop_down.dart';

class RequestFilterDialog extends StatefulWidget {
  final String? initialJobTitle;
  final String? initialDepartment;
  final String? initialRequestType;
  final Function(String? jobTitle, String? department, String? requestType) onApply;

  const RequestFilterDialog({
    Key? key,
    this.initialJobTitle,
    this.initialDepartment,
    this.initialRequestType,
    required this.onApply,
  }) : super(key: key);

  @override
  State<RequestFilterDialog> createState() => _RequestFilterDialogState();
}

class _RequestFilterDialogState extends State<RequestFilterDialog> {
  String? selectedJobTitle;
  String? selectedDepartment;
  String? selectedRequestType;

  final List<Map<String, String>> jobTitles = [
    {"key": "marketing", "value": "Marketing"},
    {"key": "manager", "value": "Manager"},
    {"key": "developer", "value": "Developer"},
    {"key": "designer", "value": "Designer"},
    {"key": "hr", "value": "HR Specialist"},
    {"key": "accountant", "value": "Accountant"},
  ];

  final List<Map<String, String>> departments = [
    {"key": "marketing", "value": "Marketing"},
    {"key": "hr", "value": "HR"},
    {"key": "it", "value": "IT"},
    {"key": "finance", "value": "Finance"},
    {"key": "operations", "value": "Operations"},
  ];

  final List<Map<String, String>> requestTypes = [
    {"key": "leave", "value": "Leave Request"},
    {"key": "overtime", "value": "Overtime Request"},
    {"key": "remote", "value": "Remote Work"},
    {"key": "training", "value": "Training Request"},
    {"key": "equipment", "value": "Equipment Request"},
  ];

  @override
  void initState() {
    super.initState();
    selectedJobTitle = widget.initialJobTitle;
    selectedDepartment = widget.initialDepartment;
    selectedRequestType = widget.initialRequestType;
  }

  void _resetFilters() {
    setState(() {
      selectedJobTitle = null;
      selectedDepartment = null;
      selectedRequestType = null;
    });
  }

  void _applyFilters() {
    widget.onApply(selectedJobTitle, selectedDepartment, selectedRequestType);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bool lightMode = Theme.of(context).brightness == Brightness.light;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      backgroundColor: lightMode ? Colors.white : const Color(0xFF1E1E1E),
      child: Container(
        width: 645.w,
        padding: EdgeInsets.all(24.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40.sp,
                  height: 40.sp,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lightMode
                        ? const Color(0xFFF5F5F5)
                        : const Color(0xFF2A2A2A),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/images/filter.svg",
                      fit: BoxFit.scaleDown,
                      width: 18.w,
                      height: 18.h,
                    ),
                  ),
                ),
                SizedBox(width: 12.sp),
                Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: lightMode ? Colors.black87 : Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.sp),

            // Filter Fields
            Row(
              children: [
                Expanded(
                  child: CustomDropdownFormField(
                    selectedValue: selectedJobTitle,
                    items: jobTitles,
                    widthIcon: 20.w,
                    heightIcon: 20.h,
                    height: 36.sp,
                    spaceHeight: 8.sp,
                    dropdownColor: lightMode
                        ? const Color(0xFFFAFAFA)
                        : const Color(0xFF2A2A2A),
                    hint: Text(
                      'Select Job Title',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: lightMode ? Colors.black54 : Colors.white54,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedJobTitle = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16.sp),
                Expanded(
                  child: CustomDropdownFormField(
                    selectedValue: selectedDepartment,
                    items: departments,
                    widthIcon: 20.w,
                    heightIcon: 20.h,
                    height: 36.sp,
                    spaceHeight: 8.sp,
                    dropdownColor: lightMode
                        ? const Color(0xFFFAFAFA)
                        : const Color(0xFF2A2A2A),
                    hint: Text(
                      'Select Department',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: lightMode ? Colors.black54 : Colors.white54,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedDepartment = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.sp),

            Row(
              children: [
                Expanded(child:CustomDropdownFormField(

                  selectedValue: selectedRequestType,
                  items: requestTypes,
                  widthIcon: 20.w,
                  heightIcon: 20.h,
                  height: 36.sp,
                  spaceHeight: 8.sp,
                  dropdownColor: lightMode
                      ? const Color(0xFFFAFAFA)
                      : const Color(0xFF2A2A2A),
                  hint: Text(
                    'Select Request Type',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: lightMode ? Colors.black54 : Colors.white54,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedRequestType = value;
                    });
                  },
                ),),
                SizedBox(width: 16.sp),
                Expanded(child: Center()),
                SizedBox(width: 10.sp),
              ],
            ),



            SizedBox(height: 32.sp),

            // Action Buttons
            Row(
              children: [


                GestureDetector(
                  onTap: _resetFilters,
                  child: Container(
                    width: 150.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: Color(0xffB5B4B4),
                      borderRadius: BorderRadius.circular(8.r)
                    ),
                    child: Center(
                      child: Text("Reset",style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500
                      ),),
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: _applyFilters,
                  child: Container(
                    width: 150.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                        color: Color(0xffB5B4B4),
                        borderRadius: BorderRadius.circular(8.r)
                    ),
                    child: Center(
                      child: Text("Apply",style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500
                      ),),
                    ),
                  ),
                )

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
    required bool lightMode,
  }) {
    return SizedBox(
      height: 44.sp,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? (lightMode ? const Color(0xFF2E2E2E) : const Color(0xFF4A4A4A))
              : (lightMode ? const Color(0xFFE0E0E0) : const Color(0xFF2A2A2A)),
          foregroundColor: isPrimary
              ? Colors.white
              : (lightMode ? Colors.black87 : Colors.white70),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Extension method to show the dialog easily
extension RequestFilterDialogExtension on BuildContext {
  Future<void> showRequestFilterDialog({
    String? initialJobTitle,
    String? initialDepartment,
    String? initialRequestType,
    required Function(String? jobTitle, String? department, String? requestType) onApply,
  }) {
    return showDialog(
      context: this,
      builder: (context) => RequestFilterDialog(
        initialJobTitle: initialJobTitle,
        initialDepartment: initialDepartment,
        initialRequestType: initialRequestType,
        onApply: onApply,
      ),
    );
  }
}