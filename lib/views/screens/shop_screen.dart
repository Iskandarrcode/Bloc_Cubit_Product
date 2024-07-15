import 'package:bloc_cubit_products/cubits/cart/cart_cubit.dart';
import 'package:bloc_cubit_products/cubits/shop/shop_cubits.dart';
import 'package:bloc_cubit_products/cubits/shop/shop_state.dart';
import 'package:bloc_cubit_products/cubits/theme/theme_cubit.dart';
import 'package:bloc_cubit_products/views/screens/cart_screen.dart';
import 'package:bloc_cubit_products/views/screens/favorit_screen.dart';
import 'package:bloc_cubit_products/views/widgets/add_alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool isTapped = false;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      context.read<ShopCubits>().getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Products",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const FavoritScreen();
                },
              ));
            },
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              child: Row(
                children: [
                  Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SwitchListTile(
              title: const Text('Dark mode'),
              value: themeCubit.state,
              onChanged: (value) => themeCubit.toggleTheme(),
            ),
          ],
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
                child: ZoomTapAnimation(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('Mahsulotni qo\'shish'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(products[index].imageUrl,
                                  height: 100, width: 100),
                              const SizedBox(height: 10),
                              Text(
                                products[index].title,
                                style: const TextStyle(fontSize: 25),
                              ),
                            ],
                          ),
                          actions: [
                            Row(
                              children: [
                                TextButton(
                                  child: const Text('Chiqish'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  child: const Text("Qo'shish"),
                                  onPressed: () {
                                    context.read<CartCubit>().addCartProducts(
                                          products[index],
                                        );
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: ListTile(
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
                            context.read<ShopCubits>().deleteProducts(index);
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
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const CartScreen();
                },
              ));
            },
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialogs(
                    index: 0,
                    isAdd: true,
                  );
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
