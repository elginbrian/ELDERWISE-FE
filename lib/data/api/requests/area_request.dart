class AreaRequestDTO {
  final String elderId;
  final String caregiverId;
  final double centerLat;
  final double centerLong;
  final int freeAreaRadius;
  final int watchAreaRadius;
  final bool isActive;

  AreaRequestDTO({
    required this.elderId,
    required this.caregiverId,
    required this.centerLat,
    required this.centerLong,
    required this.freeAreaRadius,
    required this.watchAreaRadius,
    required this.isActive,
  });

  factory AreaRequestDTO.fromJson(Map<String, dynamic> json) {
    return AreaRequestDTO(
      elderId: json['elder_id'] as String,
      caregiverId: json['caregiver_id'] as String,
      centerLat: (json['center_lat'] as num).toDouble(),
      centerLong: (json['center_long'] as num).toDouble(),
      freeAreaRadius: json['free_area_radius'] as int,
      watchAreaRadius: json['watch_area_radius'] as int,
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'elder_id': elderId,
      'caregiver_id': caregiverId,
      'center_lat': centerLat,
      'center_long': centerLong,
      'free_area_radius': freeAreaRadius,
      'watch_area_radius': watchAreaRadius,
      'is_active': isActive,
    };
  }
}
