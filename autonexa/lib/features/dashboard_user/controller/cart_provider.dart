import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/models/spare_part_model.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';
import 'package:autonexa/models/user_model.dart';
import 'package:autonexa/core/providers/supabase_provider.dart';

class CartNotifier extends Notifier<List<Map<String, dynamic>>> {
  @override
  List<Map<String, dynamic>> build() => [];

  void addToCart(SparePartModel part) {
    final existingIndex = state.indexWhere((item) => item['part'].id == part.id);
    if (existingIndex >= 0) {
      final newState = List<Map<String, dynamic>>.from(state);
      newState[existingIndex]['quantity'] += 1;
      state = newState;
    } else {
      state = [...state, {'part': part, 'quantity': 1}];
    }
  }

  void incrementQuantity(int index) {
    final newState = List<Map<String, dynamic>>.from(state);
    newState[index]['quantity'] += 1;
    state = newState;
  }

  void decrementQuantity(int index) {
    if (state[index]['quantity'] > 1) {
      final newState = List<Map<String, dynamic>>.from(state);
      newState[index]['quantity'] -= 1;
      state = newState;
    }
  }

  void removeItem(int index) {
    final newState = List<Map<String, dynamic>>.from(state);
    newState.removeAt(index);
    state = newState;
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<Map<String, dynamic>>>(() {
  return CartNotifier();
});

class UserAddressNotifier extends Notifier<String> {
  @override
  String build() {
    final user = ref.watch(userProvider);
    return user?.address ?? "123 Main St, Springfield, IL 62701";
  }
  
  Future<void> updateAddress(String address) async {
    state = address;
    final user = ref.read(userProvider);
    if (user != null) {
      await ref.read(supabaseProvider).from('users').update({
        'address': address,
      }).eq('id', user.id);
      
      // Update local user state
      ref.read(userProvider.notifier).update((state) => state?.copyWith(address: address));
    }
  }
}

final userAddressProvider = NotifierProvider<UserAddressNotifier, String>(() {
  return UserAddressNotifier();
});
