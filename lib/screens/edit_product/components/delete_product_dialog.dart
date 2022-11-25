import 'package:app_cantina_murialdo/models/product.dart';
import 'package:app_cantina_murialdo/models/product_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteProductDialog extends StatelessWidget {

  const DeleteProductDialog({@required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Cancelar ${product.name}',
      ),
      content: const Text('Esta ação não poderá ser desfeita!'),
      actions: [
        FlatButton(
          onPressed: (){
            context.read<ProductManager>().delete(product);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: const Text('Deletar', style: TextStyle(color: Colors.red),),
        ),
        FlatButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: const Text('Voltar'),
        ),
      ],
    );
  }
}
