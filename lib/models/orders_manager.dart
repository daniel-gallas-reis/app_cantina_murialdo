import 'dart:async';
import 'package:app_cantina_murialdo/models/order.dart';
import 'package:app_cantina_murialdo/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrdersManager extends ChangeNotifier {
  User user;
  List<Order> orders = [];

  final Firestore firestore = Firestore.instance;

  StreamSubscription _streamSubscription;

  void updateUser(User user) {
    this.user = user;
    orders.clear();
    _streamSubscription?.cancel();

    if (user != null) {
      _listenToOrders();
    }
  }

  void _listenToOrders() {
    _streamSubscription = firestore
        .collection('orders')
        .where('userId', isEqualTo: user.id)
        .snapshots()
        .listen((event) {
      orders.clear();
      for (final doc in event.documents) {
        orders.add(Order.fromDocument(doc));
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
  }
}
