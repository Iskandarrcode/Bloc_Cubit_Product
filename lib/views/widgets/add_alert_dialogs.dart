import 'package:bloc_cubit_products/cubits/shop/shop_cubits.dart';
import 'package:bloc_cubit_products/cubits/shop/shop_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertDialogs extends StatefulWidget {
  final int index;
  final bool isAdd;

  const AlertDialogs({super.key, required this.isAdd, required this.index});

  @override
  State<AlertDialogs> createState() => _AlertDialogsState();
}

class _AlertDialogsState extends State<AlertDialogs> {
  final titleTextController = TextEditingController();
  final imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (!widget.isAdd) {
      final products =
          (context.read<ShopCubits>().state as LoadedState).products;
      final product = products[widget.index];
      titleTextController.text = product.title;
      imageUrlController.text = product.imageUrl;
    }
  }

  @override
  void dispose() {
    if (!widget.isAdd) {
      titleTextController.dispose();
      imageUrlController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: AlertDialog(
          title: Text(widget.isAdd ? "Add Product" : "Edit Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Title",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: titleTextController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelStyle: const TextStyle(color: Colors.grey),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Input Title";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "ImageUrl",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: imageUrlController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelStyle: const TextStyle(color: Colors.grey),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Input ImageUrl";
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
            BlocConsumer<ShopCubits, ShopState>(
              listener: (context, state) {
                if (state is ErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is LoadingState) {
                  return const CircularProgressIndicator();
                }
                return TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.isAdd) {
                        context.read<ShopCubits>().addProducts(
                              UniqueKey().toString(),
                              titleTextController.text,
                              imageUrlController.text,
                            );
                      } else {
                        context.read<ShopCubits>().editProducts(
                              (state as LoadedState).products[widget.index].id,
                              titleTextController.text,
                              imageUrlController.text,
                            );
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.isAdd ? "Add" : "Edit"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
