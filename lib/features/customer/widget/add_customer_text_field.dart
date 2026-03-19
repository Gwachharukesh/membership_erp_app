import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  // Added initialValue parameter

  const CustomTextFormField({
    required this.title,
    required this.hintText,
    super.key,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.obscureText = false,
    this.toggleObscure,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
    this.onChanged,
    this.initialValue,
    this.inputFormatter,
  });
  final String title;
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final bool obscureText;
  final VoidCallback? toggleObscure;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool enabled;
  final void Function(String)? onChanged;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatter;
  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title != ''
            ? Text(
                widget.title,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey.shade800,
                    ),
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 8),
        TextFormField(
          inputFormatters: widget.inputFormatter,
          controller: widget.controller,
          initialValue:
              widget.initialValue, // Pass initialValue to TextFormField
          obscureText: _obscureText,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          enabled: widget.enabled,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: Colors.blueAccent)
                : null,
            suffixIcon: widget.toggleObscure != null
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      setState(() => _obscureText = !_obscureText);
                      widget.toggleObscure?.call();
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
