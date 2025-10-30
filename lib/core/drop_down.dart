import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatefulWidget {
  final String? selectedValue;
  final double? widthIcon;
  final Color? dropdownColor;
  final double? heightIcon;
  final List<Map<String, String>> items;
  final Function(String?) onChanged;
  final String Function(String?)? validator;
  final double? width;
  final double? height;
  final double? spaceHeight;
  final double? dropdownWidth;
  final Widget? hint;
  final String? label;
  final String? iconPath;

  const CustomDropdownFormField({
    Key? key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.widthIcon,
    required this.heightIcon,
    this.validator,
    this.width,
    this.height,
    this.spaceHeight,
    this.dropdownWidth,
    this.hint,
    this.dropdownColor,
    this.label,
    this.iconPath,
  }) : super(key: key);

  @override
  State<CustomDropdownFormField> createState() => _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  String? internalSelectedValue;
  final GlobalKey _dropdownKey = GlobalKey();
  double? _popupWidth;

  @override
  void initState() {
    super.initState();
    internalSelectedValue = widget.selectedValue;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _dropdownKey.currentContext;
      if (context != null && mounted) {
        final box = context.findRenderObject() as RenderBox;
        setState(() {
          _popupWidth = box.size.width;
        });
      }
    });
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final bool lightMode = Theme.of(context).brightness == Brightness.light;
    final double fieldHeight = widget.height ?? 36;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // Define colors inline
    final backgroundColor = lightMode ? Colors.white : const Color(0xFF1E1E1E);
    final textColor = lightMode ? Colors.black87 : Colors.white;
    final borderColor = lightMode ? Colors.grey.shade300 : Colors.grey.shade700;
    final iconColor = lightMode ? Colors.grey.shade600 : Colors.grey.shade400;
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
          SizedBox(height: widget.spaceHeight ?? 8),
        ],
        Container(
          key: _dropdownKey,
          width: widget.width,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
           // border: Border.all(color: borderColor),
          ),
          child: FormField<String>(
            initialValue: internalSelectedValue,
            validator: widget.validator,
            builder: (FormFieldState<String> field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: widget.hint,
                      value: internalSelectedValue,
                      onChanged: (value) {
                        setState(() {
                          internalSelectedValue = value;
                          field.didChange(value);
                        });
                        widget.onChanged(value);
                      },
                      buttonStyleData: ButtonStyleData(
                        height: fieldHeight,
                        width: widget.width,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: widget.dropdownColor ?? backgroundColor,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.transparent),
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        width: widget.dropdownWidth ?? _popupWidth ?? 100,
                        maxHeight: 230,
                        offset: const Offset(0, 0),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                         // border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        scrollbarTheme: ScrollbarThemeData(
                          thumbVisibility: MaterialStateProperty.all(false),
                          trackVisibility: MaterialStateProperty.all(false),
                          thickness: MaterialStateProperty.all(0),
                          radius: Radius.zero,
                        ),
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        height: fieldHeight,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return primaryColor.withOpacity(0.1);
                            }
                            return null;
                          },
                        ),
                      ),
                      iconStyleData: IconStyleData(
                        icon: Padding(
                          padding: EdgeInsets.only(
                            right: isArabic ? 0 : 4,
                            left: isArabic ? 4 : 0,
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                            color: iconColor,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: textColor,
                      ),
                      items: widget.items.map((unit) {
                        return DropdownMenuItem<String>(
                          value: unit["key"],
                          child: Text(
                            _capitalize(unit["value"] ?? ''),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: textColor,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 8),
                      child: Text(
                        field.errorText ?? '',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}