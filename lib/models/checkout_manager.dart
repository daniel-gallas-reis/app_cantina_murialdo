import 'package:app_cantina_murialdo/models/cart_manager.dart';
import 'package:app_cantina_murialdo/models/credit_card.dart';
import 'package:app_cantina_murialdo/models/order.dart';
import 'package:app_cantina_murialdo/models/product.dart';
import 'package:app_cantina_murialdo/services/rede_payment/rede_payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager cartManager;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  final Firestore firestore = Firestore.instance;

  final RedePayment redePayment = RedePayment();

  // ignore: use_setters_to_change_properties
  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  Future<void> checkout({CreditCard creditCard, Function onFail, Function onSuccess, onPayFail}) async{
    loading = true;

    final orderId = await _getOrderId();

    String payId;

    try {
      payId = await redePayment.authorize(
          creditCard: creditCard,
          price: cartManager.totalPrice,
          orderId: orderId.toString(),
          user: cartManager.user
      );

    }catch(e){
      onPayFail(e);
      loading = false;
      return;
    }


    try {
      await _decrementStock();
    }catch(e){
      onFail(e);
      loading = false;
      return;
    }

    try {
      print('chama a cap');
      String capId = await redePayment.capture(
          creditCard: creditCard,
          price: cartManager.totalPrice,
          orderId: orderId.toString(),
          user: cartManager.user,
          payId:payId
      );

    }catch(e){
      redePayment.cancel(
          creditCard: creditCard,
          price: cartManager.totalPrice,
          orderId: orderId.toString(),
          user: cartManager.user,
          payId:payId
      );
      print(e.toString());
      onPayFail(e);
      loading = false;
      return;
    }


    final order = Order.fromCartManager(cartManager);
    order.orderId = orderId.toString();
    order.payId = payId;

    await order.save();

    cartManager.clear();


    loading = false;
    onSuccess(order);
  }

  Future<int> _getOrderId() async {
    final ref = firestore.document('aux/ordercounter');

    try {
      final result = await firestore.runTransaction(
        (tx) async {
          final doc = await tx.get(ref);
          final orderId = doc.data['current'] as int;
          await tx.update(ref, {'current': orderId + 1});
          return {'orderId': orderId};
        },
      );
      return result['orderId'] as int;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar o número do pedido');
    }
  }

  Future<void> _decrementStock() async {
    return firestore.runTransaction((tx) async {
      final List<Product> productsToUpdate = [];
      final List<Product> productsWithoutStock = [];

      for (final cartProduct in cartManager.items) {
        Product product;

        if(productsToUpdate.any((p) => p.id == cartProduct.productId)){
          product = productsToUpdate.firstWhere((p) => p.id == cartProduct.productId);
        }else{
          final doc = await tx
              .get(firestore.document('products/${cartProduct.productId}'));
          product = Product.fromDocument(doc);
        }

        cartProduct.product = product;

        final flavor = product.findFlavor(cartProduct.flavor);
        if (flavor.stock - cartProduct.quantity < 0) {
          productsWithoutStock.add(product);
        } else {
          flavor.stock -= cartProduct.quantity;
          productsToUpdate.add(product);
        }
      }

      if (productsWithoutStock.isNotEmpty) {
        return Future.error(
            '${productsWithoutStock.length} produtos não tem estoque suficiente');
      }

      for (final products in productsToUpdate) {
        tx.update(firestore.document('products/${products.id}'),
            {'flavors': products.exportFlavorsList()});
      }
    });
  }
}
