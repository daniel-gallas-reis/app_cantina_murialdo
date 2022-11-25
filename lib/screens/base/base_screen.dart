import 'dart:io';

import 'package:app_cantina_murialdo/common/custom_bottom_navigation_bar/custom_admin_bottom_navigation_bar.dart';
import 'package:app_cantina_murialdo/common/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:app_cantina_murialdo/common/custom_drawer/custom_drawer.dart';
import 'package:app_cantina_murialdo/models/page_manager.dart';
import 'package:app_cantina_murialdo/models/product_manager.dart';
import 'package:app_cantina_murialdo/models/user_manager.dart';
import 'package:app_cantina_murialdo/screens/admin_orders/admin_orders_screen.dart';
import 'package:app_cantina_murialdo/screens/admin_users/admin_users_screen.dart';
import 'package:app_cantina_murialdo/screens/cart/cart_screen.dart';
import 'package:app_cantina_murialdo/screens/edit_product/edit_product_screen.dart';
import 'package:app_cantina_murialdo/screens/home/home_screen.dart';
import 'package:app_cantina_murialdo/screens/my_account_screen/my_account_screen.dart';
import 'package:app_cantina_murialdo/screens/orders/orders_screen.dart';
import 'package:app_cantina_murialdo/screens/products/components/search_dialog.dart';
import 'package:app_cantina_murialdo/screens/products/products_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);

    configFCM();

  }

  void configFCM(){
    final fcm = FirebaseMessaging();

    if(Platform.isIOS){
      fcm.requestNotificationPermissions(
        const IosNotificationSettings(provisional: true)
      );
    }

    fcm.configure(
      onLaunch: (Map<String, dynamic> message) async{
        print('onlaunch');
      },
      onResume: (Map<String, dynamic> message) async{
        print('onresume');
      },
      onMessage: (Map<String, dynamic> message) async{
        showNotification(
            message['notification']['title'] as String,
            message['notification']['body'] as String,
        );
      }
    );
  }

  void showNotification(String title, String message){
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      backgroundColor: Colors.blueAccent,
      duration: const Duration(seconds: 5),
      icon: const Icon(Icons.shopping_cart, color: Colors.white),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __) {
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HomeScreen(),
              Scaffold(
                  bottomNavigationBar: userManager.adminEnabled
                      ? CustomAdminBottomNavigationBar()
                      : CustomBottomNavigationBar(),
                  drawer: CustomDrawer(),
                  backgroundColor: Theme.of(context).primaryColor,
                  appBar: AppBar(
                    centerTitle: false,
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
                        Consumer<ProductManager>(
                          builder: (_, productManager, __) {
                            if (productManager.search.isEmpty) {
                              return const Text(
                                'Produtos',
                                textAlign: TextAlign.center,
                              );
                            } else {
                              return GestureDetector(
                                onTap: () async {
                                  final search = await showDialog<String>(
                                      context: context,
                                      builder: (_) => SearchDialog(
                                            initialText: productManager.search,
                                          ));
                                  if (search != null) {
                                    productManager.search = search;
                                  }
                                },
                                child: Text(productManager.search),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    actions: [
                      Consumer<ProductManager>(
                        builder: (_, productManager, __) {
                          if (productManager.search.isEmpty) {
                            return IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () async {
                                final search = await showDialog<String>(
                                    context: context,
                                    builder: (_) => SearchDialog(
                                          initialText: productManager.search,
                                        ));
                                if (search != null) {
                                  productManager.search = search;
                                }
                              },
                            );
                          } else {
                            return IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () async {
                                productManager.search = '';
                              },
                            );
                          }
                        },
                      ),
                      Consumer<UserManager>(
                        builder: (_, userManager, __) {
                          if (userManager.adminEnabled) {
                            return IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => EditProductScreen(null)));
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                  body: ProductsScreen(),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Colors.white.withAlpha(450),
                    foregroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => CartScreen()));
                    },
                    child: const Icon(CupertinoIcons.shopping_cart),
                  )),
              OrdersScreen(),
              Scaffold(
                  bottomNavigationBar: userManager.adminEnabled
                      ? CustomAdminBottomNavigationBar()
                      : CustomBottomNavigationBar(),
                  drawer: CustomDrawer(),
                  appBar: AppBar(
                    actions: userManager.isLoggedIn
                        ? [
                            IconButton(
                                icon: const Icon(Icons.exit_to_app),
                                onPressed: () {
                                  userManager.signOut();
                                })
                          ]
                        : null,
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: const Color.fromRGBO(69, 55, 39, 1.0),
                    //rgb(69, 55, 39)
                    title: userManager.isLoggedIn
                        ? Text(
                            'Olá ${userManager.user.name}',
                            style: const TextStyle(color: Colors.white),
                          )
                        : Container(
                            height: 75,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                    'images/logo_cantina_branco.png')),
                          ),
                  ),
                  body: MyAccountScreen()),
              if (userManager.adminEnabled) ...[
                Scaffold(
                  bottomNavigationBar: CustomAdminBottomNavigationBar(),
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
                          height: 75,
                          child: Image.asset('images/logo_pequeno.png'),
                        ),
                        const Text(
                          'Usuários',
                        ),
                      ],
                    ),
                  ),
                  body: AdminUsersScreen(),
                ),
                AdminOrdersScreen(),
              ]
            ],
          );
        },
      ),
    );
  }
}
