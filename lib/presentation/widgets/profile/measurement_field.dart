import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MeasurementField extends StatefulWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final String unit;
  final Function(String)? onChanged;
  final bool readOnly;

  const MeasurementField({
    super.key,
    required this.title,
    required this.hint,
    required this.controller,
    required this.unit,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  State<MeasurementField> createState() => _MeasurementFieldState();
}

class _MeasurementFieldState extends State<MeasurementField> {
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
        Container(
          height: 48, // Standard height
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neutral80),
            borderRadius: BorderRadius.circular(32),
            color: Colors.white,
          ),
          child: Row(
            children: [
              // Left icon
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                child: Icon(
                  widget.unit == 'cm' ? Icons.straighten : Icons.monitor_weight,
                  size: 20,
                  color: AppColors.neutral80,
                ),
              ),
              widget.readOnly
                  ? Expanded(
                      child: Text(
                        widget.controller.text.isNotEmpty
                            ? widget.controller.text
                            : widget.hint,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          color: widget.controller.text.isNotEmpty
                              ? AppColors.neutral90
                              : AppColors.neutral80,
                        ),
                      ),
                    )
                  : Expanded(
                      child: TextFormField(
                        controller: widget.controller,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          color: AppColors.neutral90,
                        ),
                        onTap: () {
                          if (!_touched) {
                            setState(() {
                              _touched = true;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: widget.hint,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            color: AppColors.neutral80,
                          ),
                        ),
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
                      ),
                    ),

              // Unit display
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.unit,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    color: AppColors.neutral80,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_touched && widget.controller.text.isEmpty && !widget.readOnly)
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
        const SizedBox(height: 16),
      ],
    );
  }
}
