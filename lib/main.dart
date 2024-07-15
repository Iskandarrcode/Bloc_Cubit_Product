import 'package:bloc_cubit_products/cubits/cart/cart_cubit.dart';
import 'package:bloc_cubit_products/cubits/shop/shop_cubits.dart';
import 'package:bloc_cubit_products/cubits/theme/theme_cubit.dart';
import 'package:bloc_cubit_products/views/screens/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return ShopCubits();
          },
        ),
        BlocProvider(
          create: (context) {
            return ThemeCubit();
          },
        ),
        BlocProvider(
          create: (context) {
            return CartCubit();
          },
        ),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (BuildContext context, bool state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                centerTitle: false,
              ),
            ),
            darkTheme: ThemeData.dark(),
            themeMode: state ? ThemeMode.dark : ThemeMode.light,
            home: const ShopScreen(),
          );
        },
      ),
    );
  }
}
