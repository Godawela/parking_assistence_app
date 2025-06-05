import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:parking_assistence_app/components/parking_card.dart';
import 'package:parking_assistence_app/models/parking_data_model.dart';
import 'package:parking_assistence_app/services/parking_service.dart';

class ParkingMapScreen extends ConsumerStatefulWidget {
  const ParkingMapScreen({super.key});

  @override
  ConsumerState<ParkingMapScreen> createState() => _ParkingMapScreenState();
}

class _ParkingMapScreenState extends ConsumerState<ParkingMapScreen> {
  // Colombo default location
  LatLng userLocation = const LatLng(6.9271, 79.8612);
  final MapController _mapController = MapController();
  final ParkingService _parkingService = ParkingService();
  final TextEditingController _searchController = TextEditingController();

  List<ParkingLot> parkingLots = [];
  ParkingLot? selectedParkingLot;
  bool isLoading = true;
  bool showFilters = false;
  String? errorMessage;

  // Filter states
  Set<ParkingCondition> selectedConditions = {};
  Set<ParkingLotType> selectedTypes = {};
  bool showOnlyAvailable = false;
  bool showOnlyEVCharging = false;

  late Timer _refreshTimer;
  late StreamSubscription<List<ParkingLot>> _parkingStreamSubscription;

  @override
  void initState() {
    super.initState();
    _loadParkingLots();
    _setupPeriodicRefresh();
    _setupRealtimeUpdates();
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    _parkingStreamSubscription.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _setupPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
      _loadParkingLots();
    });
  }

  void _setupRealtimeUpdates() {
    _parkingStreamSubscription =
        _parkingService.getParkingLotsStream(userLocation).listen((lots) {
      if (mounted) {
        setState(() {
          parkingLots = lots;
        });
      }
    });
  }

  Future<void> _loadParkingLots() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final lots = await _parkingService.getNearbyParkingLots(userLocation);
      if (mounted) {
        setState(() {
          parkingLots = lots;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _searchParkingLots(String query) async {
    if (query.isEmpty) {
      _loadParkingLots();
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final lots = await _parkingService.searchParkingLots(query, userLocation);
      if (mounted) {
        setState(() {
          parkingLots = lots;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = e.toString();
        });
      }
    }
  }

  List<ParkingLot> _getFilteredParkingLots() {
    return parkingLots.where((lot) {
      // Available filter
      if (showOnlyAvailable && !lot.hasAvailableSlots) {
        return false;
      }

      // EV Charging filter
      if (showOnlyEVCharging && !lot.hasEVCharging) {
        return false;
      }

      // Condition filter
      if (selectedConditions.isNotEmpty) {
        bool hasSelectedCondition = lot.slots
            .any((slot) => selectedConditions.contains(slot.condition));
        if (!hasSelectedCondition) return false;
      }

      // Type filter
      if (selectedTypes.isNotEmpty && !selectedTypes.contains(lot.type)) {
        return false;
      }

      return true;
    }).toList();
  }

  List<Marker> _buildMarkers() {
    final filteredLots = _getFilteredParkingLots();
    List<Marker> markers = [];

    // User location marker
    markers.add(
      Marker(
        width: 30,
        height: 40,
        point: userLocation,
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_pin_circle,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );

    // Parking lot markers
    for (final lot in filteredLots) {
      markers.add(
        Marker(
          width: 50,
          height: 80,
          point: lot.position,
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedParkingLot = lot;
              });
              _mapController.move(lot.position, 15);
            },
            child: Container(
              decoration: BoxDecoration(
                color: lot.hasAvailableSlots ? Colors.green : Colors.red,
                shape: BoxShape.circle,
                border: Border.all(
                    color: selectedParkingLot?.id == lot.id
                        ? Colors.blue
                        : Colors.white,
                    width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    // Different icons based on availability
                    lot.hasAvailableSlots
                        ? Icons.local_parking // Available
                        : Icons.block, // Full
                    color: Colors.white,
                    size: 20,
                  ),
                  Text(
                    lot.availableSlots.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return markers;
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search parking lots...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.tune,
                  color: showFilters ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    showFilters = !showFilters;
                  });
                },
              ),
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _loadParkingLots();
                  },
                ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onSubmitted: _searchParkingLots,
      ),
    );
  }

  Widget _buildFilterSheet() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: showFilters ? null : 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filters',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Quick filters
            Row(
              children: [
                Expanded(
                  child: FilterChip(
                    label: const Text('Available Only'),
                    selected: showOnlyAvailable,
                    onSelected: (selected) {
                      setState(() {
                        showOnlyAvailable = selected;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChip(
                    label: const Text('EV Charging'),
                    selected: showOnlyEVCharging,
                    onSelected: (selected) {
                      setState(() {
                        showOnlyEVCharging = selected;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Parking types
            const Text(
              'Parking Types',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ParkingLotType.values.map((type) {
                return FilterChip(
                  label: Text(type.displayName),
                  selected: selectedTypes.contains(type),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedTypes.add(type);
                      } else {
                        selectedTypes.remove(type);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // Conditions
            const Text(
              'Parking Conditions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ParkingCondition.values.map((condition) {
                return FilterChip(
                  label: Text(condition.displayName),
                  selected: selectedConditions.contains(condition),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedConditions.add(condition);
                      } else {
                        selectedConditions.remove(condition);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // Clear filters button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    selectedConditions.clear();
                    selectedTypes.clear();
                    showOnlyAvailable = false;
                    showOnlyEVCharging = false;
                  });
                },
                child: const Text('Clear All Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.1,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      selectedParkingLot != null
                          ? 'Parking Details'
                          : 'Nearby Parking (${_getFilteredParkingLots().length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (selectedParkingLot != null)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            selectedParkingLot = null;
                          });
                        },
                      ),
                  ],
                ),
              ),

              const Divider(),

              // Content
              Expanded(
                child: selectedParkingLot != null
                    ? _buildParkingLotDetails(scrollController)
                    : _buildParkingLotsList(scrollController),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildParkingLotDetails(ScrollController scrollController) {
    final lot = selectedParkingLot!;

    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Info
          Text(
            lot.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            lot.address,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber[600], size: 20),
              const SizedBox(width: 4),
              Text(
                lot.rating.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.schedule, color: Colors.grey[600], size: 20),
              const SizedBox(width: 4),
              Text(
                lot.operatingHours,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Availability Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Available',
                  lot.availableSlots.toString(),
                  Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Total',
                  lot.totalSlots.toString(),
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Distance',
                  '${lot.distanceFromUser.toStringAsFixed(1)}km',
                  Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Features
          if (lot.description.isNotEmpty) ...[
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              lot.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Slots Grid
          const Text(
            'Available Slots',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: lot.slots.length,
            itemBuilder: (context, index) {
              final slot = lot.slots[index];
              return ParkingSlotCard(
                slot: slot,
                onTap: () {
                  _showReservationDialog(lot, slot);
                },
              );
            },
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _navigateToParkingLot(lot);
                  },
                  icon: const Icon(Icons.directions),
                  label: const Text('Navigate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: lot.phoneNumber.isNotEmpty
                      ? () {
                          _makePhoneCall(lot.phoneNumber);
                        }
                      : null,
                  icon: const Icon(Icons.phone),
                  label: const Text('Call'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParkingLotsList(ScrollController scrollController) {
    final filteredLots = _getFilteredParkingLots();

    if (filteredLots.isEmpty && !isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_parking_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No parking lots found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search terms',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: filteredLots.length,
      itemBuilder: (context, index) {
        final lot = filteredLots[index];
        return ParkingLotCard(
          parkingLot: lot,
          onTap: () {
            setState(() {
              selectedParkingLot = lot;
            });
            _mapController.move(lot.position, 15);
          },
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showReservationDialog(ParkingLot lot, ParkingSlot slot) {
    if (!slot.isAvailable) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reserve ${slot.slotNumber}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Parking Lot: ${lot.name}'),
            Text('Condition: ${slot.conditionText}'),
            Text('Price: Rs.${slot.pricePerHour.toStringAsFixed(0)}/hour'),
            if (slot.isEVCharging) const Text('✓ EV Charging Available'),
            if (slot.isAccessible) const Text('✓ Accessible Parking'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _reserveSlot(lot, slot);
            },
            child: const Text('Reserve'),
          ),
        ],
      ),
    );
  }

  void _reserveSlot(ParkingLot lot, ParkingSlot slot) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Reservation for ${slot.slotNumber} at ${lot.name} is being processed...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _navigateToParkingLot(ParkingLot lot) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening navigation to ${lot.name}...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling $phoneNumber...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ParkSpot',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadParkingLots,
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              _mapController.move(userLocation, 15);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: userLocation,
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.parking_app',
              ),
              MarkerLayer(
                markers: _buildMarkers(),
              ),
            ],
          ),

          // Loading overlay
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // Error message
          if (errorMessage != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          errorMessage = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

          // Search bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                _buildSearchBar(),
                if (showFilters) _buildFilterSheet(),
              ],
            ),
          ),

          // Bottom sheet
          _buildBottomSheet(),
        ],
      ),
    );
  }
}
