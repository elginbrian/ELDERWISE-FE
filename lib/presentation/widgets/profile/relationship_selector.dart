import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class RelationshipSelector extends StatefulWidget {
  final TextEditingController controller;
  final String? selectedRelationship;
  final Function(String) onRelationshipSelected;
  final List<String> relationshipOptions;
  final bool readOnly;

  const RelationshipSelector({
    super.key,
    required this.controller,
    required this.selectedRelationship,
    required this.onRelationshipSelected,
    required this.relationshipOptions,
    this.readOnly = false,
  });

  @override
  State<RelationshipSelector> createState() => _RelationshipSelectorState();
}

class _RelationshipSelectorState extends State<RelationshipSelector> {
  bool _touched = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hubungan dengan Elder',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: AppColors.neutral90,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neutral80),
            borderRadius: BorderRadius.circular(32),
            color: Colors.white,
          ),
          child: Row(
            children: [
              // Left icon
              const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 8.0),
                child: Icon(Icons.people, size: 20, color: AppColors.neutral80),
              ),
              // Display text or dropdown based on readOnly value
              widget.readOnly
                  ? Expanded(
                      child: Text(
                        widget.controller.text.isNotEmpty
                            ? widget.controller.text
                            : 'Pilih hubungan anda',
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
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            value: widget.selectedRelationship,
                            isDense: false,
                            isExpanded: true,
                            icon: const Padding(
                              padding: EdgeInsets.only(right: 12.0),
                              child: Icon(Icons.arrow_drop_down,
                                  color: AppColors.neutral80),
                            ),
                            elevation: 2,
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              color: AppColors.neutral90,
                            ),
                            hint: const Text(
                              'Pilih hubungan anda',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                                color: AppColors.neutral80,
                              ),
                            ),
                            itemHeight: 48,
                            underline: const SizedBox(),
                            onTap: () {
                              setState(() {
                                _touched = true;
                              });
                            },
                            onChanged: (String? value) {
                              if (value != null) {
                                widget.onRelationshipSelected(value);
                                setState(() {
                                  _touched = true;
                                });
                              }
                            },
                            selectedItemBuilder: (BuildContext context) {
                              return widget.relationshipOptions
                                  .map<Widget>((String item) {
                                return Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                      color: AppColors.neutral90,
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            items: widget.relationshipOptions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                      color: AppColors.neutral90,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
              // Display dropdown icon in readOnly mode for consistent appearance
              if (widget.readOnly)
                const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child:
                      Icon(Icons.arrow_drop_down, color: AppColors.neutral80),
                ),
            ],
          ),
        ),
        if (_touched && widget.controller.text.isEmpty && !widget.readOnly)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Hubungan tidak boleh kosong',
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
