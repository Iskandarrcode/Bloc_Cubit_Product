import 'package:bloc_cubit_products/data/models/shop_models.dart';

sealed class ShopState {}

final class InitialState extends ShopState {}

final class LoadingState extends ShopState {}

final class LoadedState extends ShopState {
  List<Product> products;
  LoadedState(this.products);
}

final class ErrorState extends ShopState {
  String message;
  ErrorState(this.message);
}
