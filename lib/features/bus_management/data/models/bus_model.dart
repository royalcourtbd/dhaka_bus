import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/bus_entity.dart';

class BusModel extends BusEntity {
  const BusModel({
    required super.busId,
    required super.busNameEn,
    required super.busNameBn,
    super.serviceType,
    required super.isActive,
    required super.createdAt,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      busId: json['bus_id'] ?? '',
      busNameEn: json['bus_name_en'] ?? '',
      busNameBn: json['bus_name_bn'] ?? '',
      serviceType: json['service_type'],
      isActive: json['is_active'] ?? true,
      createdAt: (json['created_at'] as Timestamp)
          .toDate(), // Firebase Timestamp to DateTime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bus_id': busId,
      'bus_name_en': busNameEn,
      'bus_name_bn': busNameBn,
      'service_type': serviceType,
      'is_active': isActive,
      'created_at': createdAt,
    };
  }
}
