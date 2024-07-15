import 'package:bloc_cubit_products/data/models/shop_models.dart';

sealed class CartState {}

final class InitialCartState extends CartState {}

final class LoadingCartState extends CartState {}

final class LoadedCartState extends CartState {
  List<Product>? cartProducts;
  LoadedCartState(this.cartProducts);
}

final class ErrorCartState extends CartState {
  String message;
  ErrorCartState(this.message);
}
