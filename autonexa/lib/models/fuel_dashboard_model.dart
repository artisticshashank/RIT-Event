class FuelStationOverviewModel {
  final int activeRequests;
  final String activeGrowth;
  final int doneRequests;
  final String doneGrowth;
  final double revenue;
  final String revenueGrowth;

  FuelStationOverviewModel({
    required this.activeRequests,
    required this.activeGrowth,
    required this.doneRequests,
    required this.doneGrowth,
    required this.revenue,
    required this.revenueGrowth,
  });
}

class FuelRequestModel {
  final String id;
  final String customerName;
  final String carInfo;
  final String distance;
  final String fuelQuantity;
  final double price;
  final String status;
  final String fuelType;
  final String imageUrl;

  FuelRequestModel({
    required this.id,
    required this.customerName,
    required this.carInfo,
    required this.distance,
    required this.fuelQuantity,
    required this.price,
    required this.status,
    required this.fuelType,
    required this.imageUrl,
  });

  factory FuelRequestModel.fromMap(Map<String, dynamic> map) {
    return FuelRequestModel(
      id: map['id'] ?? '',
      customerName: map['customer_name'] ?? '',
      carInfo: map['car_info'] ?? '',
      distance: map['distance'] ?? '',
      fuelQuantity: map['fuel_quantity'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      status: map['status'] ?? 'NEW',
      fuelType: map['fuel_type'] ?? '',
      imageUrl: map['image_url'] ?? '',
    );
  }
}
