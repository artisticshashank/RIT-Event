class TowingOverviewModel {
  final bool isOnline;
  final double revenue;
  final int activeDrivers;
  final int totalDrivers;
  final int pendingRequests;
  final int activeJobPins;
  final int liveTrucks;

  TowingOverviewModel({
    required this.isOnline,
    required this.revenue,
    required this.activeDrivers,
    required this.totalDrivers,
    required this.pendingRequests,
    required this.activeJobPins,
    required this.liveTrucks,
  });

  factory TowingOverviewModel.fromMap(Map<String, dynamic> map) {
    return TowingOverviewModel(
      isOnline: map['is_online'] ?? false,
      revenue: map['revenue']?.toDouble() ?? 0.0,
      activeDrivers: map['active_drivers']?.toInt() ?? 0,
      totalDrivers: map['total_drivers']?.toInt() ?? 0,
      pendingRequests: map['pending_requests']?.toInt() ?? 0,
      activeJobPins: map['active_job_pins']?.toInt() ?? 0,
      liveTrucks: map['live_trucks']?.toInt() ?? 0,
    );
  }
}

class TowingRequestModel {
  final String id;
  final String customerName;
  final String carInfo;
  final String issueType;
  final String issueColor; // 'orange', 'red', etc.
  final String distance;
  final double price;
  final String imageUrl;
  final String status;

  TowingRequestModel({
    required this.id,
    required this.customerName,
    required this.carInfo,
    required this.issueType,
    required this.issueColor,
    required this.distance,
    required this.price,
    required this.imageUrl,
    required this.status,
  });

  factory TowingRequestModel.fromMap(Map<String, dynamic> map) {
    return TowingRequestModel(
      id: map['id'] ?? '',
      customerName: map['customer_name'] ?? '',
      carInfo: map['car_info'] ?? '',
      issueType: map['issue_type'] ?? '',
      issueColor: map['issue_color'] ?? 'orange',
      distance: map['distance'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      imageUrl: map['image_url'] ?? '',
      status: map['status'] ?? 'PENDING',
    );
  }
}
