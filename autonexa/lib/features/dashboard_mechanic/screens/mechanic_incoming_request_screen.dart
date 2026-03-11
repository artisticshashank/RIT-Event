import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/models/service_request_model.dart';
import 'package:autonexa/models/enums.dart';
import 'package:autonexa/features/dashboard_mechanic/controller/mechanic_controller.dart';
import 'package:autonexa/features/dashboard_mechanic/screens/mechanic_navigation_screen.dart';

class MechanicIncomingRequestScreen extends ConsumerWidget {
  final ServiceRequestModel serviceRequest;

  const MechanicIncomingRequestScreen({
    super.key,
    required this.serviceRequest,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final acceptState = ref.watch(acceptJobProvider);
    final isLoading = acceptState is AsyncLoading;

    Future<void> onAccept() async {
      final success =
          await ref.read(acceptJobProvider.notifier).accept(serviceRequest.id);
      if (!context.mounted) return;
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MechanicNavigationScreen(
              serviceRequest: serviceRequest,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not accept request. Try again.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: isDark ? Colors.black54 : Colors.white54,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Column(
          children: [
            Text(
              'NEW JOB ALERT',
              style: TextStyle(
                color: Pallete.secondaryColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'Incoming Request',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: isDark ? Colors.black54 : Colors.white54,
              child: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map background
          Container(
            width: double.infinity,
            height: double.infinity,
            color: isDark
                ? const Color(0xFF1E2333)
                : Colors.blue.withValues(alpha: 0.12),
            child: Center(
              child: Icon(Icons.map,
                  size: 200,
                  color: isDark ? Colors.white10 : Colors.black12),
            ),
          ),

          // Map markers
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: MediaQuery.of(context).size.width * 0.4,
            child: CircleAvatar(
              backgroundColor: Pallete.secondaryColor.withValues(alpha: 0.3),
              radius: 30,
              child: const CircleAvatar(
                backgroundColor: Pallete.secondaryColor,
                radius: 20,
                child: Icon(Icons.location_on,
                    color: Colors.white, size: 20),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3 + 10,
            right: MediaQuery.of(context).size.width * 0.2,
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 22,
              child: CircleAvatar(
                backgroundColor: Color(0xFF2C3146),
                radius: 18,
                child: Icon(Icons.directions_car,
                    color: Colors.white, size: 16),
              ),
            ),
          ),

          // Bottom card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1D2D) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, -5)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Customer info + estimated earning
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                Pallete.secondaryColor.withValues(alpha: 0.2),
                            child: const Icon(Icons.person,
                                color: Pallete.secondaryColor, size: 30),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Customer',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Pallete.secondaryColor,
                                      size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Requires Assistance',
                                    style: TextStyle(
                                      color: Pallete.textSecondaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'ESTIMATED\nEARNING',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Pallete.secondaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            serviceRequest.price != null
                                ? '\$${serviceRequest.price!.toStringAsFixed(2)}'
                                : '\$—',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Job info grid
                  Row(
                    children: [
                      Expanded(
                          child: _buildInfoItem('VEHICLE',
                              serviceRequest.vehicleInfo ?? '—')),
                      Expanded(
                          child: _buildInfoItem('SERVICE',
                              serviceRequest.requestType.displayName)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          'DISTANCE',
                          serviceRequest.distanceKm != null
                              ? '${serviceRequest.distanceKm!.toStringAsFixed(1)} km'
                              : 'Nearby',
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem('ISSUE TYPE',
                            serviceRequest.issueType ?? '—'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Customer's description
                  if (serviceRequest.description != null &&
                      serviceRequest.description!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E2333)
                            : Colors.blue.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info, color: Colors.blue),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              serviceRequest.description!,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : Colors.black87,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Accept button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Accept Request',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Decline button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.black26,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cancel,
                              color: Pallete.textSecondaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Decline',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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

  Widget _buildInfoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Pallete.textSecondaryColor,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
