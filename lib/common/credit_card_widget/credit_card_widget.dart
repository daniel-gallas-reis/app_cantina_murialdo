import 'package:app_cantina_murialdo/common/credit_card_widget/back_card_widget.dart';
import 'package:app_cantina_murialdo/common/credit_card_widget/front_card_widget.dart';
import 'package:app_cantina_murialdo/models/credit_card.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class CreditCardWidget extends StatefulWidget {

  const CreditCardWidget(this.creditCard);

  final CreditCard creditCard;

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  final FocusNode numberNode = FocusNode();

  final FocusNode dateNode = FocusNode();

  final FocusNode nameNode = FocusNode();

  final FocusNode cvvNode = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context){
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      actions: [
        KeyboardActionsItem(
          focusNode: numberNode,
          displayDoneButton: false,
        ),
        KeyboardActionsItem(
          focusNode: dateNode,
          displayDoneButton: false,
        ),
        KeyboardActionsItem(
          focusNode: nameNode,
          toolbarButtons: [
            (_){
              return GestureDetector(
                onTap: (){
                  cardKey.currentState.toggleCard();
                  cvvNode.requestFocus();
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Text('CONTINUAR'),
                ),
              );
            }
          ]
        ),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      config: _buildConfig(context),
      autoScroll: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FlipCard(
              key: cardKey,
              direction: FlipDirection.HORIZONTAL,
              flipOnTouch: false,
              speed: 700,
              front: FrontCardWidget(
                creditCard: widget.creditCard,
                numberNode: numberNode,
                dateNode: dateNode,
                nameNode: nameNode,
                finishedFront: (){
                  cardKey.currentState.toggleCard();
                  cvvNode.requestFocus();
                },
              ),
              back: BackCardWidget(
                creditCard: widget.creditCard,
                cvvNode: cvvNode,
              ),
            ),
            FlatButton.icon(
              padding: EdgeInsets.zero,
              onPressed: () {
                cardKey.currentState.toggleCard();
              },
              icon: Icon(
                Icons.threesixty_sharp,
                color: Theme.of(context).primaryColor,
              ),
              label: const Text('Virar Cartão'),
              textColor: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
