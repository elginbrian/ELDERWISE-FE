class Area {
  final String areaId;
  final String elderId;
  final String caregiverId;
  final double centerLat;
  final double centerLong;
  final int freeAreaRadius;
  final int watchAreaRadius;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Area({
    required this.areaId,
    required this.elderId,
    required this.caregiverId,
    required this.centerLat,
    required this.centerLong,
    required this.freeAreaRadius,
    required this.watchAreaRadius,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      areaId: json['area_id'] as String,
      elderId: json['elder_id'] as String,
      caregiverId: json['caregiver_id'] as String,
      centerLat: (json['center_lat'] as num).toDouble(),
      centerLong: (json['center_long'] as num).toDouble(),
      freeAreaRadius: json['free_area_radius'] as int,
      watchAreaRadius: json['watch_area_radius'] as int,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'area_id': areaId,
      'elder_id': elderId,
      'caregiver_id': caregiverId,
      'center_lat': centerLat,
      'center_long': centerLong,
      'free_area_radius': freeAreaRadius,
      'watch_area_radius': watchAreaRadius,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
