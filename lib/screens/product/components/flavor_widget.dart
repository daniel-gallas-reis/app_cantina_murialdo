import 'package:app_cantina_murialdo/models/item_flavor.dart';
import 'package:app_cantina_murialdo/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlavorWidget extends StatelessWidget {

  final ItemFlavor flavor;

  const FlavorWidget({@required this.flavor});

  @override
  Widget build(BuildContext context) {

    final product = context.watch<Product>();

    final selected = flavor == product.selectedFlavor;

    Color color;

    if(!flavor.temStock){
      color = Colors.red.withAlpha(50);
    }else if(selected){
      color = Theme.of(context).primaryColor;
    }else{
      color = Colors.grey;
    }

    return GestureDetector(
      onTap: (){
        if(flavor.temStock){
          product.selectedFlavor = flavor;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color
          )
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                color: color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                flavor.name,
                style: const TextStyle(
                  color: Colors.white
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'R\$${flavor.price.toStringAsFixed(2).replaceAll('.', ',')}',
                style: TextStyle(
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
