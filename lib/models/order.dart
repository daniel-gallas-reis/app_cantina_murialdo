import 'package:app_cantina_murialdo/models/address.dart';
import 'package:app_cantina_murialdo/models/cart_manager.dart';
import 'package:app_cantina_murialdo/models/cart_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum Status {canceled, preparing, onItsWay, delivered}

class Order {
  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    if (cartManager.address != null) {
      address = cartManager.address;
    }
    if (cartManager.user.serie != null) {
      turma = cartManager.user.serie;
    }
    status = Status.preparing;
  }

  Order.fromDocument(DocumentSnapshot doc) {
    orderId = doc.documentID;

    items = (doc.data['items'] as List<dynamic>).map((e) {
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();

    price = doc.data['price'] as num;
    userId = doc.data['userId'] as String;
    if (doc.data.containsKey('address')) {
      address = Address.formMap(doc.data['address'] as Map<String, dynamic>);
    }
    turma = doc.data['turma'] as String;
    date = doc.data['date'] as Timestamp;

    status = Status.values[doc.data['status'] as int];

    payId = doc.data['payId'] as String;
  }

  void updateFromDocument(DocumentSnapshot doc) {
    status = Status.values[doc.data['status'] as int];
  }

  final Firestore firestore = Firestore.instance;

  Status status;

  List<CartProduct> items;
  num price;
  String orderId;
  String userId;
  Address address;
  Timestamp date;
  String turma;
  String payId;

  Future<void> save() async {
    firestore.collection('orders').document(orderId).setData({
      'items': items.map((e) => e.toOrderItemMap()).toList(),
      'price': price,
      'userId': userId,
      if (address != null) 'address': address.toMap(),
      if (turma != null) 'turma': turma,
      'status': status.index,
      'date': Timestamp.now(),
      'payId': payId
    });
  }

  String get formatedId => '#${orderId.padLeft(6, '0')}';

  String get statusText => getStatusText(status);

  static String getStatusText(Status status) {
    switch (status) {
      case Status.canceled:
        return 'Cancelado';
      case Status.preparing:
        return 'Pedido em Preparação';
      case Status.onItsWay:
        return 'Pedido em Transporte';
      case Status.delivered:
        return 'Pedido Entregue';
      default:
        return '';
    }
  }

  Function() get back {
    return status.index >= Status.onItsWay.index
        ? () {
            status = Status.values[status.index - 1];
            firestore
                .collection('orders')
                .document(orderId)
                .updateData({'status': status.index});
          }
        : null;
  }

  Function() get forward {
    return status.index <= Status.onItsWay.index
        ? () {
            status = Status.values[status.index + 1];
            firestore
                .collection('orders')
                .document(orderId)
                .updateData({'status': status.index});
          }
        : null;
  }

  void cancel() {
    status = Status.canceled;
    firestore
        .collection('orders')
        .document(orderId)
        .updateData({'status': status.index});
  }
}
