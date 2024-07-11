import 'package:bloc_cubit_products/cubits/shop/shop_cubits.dart';
import 'package:bloc_cubit_products/cubits/shop/shop_state.dart';
import 'package:bloc_cubit_products/views/widgets/add_alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritScreen extends StatefulWidget {
  const FavoritScreen({super.key});

  @override
  State<FavoritScreen> createState() => _FavoritScreenState();
}

class _FavoritScreenState extends State<FavoritScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Favorites",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<ShopCubits, ShopState>(
        builder: (context, state) {
          if (state is InitialState) {
            return const Center(
              child: Text("Productlar mavjud emas"),
            );
          }
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ErrorState) {
            return Center(
              child: Text(state.message),
            );
          }

          final products = (state as LoadedState).products;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: products[index].isFavorite
                      ? ListTile(
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                products[index].title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              BlocBuilder<ShopCubits, ShopState>(
                                  builder: (context, states) {
                                return IconButton(
                                  onPressed: () {
                                    context
                                        .read<ShopCubits>()
                                        .editIcon(products[index].id);
                                  },
                                  icon: Icon(
                                    products[index].isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 25,
                                    color: Colors.red,
                                  ),
                                );
                              }),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialogs(
                                        index: index,
                                        isAdd: false,
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                  size: 25,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  context
                                      .read<ShopCubits>()
                                      .deleteProducts(index);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                          leading: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Image.network(
                              products[index].imageUrl,
                            ),
                          ),
                        )
                      : null);
            },
          );
        },
      ),
    );
  }
}
