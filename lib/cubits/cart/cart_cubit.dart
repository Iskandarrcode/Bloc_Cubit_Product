import 'package:bloc_cubit_products/cubits/cart/cart_state.dart';
import 'package:bloc_cubit_products/data/models/shop_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(InitialCartState());
  List<Product> cartProducts = [];

  Future<void> getCartProducts() async {
    try {
      emit(LoadingCartState());
      await Future.delayed(const Duration(microseconds: 400));
      emit(LoadedCartState(cartProducts));
    } catch (e) {
      print("Cart Producatlari kelishida xatolik");
      emit(ErrorCartState("Cartdagi producatlarni kelishida xatolik"));
    }
  }

  Future<void> addCartProducts(Product product) async {
    try {
      cartProducts.add(product);

      emit(LoadedCartState(cartProducts));
    } catch (e) {
      print("cart ga maxsulot qo'shishda xatolik");
      emit(ErrorCartState("Cartga maxsulot qo'shishda xatolik"));
    }
  }

  Future<void> deleteCartProducts(int index) async {
    await Future.delayed(const Duration(microseconds: 300));
    cartProducts.removeAt(index);
    emit(LoadedCartState(cartProducts));
  }
}
