import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_user/screens/post_request_screen.dart';
import 'package:autonexa/models/enums.dart';

class SosMapScreen extends StatefulWidget {
  const SosMapScreen({super.key});

  @override
  State<SosMapScreen> createState() => _SosMapScreenState();
}

enum MapStyle { standard, satellite, cartoDark, cartoLight }

class _SosMapScreenState extends State<SosMapScreen> {
  final MapController _mapController = MapController();
  LatLng _currentUserLocation = const LatLng(20.5937, 78.9629); // Default India center until GPS loads
  bool _isLoadingLocation = true;
  MapStyle _activeMapStyle = MapStyle.satellite;
  
  Map<String, dynamic>? _selectedProvider;

  final List<Map<String, dynamic>> _providers = [
    {
      'id': '1',
      'name': 'Elite Towing',
      'type': ServiceType.towing,
      'location': const LatLng(37.7760, -122.4210),
      'rating': 4.8,
      'eta': '5 mins',
      'icon': Icons.rv_hookup,
    },
    {
      'id': '2',
      'name': 'Quick Fuel',
      'type': ServiceType.fuel_share,
      'location': const LatLng(37.7730, -122.4170),
      'rating': 4.5,
      'eta': '8 mins',
      'icon': Icons.local_gas_station,
    },
    {
      'id': '3',
      'name': 'City Mechanics',
      'type': ServiceType.mechanical_repair,
      'location': const LatLng(37.7780, -122.4150),
      'rating': 4.9,
      'eta': '12 mins',
      'icon': Icons.build,
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentUserLocation = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });

      _mapController.move(_currentUserLocation, 15.0);
    } catch (e) {
      debugPrint('Error getting location: $e');
      setState(() => _isLoadingLocation = false);
    }
  }

  String _getMapUrl() {
    switch (_activeMapStyle) {
      case MapStyle.satellite:
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
      case MapStyle.standard:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      case MapStyle.cartoLight:
        return 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png';
      case MapStyle.cartoDark:
      default:
        return 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentUserLocation,
              initialZoom: 15.0,
              onTap: (_, __) => setState(() => _selectedProvider = null),
            ),
            children: [
              TileLayer(
                urlTemplate: _getMapUrl(),
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.autonexa',
              ),
              MarkerLayer(
                markers: [
                  // Current user marker
                  Marker(
                    point: _currentUserLocation,
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Provider markers
                  ..._providers.map((p) => Marker(
                        point: p['location'],
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedProvider = p;
                            });
                          },
                          child: Icon(
                            p['icon'],
                            color: _selectedProvider == p
                                ? Pallete.secondaryColor
                                : Colors.redAccent,
                            size: _selectedProvider == p ? 45 : 35,
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
          
          // Back UI element & GPS Fix
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cardColor,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: Icon(Icons.arrow_back, color: textColor),
                  ),
                ),
                Row(
                  children: [
                    // Map Style Switcher
                    PopupMenuButton<MapStyle>(
                      onSelected: (style) {
                        setState(() => _activeMapStyle = style);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: cardColor,
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cardColor,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 10),
                          ],
                        ),
                        child: Icon(Icons.layers, color: textColor),
                      ),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: MapStyle.standard,
                          child: Text('Standard Map'),
                        ),
                        const PopupMenuItem(
                          value: MapStyle.satellite,
                          child: Text('Satellite View'),
                        ),
                        const PopupMenuItem(
                          value: MapStyle.cartoDark,
                          child: Text('Dark Mode'),
                        ),
                        const PopupMenuItem(
                          value: MapStyle.cartoLight,
                          child: Text('Light Mode'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // GPS Location Fix
                    GestureDetector(
                      onTap: _getCurrentLocation,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cardColor,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 10),
                          ],
                        ),
                        child: Icon(
                          _isLoadingLocation ? Icons.hourglass_empty : Icons.my_location,
                          color: Pallete.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Custom card like towing dashboard
          if (_selectedProvider != null)
            Positioned(
              left: 20,
              right: 20,
              bottom: 40,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Pallete.secondaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _selectedProvider!['icon'],
                            color: Pallete.secondaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedProvider!['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${_selectedProvider!['rating']} Rating',
                                    style: const TextStyle(
                                      color: Pallete.textSecondaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.timer, color: Pallete.secondaryColor, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    _selectedProvider!['eta'],
                                    style: const TextStyle(
                                      color: Pallete.textSecondaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Pallete.secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostRequestScreen(
                                preselectedType: _selectedProvider!['type'],
                                initialLat: _selectedProvider!['location'].latitude,
                                initialLng: _selectedProvider!['location'].longitude,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Request Assitance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
