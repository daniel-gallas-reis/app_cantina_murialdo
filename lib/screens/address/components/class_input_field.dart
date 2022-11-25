import 'package:app_cantina_murialdo/common/custom_icon_buttom/custom_icon_button.dart';
import 'package:app_cantina_murialdo/models/cart_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ClassInputField extends StatelessWidget {

  ClassInputField(this.classController);

  TextEditingController classController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<CartManager>(
        builder: (_, cartManager, __){

          if(cartManager.class1 == null) {
            return Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Consumer<CartManager>(
                    builder: (_, cartManager, __) {
                      return TextFormField(
                        enabled: cartManager.address == null,
                        controller: classController,
                        decoration: const InputDecoration(
                            isDense: true,
                            labelText: 'Turma/Setor',
                            hintText: '71, 81, 101, 201, 301, Secretaria, Biblioteca...'
                        ),
                        inputFormatters: [
                          // ignore: deprecated_member_use
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        validator: (t) {
                          if (t.isEmpty) {
                            return 'Preencha o campo com sua turma!';
                          } else {
                            return null;
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 8,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: RaisedButton(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          context.read<CartManager>().getClass(classController.text);
                        }
                      },
                      child: const Text(
                        'Confirmar Turma',
                      ),
                    ),
                  ),
                ],
              ),
            );
          }else{
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Turma: ${cartManager.class1}',
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
                      classController.clear();
                      cartManager.removeAddress();
                    },
                  )
                ],
              ),
            );
          }
        },
    );
  }
}
