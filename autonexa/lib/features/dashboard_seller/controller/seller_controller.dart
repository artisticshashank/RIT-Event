import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/models/seller_dashboard_model.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';
import 'package:autonexa/features/dashboard_seller/repository/seller_repository.dart';

final sellerOverviewProvider = FutureProvider<SellerOverviewModel>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) {
    throw Exception('User is not authenticated');
  }

  final repository = ref.watch(sellerRepositoryProvider);
  return repository.fetchSellerOverview(user.id);
});

final sellerInventoryProvider = FutureProvider<List<InventoryProductModel>>((
  ref,
) async {
  final user = ref.watch(userProvider);
  if (user == null) {
    throw Exception('User is not authenticated');
  }

  final repository = ref.watch(sellerRepositoryProvider);
  return repository.fetchInventory(user.id);
});

final sellerOrdersProvider = FutureProvider<List<DetailedOrderModel>>((
  ref,
) async {
  final user = ref.watch(userProvider);
  if (user == null) {
    throw Exception('User is not authenticated');
  }

  final repository = ref.watch(sellerRepositoryProvider);
  return repository.fetchOrders(user.id);
});
