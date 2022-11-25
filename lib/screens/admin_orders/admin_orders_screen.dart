import 'package:app_cantina_murialdo/common/custom_bottom_navigation_bar/custom_admin_bottom_navigation_bar.dart';
import 'package:app_cantina_murialdo/common/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:app_cantina_murialdo/common/custom_drawer/custom_drawer.dart';
import 'package:app_cantina_murialdo/common/custom_icon_buttom/custom_icon_button.dart';
import 'package:app_cantina_murialdo/common/empty_widget/empty_widget.dart';
import 'package:app_cantina_murialdo/models/admin_orders_manager.dart';
import 'package:app_cantina_murialdo/models/order.dart';
import 'package:app_cantina_murialdo/models/user_manager.dart';
import 'package:app_cantina_murialdo/screens/orders/components/order_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AdminOrdersScreen extends StatefulWidget {

  @override
  _AdminOrdersScreenState createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<AdminOrdersManager, UserManager>(
        builder: (_, adminOrdersManager, userManager, __) {
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
                'Pedidos',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Consumer<AdminOrdersManager>(
          builder: (_, ordersManager, __) {
            final filteredOrders = ordersManager.filteredOrders;

            return SlidingUpPanel(
              controller: panelController,
              body: Column(
                children: [
                  if (ordersManager.userFilter != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Pedido de ${ordersManager.userFilter.name}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                          ),
                          CustomIconButton(
                            iconData: Icons.close,
                            color: Colors.white,
                            onTap: () {
                              ordersManager.setUserFilter(null);
                            },
                          ),
                        ],
                      ),
                    ),
                  if (filteredOrders.isEmpty)
                    const Expanded(
                      child: Card(
                        child: EmptyWidget(
                          title: 'Sem pedidos registrados',
                          iconData: Icons.layers_clear,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredOrders.length,
                        itemBuilder: (_, index) {
                          return OrderTile(
                            order: filteredOrders.reversed.toList()[index],
                            showControls: true,
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 120,)
                ],
              ),
              renderPanelSheet: false,
              maxHeight: 250,
              minHeight: 40,
              panel: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          if(panelController.isPanelClosed){
                            panelController.open();
                          }else{
                            panelController.close();
                          }
                        },
                        child: Container(
                          height: 40,
                          color: Colors.blueAccent,
                          alignment: Alignment.center,
                          child: const Text(
                            'Filtros',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: Status.values.map((s){
                              return CheckboxListTile(
                                  title: Text(Order.getStatusText(s)),
                                  value: ordersManager.statusFilter.contains(s),
                                  onChanged: (v){
                                    ordersManager.setStatusFilter(
                                      status: s,
                                      enabled: v
                                    );
                                  },
                                  dense: true,
                              );
                            }).toList(),
                          ),
                      ),
                      Divider(thickness: 10, color: Theme.of(context).primaryColor,)
                    ],
                  ),
                ),
              )
            );
          },
        ),
      );
    });
  }
}
