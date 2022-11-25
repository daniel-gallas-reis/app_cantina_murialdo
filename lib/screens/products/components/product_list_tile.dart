import 'package:app_cantina_murialdo/models/product.dart';
import 'package:app_cantina_murialdo/screens/product/product_screen.dart';
import 'package:flutter/material.dart';

class ProductsListTile extends StatelessWidget {

  const ProductsListTile({@required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductScreen(product: product)));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(product.images.first),
              ),
              const SizedBox(width: 16,),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'A partir de',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        'R\$${product.basePrice.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      if(!product.hasStock)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'Sem estoque disponível',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red
                            ),
                          ),
                        ),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
