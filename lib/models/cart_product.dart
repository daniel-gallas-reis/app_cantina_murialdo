import 'package:app_cantina_murialdo/models/item_flavor.dart';
import 'package:app_cantina_murialdo/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CartProduct extends ChangeNotifier {
  Product _product;

  Product get product => _product;

  set product(Product value) {
    _product = value;
    notifyListeners();
  }

  DocumentSnapshot document;

  CartProduct.fromProduct(this._product) {
    productId = product.id;
    quantity = 1;
    flavor = product.selectedFlavor.name;
  }

  CartProduct.fromDocument({@required this.document}) {
    id = document.documentID;
    productId = document.data['pid'] as String;
    quantity = document.data['quantity'] as int;
    flavor = document.data['flavor'] as String;

    firestore.document('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
    });
  }

  CartProduct.fromMap(Map<String, dynamic> map) {
    productId = map['pid'] as String;
    quantity = map['quantity'] as int;
    flavor = map['flavor'] as String;
    fixedPrice = map['fixedPrice'] as num;

    firestore.document('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
    });
  }

  final Firestore firestore = Firestore.instance;

  String id;

  String productId;
  int quantity;
  String flavor;
  num fixedPrice;

  ItemFlavor get itemFlavor {
    if (product == null) return null;
    return product.findFlavor(flavor);
  }

  num get unitPrice {
    if (product == null) return 0;
    return itemFlavor?.price ?? 0;
  }

  num get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'flavor': flavor,
    };
  }

  Map<String, dynamic> toOrderItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'flavor': flavor,
      'fixedPrice': fixedPrice ?? unitPrice
    };
  }

  bool stackable(Product product) {
    return product.id == productId && product.selectedFlavor.name == flavor;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  bool get hasStock {
    if(product != null && product.deleted) return false;

    final flavor = itemFlavor;
    if (flavor == null) return false;
    return flavor.stock >= quantity;
  }
}
