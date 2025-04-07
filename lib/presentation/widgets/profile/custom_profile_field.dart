import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomProfileField extends StatefulWidget {
  final String title;
  final String hintText;
  final TextEditingController? controller;
  final String? assetImage;
  final bool isDate;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool obscureText;
  final IconData? icon;

  const CustomProfileField({
    super.key,
    required this.title,
    this.controller,
    required this.hintText,
    this.assetImage,
    this.isDate = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.icon,
  });

  @override
  State<CustomProfileField> createState() => _CustomProfileFieldState();
}

class _CustomProfileFieldState extends State<CustomProfileField> {
  bool _touched = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && !_touched) {
      setState(() {
        _touched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: AppColors.neutral90,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          focusNode: _focusNode,
          onTap: () {
            if (!_touched) {
              setState(() {
                _touched = true;
              });
            }
          },
          inputFormatters: widget.keyboardType == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
            color: AppColors.neutral90,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              color: AppColors.neutral80,
            ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8.0),
              child: widget.icon != null
                  ? Icon(widget.icon, size: 20, color: AppColors.neutral80)
                  : widget.assetImage != null
                      ? ImageIcon(
                          AssetImage('assets/icons/${widget.assetImage}'),
                          color: AppColors.neutral80)
                      : Icon(Icons.person,
                          size: 20, color: AppColors.neutral80),
            ),
            contentPadding: const EdgeInsets.only(right: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide:
                  const BorderSide(color: AppColors.neutral80, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide:
                  const BorderSide(color: AppColors.neutral80, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide:
                  const BorderSide(color: AppColors.neutral80, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide:
                  const BorderSide(color: AppColors.neutral80, width: 1),
            ),
          ),
          keyboardType: widget.keyboardType,
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
            if (!_touched) {
              setState(() {
                _touched = true;
              });
            }
          },
          validator: widget.validator,
        ),
        if (_touched && (widget.controller?.text.isEmpty ?? true))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${widget.title} tidak boleh kosong',
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 12,
              ),
            ),
          ),
        const SizedBox(height: 16)
      ],
    );
  }
}
