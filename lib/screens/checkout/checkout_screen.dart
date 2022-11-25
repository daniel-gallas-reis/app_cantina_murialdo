import 'package:app_cantina_murialdo/common/credit_card_widget/credit_card_widget.dart';
import 'package:app_cantina_murialdo/common/price_card/price_card.dart';
import 'package:app_cantina_murialdo/models/cart_manager.dart';
import 'package:app_cantina_murialdo/models/checkout_manager.dart';
import 'package:app_cantina_murialdo/models/credit_card.dart';
import 'package:app_cantina_murialdo/models/order.dart';
import 'package:app_cantina_murialdo/screens/base/base_screen.dart';
import 'package:app_cantina_murialdo/screens/checkout/components/cpf_field.dart';
import 'package:app_cantina_murialdo/screens/confirmations/confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final CreditCard creditCard = CreditCard();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.payment),
              Text(
                'Pagamento ',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Consumer<CheckoutManager>(builder: (_, checkoutManager, __) {
            if (checkoutManager.loading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                    ),
                    Text(
                      'Processando o seu pagamento...',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              );
            }
            return Form(
              key: formKey,
              child: ListView(
                children: [
                  CreditCardWidget(creditCard),
                  CpfField(),
                  PriceCard(
                    buttonText: 'Finalizar pedido',
                    onPressed: () {
                      if(formKey.currentState.validate()) {
                        formKey.currentState.save();


                        checkoutManager.checkout(
                            creditCard: creditCard,
                            onFail: (e) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }, onPayFail: (e){
                                 scaffoldKey.currentState.showSnackBar(
                                   SnackBar(content: Text('$e'), backgroundColor: Colors.red,)
                                 );
                            }, onSuccess: (order) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => BaseScreen()));
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                                  ConfirmationScreen(order: order as Order)));
                        });
                      }
                    },
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
