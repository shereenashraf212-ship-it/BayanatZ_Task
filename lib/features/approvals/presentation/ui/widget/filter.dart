import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/model/employee_model.dart';

class FilterSectionWidget extends StatefulWidget {
  final Function(String)? onFilterChanged;
  final List<RequestModel> requests; // Accept list of requests

  const FilterSectionWidget({
    Key? key,
    this.onFilterChanged,
    required this.requests, // Required parameter
  }) : super(key: key);

  @override
  State<FilterSectionWidget> createState() => _FilterSectionWidgetState();
}

class _FilterSectionWidgetState extends State<FilterSectionWidget> {
  String selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate counts dynamically from requests
    final int totalServices = widget.requests.length;
    final int approvedCount = widget.requests
        .where((request) => request.status.toLowerCase() == 'approved')
        .length;
    final int pendingCount = widget.requests
        .where((request) => request.status.toLowerCase() == 'pending')
        .length;
    final int rejectedCount = widget.requests
        .where((request) => request.status.toLowerCase() == 'rejected')
        .length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: Row(
        children: [
          _buildStatusChip(
            count: totalServices.toString(),
            label: 'All',
            isSelected: selectedStatus == 'All',
            labelColor: isDark ? Colors.grey[300]! : Colors.grey[700]!,
          ),
          _buildStatusChip(
            count: approvedCount.toString(),
            label: 'Approved',
            isSelected: selectedStatus == 'Approved',
            labelColor: Colors.green[600]!,
          ),
          _buildStatusChip(
            count: pendingCount.toString(),
            label: 'Pending',
            isSelected: selectedStatus == 'Pending',
            labelColor: Colors.amber[700]!,
          ),
          _buildStatusChip(
            count: rejectedCount.toString(),
            label: 'Rejected',
            isSelected: selectedStatus == 'Rejected',
            labelColor: Colors.red[600]!,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip({
    required String count,
    required String label,
    required bool isSelected,
    required Color labelColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = label;
        });
        widget.onFilterChanged?.call(label);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          children: [
            Container(
              width: isMobile ? 35.w : 45.w,
              height: isMobile ? 35.h : 45.h,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blue[600]
                    : isDark
                    ? Colors.grey[800]
                    : Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Center(
                child: Text(
                  count,
                  style: TextStyle(
                    fontSize: isMobile ? 14.sp : 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : isDark
                        ? Colors.grey[300]
                        : Colors.grey[700],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: isMobile ? 14.sp : 16.sp,
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}