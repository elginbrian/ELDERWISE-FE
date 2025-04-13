import 'package:flutter/foundation.dart';

enum EntityType {
  elder,
  caregiver,
  user,
  agenda,
  area,
  general;

  String toStringValue() {
    return toString().split('.').last.toLowerCase();
  }

  String toJson() {
    return toStringValue();
  }

  static EntityType? fromString(String? value) {
    if (value == null || value.isEmpty) return EntityType.general;

    String cleanValue = value.trim().toLowerCase();
    if (cleanValue.contains('.')) {
      cleanValue = cleanValue.split('.').last.trim();
    }
    if (cleanValue.contains('entitytype.')) {
      cleanValue = cleanValue.replaceAll('entitytype.', '');
    }

    debugPrint(
        "Trying to parse EntityType from: $value -> cleaned to: $cleanValue");

    try {
      return EntityType.values.firstWhere(
        (type) => type.toStringValue() == cleanValue,
        orElse: () => EntityType.general,
      );
    } catch (_) {
      debugPrint("EntityType parsing failed, defaulting to general");
      return EntityType.general;
    }
  }
}
