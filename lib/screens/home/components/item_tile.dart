import 'dart:io';
import 'package:app_cantina_murialdo/models/home_manager.dart';
import 'package:app_cantina_murialdo/models/product.dart';
import 'package:app_cantina_murialdo/models/product_manager.dart';
import 'package:app_cantina_murialdo/models/section.dart';
import 'package:app_cantina_murialdo/models/section_item.dart';
import 'package:app_cantina_murialdo/screens/product/product_screen.dart';
import 'package:app_cantina_murialdo/screens/select_product/select_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({@required this.item});

  final SectionItem item;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return GestureDetector(
      onTap: () {
        if (item.product != null) {
          final product =
              context.read<ProductManager>().findProductById(item.product);
          if (product != null) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ProductScreen(product: product)));
          }
        }
      },
      onLongPress: homeManager.editing
          ? () {
              showDialog(
                  context: context,
                  builder: (_) {
                    final product = context
                        .read<ProductManager>()
                        .findProductById(item.product);
                    return AlertDialog(
                      title: const Text('Editar Item'),
                      content: product != null
                          ? ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Image.network(product.images.first),
                              title: Text(product.name),
                              subtitle: Text(
                                  'R\$${product.basePrice.toStringAsFixed(2).replaceAll('.', ',')}'),
                            )
                          : null,
                      actions: [
                        FlatButton(
                          onPressed: () {
                            context.read<Section>().removeItem(item);
                            Navigator.of(context).pop();
                          },
                          textColor: Colors.red,
                          child: const Text(
                            'Excluir',
                          ),
                        ),
                        FlatButton(
                          onPressed: () async {
                            if (product != null) {
                              item.product = null;
                            } else {
                              final Product product =
                                  await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              SelectProductScreen())) as Product;
                              item.product = product?.id;
                            }
                            Navigator.of(context).pop();
                          },
                          textColor: Theme.of(context).primaryColor,
                          child: Text(
                            product != null ? 'Desvincular' : 'Vincular',
                          ),
                        ),
                      ],
                    );
                  });
            }
          : null,
      child: AspectRatio(
        aspectRatio: 1,
        child: item.image is String
            ? FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: item.image as String,
                fit: BoxFit.cover,
              )
            : Image.file(
                item.image as File,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
