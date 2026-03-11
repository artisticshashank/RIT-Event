import 'package:flutter/material.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/features/dashboard_user/widgets/form_section_header.dart';
import 'package:autonexa/features/dashboard_user/widgets/custom_dropdown.dart';
import 'package:autonexa/features/dashboard_user/widgets/evidence_uploader.dart';

class PostRequestScreen extends StatefulWidget {
  const PostRequestScreen({super.key});

  @override
  State<PostRequestScreen> createState() => _PostRequestScreenState();
}

class _PostRequestScreenState extends State<PostRequestScreen> {
  double _currentBudgetMin = 200;
  double _currentBudgetMax = 500;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final bgColor = isDark ? const Color(0xFF1B1B4A) : Colors.white; // Approximating the dark blue
    final inputBgColor = isDark ? const Color(0xFF28286A) : Colors.grey.shade100;

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
            child: const Text('Drafts', style: TextStyle(color: Pallete.secondaryColor)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FormSectionHeader(title: 'Vehicle Details', icon: Icons.directions_car),
            const SizedBox(height: 12),
            const Text('Select Vehicle', style: TextStyle(fontSize: 12, color: Pallete.textSecondaryColor)),
            const SizedBox(height: 8),
            const CustomDropdown(hint: 'Tesla Model 3 - Red'),
            const SizedBox(height: 16),
            const Text('Problem Category', style: TextStyle(fontSize: 12, color: Pallete.textSecondaryColor)),
            const SizedBox(height: 8),
            const CustomDropdown(hint: 'Engine, Brakes, AC, etc.'),
            const SizedBox(height: 32),

            const FormSectionHeader(title: 'Describe the Issue', icon: Icons.edit_note),
            const SizedBox(height: 12),
            Container(
              height: 120,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: inputBgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Pallete.textSecondaryColor.withValues(alpha: 0.2)),
              ),
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Describe what\'s happening with your vehicle in detail...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Pallete.textSecondaryColor.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const FormSectionHeader(title: 'Upload Evidence', icon: Icons.camera_alt),
                const Text('Max 5 files', style: TextStyle(color: Pallete.textSecondaryColor, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),
            const EvidenceUploader(),
            const SizedBox(height: 32),

            const FormSectionHeader(title: 'Service Location', icon: Icons.location_on),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: inputBgColor,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Pallete.textSecondaryColor.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.my_location, color: Pallete.secondaryColor, size: 20),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '123 Innovation Drive, San Francisco, CA',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=600&auto=format&fit=crop&grayscale=1'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const FormSectionHeader(title: 'Budget Range', icon: Icons.payments),
                Text(
                  '\$${_currentBudgetMin.toInt()} - \$${_currentBudgetMax.toInt()}',
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
                Text('\$50', style: TextStyle(color: Pallete.textSecondaryColor, fontSize: 12)),
                Text('\$2,000+', style: TextStyle(color: Pallete.textSecondaryColor, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 48),
            
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
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Post Service Request',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.send),
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

