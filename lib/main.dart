import 'package:app_cantina_murialdo/models/admin_orders_manager.dart';
import 'package:app_cantina_murialdo/models/admin_users_manager.dart';
import 'package:app_cantina_murialdo/models/cart_manager.dart';
import 'package:app_cantina_murialdo/models/home_manager.dart';
import 'package:app_cantina_murialdo/models/orders_manager.dart';
import 'package:app_cantina_murialdo/models/product_manager.dart';
import 'package:app_cantina_murialdo/models/user_manager.dart';
import 'package:app_cantina_murialdo/screens/base/base_screen.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  runApp(MyApp());
  
  /*final response = await CloudFunctions.instance.getHttpsCallable(functionName: 'addMessage').call(
    {"teste" : "Daniel"}
  );
  print(response.data);*/
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(create: (_) => ProductManager(), lazy: false),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) =>
              ordersManager..updateUser(userManager.user),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          update: (_, userManager, adminUsersManager) =>
          adminUsersManager..updateUser(userManager),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          update: (_, userManager, adminOrdersManager) =>
          adminOrdersManager..updateAdmin(userManager.adminEnabled),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App Cantina Murialdo',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            elevation: 0,
          ),
          primaryColor: const Color.fromRGBO(69, 55, 39, 1.0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BaseScreen() /*LoginScreen()*/,
      ),
    );
  }
}
