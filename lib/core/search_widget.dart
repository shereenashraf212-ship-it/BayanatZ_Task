import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';



class CustomSearchWidget extends StatelessWidget {
  const CustomSearchWidget({
    required this.controller,
    required this.onChanged,
    super.key,
    this.fillColor,
  });

  final TextEditingController controller;
  final Color? fillColor;
  final dynamic Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return Expanded(
      child: SizedBox(
        height: 38.h,
        child: TextField(
          controller: controller,
          onChanged: onChanged,

          maxLines: 1,
          textAlignVertical: TextAlignVertical.center,

          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400
          ),
          decoration: InputDecoration(
            hoverColor: Colors.transparent,
            hintText: "search",
            hintStyle: TextStyle(
                fontSize: 14.sp,
                color: lightMode ? Colors.grey : Colors.white,
                fontWeight: FontWeight.w400
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 0.sp),
              child: SvgPicture.asset(
                "assets/images/searchIcon.svg",
              ),
            ),
            isCollapsed: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 0.sp,
              vertical: 8.sp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide.none,
            ),

            fillColor: lightMode ?  Color(0xffffffff) : Colors.grey[900],
            filled: true,
          ),
        ),
      ),
    );
  }
}