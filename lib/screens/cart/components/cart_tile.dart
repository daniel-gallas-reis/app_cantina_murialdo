import 'package:app_cantina_murialdo/common/custom_icon_buttom/custom_icon_button.dart';
import 'package:app_cantina_murialdo/models/cart_product.dart';
import 'package:app_cantina_murialdo/screens/product/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;

  const CartTile({@required this.cartProduct});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cartProduct,
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductScreen(product: cartProduct.product)));
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.network(cartProduct.product.images.first),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartProduct.product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Sabor: ${cartProduct.flavor}',
                            style: const TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                        Consumer<CartProduct>(
                          builder: (_, cartProduct, __) {
                            if (cartProduct.hasStock) {
                              return Text(
                                'R\$${cartProduct.unitPrice.toStringAsFixed(2).replaceAll('.', ',')}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            } else {
                              return const Text('Sem Estoque Disponível',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Consumer<CartProduct>(
                  builder: (_, cartProduct, __) {
                    return Column(
                      children: [
                        CustomIconButton(
                            iconData: Icons.add,
                            color: Theme.of(context).primaryColor,
                            onTap: cartProduct.increment),
                        Text(
                          '${cartProduct.quantity}',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        CustomIconButton(
                            iconData: Icons.remove,
                            color: cartProduct.quantity > 1
                                ? Theme.of(context).primaryColor
                                : Colors.red,
                            onTap: cartProduct.decrement),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
