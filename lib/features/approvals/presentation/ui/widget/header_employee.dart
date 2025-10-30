import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmployeeHeaderWidget extends StatelessWidget {
  final String fullName;
  final String title;
  final String departmentName;
  final bool lightMode;
  final bool isArabic;
  final bool isMobile;
  final bool isTablet;
  final bool isLandscape;
  final VoidCallback onMessagePressed;

  const EmployeeHeaderWidget({
    Key? key,
    required this.fullName,
    required this.title,
    required this.departmentName,

    required this.lightMode,
    required this.isArabic,
    required this.isMobile,
    required this.isTablet,
    required this.isLandscape,
    required this.onMessagePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return _buildMobileLayout();
    } else if (isTablet && !isLandscape) {
      return _buildTabletPortraitLayout();
    } else {
      return _buildDesktopLayout();
    }
  }

  Widget _buildMobileLayout() {
    return Container(
      decoration: BoxDecoration(
        color: lightMode ? Colors.white : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.sp),
        child: Column(
          children: [
            Row(
              children: [
                _buildAvatar(45.sp),
                SizedBox(width: 5.sp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _capitalize(fullName),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: lightMode ? Colors.black : Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _capitalize(departmentName),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: lightMode ? Colors.grey[600] : Colors.grey[400],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _capitalize(title),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: lightMode ? Colors.grey[600] : Colors.grey[400],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _buildCheckInButton(
                  width: 135.sp,
                  height: 38.sp,
                  showText: false,
                  iconSize: 20.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletPortraitLayout() {
    return Container(
      decoration: BoxDecoration(
        color: lightMode ? Colors.white : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.sp),
        child: Row(
          children: [
            Row(
              children: [
                _buildAvatar(80.sp),
                SizedBox(width: 10.sp),
                // Info Data Name & Title & Department
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Name
                      _buildInfoLabel(
                        label: _capitalize(fullName),
                      ),


                      // Title
                      _buildInfoRow(
                        label: "Title: ",
                        value: title,
                      ),

                      // Department
                      _buildInfoRow(
                        label: "Department: ",
                        value: departmentName,
                      ),

                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            _buildCheckInButton(
              width: 135.sp,
              height: 38.sp,
              showText: true,
              iconSize: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Container(
      decoration: BoxDecoration(
        color: lightMode ? Colors.white : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.sp),
        child: Row(
          children: [
            Row(
              children: [
                _buildAvatar(80.sp),
                SizedBox(width: 10.sp),
                // Info Data Name & Title & Department
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Name
                      _buildInfoLabel(
                        label: _capitalize(fullName),
                      ),


                      // Title
                      _buildInfoRow(
                        label: "Title: ",
                        value: title,
                      ),

                      // Department
                      _buildInfoRow(
                        label: "Department: ",
                        value: departmentName,
                      ),

                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            _buildCheckInButton(
              width: 135.sp,
              height: 38.sp,
              showText: true,
              iconSize: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(double size) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: SvgPicture.asset(
          "assets/images/male.svg",
          fit: BoxFit.cover,
          width: size,
          height: size,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
  })
  {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: lightMode ? Color(0xff797979) : Colors.grey[400],
          ),
        ),
        Text(
          _capitalize(value),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: lightMode ? Color(0xff797979) : Colors.white,
          ),
        ),
      ],
    );
  }
  Widget _buildInfoLabel({
    required String label,
  })
  {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: lightMode ? Color(0xff2D2D2D) : Colors.grey[400],
          ),
        ),
      ],
    );
  }


  Widget _buildCheckInButton({
    required double width,
    required double height,
    required bool showText,
    required double iconSize,
  }) {
    return Material(
      color: const Color(0xFF6366F1), // Primary color
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: (){},
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Color(0xffB5B4B4),
            borderRadius: BorderRadius.circular(8.r)
          ),
       
          padding: EdgeInsets.symmetric(horizontal: showText ? 16.sp : 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/check_in.svg",
                width: iconSize,
                height: iconSize,
                color: Colors.black,
              ),
              if (showText) ...[
                SizedBox(width: 8.sp),
                Text(
                  "Check In",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}