import 'dart:async';
import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'package:parking_assistence_app/models/parking_data_model.dart';

class ParkingService {
  static final ParkingService _instance = ParkingService._internal();
  factory ParkingService() => _instance;
  ParkingService._internal();

  // Hardcoded parking lots data around Colombo
  static final List<ParkingLot> _parkingLots = [
    const ParkingLot(
      id: 'pl_001',
      name: 'Colombo City Centre Parking',
      address: 'R.A. De Mel Mawatha, Colombo 3',
      position: const LatLng(6.9147, 79.8572),
      type: ParkingLotType.commercial,
      rating: 4.5,
      operatingHours: '24/7',
      hasToilet: true,
      hasSecurity: true,
      hasEVCharging: true,
      phoneNumber: '+94112345678',
      description: 'Multi-level parking with covered spaces',
      slots: [
        ParkingSlot(id: 'slot_001', slotNumber: 'A1', status: ParkingSlotStatus.available, condition: ParkingCondition.covered, pricePerHour: 150.0),
        ParkingSlot(id: 'slot_002', slotNumber: 'A2', status: ParkingSlotStatus.occupied, condition: ParkingCondition.covered, pricePerHour: 150.0),
        ParkingSlot(id: 'slot_003', slotNumber: 'A3', status: ParkingSlotStatus.available, condition: ParkingCondition.covered, pricePerHour: 150.0, isEVCharging: true),
        ParkingSlot(id: 'slot_004', slotNumber: 'B1', status: ParkingSlotStatus.available, condition: ParkingCondition.underground, pricePerHour: 200.0),
        ParkingSlot(id: 'slot_005', slotNumber: 'B2', status: ParkingSlotStatus.reserved, condition: ParkingCondition.underground, pricePerHour: 200.0),
      ],
    ),
   const ParkingLot(
      id: 'pl_002',
      name: 'Independence Square Parking',
      address: 'Independence Avenue, Colombo 7',
      position: const LatLng(6.9034, 79.8618),
      type: ParkingLotType.public,
      rating: 4.2,
      operatingHours: '6:00 AM - 10:00 PM',
      hasToilet: true,
      hasSecurity: false,
      hasEVCharging: false,
      phoneNumber: '+94112345679',
      description: 'Open-air parking near Independence Square',
      slots: [
        ParkingSlot(id: 'slot_006', slotNumber: '1', status: ParkingSlotStatus.available, condition: ParkingCondition.shaded, pricePerHour: 100.0),
        ParkingSlot(id: 'slot_007', slotNumber: '2', status: ParkingSlotStatus.available, condition: ParkingCondition.sunny, pricePerHour: 80.0),
        ParkingSlot(id: 'slot_008', slotNumber: '3', status: ParkingSlotStatus.occupied, condition: ParkingCondition.shaded, pricePerHour: 100.0),
        ParkingSlot(id: 'slot_009', slotNumber: '4', status: ParkingSlotStatus.available, condition: ParkingCondition.sunny, pricePerHour: 80.0, isAccessible: true),
      ],
    ),
  const ParkingLot(
      id: 'pl_003',
      name: 'Galle Face Hotel Parking',
      address: '2 Kollupitiya Rd, Colombo 3',
      position:  LatLng(6.9125, 79.8466),
      type: ParkingLotType.private,
      rating: 4.8,
      operatingHours: '24/7',
      hasToilet: true,
      hasSecurity: true,
      hasEVCharging: true,
      phoneNumber: '+94112345680',
      description: 'Premium valet parking service',
      slots: [
        ParkingSlot(id: 'slot_010', slotNumber: 'V1', status: ParkingSlotStatus.available, condition: ParkingCondition.covered, pricePerHour: 300.0),
        ParkingSlot(id: 'slot_011', slotNumber: 'V2', status: ParkingSlotStatus.available, condition: ParkingCondition.covered, pricePerHour: 300.0),
        ParkingSlot(id: 'slot_012', slotNumber: 'V3', status: ParkingSlotStatus.occupied, condition: ParkingCondition.covered, pricePerHour: 300.0),
      ],
    ),
    const ParkingLot(
      id: 'pl_004',
      name: 'Majestic City Parking',
      address: 'Station Rd, Colombo 4',
      position:  LatLng(6.8956, 79.8563),
      type: ParkingLotType.commercial,
      rating: 3.8,
      operatingHours: '8:00 AM - 10:00 PM',
      hasToilet: true,
      hasSecurity: true,
      hasEVCharging: false,
      phoneNumber: '+94112345681',
      description: 'Shopping mall parking with multiple levels',
      slots: [
        ParkingSlot(id: 'slot_013', slotNumber: 'L1-01', status: ParkingSlotStatus.available, condition: ParkingCondition.covered, pricePerHour: 120.0),
        ParkingSlot(id: 'slot_014', slotNumber: 'L1-02', status: ParkingSlotStatus.available, condition: ParkingCondition.covered, pricePerHour: 120.0),
        ParkingSlot(id: 'slot_015', slotNumber: 'L1-03', status: ParkingSlotStatus.occupied, condition: ParkingCondition.covered, pricePerHour: 120.0),
        ParkingSlot(id: 'slot_016', slotNumber: 'L2-01', status: ParkingSlotStatus.available, condition: ParkingCondition.shaded, pricePerHour: 100.0),
        ParkingSlot(id: 'slot_017', slotNumber: 'L2-02', status: ParkingSlotStatus.reserved, condition: ParkingCondition.shaded, pricePerHour: 100.0),
        ParkingSlot(id: 'slot_018', slotNumber: 'L3-01', status: ParkingSlotStatus.available, condition: ParkingCondition.sunny, pricePerHour: 80.0),
      ],
    ),
   const ParkingLot(
      id: 'pl_005',
      name: 'Pettah Market Parking',
      address: 'Main St, Colombo 11',
      position:  LatLng(6.9356, 79.8531),
      type: ParkingLotType.public,
      rating: 3.2,
      operatingHours: '5:00 AM - 8:00 PM',
      hasToilet: false,
      hasSecurity: false,
      hasEVCharging: false,
      phoneNumber: '+94112345682',
      description: 'Basic parking near Pettah market',
      slots: [
        ParkingSlot(id: 'slot_019', slotNumber: '1A', status: ParkingSlotStatus.available, condition: ParkingCondition.sunny, pricePerHour: 50.0),
        ParkingSlot(id: 'slot_020', slotNumber: '1B', status: ParkingSlotStatus.occupied, condition: ParkingCondition.sunny, pricePerHour: 50.0),
        ParkingSlot(id: 'slot_021', slotNumber: '2A', status: ParkingSlotStatus.available, condition: ParkingCondition.shaded, pricePerHour: 60.0),
        ParkingSlot(id: 'slot_022', slotNumber: '2B', status: ParkingSlotStatus.available, condition: ParkingCondition.sunny, pricePerHour: 50.0),
        ParkingSlot(id: 'slot_023', slotNumber: '3A', status: ParkingSlotStatus.outOfOrder, condition: ParkingCondition.sunny, pricePerHour: 50.0),
      ],
    ),
  ];

  // Get nearby parking lots based on user location
  Future<List<ParkingLot>> getNearbyParkingLots(LatLng userLocation, {double radiusKm = 5.0}) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay

     final Distance distance =  Distance();

    List<ParkingLot> nearbyLots = _parkingLots.map((lot) {
      final distanceToLot = distance.as(LengthUnit.Kilometer, userLocation, lot.position);

      return ParkingLot(
        id: lot.id,
        name: lot.name,
        address: lot.address,
        position: lot.position,
        slots: lot.slots,
        type: lot.type,
        rating: lot.rating,
        operatingHours: lot.operatingHours,
        hasToilet: lot.hasToilet,
        hasSecurity: lot.hasSecurity,
        hasEVCharging: lot.hasEVCharging,
        phoneNumber: lot.phoneNumber,
        description: lot.description,
        distanceFromUser: distanceToLot,
      );
    }).where((lot) => lot.distanceFromUser <= radiusKm).toList();

    // Sort by distance
    nearbyLots.sort((a, b) => a.distanceFromUser.compareTo(b.distanceFromUser));

    return nearbyLots;
  }

  // Get parking lot by ID
  Future<ParkingLot?> getParkingLotById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      return _parkingLots.firstWhere((lot) => lot.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get available slots for a specific parking lot
  Future<List<ParkingSlot>> getAvailableSlots(String parkingLotId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final parkingLot = await getParkingLotById(parkingLotId);
    if (parkingLot == null) return [];

    return parkingLot.slots.where((slot) => slot.isAvailable).toList();
  }

  // Reserve a parking slot
  Future<ParkingReservation?> reserveSlot({
    required String userId,
    required String parkingLotId,
    required String slotId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    final parkingLot = await getParkingLotById(parkingLotId);
    if (parkingLot == null) return null;

    final slot = parkingLot.slots.where((s) => s.id == slotId).firstOrNull;
    if (slot == null || !slot.isAvailable) return null;

    // Calculate total price
    final hours = endTime.difference(startTime).inHours;
    final totalPrice = slot.pricePerHour * hours;

    // Create reservation
    final reservation = ParkingReservation(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      parkingLotId: parkingLotId,
      slotId: slotId,
      startTime: startTime,
      endTime: endTime,
      totalPrice: totalPrice.toDouble(),
      createdAt: DateTime.now(),
    );

    return reservation;
  }

  // Search parking lots by name or address
  Future<List<ParkingLot>> searchParkingLots(String query, LatLng userLocation) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final Distance distance = Distance();

    final filteredLots = _parkingLots.where((lot) {
      final nameMatch = lot.name.toLowerCase().contains(query.toLowerCase());
      final addressMatch = lot.address.toLowerCase().contains(query.toLowerCase());
      return nameMatch || addressMatch;
    }).map((lot) {
      final distanceToLot = distance.as(LengthUnit.Kilometer, userLocation, lot.position);

      return ParkingLot(
        id: lot.id,
        name: lot.name,
        address: lot.address,
        position: lot.position,
        slots: lot.slots,
        type: lot.type,
        rating: lot.rating,
        operatingHours: lot.operatingHours,
        hasToilet: lot.hasToilet,
        hasSecurity: lot.hasSecurity,
        hasEVCharging: lot.hasEVCharging,
        phoneNumber: lot.phoneNumber,
        description: lot.description,
        distanceFromUser: distanceToLot,
      );
    }).toList();

    // Sort by distance
    filteredLots.sort((a, b) => a.distanceFromUser.compareTo(b.distanceFromUser));

    return filteredLots;
  }

  // Get parking statistics
  Future<Map<String, dynamic>> getParkingStatistics() async {
    await Future.delayed(const Duration(milliseconds: 200));

    final totalLots = _parkingLots.length;
    final totalSlots = _parkingLots.fold(0, (sum, lot) => sum + lot.totalSlots);
    final availableSlots = _parkingLots.fold(0, (sum, lot) => sum + lot.availableSlots);
    final occupiedSlots = _parkingLots.fold(0, (sum, lot) => sum + lot.occupiedSlots);

    return {
      'totalLots': totalLots,
      'totalSlots': totalSlots,
      'availableSlots': availableSlots,
      'occupiedSlots': occupiedSlots,
      'occupancyRate': (occupiedSlots / totalSlots * 100).toStringAsFixed(1),
    };
  }

  // Simulate real-time updates
  Stream<List<ParkingLot>> getParkingLotsStream(LatLng userLocation) {
    return Stream.periodic(const Duration(seconds: 30), (count) {
      // Simulate random slot status changes
      final random = Random();
      for (var lot in _parkingLots) {
        for (var slot in lot.slots) {
          if (random.nextDouble() < 0.1) { // 10% chance of status change
            // Randomly change status (simplified simulation)
            if (slot.status == ParkingSlotStatus.available && random.nextBool()) {
            }
          }
        }
      }
      return _parkingLots;
    }).asyncMap((_) => getNearbyParkingLots(userLocation));
  }
}

// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';
// import 'package:parking_assistence_app/models/parking_data_model.dart';

// class ParkingService {
//   static final ParkingService _instance = ParkingService._internal();
//   factory ParkingService() => _instance;
//   ParkingService._internal();
//   int locationId = 4;

//   // API Configuration
//   static const String _baseUrl =
//       'http://development.nimbusventure.com:8033/parking-solution/v1';
//   static const Duration _requestTimeout = Duration(seconds: 30);

//   // HTTP Client
//   final http.Client _httpClient = http.Client();

//   // Cache for parking lots
//   List<ParkingLot> _cachedParkingLots = [];

//   // API Methods

//   /// Fetch parking lots from API for a specific location
//   Future<List<ParkingLot>> getParkingLotsFromAPI(int locationId) async {
//     try {
//       final headers = {
//         'Content-Type': 'application/json',
//         'accept': 'application/json',
//         'Authorization': 'Bearer token',
//       };

//       final response = await _httpClient
//           .get(
//             Uri.parse('$_baseUrl/location/1/parking-lot'),
//             headers: headers,
//           )
//           .timeout(_requestTimeout);

//       print("Response status: ${response.statusCode}");
//       print("Response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final dynamic jsonData = json.decode(response.body);

//         if (jsonData is List) {
//           return jsonData.map((data) => _mapApiToParkingLot(data)).toList();
//         } else if (jsonData is Map) {
//           return [_mapApiToParkingLot(jsonData as Map<String, dynamic>)];
//         } else {
//           throw Exception('Unexpected response format');
//         }
//       } else if (response.statusCode == 401) {
//         throw Exception('Authentication failed - please login again');
//       } else {
//         throw Exception('Failed to load parking lots: ${response.statusCode}');
//       }
//     } on TimeoutException {
//       throw Exception('Request timed out - please check your connection');
//     } on http.ClientException catch (e) {
//       throw Exception('Network error: ${e.message}');
//     } catch (e) {
//       throw Exception('Error fetching parking lots: $e');
//     }
//   }

//   /// Fetch parking slots from API for a specific parking lot
//   Future<List<ParkingSlot>> getParkingSlotsFromAPI(
//       int locationId, int parkingLotId) async {
//     try {
//       final headers = {
//         'Content-Type': 'application/json',
//         'accept': 'application/json',
//         'Authorization': 'Bearer token',
//       };

//       final response = await _httpClient
//           .get(
//             Uri.parse('$_baseUrl/location/1/parking-lot/1/slot'),
//             headers: headers,
//           )
//           .timeout(_requestTimeout);

//       print("Response status: ${response.statusCode}");
//       print("Response body: ${response.body}");

//     if (response.statusCode == 200) {
//         final dynamic jsonData = json.decode(response.body);

//         if (jsonData is List) {
//           return jsonData.map((data) => _mapApiToParkingSlot(data)).toList();
//         } else if (jsonData is Map) {
//           return [_mapApiToParkingSlot(jsonData as Map<String, dynamic>)];
//         } else {
//           throw Exception('Unexpected response format');
//         }
//       } else if (response.statusCode == 401) {
//         throw Exception('Authentication failed - please login again');
//       } else {
//         throw Exception('Failed to load parking lots: ${response.statusCode}');
//       }
//     } on TimeoutException {
//       throw Exception('Request timed out - please check your connection');
//     } on http.ClientException catch (e) {
//       throw Exception('Network error: ${e.message}');
//     } catch (e) {
//       throw Exception('Error fetching parking lots: $e');
//     }
//   }

//   /// Map API response to ParkingLot model
//   ParkingLot _mapApiToParkingLot(Map<String, dynamic> data) {
//     return ParkingLot(
//       id: data['id'].toString(),
//       name: data['name'] ?? '',
//       address: data['address'] ?? '',
//       position: LatLng(
//         (data['latitude'] ?? 0.0).toDouble(),
//         (data['longitude'] ?? 0.0).toDouble(),
//       ),
//       type: _mapStringToParkingLotType(data['type'] ?? ''),
//       rating: (data['rating'] ?? 0.0).toDouble(),
//       operatingHours: data['operatingHours'] ?? '24/7',
//       hasToilet: data['hasToilet'] ?? false,
//       hasSecurity: data['hasSecurity'] ?? false,
//       hasEVCharging: data['hasEvCharging'] ?? false,
//       phoneNumber: data['phoneNumber'] ?? '',
//       description: data['description'] ?? '',
//       slots: [], // Slots will be loaded separately
//     );
//   }

//   /// Map API response to ParkingSlot model
//   ParkingSlot _mapApiToParkingSlot(Map<String, dynamic> data) {
//     return ParkingSlot(
//       id: data['id'].toString(),
//       slotNumber: data['slotNumber'] ?? '',
//       status: _mapStringToParkingSlotStatus(data['status'] ?? ''),
//       condition: _mapStringToParkingCondition(data['condition'] ?? ''),
//       pricePerHour: (data['pricePerHour'] ?? 0.0).toDouble(),
//       isEVCharging: data['evcharging'] ?? false,
//       isAccessible: data['accessible'] ?? false,
//       reservedUntil: data['reservedUntil'] != null
//           ? DateTime.tryParse(data['reservedUntil'])
//           : null,
//       vehicleType: data['vehicleType'] ?? 'Car',
//     );
//   }

//   /// Helper method to map string to ParkingLotType enum
//   ParkingLotType _mapStringToParkingLotType(String type) {
//     switch (type.toLowerCase()) {
//       case 'public':
//         return ParkingLotType.public;
//       case 'private':
//         return ParkingLotType.private;
//       case 'commercial':
//       case 'multi-storey':
//         return ParkingLotType.commercial;
//       case 'residential':
//         return ParkingLotType.residential;
//       default:
//         return ParkingLotType.public;
//     }
//   }

//   /// Helper method to map string to ParkingSlotStatus enum
//   ParkingSlotStatus _mapStringToParkingSlotStatus(String status) {
//     switch (status.toLowerCase()) {
//       case 'available':
//         return ParkingSlotStatus.available;
//       case 'occupied':
//         return ParkingSlotStatus.occupied;
//       case 'reserved':
//         return ParkingSlotStatus.reserved;
//       case 'out of order':
//         return ParkingSlotStatus.outOfOrder;
//       default:
//         return ParkingSlotStatus.available;
//     }
//   }

//   /// Helper method to map string to ParkingCondition enum
//   ParkingCondition _mapStringToParkingCondition(String condition) {
//     switch (condition.toLowerCase()) {
//       case 'good':
//       case 'covered':
//         return ParkingCondition.covered;
//       case 'fair':
//       case 'shaded':
//         return ParkingCondition.shaded;
//       case 'sunny':
//         return ParkingCondition.sunny;
//       case 'underground':
//         return ParkingCondition.underground;
//       default:
//         return ParkingCondition.sunny;
//     }
//   }

//   // Core Service Methods

//   /// Get nearby parking lots based on user location
//   Future<List<ParkingLot>> getNearbyParkingLots(LatLng userLocation,
//       {double radiusKm = 5.0, int? locationId}) async {
//     try {
//       List<ParkingLot> parkingLots;

//       if (locationId != null) {
//         // Fetch from API
//         parkingLots = await getParkingLotsFromAPI(locationId);
//       } else {
//         // Use cached data if available
//         parkingLots = _cachedParkingLots;
//       }

//       if (parkingLots.isEmpty) {
//         return [];
//       }

//       final Distance distance = Distance();

//       List<ParkingLot> nearbyLots = parkingLots
//           .map((lot) {
//             final distanceToLot =
//                 distance.as(LengthUnit.Kilometer, userLocation, lot.position);

//             return ParkingLot(
//               id: lot.id,
//               name: lot.name,
//               address: lot.address,
//               position: lot.position,
//               slots: lot.slots,
//               type: lot.type,
//               rating: lot.rating,
//               operatingHours: lot.operatingHours,
//               hasToilet: lot.hasToilet,
//               hasSecurity: lot.hasSecurity,
//               hasEVCharging: lot.hasEVCharging,
//               phoneNumber: lot.phoneNumber,
//               description: lot.description,
//               distanceFromUser: distanceToLot,
//             );
//           })
//           .where((lot) => lot.distanceFromUser <= radiusKm)
//           .toList();

//       // Sort by distance
//       nearbyLots
//           .sort((a, b) => a.distanceFromUser.compareTo(b.distanceFromUser));

//       return nearbyLots;
//     } catch (e) {
//       throw Exception('Error getting nearby parking lots: $e');
//     }
//   }

//   /// Get parking lot by ID
//   Future<ParkingLot?> getParkingLotById(String id, {int? locationId}) async {
//     try {
//       if (locationId != null) {
//         // Try to fetch from API first
//         final lots = await getParkingLotsFromAPI(locationId);
//         final lot = lots.where((lot) => lot.id == id).firstOrNull;
//         if (lot != null) {
//           // Load slots for this lot
//           final slots = await getParkingSlotsFromAPI(locationId, int.parse(id));
//           return ParkingLot(
//             id: lot.id,
//             name: lot.name,
//             address: lot.address,
//             position: lot.position,
//             slots: slots,
//             type: lot.type,
//             rating: lot.rating,
//             operatingHours: lot.operatingHours,
//             hasToilet: lot.hasToilet,
//             hasSecurity: lot.hasSecurity,
//             hasEVCharging: lot.hasEVCharging,
//             phoneNumber: lot.phoneNumber,
//             description: lot.description,
//             distanceFromUser: lot.distanceFromUser,
//           );
//         }
//       }

//       // Fallback to cached data
//       return _cachedParkingLots.where((lot) => lot.id == id).firstOrNull;
//     } catch (e) {
//       // Fallback to cached data on error
//       return _cachedParkingLots.where((lot) => lot.id == id).firstOrNull;
//     }
//   }

//   /// Get available slots for a specific parking lot
//   Future<List<ParkingSlot>> getAvailableSlots(String parkingLotId,
//       {int? locationId}) async {
//     try {
//       final parkingLot =
//           await getParkingLotById(parkingLotId, locationId: locationId);
//       if (parkingLot == null) return [];

//       return parkingLot.slots.where((slot) => slot.isAvailable).toList();
//     } catch (e) {
//       throw Exception('Error getting available slots: $e');
//     }
//   }

//   /// Reserve a parking slot
//   Future<ParkingReservation?> reserveSlot({
//     required String userId,
//     required String parkingLotId,
//     required String slotId,
//     required DateTime startTime,
//     required DateTime endTime,
//     int? locationId,
//   }) async {
//     try {
//       final parkingLot =
//           await getParkingLotById(parkingLotId, locationId: locationId);
//       if (parkingLot == null) return null;

//       final slot = parkingLot.slots.where((s) => s.id == slotId).firstOrNull;
//       if (slot == null || !slot.isAvailable) return null;

//       // Calculate total price
//       final hours = endTime.difference(startTime).inHours;
//       final totalPrice = slot.pricePerHour * hours;

//       // Create reservation
//       final reservation = ParkingReservation(
//         id: 'res_${DateTime.now().millisecondsSinceEpoch}',
//         userId: userId,
//         parkingLotId: parkingLotId,
//         slotId: slotId,
//         startTime: startTime,
//         endTime: endTime,
//         totalPrice: totalPrice.toDouble(),
//         createdAt: DateTime.now(),
//       );

//       // Here you would typically make an API call to actually reserve the slot
//       // For now, we'll just return the reservation object

//       return reservation;
//     } catch (e) {
//       throw Exception('Error reserving slot: $e');
//     }
//   }

//   /// Search parking lots by name or address
//   Future<List<ParkingLot>> searchParkingLots(String query, LatLng userLocation,
//       {int? locationId}) async {
//     try {
//       List<ParkingLot> parkingLots;

//       if (locationId != null) {
//         parkingLots = await getParkingLotsFromAPI(locationId);
//       } else {
//         parkingLots = _cachedParkingLots;
//       }

//       final Distance distance = Distance();

//       final filteredLots = parkingLots.where((lot) {
//         final nameMatch = lot.name.toLowerCase().contains(query.toLowerCase());
//         final addressMatch =
//             lot.address.toLowerCase().contains(query.toLowerCase());
//         return nameMatch || addressMatch;
//       }).map((lot) {
//         final distanceToLot =
//             distance.as(LengthUnit.Kilometer, userLocation, lot.position);

//         return ParkingLot(
//           id: lot.id,
//           name: lot.name,
//           address: lot.address,
//           position: lot.position,
//           slots: lot.slots,
//           type: lot.type,
//           rating: lot.rating,
//           operatingHours: lot.operatingHours,
//           hasToilet: lot.hasToilet,
//           hasSecurity: lot.hasSecurity,
//           hasEVCharging: lot.hasEVCharging,
//           phoneNumber: lot.phoneNumber,
//           description: lot.description,
//           distanceFromUser: distanceToLot,
//         );
//       }).toList();

//       // Sort by distance
//       filteredLots
//           .sort((a, b) => a.distanceFromUser.compareTo(b.distanceFromUser));

//       return filteredLots;
//     } catch (e) {
//       throw Exception('Error searching parking lots: $e');
//     }
//   }

//   /// Get parking statistics
//   Future<Map<String, dynamic>> getParkingStatistics({int? locationId}) async {
//     try {
//       List<ParkingLot> parkingLots;

//       if (locationId != null) {
//         parkingLots = await getParkingLotsFromAPI(locationId);
//         // Load slots for each lot to get accurate statistics
//         for (int i = 0; i < parkingLots.length; i++) {
//           final slots = await getParkingSlotsFromAPI(
//               locationId, int.parse(parkingLots[i].id));
//           parkingLots[i] = ParkingLot(
//             id: parkingLots[i].id,
//             name: parkingLots[i].name,
//             address: parkingLots[i].address,
//             position: parkingLots[i].position,
//             slots: slots,
//             type: parkingLots[i].type,
//             rating: parkingLots[i].rating,
//             operatingHours: parkingLots[i].operatingHours,
//             hasToilet: parkingLots[i].hasToilet,
//             hasSecurity: parkingLots[i].hasSecurity,
//             hasEVCharging: parkingLots[i].hasEVCharging,
//             phoneNumber: parkingLots[i].phoneNumber,
//             description: parkingLots[i].description,
//           );
//         }
//       } else {
//         parkingLots = _cachedParkingLots;
//       }

//       final totalLots = parkingLots.length;
//       final totalSlots =
//           parkingLots.fold(0, (sum, lot) => sum + lot.totalSlots);
//       final availableSlots =
//           parkingLots.fold(0, (sum, lot) => sum + lot.availableSlots);
//       final occupiedSlots =
//           parkingLots.fold(0, (sum, lot) => sum + lot.occupiedSlots);

//       return {
//         'totalLots': totalLots,
//         'totalSlots': totalSlots,
//         'availableSlots': availableSlots,
//         'occupiedSlots': occupiedSlots,
//         'occupancyRate': totalSlots > 0
//             ? (occupiedSlots / totalSlots * 100).toStringAsFixed(1)
//             : '0.0',
//       };
//     } catch (e) {
//       throw Exception('Error getting parking statistics: $e');
//     }
//   }

//   /// Simulate real-time updates
//   Stream<List<ParkingLot>> getParkingLotsStream(LatLng userLocation,
//       {int? locationId}) {
//     return Stream.periodic(const Duration(seconds: 30), (count) async {
//       try {
//         return await getNearbyParkingLots(userLocation, locationId: locationId);
//       } catch (e) {
//         return <ParkingLot>[];
//       }
//     }).asyncMap((future) => future);
//   }

//   /// Clean up resources
//   void dispose() {
//     _httpClient.close();
//   }
// }
