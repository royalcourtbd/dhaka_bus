import 'package:dhaka_bus/core/base/base_entity.dart';

class RouteEntity extends BaseEntity {
  final String routeId;
  final String busId;
  final List<String> stops;
  final String routeDistance;
  final int totalStops;
  final DateTime createdAt;

  const RouteEntity({
    required this.routeId,
    required this.busId,
    required this.stops,
    required this.routeDistance,
    required this.totalStops,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    routeId,
    busId,
    stops,
    routeDistance,
    totalStops,
    createdAt,
  ];
}
