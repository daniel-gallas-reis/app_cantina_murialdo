import 'package:app_cantina_murialdo/models/product_manager.dart';
import 'package:app_cantina_murialdo/screens/products/components/product_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductManager>(
      builder: (_, productManager, __){
        final filteredProducts =productManager.filteredProducts;
        return ListView.builder(
          itemCount: filteredProducts.length,
          itemBuilder: (_, index){
            return ProductsListTile(product: filteredProducts[index]);
          },
        );
      },
    );
  }
}
