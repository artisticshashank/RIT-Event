import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/models/enums.dart';
import 'package:autonexa/features/dashboard_user/controller/user_dashboard_controller.dart';
import 'package:autonexa/features/dashboard_user/widgets/form_section_header.dart';
import 'package:autonexa/features/dashboard_user/widgets/evidence_uploader.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PostRequestScreen extends ConsumerStatefulWidget {
  final ServiceType? preselectedType;
  final double? initialLat;
  final double? initialLng;
  const PostRequestScreen({
    super.key,
    this.preselectedType,
    this.initialLat,
    this.initialLng,
  });

  @override
  ConsumerState<PostRequestScreen> createState() => _PostRequestScreenState();
}

class _PostRequestScreenState extends ConsumerState<PostRequestScreen> {
  double _currentBudgetMin = 200;
  double _currentBudgetMax = 500;

  final _descController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedServiceType;
  String? _selectedProblemCategory;
  String? _selectedVehicleInfo;

  List<File> _evidenceImages = [];
  final ImagePicker _picker = ImagePicker();

  double? _lat;
  double? _lng;

  // â”€â”€ Fuel-specific fields â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  String? _selectedFuelType;
  String? _selectedFuelQuantity;

  // â”€â”€ Towing-specific fields â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  String? _selectedTowingIssue;

  final List<String> _serviceTypes = [
    'Towing',
    'Jump Start',
    'Fuel Delivery',
    'Flat Tire',
    'Mechanical Repair',
  ];

  final List<String> _problemCategories = [
    'Engine',
    'Brakes',
    'AC',
    'Electrical',
    'Tyres',
    'Fuel',
    'Other',
  ];

  final List<String> _fuelTypes = ['95 OCT', '98 OCT', 'DIESEL', 'E85', 'LPG'];

  final List<String> _fuelQuantities = [
    '5 Liters',
    '10 Liters',
    '15 Liters',
    '20 Liters',
    '30 Liters',
    '45 Liters',
    'Full Tank',
  ];

  final List<String> _towingIssues = [
    'Flat Tire',
    'Engine Failure',
    'Accident',
    'Out of Fuel',
    'Battery Dead',
    'Overheating',
    'Locked Out',
    'Other',
  ];

  bool get _isFuelRequest => _selectedServiceType == 'Fuel Delivery';
  bool get _isTowingRequest => _selectedServiceType == 'Towing';
  bool get _isMechanicalRequest =>
      _selectedServiceType == 'Mechanical Repair' ||
      _selectedServiceType == 'Jump Start' ||
      _selectedServiceType == 'Flat Tire';

  @override
  void initState() {
    super.initState();
    _lat = widget.initialLat;
    _lng = widget.initialLng;

    if (widget.preselectedType != null) {
      _selectedServiceType = widget.preselectedType!.displayName;
    }

    if (_lat != null && _lng != null) {
      _getAddressFromCoords(_lat!, _lng!);
    } else {
      _getCurrentLocation();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vehicles = ref.read(userVehiclesProvider).value;
      if (vehicles != null && vehicles.isNotEmpty) {
        final v = vehicles.first;
        setState(() => _selectedVehicleInfo = '${v.make} ${v.model} ${v.year}');
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnack('Location services are disabled.', isError: true);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnack('Location permissions are denied.', isError: true);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnack('Location permissions are permanently denied.', isError: true);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() {
        _lat = position.latitude;
        _lng = position.longitude;
      });
      _getAddressFromCoords(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _getAddressFromCoords(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final address = '${p.street}, ${p.subLocality}, ${p.locality}, ${p.postalCode}';
        setState(() {
          _locationController.text = address;
        });
      }
    } catch (e) {
      debugPrint('Error reverse geocoding: $e');
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  ServiceType _mapToServiceType(String? label) {
    switch (label) {
      case 'Towing':
        return ServiceType.towing;
      case 'Jump Start':
        return ServiceType.jump_start;
      case 'Fuel Delivery':
        return ServiceType.fuel_share;
      case 'Flat Tire':
        return ServiceType.flat_tire;
      default:
        return ServiceType.mechanical_repair;
    }
  }

  Future<void> _submitRequest() async {
    if (_selectedServiceType == null) {
      _showSnack('Please select a service type', isError: true);
      return;
    }
    if (_isFuelRequest && _selectedFuelType == null) {
      _showSnack('Please select a fuel type', isError: true);
      return;
    }
    if (_isFuelRequest && _selectedFuelQuantity == null) {
      _showSnack('Please select fuel quantity', isError: true);
      return;
    }

    final success = await ref
        .read(createServiceRequestProvider.notifier)
        .create(
          requestType: _mapToServiceType(_selectedServiceType),
          locationLat: _lat ?? 0.0,
          locationLng: _lng ?? 0.0,
          locationAddress: _locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim(),
          vehicleInfo: _selectedVehicleInfo,
          description: _descController.text.trim(),
          fuelQuantity: _isFuelRequest ? _selectedFuelQuantity : null,
          fuelType: _isFuelRequest ? _selectedFuelType : null,
          issueType: _isTowingRequest
              ? _selectedTowingIssue
              : _selectedProblemCategory,
          price: _currentBudgetMin.toDouble(),
          evidenceFiles: _evidenceImages,
        );

    if (!mounted) return;
    if (success) {
      _showSnack('Request posted! Searching for providers...');
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) Navigator.pop(context);
    } else {
      _showSnack('Failed to post request. Try again.', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.redAccent : Pallete.secondaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (_evidenceImages.length >= 5) {
      _showSnack('You can only upload up to 5 images', isError: true);
      return;
    }
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (pickedFile != null) {
        setState(() {
          _evidenceImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      _showSnack('Failed to pick image', isError: true);
    }
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputBgColor = isDark
        ? const Color(0xFF28286A)
        : Colors.grey.shade100;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: inputBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Pallete.textSecondaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: inputBgColor,
          style: TextStyle(color: textColor, fontSize: 16),
          hint: Text(
            hint,
            style: TextStyle(
              color: Pallete.textSecondaryColor.withValues(alpha: 0.7),
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Pallete.textSecondaryColor,
          ),
          isExpanded: true,
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final bgColor = isDark ? const Color(0xFF1B1B4A) : Colors.white;
    final inputBgColor = isDark
        ? const Color(0xFF28286A)
        : Colors.grey.shade100;

    final createState = ref.watch(createServiceRequestProvider);
    final isLoading = createState is AsyncLoading;

    final vehiclesAsync = ref.watch(userVehiclesProvider);
    final vehicleOptions =
        vehiclesAsync.value
            ?.map((v) => '${v.make} ${v.model} ${v.year}')
            .toList() ??
        [];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Post a Request',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Drafts',
              style: TextStyle(color: Pallete.secondaryColor),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // â”€â”€ Service Type â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            const FormSectionHeader(
              title: 'Service Type',
              icon: Icons.build_circle,
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              hint: 'Select Service Type',
              value: _selectedServiceType,
              items: _serviceTypes,
              onChanged: (v) => setState(() {
                _selectedServiceType = v;
                // Reset type-specific fields on change
                _selectedFuelType = null;
                _selectedFuelQuantity = null;
                _selectedTowingIssue = null;
                _selectedProblemCategory = null;
              }),
              context: context,
            ),
            const SizedBox(height: 24),

            // â”€â”€ Fuel-specific section â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            if (_isFuelRequest) ...[
              const FormSectionHeader(
                title: 'Fuel Details',
                icon: Icons.local_gas_station,
              ),
              const SizedBox(height: 12),
              const Text(
                'Fuel Type',
                style: TextStyle(
                  fontSize: 12,
                  color: Pallete.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                hint: 'Select Fuel Type',
                value: _selectedFuelType,
                items: _fuelTypes,
                onChanged: (v) => setState(() => _selectedFuelType = v),
                context: context,
              ),
              const SizedBox(height: 16),
              const Text(
                'Quantity Needed',
                style: TextStyle(
                  fontSize: 12,
                  color: Pallete.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                hint: 'How much fuel do you need?',
                value: _selectedFuelQuantity,
                items: _fuelQuantities,
                onChanged: (v) => setState(() => _selectedFuelQuantity = v),
                context: context,
              ),
              const SizedBox(height: 24),
            ],

            // â”€â”€ Towing-specific section â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            if (_isTowingRequest) ...[
              const FormSectionHeader(
                title: 'Issue Details',
                icon: Icons.car_crash,
              ),
              const SizedBox(height: 12),
              const Text(
                'What happened?',
                style: TextStyle(
                  fontSize: 12,
                  color: Pallete.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                hint: 'Select issue type',
                value: _selectedTowingIssue,
                items: _towingIssues,
                onChanged: (v) => setState(() => _selectedTowingIssue = v),
                context: context,
              ),
              const SizedBox(height: 24),
            ],

            // â”€â”€ Vehicle Details â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            const FormSectionHeader(
              title: 'Vehicle Details',
              icon: Icons.directions_car,
            ),
            const SizedBox(height: 12),
            const Text(
              'Select Vehicle',
              style: TextStyle(fontSize: 12, color: Pallete.textSecondaryColor),
            ),
            const SizedBox(height: 8),
            vehicleOptions.isEmpty
                ? Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: inputBgColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'No vehicles added yet',
                        style: TextStyle(color: Pallete.textSecondaryColor),
                      ),
                    ),
                  )
                : _buildDropdown(
                    hint: 'Select your vehicle',
                    value: _selectedVehicleInfo,
                    items: vehicleOptions,
                    onChanged: (v) => setState(() => _selectedVehicleInfo = v),
                    context: context,
                  ),

            // Problem Category â€” only for mechanical/tire/jump
            if (_isMechanicalRequest) ...[
              const SizedBox(height: 16),
              const Text(
                'Problem Category',
                style: TextStyle(
                  fontSize: 12,
                  color: Pallete.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                hint: 'Engine, Brakes, AC, etc.',
                value: _selectedProblemCategory,
                items: _problemCategories,
                onChanged: (v) => setState(() => _selectedProblemCategory = v),
                context: context,
              ),
            ],
            const SizedBox(height: 32),

            // â”€â”€ Describe issue â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            const FormSectionHeader(
              title: 'Describe the Issue',
              icon: Icons.edit_note,
            ),
            const SizedBox(height: 12),
            Container(
              height: 120,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: inputBgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Pallete.textSecondaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: TextField(
                controller: _descController,
                maxLines: null,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Describe what\'s happening with your vehicle...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Pallete.textSecondaryColor.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // â”€â”€ Evidence â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                FormSectionHeader(
                  title: 'Upload Evidence',
                  icon: Icons.camera_alt,
                ),
                Text(
                  'Max 5 files',
                  style: TextStyle(
                    color: Pallete.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            EvidenceUploader(
              images: _evidenceImages,
              onAdd: _pickImage,
              onRemove: (index) {
                setState(() {
                  _evidenceImages.removeAt(index);
                });
              },
            ),
            const SizedBox(height: 32),

            // â”€â”€ Location â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            const FormSectionHeader(
              title: 'Service Location',
              icon: Icons.location_on,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: inputBgColor,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: Pallete.textSecondaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showSnack('Fetching precise location...');
                      _getCurrentLocation();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Pallete.secondaryColor.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.my_location,
                        color: Pallete.secondaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: 'Enter your location or address...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Pallete.textSecondaryColor.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Pallete.secondaryColor.withOpacity(0.2),
                  width: 2,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(_lat ?? 20.5937, _lng ?? 78.9629),
                  initialZoom: 14.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: isDark
                        ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                        : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                    subdomains: const ['a', 'b', 'c', 'd'],
                  ),
                  if (_lat != null && _lng != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(_lat!, _lng!),
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.redAccent,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // â”€â”€ Budget â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const FormSectionHeader(
                  title: 'Budget Range',
                  icon: Icons.payments,
                ),
                Text(
                  '₹${_currentBudgetMin.toInt()} - ₹${_currentBudgetMax.toInt()}',
                  style: const TextStyle(
                    color: Pallete.secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            RangeSlider(
              values: RangeValues(_currentBudgetMin, _currentBudgetMax),
              min: 50,
              max: 2000,
              activeColor: Pallete.secondaryColor,
              inactiveColor: inputBgColor,
              onChanged: (RangeValues values) {
                setState(() {
                  _currentBudgetMin = values.start;
                  _currentBudgetMax = values.end;
                });
              },
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹50',
                  style: TextStyle(
                    color: Pallete.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '₹2,000+',
                  style: TextStyle(
                    color: Pallete.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // â”€â”€ Submit â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.secondaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  elevation: 5,
                  shadowColor: Pallete.secondaryColor.withValues(alpha: 0.5),
                ),
                onPressed: isLoading ? null : _submitRequest,
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isFuelRequest
                                ? 'Request Fuel Delivery'
                                : _isTowingRequest
                                ? 'Request Tow Truck'
                                : 'Post Service Request',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.send),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

