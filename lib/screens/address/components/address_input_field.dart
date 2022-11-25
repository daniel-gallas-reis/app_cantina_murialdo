import 'package:app_cantina_murialdo/models/address.dart';
import 'package:app_cantina_murialdo/models/cart_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddressInputField extends StatelessWidget {
  const AddressInputField(this.address);

  final Address address;

  @override
  Widget build(BuildContext context) {
    String emptyValidator(String text) =>
        text.isEmpty ? 'Campo obrigatório' : null;
    final cartManager = context.watch<CartManager>();

    if (address.zipCode != null && cartManager.deliveryPrice == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            enabled: !cartManager.loading,
            initialValue: address.street,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Rua/Avenida',
              hintText: 'Av. Brasil',
            ),
            validator: emptyValidator,
            onSaved: (t) => address.street = t,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  enabled: !cartManager.loading,
                  initialValue: address.number,
                  decoration: const InputDecoration(
                      isDense: true, labelText: 'Número', hintText: '123'),
                  inputFormatters: [
                    // ignore: deprecated_member_use
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                  validator: emptyValidator,
                  onSaved: (t) => address.number = t,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  enabled: !cartManager.loading,
                  initialValue: address.complement,
                  decoration: const InputDecoration(
                      isDense: true,
                      labelText: 'Complemento',
                      hintText: 'Opcional'),
                  onSaved: (t) => address.complement = t,
                ),
              ),
            ],
          ),
          TextFormField(
            enabled: !cartManager.loading,
            initialValue: address.district,
            decoration: const InputDecoration(
                isDense: true, labelText: 'Bairro', hintText: 'Centro'),
            validator: emptyValidator,
            onSaved: (t) => address.district = t,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  enabled: false,
                  initialValue: address.city,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Cidade',
                    hintText: 'Caxias do Sul',
                  ),
                  validator: emptyValidator,
                  onSaved: (t) => address.city = t,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  autocorrect: false,
                  enabled: false,
                  textCapitalization: TextCapitalization.characters,
                  initialValue: address.state,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'UF',
                    hintText: 'RS',
                    counterText: '',
                  ),
                  maxLength: 2,
                  validator: (e) {
                    if (e.isEmpty) {
                      return 'Campo Obrigatório';
                    } else if (e.length != 2) {
                      return 'Inválido';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (t) => address.state = t,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: !cartManager.loading ? () async {
                if (Form.of(context).validate()) {
                  Form.of(context).save();
                  try {
                    await context.read<CartManager>().setAddress(address);
                  } catch (e) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red, content: Text('$e')));
                  }
                }
              } : null,
              child: !cartManager.loading ? const Text(
                'Calcular Frete',
              ) : LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                backgroundColor: Colors.transparent,
              ),
            ),
          )
        ],
      );
    } else if(address.zipCode != null){
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          '${address.city}, ${address.number}\n${address.district}\n'
              '${address.city} - ${address.state}',
        ),
      );
    }else{
      return Container();
    }
  }
}
