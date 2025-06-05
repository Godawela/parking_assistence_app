import 'package:flutter/material.dart';
import 'package:parking_assistence_app/models/parking_data_model.dart';

class ParkingLotCard extends StatelessWidget {
  final ParkingLot parkingLot;
  final VoidCallback? onTap;
  final bool showDistance;

  const ParkingLotCard({
    super.key,
    required this.parkingLot,
    this.onTap,
    this.showDistance = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          parkingLot.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          parkingLot.address,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showDistance)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${parkingLot.distanceFromUser.toStringAsFixed(1)} km',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Availability Row
              Row(
                children: [
                  _buildStatusChip(
                    'Available',
                    parkingLot.availableSlots.toString(),
                    Colors.green,
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(
                    'Total',
                    parkingLot.totalSlots.toString(),
                    Colors.grey,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber[600]),
                      const SizedBox(width: 4),
                      Text(
                        parkingLot.rating.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Features Row
              Row(
                children: [
                  if (parkingLot.hasSecurity)
                    _buildFeatureIcon(Icons.security, 'Security'),
                  if (parkingLot.hasEVCharging)
                    _buildFeatureIcon(Icons.ev_station, 'EV Charging'),
                  if (parkingLot.hasToilet)
                    _buildFeatureIcon(Icons.wc, 'Restroom'),
                  const Spacer(),
                  Text(
                    'From Rs.${parkingLot.averagePrice.toStringAsFixed(0)}/hr',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Condition Summary
              _buildConditionSummary(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String tooltip) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Tooltip(
        message: tooltip,
        child: Icon(
          icon,
          size: 16,
          color: Colors.blue[600],
        ),
      ),
    );
  }

  Widget _buildConditionSummary() {
    return Row(
      children: [
        if (parkingLot.shadedSlots > 0) ...[
          Icon(Icons.umbrella, size: 14, color: Colors.green[600]),
          const SizedBox(width: 4),
          Text(
            '${parkingLot.shadedSlots} Shaded',
            style: TextStyle(fontSize: 12, color: Colors.green[600]),
          ),
          const SizedBox(width: 12),
        ],
        if (parkingLot.sunnySlots > 0) ...[
          Icon(Icons.wb_sunny, size: 14, color: Colors.orange[600]),
          const SizedBox(width: 4),
          Text(
            '${parkingLot.sunnySlots} Sunny',
            style: TextStyle(fontSize: 12, color: Colors.orange[600]),
          ),
        ],
      ],
    );
  }
}

// Parking Slot Card Component
class ParkingSlotCard extends StatelessWidget {
  final ParkingSlot slot;
  final VoidCallback? onTap;
  final bool isSelected;

  const ParkingSlotCard({
    super.key,
    required this.slot,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    Color getStatusColor() {
      switch (slot.status) {
        case ParkingSlotStatus.available:
          return Colors.green;
        case ParkingSlotStatus.occupied:
          return Colors.red;
        case ParkingSlotStatus.reserved:
          return Colors.orange;
        case ParkingSlotStatus.outOfOrder:
          return Colors.grey;
      }
    }

    IconData getConditionIcon() {
      switch (slot.condition) {
        case ParkingCondition.shaded:
          return Icons.umbrella;
        case ParkingCondition.sunny:
          return Icons.wb_sunny;
        case ParkingCondition.covered:
          return Icons.roofing;
        case ParkingCondition.underground:
          return Icons.garage;
      }
    }

    String getStatusText() {
      switch (slot.status) {
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

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected 
          ? const BorderSide(color: Colors.blue, width: 2)
          : BorderSide.none,
      ),
      child: InkWell(
        onTap: slot.isAvailable ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8), 
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: slot.isAvailable ? null : Colors.grey[100],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with slot number and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      slot.slotNumber,
                      style: const TextStyle(
                        fontSize: 13, 
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), // Reduced padding
                    decoration: BoxDecoration(
                      color: getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: getStatusColor().withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      getStatusText(),
                      style: TextStyle(
                        fontSize: 8, 
                        fontWeight: FontWeight.w500,
                        color: getStatusColor(),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 4), 
              
              // Condition and features
              Row(
                children: [
                  Icon(
                    getConditionIcon(),
                    size: 12, 
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      slot.conditionText,
                      style: TextStyle(
                        fontSize: 10, 
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 4), 
              
              // Features icons and price
              Row(
                children: [
                  if (slot.isEVCharging) ...[
                    Icon(
                      Icons.ev_station,
                      size: 12, 
                      color: Colors.green[600],
                    ),
                    const SizedBox(width: 4),
                  ],
                  if (slot.isAccessible) ...[
                    Icon(
                      Icons.accessible,
                      size: 12,
                      color: Colors.blue[600],
                    ),
                    const SizedBox(width: 4),
                  ],
                  const Spacer(),
                  Flexible(
                    child: Text(
                      'Rs.${slot.pricePerHour.toStringAsFixed(0)}/hr',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: slot.isAvailable ? Colors.green[700] : Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              // Reserve button (only if available) 
              if (slot.isAvailable) ...[
                const SizedBox(height: 4), 
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 4), 
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      'Tap to Reserve',
                      style: TextStyle(
                        fontSize: 9, // Reduced from 10
                        fontWeight: FontWeight.w500,
                        color: Colors.green[700],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Filter Chip Component
class ParkingFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const ParkingFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16),
            const SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }
}

// Parking Statistics Widget
class ParkingStatsWidget extends StatelessWidget {
  final List<ParkingLot> parkingLots;

  const ParkingStatsWidget({
    super.key,
    required this.parkingLots,
  });

  @override
  Widget build(BuildContext context) {
    int totalSlots = parkingLots.fold(0, (sum, lot) => sum + lot.totalSlots);
    int availableSlots = parkingLots.fold(0, (sum, lot) => sum + lot.availableSlots);
    int occupiedSlots = totalSlots - availableSlots;
    double occupancyRate = totalSlots > 0 ? (occupiedSlots / totalSlots) * 100 : 0;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Parking Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Slots',
                    totalSlots.toString(),
                    Icons.local_parking,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Available',
                    availableSlots.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Occupied',
                    occupiedSlots.toString(),
                    Icons.cancel,
                    Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Occupancy',
                    '${occupancyRate.toStringAsFixed(1)}%',
                    Icons.pie_chart,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Loading Shimmer Effect
class ParkingLotShimmer extends StatelessWidget {
  const ParkingLotShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 20,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 16,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 24,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  height: 24,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 24,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 16,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Empty State Widget
class EmptyParkingState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onRefresh;

  const EmptyParkingState({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.local_parking_outlined,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            if (onRefresh != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Compact Parking Slot Card 
class CompactParkingSlotCard extends StatelessWidget {
  final ParkingSlot slot;
  final VoidCallback? onTap;
  final bool isSelected;

  const CompactParkingSlotCard({
    super.key,
    required this.slot,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    Color getStatusColor() {
      switch (slot.status) {
        case ParkingSlotStatus.available:
          return Colors.green;
        case ParkingSlotStatus.occupied:
          return Colors.red;
        case ParkingSlotStatus.reserved:
          return Colors.orange;
        case ParkingSlotStatus.outOfOrder:
          return Colors.grey;
      }
    }

    return Card(
      margin: const EdgeInsets.all(4),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isSelected 
          ? const BorderSide(color: Colors.blue, width: 2)
          : BorderSide.none,
      ),
      child: InkWell(
        onTap: slot.isAvailable ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: slot.isAvailable ? null : Colors.grey[100],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                slot.slotNumber,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  slot.status.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: getStatusColor(),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Rs.${slot.pricePerHour.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: slot.isAvailable ? Colors.green[700] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}