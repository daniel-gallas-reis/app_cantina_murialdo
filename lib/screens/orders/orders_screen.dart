import 'package:app_cantina_murialdo/common/custom_bottom_navigation_bar/custom_admin_bottom_navigation_bar.dart';
import 'package:app_cantina_murialdo/common/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:app_cantina_murialdo/common/custom_drawer/custom_drawer.dart';
import 'package:app_cantina_murialdo/common/empty_widget/empty_widget.dart';
import 'package:app_cantina_murialdo/common/login_card/login_card.dart';
import 'package:app_cantina_murialdo/models/orders_manager.dart';
import 'package:app_cantina_murialdo/models/user_manager.dart';
import 'package:app_cantina_murialdo/screens/orders/components/order_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<OrdersManager, UserManager>(
        builder: (_, ordersManager, userManager, __) {
          return Scaffold(
            bottomNavigationBar: userManager.adminEnabled
                ? CustomAdminBottomNavigationBar()
                : CustomBottomNavigationBar(),
            drawer: CustomDrawer(),
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: const Color.fromRGBO(69, 55, 39, 1.0),
              //rgb(69, 55, 39)
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    child: Image.asset('images/logo_pequeno.png'),
                  ),
                  const Text(
                    'Meus Pedidos',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            backgroundColor: ordersManager.user != null &&
                ordersManager.orders.isNotEmpty
                ? Theme
                .of(context)
                .primaryColor
                : Colors.white,
            body: Consumer<OrdersManager>(
              builder: (_, ordersManager, __) {
                if (ordersManager.user == null) {
                  return LoginCard();
                }
                if (ordersManager.orders.isEmpty) {
                  return const EmptyWidget(
                    title: 'Sem pedidos registrados',
                    iconData: Icons.layers_clear,
                  );
                }
                return ListView.builder(
                  itemCount: ordersManager.orders.length,
                  itemBuilder: (_, index) {
                    return OrderTile(order: ordersManager.orders.reversed.toList()[index],);
                  },
                );
              },
            ),
          );
        }
    );
  }
}