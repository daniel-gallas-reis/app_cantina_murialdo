import 'dart:io';

import 'package:app_cantina_murialdo/models/address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class User {
  String email;
  String password;
  String confirmPassword;
  String name;
  String id;
  double credit;
  String serie;
  String cpf;
  // ignore: non_constant_identifier_names
  String parental_email;
  bool admin = false;

  Address address;

  User(
      { this.password,
        this.email,
        this.name,
        this.confirmPassword,
        this.id,
        this.credit,
        // ignore: non_constant_identifier_names
        this.parental_email,
        this.serie
      });

  User.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document.data['name'] as String;
    email = document.data['email'] as String;
    credit = document.data['credit'] as double;
    serie = document.data['serie'] as String;
    parental_email = document.data['parental_email'] as String;
    if(document.data.containsKey('cpf')){
      cpf = document.data['cpf'] as String;
    }
    if(document.data.containsKey('address')){
      address = Address.formMap(document.data['address'] as Map<String, dynamic>);
    }
  }

  DocumentReference get firestoreRef => Firestore.instance.document('users/$id');

  CollectionReference get cartReference => firestoreRef.collection('cart');

  CollectionReference get tokensReference => firestoreRef.collection('tokens');

  Future<void> saveData() async{
    await firestoreRef.setData(toMap());
  }

  Future<void> updateData() async{
    await firestoreRef.updateData(toMap());
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'email': email,
      'credit': credit,
      if(serie != null)
        'serie': serie,
      if(parental_email != null)
        'parental_email': parental_email,
      if(address != null)
        'address': address.toMap(),
      if(cpf != null)
        'cpf': cpf
    };
  }

  void setAddress(Address address){
    this.address = address;
    saveData();
  }

  void setCpf(String cpf){
    this.cpf = cpf;
    saveData();
  }

  Future<void> saveToken() async{
    final token = await FirebaseMessaging().getToken();

    await tokensReference.document(token).setData({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem
    });

  }

}
