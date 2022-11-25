import 'package:app_cantina_murialdo/common/credit_card_widget/components/card_text_field.dart';
import 'package:app_cantina_murialdo/models/credit_card.dart';
import 'package:brasil_fields/formatter/cartao_bancario_input_formatter.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FrontCardWidget extends StatelessWidget {
  final dateFormatter = MaskTextInputFormatter(
      mask: '!#/##', filter: {'#': RegExp('[0-9]'), '!': RegExp('[0-1]')});

  FrontCardWidget(
      {this.dateNode,
      this.nameNode,
      this.numberNode,
      this.finishedFront,
      this.creditCard});

  final FocusNode numberNode;
  final FocusNode dateNode;
  final FocusNode nameNode;
  final VoidCallback finishedFront;
  final CreditCard creditCard;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 16,
      child: Container(
        padding: const EdgeInsets.all(24),
        height: 200,
        color: const Color(0xFF81259D),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CardTextField(
                    initialValue: creditCard.number,
                    title: 'Número do Cartão',
                    hint: '0000 0000 0000 0000',
                    textInputType: TextInputType.number,
                    bold: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CartaoBancarioInputFormatter(),
                    ],
                    focusNode: numberNode,
                    onSubmited: (_) {
                      dateNode.requestFocus();
                    },
                    validator: (number) {
                      if (number == null || detectCCType(number) ==
                          CreditCardType.unknown) {
                        return 'Inválido';
                      } else {
                        return null;
                      }
                    },
                    onSaved: creditCard.setNumber,
                  ),
                  CardTextField(
                    initialValue: creditCard.expirationDate,
                    focusNode: dateNode,
                    title: 'Validade',
                    hint: '10/23',
                    textInputType: TextInputType.datetime,
                    inputFormatters: [dateFormatter],
                    onSubmited: (_) {
                      nameNode.requestFocus();
                    },
                    validator: (date) {
                      if (date == null || date.length != 5) {
                        return 'Inválido';
                      } else {
                        return null;
                      }
                    },
                    onSaved: creditCard.setExpirationDate,
                  ),
                  CardTextField(
                    initialValue: creditCard.holder,
                    focusNode: nameNode,
                    title: 'Nome do Titular',
                    hint: 'João da Silva',
                    bold: true,
                    textInputType: TextInputType.text,
                    onSubmited: (_) {
                      finishedFront();
                    },
                    validator: (name) {
                      if (name == null) {
                        return 'Inválido';
                      } else {
                        return null;
                      }
                    },
                    onSaved: creditCard.setHolder,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
