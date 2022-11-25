import 'package:app_cantina_murialdo/models/admin_users_manager.dart';
import 'package:app_cantina_murialdo/models/checkout_manager.dart';
import 'package:app_cantina_murialdo/models/order.dart';
import 'package:app_cantina_murialdo/services/rede_payment/rede_payment.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class ExportAddressDialog extends StatelessWidget {

  ExportAddressDialog({@required this.order});

  final Order order;

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Informações de Entrega'),
      content: Screenshot(
        controller: screenshotController,
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<AdminUsersManager>(
                  builder: (_, adminUserManager, __){
                    return Text(
                      '${adminUserManager.findName(order.userId)}\n'
                      'Pedido: ${order.formatedId}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      ),
                    );
                  },
              ),
              Text(
                order.address != null ?
                    '${order.address.street}, ${order.address.number} ${order.address.complement}\n'
                    '${order.address.district}\n'
                    '${order.address.city}/${order.address.state}\n'
                    '${order.address.zipCode}\n' '${order.date.toDate().day}/${order.date.toDate().month}/${order.date.toDate().year} - ${order.date.toDate().hour}:${order.date.toDate().minute}:${order.date.toDate().day}:${order.date.toDate().second}' :
                    'Turma/Setor: ${order.turma}\n'
                        '${order.date.toDate().day}/${order.date.toDate().month}/${order.date.toDate().year} - ${order.date.toDate().hour}:${order.date.toDate().minute}:${order.date.toDate().day}:${order.date.toDate().second}'
              ),
              Text(
                ' TID: ${order.payId}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
      actions: [
        FlatButton(
            onPressed: () async{
              Navigator.of(context).pop();
              final file = await screenshotController.capture();
              await GallerySaver.saveImage(file.path);
            },
            child: const Text('Exportar como imagem'),
        ),
      ],
    );
  }
}
