import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_bayanat/core/text_field.dart';

// Success Dialog - Shows success message with icon
Future<void> showSuccessDialog({
  required String icon,
  required Color iconColor,
  required String title,
  required BuildContext context,
  required String subtitle,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: SizedBox(
          width: 405.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                icon,
              ),
              SizedBox(height: 20.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[600]
                      : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// Confirmation Dialog - Shows Yes/No buttons
Future<void> showConfirmationDialog({
  required String icon,
  required Color iconColor,
  required String title,
  required BuildContext context,
  required String message,
  required VoidCallback onConfirm,
}) async {
  var lightMode = Theme.of(context).brightness == Brightness.light;
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: SizedBox(
          width: 411.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              SvgPicture.asset(
                icon,
              ),
              SizedBox(height: 10.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[600]
                      : Colors.grey[400],
                ),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 56.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap : (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 135.w,
                        height: 38.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: lightMode ? Color(0xffD9D9D9) : Colors.black45
                        ),
                        child: Center(
                          child: Text('No', style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    GestureDetector(
                      onTap : (){
                        Navigator.pop(context);
                        onConfirm();
                      },
                      child: Container(
                        width: 135.w,
                        height: 38.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: lightMode ? Color(0xffB5B4B4) : Colors.black45
                        ),
                        child: Center(
                          child: Text('yes', style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// Reason Dialog - Shows text input field for rejection/approval reason
Future<void> showReasonDialog({
  required BuildContext context,
  required String title,
  required String label,
  required String hint,
  required TextEditingController controller,
  required VoidCallback onSubmit,
  Color? iconColor,
}) async {
  final light = Theme.of(context).brightness == Brightness.light;

  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      backgroundColor: light ? Colors.white : const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: SizedBox(
          width: 405.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with icon
              Row(
                children: [
                  Container(
                    width: 30.sp,
                    height: 30.sp,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: light ? Color(0xffB5B4B4) : Colors.black
                    ),

                    child: Center(
                      child: SvgPicture.asset(
                        "assets/images/reson_reject.svg",
                        fit: BoxFit.scaleDown,
                        color: light ? Colors.black : Colors.white,
                        width: 16.w,
                        height: 16.h,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: light ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Label
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: light ? Colors.black87 : Colors.white70,
                ),
              ),
              // space
              SizedBox(height: 8.h),
              // Text Input Field
              CustomValidatedTextFieldMaster(
                hint: hint,
                controller: controller,
                maxLines: 3,
                maxLength: 500,
                height: 72,
                textStyle: TextStyle(
                  color: light ? Colors.black : Colors.white,
                ),
                hintStyle: TextStyle(
                  color: light ? Colors.grey[400] : Colors.grey[600],
                ),
                // Optional: if you want to show character count
                showCharCount: true,
                // Optional: if you need to track changes
                onChanged: (value) {
                  // your logic here
                },
              ),
              // space
              SizedBox(height: 16.h),
              // Submit Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      onSubmit();
                    },
                    child: Container(
                      width: 150.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: Color(0xffB5B4B4),
                        borderRadius: BorderRadius.circular(8.r)
                      ),
                      child: Center(
                        child: Text("Submit",style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff2D2D2D),
                          fontSize: 16.sp,
                        ),
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}