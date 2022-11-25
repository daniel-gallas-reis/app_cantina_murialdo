import 'package:app_cantina_murialdo/models/order.dart';
import 'package:app_cantina_murialdo/screens/orders/components/order_product_tile.dart';
import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {

  const ConfirmationScreen({@required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
              'Pedido ${order.formatedId} Confirmado',
              textAlign: TextAlign.center,
            ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.zero,
            margin: const EdgeInsets.only(top: 25),
            child: Image.asset(
              'images/logo_cantina_branco.png',
            ),
          ),
          Center(
            child: Card(
              margin: const EdgeInsets.all(16),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.formatedId,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor
                            ),
                          ),
                          Text(
                            'R\$${order.price.toStringAsFixed(2).replaceAll('.', ',')}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black
                            ),
                          )
                        ],
                      ),
                  ),
                  Column(
                    children: order.items.map((e){
                      return OrderProductTile(e);
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
