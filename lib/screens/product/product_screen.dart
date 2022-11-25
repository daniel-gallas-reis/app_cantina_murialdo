import 'package:app_cantina_murialdo/models/cart_manager.dart';
import 'package:app_cantina_murialdo/models/product.dart';
import 'package:app_cantina_murialdo/models/user_manager.dart';
import 'package:app_cantina_murialdo/screens/cart/cart_screen.dart';
import 'package:app_cantina_murialdo/screens/edit_product/edit_product_screen.dart';
import 'package:app_cantina_murialdo/screens/login/login_screen.dart';
import 'package:app_cantina_murialdo/screens/product/components/flavor_widget.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({@required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        backgroundColor: Colors.white,
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
              Text(
                product.name,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.adminEnabled && !product.deleted) {
                  return IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => EditProductScreen(product)));
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: product.images.map((url) => NetworkImage(url)).toList(),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: Theme.of(context).primaryColor,
                autoplay: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'A partir de',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Text(
                    'R\$${product.basePrice.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                  if (product.deleted)
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'Produto Indisponível',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.red
                        ),
                      ),
                    )
                  else ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'Sabores',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: product.flavors.map((f) {
                        return FlavorWidget(flavor: f);
                      }).toList(),
                    ),
                  ],
                  const SizedBox(
                    height: 20,
                  ),
                  if (product.hasStock)
                    Consumer2<UserManager, Product>(
                      builder: (_, userManager, product, __) {
                        return SizedBox(
                          height: 44,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              onPressed: product.selectedFlavor != null
                                  ? () {
                                      if (userManager.isLoggedIn) {
                                        context
                                            .read<CartManager>()
                                            .addToCart(product);
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) => CartScreen()));
                                      } else {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) => LoginScreen()));
                                      }
                                    }
                                  : null,
                              child: Text(
                                userManager.isLoggedIn
                                    ? 'Adicionar ao Carrinho'
                                    : 'Entre para Comprar',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
