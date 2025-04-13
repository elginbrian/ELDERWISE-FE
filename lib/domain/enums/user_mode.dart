enum UserMode {
  caregiver,
  elder;

  static UserMode fromString(String value) {
    return UserMode.values.firstWhere(
      (mode) => mode.toString().split('.').last == value,
      orElse: () => UserMode.caregiver,
    );
  }
}
