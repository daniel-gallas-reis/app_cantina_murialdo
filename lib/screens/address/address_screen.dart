import 'package:app_cantina_murialdo/common/price_card/price_card.dart';
import 'package:app_cantina_murialdo/models/cart_manager.dart';
import 'package:app_cantina_murialdo/screens/address/components/address_card.dart';
import 'package:app_cantina_murialdo/screens/address/components/class_card.dart';
import 'package:app_cantina_murialdo/screens/checkout/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatelessWidget {
  final classController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.local_shipping),
            Text(
              'Entrega ',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AddressCard(classController),
          ClassCard(classController),
          Consumer<CartManager>(
            builder: (_, cartManager, __) {
              return PriceCard(
                buttonText: 'Continuar para Pagamento',
                onPressed: cartManager.isAddressValid
                    ? () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => CheckoutScreen()));
                      }
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
