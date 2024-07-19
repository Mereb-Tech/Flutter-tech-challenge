import 'package:flutter/material.dart';

class CustomSendMessageTextFormFieldWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool autoFocus;
  final int? maxText;
  final VoidCallback onSend;

  const CustomSendMessageTextFormFieldWidget(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.onSend,
      this.maxText,
      this.autoFocus = false});
  @override
  State<CustomSendMessageTextFormFieldWidget> createState() =>
      _CustomSendMessageTextFormFieldWidgetState();
}

class _CustomSendMessageTextFormFieldWidgetState
    extends State<CustomSendMessageTextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          controller: widget.controller,
          autofocus: widget.autoFocus,
          textAlignVertical: TextAlignVertical.center,
          maxLength: widget.maxText,
          decoration: InputDecoration(
            isDense: true,
            isCollapsed: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            counterStyle: const TextStyle(fontSize: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: Colors.indigo.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: Colors.indigo.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(color: Colors.grey.shade400)),
            hintText: widget.hintText,
            hintStyle: const TextStyle(fontSize: 14),
            suffixIcon: GestureDetector(
              onTap: widget.onSend,
              child: const Icon(Icons.send, color: Colors.indigo, size: 16),
            ),
          ),
        ));
  }
}
