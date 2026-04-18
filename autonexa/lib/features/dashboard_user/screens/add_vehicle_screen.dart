import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_user/controller/user_dashboard_controller.dart';
import 'package:autonexa/core/common/loader.dart';

class AddVehicleScreen extends ConsumerStatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  ConsumerState<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends ConsumerState<AddVehicleScreen> {
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _licensePlateController = TextEditingController();
  
  bool _isUploadingDocs = false;
  bool _docsUploaded = false;

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _licensePlateController.dispose();
    super.dispose();
  }

  void _simulateDocUpload() async {
    setState(() => _isUploadingDocs = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isUploadingDocs = false;
      _docsUploaded = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Service details uploaded successfully!'),
        backgroundColor: Pallete.secondaryColor,
      ),
    );
  }

  void _submit() async {
    final make = _makeController.text.trim();
    final model = _modelController.text.trim();
    final year = int.tryParse(_yearController.text.trim()) ?? 0;
    final licensePlate = _licensePlateController.text.trim();

    if (make.isEmpty || model.isEmpty || year == 0 || licensePlate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await ref.read(addVehicleProvider.notifier).addVehicle(
          make: make,
          model: model,
          year: year,
          licensePlate: licensePlate,
        );
        
    if (success && mounted) {
      ref.invalidate(userVehiclesProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vehicle added successfully!'),
          backgroundColor: Pallete.secondaryColor,
        ),
      );
      Navigator.pop(context);
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType type = TextInputType.text}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Pallete.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: type,
            style: TextStyle(color: isDark ? Colors.white : Pallete.textColor),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Pallete.textColor;
    
    // Using provider state to check loading
    // The riverpod v3 AsyncNotifier doesn't expose standard riverpod state natively if mapped this way without explicitly watching
    // We can do it by creating a small extension or just watching the Provider if it was a StateNotifier.
    // For simplicity, we just watch the provider if it exists but AddVehicleNotifier is an AsyncNotifier.
    final loadingState = ref.watch(addVehicleProvider);
    final isSubmitting = loadingState is AsyncLoading;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Add Your Vehicle', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Make (e.g. Tesla, Ford)', _makeController),
            _buildTextField('Model (e.g. Model 3, Mustang)', _modelController),
            _buildTextField('Year', _yearController, type: TextInputType.number),
            _buildTextField('License Plate', _licensePlateController),
            
            const SizedBox(height: 24),
            Text(
              'Previous Service Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload your previous service records so we can remind you when your next service is due.',
              style: TextStyle(color: Pallete.textSecondaryColor, fontSize: 13),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _docsUploaded ? null : _simulateDocUpload,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: _docsUploaded ? Colors.green.withOpacity(0.1) : (isDark ? const Color(0xFF1E1E1E) : Colors.grey[100]),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _docsUploaded ? Colors.green : Pallete.secondaryColor.withOpacity(0.5),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    if (_isUploadingDocs)
                      const CircularProgressIndicator(strokeWidth: 2)
                    else if (_docsUploaded)
                      const Icon(Icons.check_circle, color: Colors.green, size: 40)
                    else
                      Icon(Icons.upload_file, color: Pallete.secondaryColor, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      _docsUploaded ? 'Service Records Uploaded' : 'Tap to Upload Records (PDF/JPG)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _docsUploaded ? Colors.green : Pallete.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isSubmitting 
                    ? const Loader()
                    : const Text(
                        'Save Vehicle',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
