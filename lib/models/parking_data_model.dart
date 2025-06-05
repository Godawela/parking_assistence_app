import 'package:latlong2/latlong.dart';

enum ParkingCondition {
  shaded,
  sunny,
  covered,
  underground;

  String get displayName {
    switch (this) {
      case ParkingCondition.shaded:
        return 'Shaded';
      case ParkingCondition.sunny:
        return 'Sunny';
      case ParkingCondition.covered:
        return 'Covered';
      case ParkingCondition.underground:
        return 'Underground';
    }
  }
}

enum ParkingSlotStatus {
  available,
  occupied,
  reserved,
  outOfOrder
}

enum ParkingLotType {
  public,
  private,
  commercial,
  residential;

  String get displayName {
    switch (this) {
      case ParkingLotType.public:
        return 'Public';
      case ParkingLotType.private:
        return 'Private';
      case ParkingLotType.commercial:
        return 'Commercial';
      case ParkingLotType.residential:
        return 'Residential';
    }
  }
}

class ParkingSlot {
  final String id;
  final String slotNumber;
  final ParkingSlotStatus status;
  final ParkingCondition condition;
  final double pricePerHour;
  final bool isAccessible; // For disabled parking
  final bool isEVCharging; // Electric vehicle charging
  final DateTime? reservedUntil;
  final String? vehicleType; // car, motorcycle, truck

  const ParkingSlot({
    required this.id,
    required this.slotNumber,
    required this.status,
    required this.condition,
    required this.pricePerHour,
    this.isAccessible = false,
    this.isEVCharging = false,
    this.reservedUntil,
    this.vehicleType = 'car',
  });

  bool get isAvailable => status == ParkingSlotStatus.available;
  
  String get conditionText {
    switch (condition) {
      case ParkingCondition.shaded:
        return 'Shaded';
      case ParkingCondition.sunny:
        return 'Sunny';
      case ParkingCondition.covered:
        return 'Covered';
      case ParkingCondition.underground:
        return 'Underground';
    }
  }

  String get statusText {
    switch (status) {
      case ParkingSlotStatus.available:
        return 'Available';
      case ParkingSlotStatus.occupied:
        return 'Occupied';
      case ParkingSlotStatus.reserved:
        return 'Reserved';
      case ParkingSlotStatus.outOfOrder:
        return 'Out of Order';
    }
  }
}

class ParkingLot {
  final String id;
  final String name;
  final String address;
  final LatLng position;
  final List<ParkingSlot> slots;
  final ParkingLotType type;
  final double rating;
  final String operatingHours;
  final bool hasToilet;
  final bool hasSecurity;
  final bool hasEVCharging;
  final String phoneNumber;
  final String description;
  final double distanceFromUser; // in kilometers

  const ParkingLot({
    required this.id,
    required this.name,
    required this.address,
    required this.position,
    required this.slots,
    required this.type,
    required this.rating,
    required this.operatingHours,
    this.hasToilet = false,
    this.hasSecurity = false,
    this.hasEVCharging = false,
    this.phoneNumber = '',
    this.description = '',
    this.distanceFromUser = 0.0,
  });

  int get totalSlots => slots.length;
  int get availableSlots => slots.where((slot) => slot.isAvailable).length;
  int get occupiedSlots => slots.where((slot) => slot.status == ParkingSlotStatus.occupied).length;
  int get reservedSlots => slots.where((slot) => slot.status == ParkingSlotStatus.reserved).length;
  
  double get averagePrice {
    if (slots.isEmpty) return 0.0;
    return slots.map((slot) => slot.pricePerHour).reduce((a, b) => a + b) / slots.length;
  }

  int get shadedSlots => slots.where((slot) => 
    slot.condition == ParkingCondition.shaded || 
    slot.condition == ParkingCondition.covered ||
    slot.condition == ParkingCondition.underground
  ).length;

  int get sunnySlots => slots.where((slot) => slot.condition == ParkingCondition.sunny).length;

  String get typeText {
    switch (type) {
      case ParkingLotType.public:
        return 'Public';
      case ParkingLotType.private:
        return 'Private';
      case ParkingLotType.commercial:
        return 'Commercial';
      case ParkingLotType.residential:
        return 'Residential';
    }
  }

  bool get hasAvailableSlots => availableSlots > 0;
}

class ParkingReservation {
  final String id;
  final String userId;
  final String parkingLotId;
  final String slotId;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final bool isPaid;
  final DateTime createdAt;

  const ParkingReservation({
    required this.id,
    required this.userId,
    required this.parkingLotId,
    required this.slotId,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    this.isPaid = false,
    required this.createdAt,
  });

  Duration get duration => endTime.difference(startTime);
  bool get isActive => DateTime.now().isBefore(endTime) && DateTime.now().isAfter(startTime);
  bool get isExpired => DateTime.now().isAfter(endTime);
}