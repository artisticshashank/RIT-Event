import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/models/seller_dashboard_model.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';
import 'package:autonexa/features/dashboard_seller/repository/seller_repository.dart';

// ── Overview ─────────────────────────────────────────────────────────────────
final sellerOverviewProvider = FutureProvider<SellerOverviewModel>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) throw Exception('User is not authenticated');
  return ref.watch(sellerRepositoryProvider).fetchSellerOverview(user.id);
});

// ── Inventory ─────────────────────────────────────────────────────────────────
final sellerInventoryProvider = FutureProvider<List<InventoryProductModel>>((
  ref,
) async {
  final user = ref.watch(userProvider);
  if (user == null) throw Exception('User is not authenticated');
  return ref.watch(sellerRepositoryProvider).fetchInventory(user.id);
});

// ── Orders ────────────────────────────────────────────────────────────────────
final sellerOrdersProvider = FutureProvider<List<DetailedOrderModel>>((
  ref,
) async {
  final user = ref.watch(userProvider);
  if (user == null) throw Exception('User is not authenticated');
  return ref.watch(sellerRepositoryProvider).fetchOrders(user.id);
});

// ── Add Product action ────────────────────────────────────────────────────────
// Uses a simple AsyncNotifier (Riverpod v3 pattern) so screens can call
// ref.read(addProductProvider.notifier).addProduct(...) and watch loading state.
class AddProductNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> addProduct({
    required String sellerId,
    required String name,
    required String description,
    required double price,
    required int stock,
    String? sku,
    String? category,
  }) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(sellerRepositoryProvider);
      final success = await repo.addProduct(
        sellerId: sellerId,
        name: name,
        description: description,
        price: price,
        stock: stock,
        sku: sku,
        category: category,
      );
      state = const AsyncData(null);
      return success;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final addProductProvider = AsyncNotifierProvider<AddProductNotifier, void>(
  AddProductNotifier.new,
);

// ── Update Product action ───────────────────────────────────────────────────
class UpdateProductNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> updateProduct({
    required String productId,
    required String name,
    required String description,
    required double price,
    required int stock,
    String? sku,
    String? category,
  }) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(sellerRepositoryProvider);
      final success = await repo.updateProduct(
        productId: productId,
        name: name,
        description: description,
        price: price,
        stock: stock,
        sku: sku,
        category: category,
      );
      state = const AsyncData(null);
      return success;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final updateProductProvider =
    AsyncNotifierProvider<UpdateProductNotifier, void>(
      UpdateProductNotifier.new,
    );

// ── Update Order Status action ────────────────────────────────────────────────
class UpdateOrderStatusNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> updateStatus(String orderId, String newStatus) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(sellerRepositoryProvider);
      final success = await repo.updateOrderStatus(orderId, newStatus);
      state = const AsyncData(null);
      return success;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final updateOrderStatusProvider =
    AsyncNotifierProvider<UpdateOrderStatusNotifier, void>(
      UpdateOrderStatusNotifier.new,
    );

// ── Delete Product action ─────────────────────────────────────────────────────
class DeleteProductNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> delete(String productId) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(sellerRepositoryProvider);
      final success = await repo.deleteProduct(productId);
      state = const AsyncData(null);
      return success;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final deleteProductProvider =
    AsyncNotifierProvider<DeleteProductNotifier, void>(
      DeleteProductNotifier.new,
    );
