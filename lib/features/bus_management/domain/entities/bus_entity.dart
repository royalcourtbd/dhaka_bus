import 'package:dhaka_bus/core/base/base_entity.dart';

class BusEntity extends BaseEntity {
  final String busId;
  final String busNameEn;
  final String busNameBn;
  final String? serviceType;
  final bool isActive;
  final DateTime createdAt;

  const BusEntity({
    required this.busId,
    required this.busNameEn,
    required this.busNameBn,
    this.serviceType,
    required this.isActive,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    busId,
    busNameEn,
    busNameBn,
    serviceType,
    isActive,
    createdAt,
  ];
}
