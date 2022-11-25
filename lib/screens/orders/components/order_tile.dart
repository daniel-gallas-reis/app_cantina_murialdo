import 'package:app_cantina_murialdo/models/admin_users_manager.dart';
import 'package:app_cantina_murialdo/models/order.dart';
import 'package:app_cantina_murialdo/screens/orders/components/cancel_order_dialog.dart';
import 'package:app_cantina_murialdo/screens/orders/components/export_address_dialog.dart';
import 'package:app_cantina_murialdo/screens/orders/components/order_product_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({@required this.order, this.showControls = false});

  final Order order;
  final bool showControls;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.formatedId,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor),
                ),
                Text(
                  'R\$${order.price.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14),
                ),
                Consumer<AdminUsersManager>(
                    builder: (_, adminUsersManager, __){
                      return Container(
                        width: 90,
                        child: Text(
                          adminUsersManager.findName(order.userId).substring(0,12),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 12
                          ),
                        ),
                      );
                    },
                ),
              ],
            ),
            _buildCircle(order.status.index)
          ],
        ),
        children: [
          Column(
            children: order.items.map((e) {
              return OrderProductTile(e);
            }).toList(),
          ),
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (showControls && order.status != Status.canceled)
                    FlatButton(
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (_) => CancelOrderDialog(order: order,)
                        );
                      },
                      child: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                    ),
                  if (showControls && order.status != Status.canceled)
                    FlatButton(
                      onPressed: order.back,
                      child: Icon(
                        Icons.arrow_back,
                        color: order.status.index < 2
                            ? Colors.grey.withAlpha(300)
                            : Colors.blueAccent,
                      ),
                    ),
                  if (showControls && order.status != Status.canceled)
                    FlatButton(
                      onPressed: order.forward,
                      child: Icon(
                        Icons.arrow_forward,
                        color: order.status.index == 1 || order.status.index == 2
                            ? Colors.blueAccent
                            : Colors.grey.withAlpha(300),
                      ),
                    ),
                  FlatButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => ExportAddressDialog(order: order,)
                      );
                    },
                    child: Icon(
                      Icons.info,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildCircle(int status) {
    Color backColor;
    Widget child;
    String subtitle;

    if (status == 1) {
      backColor = Colors.blueAccent;
      subtitle = 'Preparando pedido';
      child = Stack(
        alignment: Alignment.center,
        children: const [
          Text(
            '1',
            style: const TextStyle(color: Colors.white),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ],
      );
    } else if (status == 2) {
      backColor = Colors.blueAccent;
      subtitle = 'Pedido em Transporte';
      child = Stack(
        alignment: Alignment.center,
        children: const [
          Text(
            '2',
            style: const TextStyle(color: Colors.white),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ],
      );
    } else if (status > 2) {
      subtitle = 'Pedido entregue';
      backColor = Colors.green;
      child = const Icon(Icons.check, color: Colors.white,);
    } else if (status == 0) {
      subtitle = 'Pedido Cancelado';
      backColor = Colors.red;
      child = const Icon(Icons.cancel);
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}
