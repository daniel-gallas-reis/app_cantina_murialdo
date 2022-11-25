import 'dart:collection';

import 'package:app_cantina_murialdo/models/credit_card.dart';
import 'package:app_cantina_murialdo/models/user.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';

class RedePayment {
  final CloudFunctions functions = CloudFunctions.instance;
  Map<String, dynamic> respData;
  Map<String, dynamic> capData;


  Future<String> authorize(
      {CreditCard creditCard, num price, String orderId, User user}) async {
    try {
      final Map<String, dynamic> dataSale = {
        'reference': orderId,
        'amount': (price * 100).toInt(),
        'softDescriptor': 'Cantina Muri',
        'installments': 1,
        'creditCard': creditCard.toJson(),
        'cpf': user.cpf
      };
      final HttpsCallable callable = functions.getHttpsCallable(
        functionName: 'authorizeCreditCard',
      );
      callable.timeout = const Duration(seconds: 60);
      final response = await callable.call(dataSale);
      respData =
      Map<String, dynamic>.from(response.data as LinkedHashMap);
      if (respData['returnCode'] == '00') {
        return respData['tid'] as String;
      } else {
        switch (respData['returnCode'] as String) {
          case '58':
            return Future.error('Pagamento não autorizado, tente novamente');
            break;
          case '69':
            return Future.error(
                'Transação não permitida para este tipo de produto');
            break;
          case '74':
            return Future.error('Falha na comunicação, tente novamente');
            break;
          case '79':
            return Future.error(
                'Cartão expirado, transação não permitida, contatar emissor');
            break;
          case '84':
            return Future.error(
                'Cartão expirado, transação não permitida, contatar emissor');
            break;
          case '101':
            return Future.error(
                'Cartão expirado, transação não permitida, contatar emissor');
            break;
          case '105':
            return Future.error('Cartão rejeitado, contatar emissor');
            break;
          case '108':
            return Future.error('Valor não permitido para este tipo de cartão');
            break;
          case '112':
            return Future.error('Validade expirada');
            break;
          case '115':
            return Future.error('Limite de transação expirado');
            break;
          case '118':
            return Future.error('Cartão bloqueado');
            break;
          case '119':
            return Future.error('Código de segurança inválido');
            break;
          case '204':
            return Future.error('Nome do cartão não confere');
            break;
          default:
            return Future.error(
                'Erro na transação, tente novamente, se o erro persistir, procure a loja ou o emissor');
        }
      }
    }catch(e){
      debugPrint('$e');
      return Future.error('Falha ao processar transação. Tente novamente.');
    }
  }

  Future<String> capture({CreditCard creditCard, num price, String orderId, User user, String payId}) async{
    print('chamou cap');
    final Map<String, dynamic> captureData = {
      'reference': orderId,
      'amount': (price * 100).toInt(),
      'softDescriptor': 'Cantina Muri',
      'installments': 1,
      'creditCard': creditCard.toJson(),
      'cpf': user.cpf,
      'payId': payId
    };
    //final captureData = respData['tid'];
    final HttpsCallable callable = functions.getHttpsCallable(
      functionName: 'captureCreditCard',
    );
    callable.timeout = const Duration(seconds: 60);
    final response = await callable.call(captureData);
    capData =
    Map<String, dynamic>.from(response.data as LinkedHashMap);
    if (capData['returnCode'] == '00') {
      return capData['tid'] as String;
    } else {
      switch (capData['returnCode'] as String) {
        case '58':
          return Future.error('Pagamento não autorizado, tente novamente');
          break;
        case '69':
          return Future.error(
              'Transação não permitida para este tipo de produto');
          break;
        case '74':
          return Future.error('Falha na comunicação, tente novamente');
          break;
        case '79':
          return Future.error(
              'Cartão expirado, transação não permitida, contatar emissor');
          break;
        case '84':
          return Future.error(
              'Cartão expirado, transação não permitida, contatar emissor');
          break;
        case '101':
          return Future.error(
              'Cartão expirado, transação não permitida, contatar emissor');
          break;
        case '105':
          return Future.error('Cartão rejeitado, contatar emissor');
          break;
        case '108':
          return Future.error('Valor não permitido para este tipo de cartão');
          break;
        case '112':
          return Future.error('Validade expirada');
          break;
        case '115':
          return Future.error('Limite de transação expirado');
          break;
        case '118':
          return Future.error('Cartão bloqueado');
          break;
        case '119':
          return Future.error('Código de segurança inválido');
          break;
        case '204':
          return Future.error('Nome do cartão não confere');
          break;
        default:
          return Future.error(
              'Erro na Captura, tente novamente, se o erro persistir, procure a loja ou o emissor');
      }
    }
  }

  Future<String> cancel({CreditCard creditCard, num price, String orderId, User user, String payId}) async{
    final Map<String, dynamic> cancelData = {
      'reference': orderId,
      'amount': (price * 100).toInt(),
      'softDescriptor': 'Cantina Muri',
      'installments': 1,
      'creditCard': creditCard.toJson(),
      'cpf': user.cpf,
      'payId': payId
    };
    //final captureData = respData['tid'];
    final HttpsCallable callable = functions.getHttpsCallable(
      functionName: 'cancelCreditCard',
    );
    callable.timeout = const Duration(seconds: 60);
    final response = await callable.call(cancelData);
    capData =
    Map<String, dynamic>.from(response.data as LinkedHashMap);
    print(response.data);
    if (capData['returnCode'] == '00') {
      return capData['tid'] as String;
    } else {
      switch (capData['returnCode'] as String) {
        case '58':
          return Future.error('Pagamento não autorizado, tente novamente');
          break;
        case '69':
          return Future.error(
              'Transação não permitida para este tipo de produto');
          break;
        case '74':
          return Future.error('Falha na comunicação, tente novamente');
          break;
        case '79':
          return Future.error(
              'Cartão expirado, transação não permitida, contatar emissor');
          break;
        case '84':
          return Future.error(
              'Cartão expirado, transação não permitida, contatar emissor');
          break;
        case '101':
          return Future.error(
              'Cartão expirado, transação não permitida, contatar emissor');
          break;
        case '105':
          return Future.error('Cartão rejeitado, contatar emissor');
          break;
        case '108':
          return Future.error('Valor não permitido para este tipo de cartão');
          break;
        case '112':
          return Future.error('Validade expirada');
          break;
        case '115':
          return Future.error('Limite de transação expirado');
          break;
        case '118':
          return Future.error('Cartão bloqueado');
          break;
        case '119':
          return Future.error('Código de segurança inválido');
          break;
        case '204':
          return Future.error('Nome do cartão não confere');
          break;
        default:
          return Future.error(
              'Erro na Captura, tente novamente, se o erro persistir, procure a loja ou o emissor');
      }
    }
  }

}
