import 'package:app_cantina_murialdo/common/empty_widget/empty_widget.dart';
import 'package:app_cantina_murialdo/common/login_card/login_card.dart';
import 'package:app_cantina_murialdo/common/price_card/price_card.dart';
import 'package:app_cantina_murialdo/models/cart_manager.dart';
import 'package:app_cantina_murialdo/screens/address/address_screen.dart';
import 'package:app_cantina_murialdo/screens/cart/components/cart_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const Text(
              'Carrinho',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
          if(cartManager.user == null){
            return LoginCard();
          }

          if(cartManager.items.isEmpty){
            return const EmptyWidget(
              iconData: Icons.remove_shopping_cart,
              title: 'Carrinho Vazio',);
          }

          return ListView(children: [
            Column(
              children: cartManager.items
                  .map((cartProduct) => CartTile(cartProduct: cartProduct))
                  .toList(),
            ),
            PriceCard(
              buttonText: 'Confirmar Pedido',
              onPressed: cartManager.isCartValid
                  ? () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AddressScreen()));
                    }
                  : null,
            ),
          ]);
        },
      ),
    );
  }
}
