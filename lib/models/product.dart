import 'dart:io';
import 'package:app_cantina_murialdo/models/item_flavor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {
  String name;
  List<String> images;
  String id;
  List<ItemFlavor> flavors;

  List<dynamic> newImages;

  bool deleted;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  Product({this.flavors, this.images, this.name, this.id, this.deleted = false}) {
    images = images ?? [];
    flavors = flavors ?? [];
  }

  Product.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document['name'] as String;
    deleted = (document.data['deleted'] ?? false) as bool;
    images = List<String>.from(document.data['images'] as List<dynamic>);
    flavors = (document.data['flavors'] as List<dynamic> ?? [])
        .map((f) => ItemFlavor.fromMap(f as Map<String, dynamic>))
        .toList();
  }

  final Firestore firestore = Firestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.document('products/$id');

  StorageReference get storageRef => storage.ref().child('products').child(id);

  ItemFlavor _selectedFlavor;

  ItemFlavor get selectedFlavor => _selectedFlavor;

  set selectedFlavor(ItemFlavor value) {
    _selectedFlavor = value;
    notifyListeners();
  }

  int get totalStock {
    int stock = 0;
    for (final flavor in flavors) {
      stock += flavor.stock;
    }
    return stock;
  }

  bool get hasStock {
    return totalStock > 0 && !deleted;
  }

  num get basePrice {
    num lowest = double.infinity;
    for (final flavor in flavors) {
      if (flavor.price < lowest/* && flavor.temStock*/) {
        lowest = flavor.price;
      }
    }
    return lowest;
  }

  ItemFlavor findFlavor(String name) {
    try {
      return flavors.firstWhere((f) => f.name == name);
    } catch (e) {
      return null;
    }
  }

  List<Map<String, dynamic>> exportFlavorsList() {
    return flavors.map((flavor) => flavor.toMap()).toList();
  }

  Future<void> save() async {
    loading = true;

    final Map<String, dynamic> data = {
      'name': name,
      'flavors': exportFlavorsList(),
      'deleted': deleted
    };

    if (id == null) {
      final doc = await firestore.collection('products').add(data);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(data);
    }

    final List<String> updateImages = [];

    for (final newImage in newImages) {
      if (images.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        final StorageUploadTask task =
            storageRef.child(Uuid().v1()).putFile(newImage as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;
        updateImages.add(url);
      }
    }

    for(final image in images){
      if(!newImages.contains(image) && image.contains('firebase')){
        try {
          final ref = await storage.getReferenceFromUrl(image);
          await ref.delete();
        }catch(e){
          debugPrint('Falha ao deletar imagem $image!');
        }
      }
    }

    await firestoreRef.updateData({'images': updateImages});

    images = updateImages;

    loading = false;
  }

  void delete(){
    firestoreRef.updateData({'deleted': true});
  }

  Product clone() {
    return Product(
      id: id,
      name: name,
      images: List.from(images),
      flavors: flavors.map((f) => f.clone()).toList(),
      deleted: deleted
    );
  }
}
