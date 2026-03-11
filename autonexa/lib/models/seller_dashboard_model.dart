class RecentOrderModel {
  final String id;
  final String orderNumber;
  final String title;
  final double price;
  final String status; // NEW, PROCESSING, SHIPPED
  final String iconCode;

  RecentOrderModel({
    required this.id,
    required this.orderNumber,
    required this.title,
    required this.price,
    required this.status,
    required this.iconCode,
  });

  factory RecentOrderModel.fromMap(Map<String, dynamic> map) {
    return RecentOrderModel(
      id: map['id'] ?? '',
      orderNumber: map['order_number'] ?? '',
      title: map['title'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      status: map['status'] ?? 'NEW',
      iconCode: map['icon_code'] ?? 'parts',
    );
  }
}

class SalesDailyModel {
  final String day;
  final double amount;

  SalesDailyModel({required this.day, required this.amount});
}

class SellerOverviewModel {
  final double totalSales;
  final double salesGrowth;
  final int ordersPending;
  final List<SalesDailyModel> weeklySales;
  final List<RecentOrderModel> recentOrders;

  SellerOverviewModel({
    required this.totalSales,
    required this.salesGrowth,
    required this.ordersPending,
    required this.weeklySales,
    required this.recentOrders,
  });
}

class InventoryProductModel {
  final String id;
  final String name;
  final String sku;
  final double price;
  final int stock;
  final String iconCode;

  InventoryProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.stock,
    required this.iconCode,
  });

  factory InventoryProductModel.fromMap(Map<String, dynamic> map) {
    return InventoryProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      sku: map['sku'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      stock: map['stock']?.toInt() ?? 0,
      iconCode: map['icon_code'] ?? 'parts',
    );
  }
}

class DetailedOrderModel {
  final String id;
  final String status;
  final String orderNumber;
  final String customerName;
  final String info;
  final String date;
  final double price;
  final String imageUrl;

  DetailedOrderModel({
    required this.id,
    required this.status,
    required this.orderNumber,
    required this.customerName,
    required this.info,
    required this.date,
    required this.price,
    required this.imageUrl,
  });

  factory DetailedOrderModel.fromMap(Map<String, dynamic> map) {
    return DetailedOrderModel(
      id: map['id'] ?? '',
      status: map['status'] ?? 'PENDING',
      orderNumber: map['order_number'] ?? '',
      customerName: map['customer_name'] ?? '',
      info: map['info'] ?? '',
      date: map['date'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      imageUrl: map['image_url'] ?? '',
    );
  }
}
