import 'package:bloc/bloc.dart';
import 'package:bloc_cubit_products/cubits/shop/shop_state.dart';
import 'package:bloc_cubit_products/data/models/shop_models.dart';
import 'package:flutter/material.dart';

class ShopCubits extends Cubit<ShopState> {
  ShopCubits() : super(InitialState());
  List<Product> products = [];

  Future<void> getProducts() async {
    try {
      emit(LoadingState());
      await Future.delayed(const Duration(seconds: 2));

      products.add(
        Product(
          id: UniqueKey().toString(),
          title: "Naushnik",
          imageUrl:
              "https://ae01.alicdn.com/kf/HTB1pvFocMjN8KJjSZFgq6zjbVXap/ZEALOT-B20-Hi-Fi-Bluetooth.jpg",
        ),
      );

      emit(LoadedState(products));
    } catch (e) {
      print("xatolik sodir bo'ldi");
      emit(ErrorState(""));
    }
  }

  Future<void> addProducts(String id, String title, String imageUrl) async {
    try {
      if (state is LoadedState) {
        products = (state as LoadedState).products;
      }

      emit(LoadingState());
      await Future.delayed(const Duration(seconds: 1));

      products.add(
        Product(
          id: id,
          title: title,
          imageUrl: imageUrl,
        ),
      );
      emit(LoadedState(products));
    } catch (e) {
      print("Mahsulot Qo'shishda xatolik");
      emit(ErrorState("Qo'shishda xatolik!"));
    }
  }

  Future<void> editProducts(
      String id, String newTitle, String newImageUrl) async {
    try {
      emit(LoadingState());
      await Future.delayed(const Duration(milliseconds: 500));

      final indexProduct = products.indexWhere((product) => product.id == id);
      if (indexProduct != -1) {
        products[indexProduct].title = newTitle;
        products[indexProduct].imageUrl = newImageUrl;
        emit(LoadedState(products));
      } else {
        emit(ErrorState("Product not found"));
      }
    } catch (e) {
      print("Edit qilishda xatolik: $e");
      emit(ErrorState("Edit qilishda xatolik"));
    }
  }

  Future<void> editIcon(String id) async {
    final indexProduct = products.indexWhere((product) => product.id == id);
    if (indexProduct != -1) {
      products[indexProduct].isFavorite = !products[indexProduct].isFavorite;
      emit(LoadedState(products));
    }
  }

  Future<void> deleteProducts(int index) async {
    await Future.delayed(const Duration(milliseconds: 500));
    products.removeAt(index);
    emit(LoadedState(products));
  }
}
