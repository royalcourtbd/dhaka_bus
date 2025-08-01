import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';

class BusModel extends BusEntity {
  const BusModel({
    required super.busId,
    required super.busNameEn,
    required super.busNameBn,
    super.busImageUrl,
    super.serviceType,
    required super.isActive,
    required super.createdAt,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      busId: json['bus_id'] ?? '',
      busNameEn: json['bus_name_en'] ?? '',
      busNameBn: json['bus_name_bn'] ?? '',
      busImageUrl: json['bus_image_url'],
      serviceType: json['service_type'],
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] is String
          ? DateTime.parse(json['created_at'])
          : (json['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bus_id': busId,
      'bus_name_en': busNameEn,
      'bus_name_bn': busNameBn,
      'service_type': serviceType,
      'bus_image_url': busImageUrl,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

extension BusModelExtension on BusModel {
  static BusModel fromEntity(BusEntity entity) {
    return BusModel(
      busId: entity.busId,
      busNameEn: entity.busNameEn,
      busNameBn: entity.busNameBn,
      busImageUrl: entity.busImageUrl,
      serviceType: entity.serviceType,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
    );
  }
}
