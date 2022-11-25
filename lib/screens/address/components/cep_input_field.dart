import 'package:app_cantina_murialdo/common/custom_icon_buttom/custom_icon_button.dart';
import 'package:app_cantina_murialdo/models/address.dart';
import 'package:app_cantina_murialdo/models/cart_manager.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatefulWidget {

  CepInputField(this.address, this.classController);

  TextEditingController classController;

  final Address address;

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {

  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final cartManager = context.watch<CartManager>();

    if (widget.address.zipCode == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer<CartManager>(
              builder: (_, cartManager, __){
                return TextFormField(
                  enabled: cartManager.class1 == null || cartManager.loading,
                  controller: cepController,
                  decoration: const InputDecoration(
                      isDense: true, labelText: 'CEP', hintText: '12.345-78'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    // ignore: deprecated_member_use
                    WhitelistingTextInputFormatter.digitsOnly,
                    CepInputFormatter(),
                  ],
                  validator: (cep) {
                    if (cep.isEmpty) {
                      return 'Campo Obrigatório!';
                    } else if (cep.length != 10) {
                      return 'CEP inválido!';
                    } else {
                      return null;
                    }
                  },
                );
              },
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: RaisedButton(
              onPressed: !cartManager.loading ? () async{
                widget.classController.clear();
                if (Form.of(context).validate()) {
                  try {
                    await context.read<CartManager>().getAddress(cepController.text);
                  } catch(e){
                    Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red, content: Text('$e')));
                  }
                }
              } : null,
              color: Theme.of(context).primaryColor,
              disabledColor: Theme.of(context).primaryColor.withAlpha(100),
              child: !cartManager.loading ? const Text(
                'Buscar CEP',
                style: TextStyle(color: Colors.white),
              ) : LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                    backgroundColor: Colors.transparent,
                  ),
            ),
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'CEP: ${widget.address.zipCode}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              size: 20,
              color: Theme.of(context).primaryColor,
              onTap: (){
                context.read<CartManager>().removeAddress();
              },
            )
          ],
        ),
      );
    }
  }
}
