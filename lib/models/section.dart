import 'dart:io';
import 'package:app_cantina_murialdo/models/section_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Section extends ChangeNotifier {
  Section({this.name, this.items, this.type, this.id}) {
    items = items ?? [];
    originalItems = items;
  }

  Section.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document.data['name'] as String;
    type = document.data['type'] as String;
    items = (document.data['items'] as List)
        .map((i) => SectionItem.fromMap(i as Map<String, dynamic>))
        .toList();
  }

  final Firestore firestore = Firestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.document('home/$id');

  StorageReference get storageRef => storage.ref().child('home/$id');

  String id;
  String name;
  String type;
  List<SectionItem> items;
  List<SectionItem> originalItems;

  String _error;

  String get error => _error;

  set error(String value) {
    _error = value;
    notifyListeners();
  }

  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item) {
    items.remove(item);
    notifyListeners();
  }

  Section clone() {
    return Section(
        id: id,
        name: name,
        items: items.map((i) => i.clone()).toList(),
        type: type);
  }

  bool valid() {
    if (name.isEmpty || name == null) {
      error = 'Título Inválido';
    } else if (items.isEmpty) {
      error = 'Insira ao menos uma imagem!';
    } else {
      error = null;
    }
    return error == null;
  }

  Future<void> save(int pos) async {
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
      'pos': pos,
    };

    if (id == null) {
      final doc = await firestore.collection('home').add(data);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(data);
    }

    for (final item in items) {
      if (item.image is File) {
        final StorageUploadTask task =
            storageRef.child(Uuid().v1()).putFile(item.image as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;
        item.image = url;
      }
    }

    for(final original in originalItems){
      if(!items.contains(original) && (original.image as String).contains('firebase')){
        try {
          final ref = await storage.getReferenceFromUrl(
              original.image as String);
          await ref.delete();
        // ignore: empty_catches
        }catch(e){}
      }
    }

    final Map<String, dynamic> itemsData = {
      'items': items.map((i) => i.toMap()).toList()
    };

    await firestoreRef.updateData(itemsData);


  }

  Future<void> delete() async{
    await firestoreRef.delete();
    for(final item in items){
      if((item.image as String).contains('firebase')) {
        try {
          final ref = await storage.getReferenceFromUrl(item.image as String);
          await ref.delete();
          // ignore: empty_catches
        } catch (e) {}
      }
    }
  }

}
