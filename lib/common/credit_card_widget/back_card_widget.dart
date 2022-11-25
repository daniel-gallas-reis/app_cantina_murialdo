import 'package:app_cantina_murialdo/common/credit_card_widget/components/card_text_field.dart';
import 'package:app_cantina_murialdo/models/credit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BackCardWidget extends StatelessWidget {

  const BackCardWidget({this.cvvNode, this.creditCard});

  final FocusNode cvvNode;

  final CreditCard creditCard;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 16,
      child: Container(
        height: 200,
        color: const Color(0xFF81259D),
        child: Column(
          children: [
            Container(
              color: Colors.black,
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 16),
            ),
            Row(
              children: [
                Expanded(
                  flex: 70,
                  child: Container(
                    margin: const EdgeInsets.only(left: 12),
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    color: Colors.grey[500],
                    child: CardTextField(
                      initialValue: creditCard.securityCode,
                      focusNode: cvvNode,
                      title: null,
                      hint: '123',
                      maxLength: 3,
                      textAlign: TextAlign.end,
                      textInputType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (cvv){
                          if(cvv == null || cvv.length != 3){
                            return 'Inválido';
                          }else{
                            return null;
                          }
                      },
                      onSaved: creditCard.setCVV,
                    ),
                  ),
                ),
                Expanded(
                  flex: 30,
                  child: Container(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
