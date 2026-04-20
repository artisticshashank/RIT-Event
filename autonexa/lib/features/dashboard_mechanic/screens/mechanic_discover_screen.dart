import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/models/service_request_model.dart';
import 'package:autonexa/models/enums.dart';
import 'package:autonexa/core/common/loader.dart';
import 'package:autonexa/features/dashboard_mechanic/controller/mechanic_controller.dart';
import 'package:autonexa/features/dashboard_mechanic/widgets/nearby_request_card.dart';
import 'package:autonexa/features/dashboard_mechanic/screens/mechanic_incoming_request_screen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart' hide ServiceStatus;

class MechanicDiscoverScreen extends ConsumerStatefulWidget {
  const MechanicDiscoverScreen({super.key});

  @override
  ConsumerState<MechanicDiscoverScreen> createState() =>
      _MechanicDiscoverScreenState();
}

class _MechanicDiscoverScreenState
    extends ConsumerState<MechanicDiscoverScreen> {
  int _selectedTabIndex = 0; // 0=All, 1=Emergency, 2=Scheduled
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  bool _isLoadingMapLocation = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _isLoadingMapLocation = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingMapLocation = false);
    }
  }

  // Map ServiceType to whether it's "emergency-priority"
  bool _isEmergency(ServiceRequestModel r) =>
      r.requestType == ServiceType.jump_start ||
      r.requestType == ServiceType.towing ||
      r.requestType == ServiceType.flat_tire;

  String _distanceLabel(ServiceRequestModel r) => r.distanceKm != null
      ? '${r.distanceKm!.toStringAsFixed(1)} km away'
      : 'Nearby';

  String _timeLabel(ServiceRequestModel r) {
    if (r.createdAt == null) return 'Just now';
    final diff = DateTime.now().difference(r.createdAt!);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return 'Requested ${diff.inMinutes}m ago';
    return 'Requested ${diff.inHours}h ago';
  }

  String _statusLabel(ServiceRequestModel r) {
    if (_isEmergency(r)) return 'EMERGENCY';
    return 'NEARBY';
  }

  Color _statusColor(ServiceRequestModel r) {
    if (_isEmergency(r)) return Pallete.secondaryColor;
    return Colors.blue;
  }

  Widget _buildTab(String title, IconData icon, int index) {
    final isSelected = _selectedTabIndex == index;
    final color = isSelected
        ? Pallete.secondaryColor
        : Pallete.textSecondaryColor;

    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 3,
            width: 40,
            decoration: BoxDecoration(
              color: isSelected ? Pallete.secondaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final isOnline = ref.watch(mechanicOnlineProvider);
    final pendingAsync = ref.watch(pendingJobsProvider);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Flutter Map with Online toggle overlay
              Container(
                height: 250,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _currentLocation ?? const LatLng(20.5937, 78.9629),
                        initialZoom: 12.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: isDark
                              ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                              : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                          subdomains: const ['a', 'b', 'c', 'd'],
                        ),
                        // Request markers
                        pendingAsync.when(
                          data: (jobs) => MarkerLayer(
                            markers: jobs.map((job) {
                              return Marker(
                                point: LatLng(
                                  job.locationLat != 0.0 ? job.locationLat : (_currentLocation?.latitude ?? 20.5937),
                                  job.locationLng != 0.0 ? job.locationLng : (_currentLocation?.longitude ?? 78.9629),
                                ),
                                width: 30,
                                height: 30,
                                child: Icon(
                                  Icons.location_on,
                                  color: job.requestType == ServiceType.towing || job.requestType == ServiceType.jump_start
                                      ? Pallete.secondaryColor
                                      : Colors.blue,
                                  size: 24,
                                ),
                              );
                            }).toList(),
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),

                    // Online toggle — tapping calls Supabase
                    Positioned(
                      top: 16,
                      left: 16,
                      child: GestureDetector(
                        onTap: () => updateMechanicAvailability(ref, !isOnline),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2C3146)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: isOnline ? Colors.green : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isOnline ? 'Online & Available' : 'Go Online',
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Job count badge
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Pallete.secondaryColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: pendingAsync.when(
                          data: (jobs) => Text(
                            '${jobs.length} Requests',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          loading: () => const Text(
                            '...',
                            style: TextStyle(color: Colors.white),
                          ),
                          error: (_, __) => const Text(
                            '—',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    // Live Location Getter Button
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          if (_currentLocation != null) {
                            _mapController.move(_currentLocation!, 15.0);
                          } else {
                            _fetchCurrentLocation();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2C3146) : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 10),
                            ],
                          ),
                          child: Icon(
                            _isLoadingMapLocation ? Icons.hourglass_empty : Icons.my_location,
                            color: Pallete.secondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTab('All', Icons.list, 0),
                    _buildTab('Emergency', Icons.bolt, 1),
                    _buildTab('Scheduled', Icons.calendar_today, 2),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nearby Requests',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Sorted by distance',
                      style: TextStyle(
                        color: Pallete.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // ── Request cards ───────────────────────────────────────────────
        pendingAsync.when(
          data: (all) {
            final List<ServiceRequestModel> filtered;
            if (_selectedTabIndex == 1) {
              filtered = all.where(_isEmergency).toList();
            } else if (_selectedTabIndex == 2) {
              filtered = all.where((r) => !_isEmergency(r)).toList();
            } else {
              filtered = all;
            }

            if (filtered.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Pallete.textSecondaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isOnline
                            ? 'No requests in your area right now.'
                            : 'Go online to see nearby requests.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Pallete.textSecondaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
                  final r = filtered[i];
                  return NearbyRequestCard(
                    statusLabel: _statusLabel(r),
                    statusColor: _statusColor(r),
                    distance: _distanceLabel(r),
                    carTitle: r.vehicleInfo ?? r.requestType.displayName,
                    description:
                        r.description ?? r.issueType ?? 'Requires assistance',
                    timeText: _timeLabel(r),
                    isEmergency: _isEmergency(r),
                    isPrimaryAction: _isEmergency(r),
                    onAccept: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MechanicIncomingRequestScreen(serviceRequest: r),
                        ),
                      );
                    },
                  );
                }, childCount: filtered.length),
              ),
            );
          },
          loading: () => const SliverToBoxAdapter(child: Loader()),
          error: (e, _) => SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Error loading requests: $e',
                  style: const TextStyle(color: Pallete.textSecondaryColor),
                ),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
