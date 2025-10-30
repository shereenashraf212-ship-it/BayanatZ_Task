import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomValidatedTextFieldMaster extends StatefulWidget {
  final String? label;
  final String hint;
  final TextEditingController controller;
  final double height;
  final double? width;
  final int maxLines;
  final bool enabled;
  final bool showCharCount;
  final ValueChanged<String>? onChanged;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final bool onlyDigits;
  final bool submitted;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final int maxLength;

  const CustomValidatedTextFieldMaster({
    super.key,
    this.label,
    required this.hint,
    required this.controller,
    this.height = 36,
    this.width,
    this.maxLines = 1,
    this.enabled = true,
    this.showCharCount = false,
    this.onChanged,
    this.textDirection = TextDirection.ltr,
    this.textAlign = TextAlign.start,
    this.onlyDigits = false,
    this.submitted = false,
    this.textStyle,
    this.hintStyle,
    this.fillColor,
    this.maxLength = 500,
  });

  @override
  State<CustomValidatedTextFieldMaster> createState() =>
      _CustomValidatedTextFieldMasterState();
}

class _CustomValidatedTextFieldMasterState
    extends State<CustomValidatedTextFieldMaster> {

  @override
  void initState() {
    super.initState();
    // Listen to text changes to rebuild the widget
    widget.controller.addListener(_updateState);
  }

  @override
  void dispose() {
    // Remove listener when disposing
    widget.controller.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    setState(() {}); // Rebuild to update character count
  }

  String _toArabicNum(int number) {
    const arabicNums = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((e) => arabicNums[int.parse(e)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabicField = widget.textDirection == TextDirection.rtl;
    final bool isEnglishField = widget.textDirection == TextDirection.ltr;
    final String text = widget.controller.text;

    final bool hasArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
    final bool hasEnglish = RegExp(r'[a-zA-Z]').hasMatch(text);
    final bool isNotDigits =
        widget.onlyDigits && text.isNotEmpty && !RegExp(r'^\d+$').hasMatch(text);
    final bool isEmpty = text.trim().isEmpty;

    final bool showError = (widget.submitted && isEmpty) ||
        (!isEmpty &&
            ((isEnglishField && hasArabic) ||
                (isArabicField && hasEnglish) ||
                isNotDigits));

    String errorText = '';
    if (isEmpty) {
      errorText = widget.textDirection == TextDirection.rtl
          ? "هذا الحقل مطلوب"
          : "This field is required.";
    } else if (isEnglishField && hasArabic) {
      errorText = "Please use English characters only.";
    } else if (isArabicField && hasEnglish) {
      errorText = "الرجاء استخدام الأحرف العربية فقط.";
    } else if (isNotDigits) {
      errorText = "Only numbers are allowed.";
    }

    final bool lightMode = Theme.of(context).brightness == Brightness.light;
    final bool showCounter = widget.showCharCount && !showError;

    final List<TextInputFormatter> formatters = [
      if (widget.onlyDigits) FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(widget.maxLength),
    ];

    int currentLen = widget.controller.text.characters.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            textDirection: widget.textDirection,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: lightMode ? Colors.black87 : Colors.white,
            ),
          ),
        if (widget.label != null) const SizedBox(height: 6),

        SizedBox(
          width: widget.width,
          child: TextFormField(
            controller: widget.controller,
            maxLines: widget.maxLines,
            enabled: widget.enabled,
            textDirection: widget.textDirection,
            textAlign: widget.textAlign,
            keyboardType:
            widget.onlyDigits ? TextInputType.number : TextInputType.text,
            style: widget.textStyle ??
                TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: lightMode ? Colors.black87 : Colors.white,
                ),
            onChanged: widget.onChanged,
            inputFormatters: formatters,
            maxLength: widget.maxLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: InputDecoration(
              hoverColor: Colors.transparent,
              hintText: widget.hint,
              hintStyle: widget.hintStyle ??
                  TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: lightMode ? Colors.grey[600] : Colors.grey[400],
                  ),
              filled: true,
              fillColor: widget.fillColor ??
                  (lightMode ? Colors.grey[50] : Colors.grey[900]),
              isDense: true,
              counterText: '',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide:
                const BorderSide(color: Colors.transparent, width: 1),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide:
                const BorderSide(color: Colors.transparent, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1,
                ),
              ),
            ),
          ),
        ),

        SizedBox(
          height: 18,
          child: showError
              ? Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                height: 1.1,
                color: Colors.red,
              ),
            ),
          )
              : (showCounter
              ? Align(
            alignment: widget.textDirection == TextDirection.rtl
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Text(
              widget.textDirection == TextDirection.rtl
                  ? "${_toArabicNum(currentLen)}/${_toArabicNum(widget.maxLength)}"
                  : "$currentLen/${widget.maxLength}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          )
              : const SizedBox.shrink()),
        ),
      ],
    );
  }
}