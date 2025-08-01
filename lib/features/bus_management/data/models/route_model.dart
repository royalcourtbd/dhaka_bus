import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhaka_bus/features/bus_management/domain/entities/route_entity.dart';

class RouteModel extends RouteEntity {
  const RouteModel({
    required super.routeId,
    required super.busId,
    required super.stops,
    required super.routeDistance,
    required super.totalStops,
    required super.createdAt,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      routeId: json['route_id'] ?? '',
      busId: json['bus_id'] ?? '',
      stops: List<String>.from(json['stops'] ?? []),
      routeDistance: json['route_distance'] ?? '',
      totalStops: json['total_stops'] ?? 0,
      createdAt: json['created_at'] is String
          ? DateTime.parse(json['created_at'])
          : (json['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'route_id': routeId,
      'bus_id': busId,
      'stops': stops,
      'route_distance': routeDistance,
      'total_stops': totalStops,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

extension RouteModelExtension on RouteModel {
  static RouteModel fromEntity(RouteEntity entity) {
    return RouteModel(
      routeId: entity.routeId,
      busId: entity.busId,
      stops: entity.stops,
      routeDistance: entity.routeDistance,
      totalStops: entity.totalStops,
      createdAt: entity.createdAt,
    );
  }
}
