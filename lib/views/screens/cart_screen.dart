// import 'package:bloc_cubit_products/cubits/cart/cart_cubit.dart';
// import 'package:bloc_cubit_products/cubits/cart/cart_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class CartScreen extends StatefulWidget {
//   const CartScreen({super.key});

//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Cart Products"),
//       ),
//       body: BlocBuilder<CartCubit, CartState>(
//         builder: (context, state) {
//           if (state is InitialCartState) {
//             return const Center(
//               child: Text("Productlar mavjud emas"),
//             );
//           }
//           if (state is LoadingCartState) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (state is ErrorCartState) {
//             return Center(
//               child: Text(state.message),
//             );
//           }

//           final products = (state as LoadedCartState).cartProducts;

//           return ListView.builder(
//             itemCount: products!.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                   padding: const EdgeInsets.only(top: 15, bottom: 15),
//                   child: products[index].isFavorite
//                       ? ListTile(
//                           title: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 products[index].title,
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const Spacer(),
//                               IconButton(
//                                 onPressed: () {
//                                   context
//                                       .read<CartCubit>()
//                                       .deleteCartProducts(index);
//                                 },
//                                 icon: const Icon(
//                                   Icons.delete,
//                                   color: Colors.red,
//                                   size: 25,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           leading: Container(
//                             width: 70,
//                             height: 70,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(100),
//                             ),
//                             child: Image.network(
//                               products[index].imageUrl,
//                             ),
//                           ),
//                         )
//                       : null);
//             },
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:bloc_cubit_products/cubits/cart/cart_cubit.dart';
import 'package:bloc_cubit_products/cubits/cart/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Cart Products"),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is InitialCartState) {
            return const Center(
              child: Text("Productlar mavjud emas"),
            );
          }
          if (state is LoadingCartState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ErrorCartState) {
            return Center(
              child: Text(state.message),
            );
          }

          final products = (state as LoadedCartState).cartProducts;

          return ListView.builder(
            itemCount: products!.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: product.isFavorite
                    ? ListTile(
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              product.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                context
                                    .read<CartCubit>()
                                    .deleteCartProducts(index);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                        leading: Hero(
                          tag: 'product-image-${product.id}',
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
