import 'package:flutter/material.dart';

class CustomTextFormFieldWidget extends StatefulWidget {
  final bool isNum;
  final bool isPhone;
  final bool isObscureText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int maxLine;
  final int? maxLength;
  final bool autoFocus;
  const CustomTextFormFieldWidget(
      {super.key,
      this.isNum = false,
      this.isPhone = false,
      this.isObscureText = false,
      this.maxLine = 1,
      this.maxLength,
      this.autoFocus = false,
      required this.hintText,
      required this.controller,
      this.validator});
  @override
  State<CustomTextFormFieldWidget> createState() =>
      _CustomTextFormFieldWidgetState();
}

class _CustomTextFormFieldWidgetState extends State<CustomTextFormFieldWidget> {
  bool obscureText = false;
  @override
  void initState() {
    obscureText = widget.isObscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        keyboardType:
            widget.isNum ? TextInputType.phone : TextInputType.emailAddress,
        obscureText: obscureText,
        validator: widget.validator,
        controller: widget.controller,
        maxLines: widget.maxLine,
        autofocus: widget.autoFocus,
        maxLength: widget.maxLength,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          isCollapsed: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(10),
          //   borderSide: BorderSide(
          //       color: const Color(0xff020418).withOpacity(0.1), width: 1),
          // ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.indigo.withOpacity(0.25)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.indigo.withOpacity(0.25)),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400)),
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontSize: 14),

          prefixIcon: widget.isPhone
              ? const Padding(
                  padding: EdgeInsets.only(left: 10, top: 15),
                  child: Text("+251"),
                )
              : null,
          suffixIcon: widget.isObscureText
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.indigo,
                      size: 15),
                )
              : null,
        ));
  }
}
