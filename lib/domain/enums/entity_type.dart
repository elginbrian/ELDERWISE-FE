enum EntityType {
  elder,
  caregiver,
  user,
  agenda,
  area,
  general;

  String toStringValue() {
    return toString().split('.').last;
  }

  static EntityType? fromString(String? value) {
    if (value == null) return null;

    try {
      return EntityType.values.firstWhere(
        (type) => type.toStringValue() == value,
      );
    } catch (_) {
      return EntityType.general;
    }
  }
}
