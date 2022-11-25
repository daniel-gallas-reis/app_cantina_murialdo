import 'package:app_cantina_murialdo/models/order.dart';
import 'package:flutter/material.dart';

class CancelOrderDialog extends StatelessWidget {

  const CancelOrderDialog({@required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Cancelar ${order.formatedId}',
      ),
      content: const Text('Esta ação não poderá ser desfeita!'),
      actions: [
        FlatButton(
          onPressed: (){
            order.cancel();
            Navigator.of(context).pop();
          },
          child: const Text('Confirmar', style: TextStyle(color: Colors.red),),
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
