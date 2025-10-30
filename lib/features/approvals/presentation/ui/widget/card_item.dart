import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import '../../../../../core/dialog.dart';
import '../../../data/model/employee_model.dart';

class ApprovalRequestCard extends StatefulWidget {
  final RequestModel request;
  final VoidCallback? onRefresh;
  final Function(String requestId)? onApprove;
  final Function(String requestId)? onReject;
  final bool isTablet;
  final bool isMobile;
  final bool isLandscape;

  const ApprovalRequestCard({
    super.key,
    required this.request,
    this.onRefresh,
    this.onApprove,
    this.onReject,
    this.isTablet = false,
    this.isMobile = true,
    this.isLandscape = false,
  });

  @override
  State<ApprovalRequestCard> createState() => _ApprovalRequestCardState();
}

class _ApprovalRequestCardState extends State<ApprovalRequestCard> {
  final TextEditingController rejectController = TextEditingController();
  final TextEditingController approveController = TextEditingController();

  // ✅ Helper method to format the date
  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  // ✅ Helper method to format total time
  String _formatTotalTime(double hours) {
    if (hours < 24) {
      return '$hours hours';
    } else {
      final days = (hours / 24).floor();
      final remainingHours = hours % 24;
      if (remainingHours == 0) {
        return '$days day${days > 1 ? 's' : ''}';
      }
      return '$days day${days > 1 ? 's' : ''} $remainingHours hours';
    }
  }

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;

    // Determine if user can take action based on status
    final canAct = widget.request.status.toLowerCase() == 'pending';
    final currentStatus = widget.request.status;

    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: light ? Colors.white : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Header
            Row(
              children: [
                Container(
                  width: 50.sp,
                  height: 50.sp,
                  decoration: BoxDecoration(
                    color: light ? const Color(0xffD9D9D9) : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: SvgPicture.asset(
                    "assets/images/write.svg",
                    fit: BoxFit.scaleDown,
                    color: light ? Colors.black : Colors.white,
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
                SizedBox(width: 10.sp),
                Text(
                  "Request Type: ",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: light ? Color(0xff797979) : Colors.grey,
                  ),
                ),
                Text(
                  "Sick Leave",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: light ? Colors.black : Colors.white,
                  ),
                )
              ],
            ),

            SizedBox(height: 12.h),

            // ✅ Info Rows - NOW USING REAL DATA FROM widget.request
            _buildInfoRow(
              "assets/images/User Plus.svg",
              "Requested by: ",
              widget.request.requestedBy, // ✅ Real data
              light,
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              "assets/images/jobtitle.svg",
              "Job Title: ",
              widget.request.jobTitle, // ✅ Real data
              light,
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              "assets/images/department.svg",
              "Department: ",
              widget.request.department, // ✅ Real data
              light,
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              "assets/images/Calendar.svg",
              "Request Date: ",
              _formatDate(widget.request.requestDate), // ✅ Real data formatted
              light,
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              "assets/images/Calendar.svg",
              "Requested Timeframe: ",
              widget.request.requestedTimeframe, // ✅ Real data
              light,
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              "assets/images/totaltime.svg",
              "Total Time: ",
              _formatTotalTime(widget.request.totalTime), // ✅ Real data formatted
              light,
            ),

            SizedBox(height: 12.h),

            // Action Buttons
            if (canAct)
              Row(
                children: [
                  // Reject Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _showRejectDialog();
                      },
                      child: Container(
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: light ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 22.sp,
                              height: 22.sp,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Reject",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // Approve Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _showApproveDialog();
                      },
                      child: Container(
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: light ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Approve",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            if (!canAct)
              Center(
                child: _buildStatusBadge(
                  label: _getStatusLabel(currentStatus),
                  color: _getStatusColor(currentStatus),
                  status: currentStatus,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String icon, String label, String value, bool light) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon,
          fit: BoxFit.scaleDown,
          width: 16.w,
          height: 16.h,
          color: light ? Colors.grey : Colors.white60,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14.sp,
                color: light ? Colors.black87 : Colors.white70,
              ),
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: light ?  Color(0xff797979) : Colors.grey
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: light ?  Color(0xff2D2D2D) : Colors.white
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge({
    required String label,
    required Color color,
    required String status,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getStatusIcon(status),
            color: color,
            size: 24.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.pending;
    }
  }

  void _showRejectDialog() {
    showConfirmationDialog(
      context: context,
      icon: "assets/images/reject.svg",
      iconColor: Colors.red,
      title: 'Reject Request',
      message: 'Are you sure you want to reject this request?',
      onConfirm: _showRejectReasonDialog,
    );
  }

  void _showRejectReasonDialog() {
    showReasonDialog(
      context: context,
      title: 'Reason Of Rejection',
      label: 'Justifications',
      hint: 'Text here',
      controller: rejectController,
      iconColor: Colors.red,
      onSubmit: _performRejectAction,
    );
  }

  void _performRejectAction() {
    if (widget.request.id != null) {
      widget.onReject?.call(widget.request.id!);
    }

    // Success dialog
    showSuccessDialog(
      context: context,
      icon: "assets/images/approve.svg",
      iconColor: Colors.green,
      title: 'Successful',
      subtitle: 'You Successfully Rejected This Request',
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });

    widget.onRefresh?.call();
  }

  void _showApproveDialog() {
    showConfirmationDialog(
      context: context,
      icon: "assets/images/approve.svg",
      iconColor: Colors.green,
      title: 'Approve Request',
      message: 'Are you sure you want to approve this request?',
      onConfirm: _performApproveAction,
    );
  }

  void _performApproveAction() {
    // Call the onApprove callback with request ID
    if (widget.request.id != null) {
      widget.onApprove?.call(widget.request.id!);
    }

    // Show success dialog
    showSuccessDialog(
      context: context,
      icon: "assets/images/reject.svg",
      iconColor: Colors.green,
      title: 'Service Requested',
      subtitle: 'You Successfully Approved This Request',
    );

    // Auto-close after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });

    widget.onRefresh?.call();
  }

  @override
  void dispose() {
    rejectController.dispose();
    approveController.dispose();
    super.dispose();
  }
}