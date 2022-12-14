import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class CreditCard {

  String number;
  String holder;
  String expirationDate;
  String securityCode;
  String brand;

  // ignore: use_setters_to_change_properties
  void setHolder(String name) => holder = name;
  // ignore: use_setters_to_change_properties
  void setExpirationDate(String date) => expirationDate = date;
  // ignore: use_setters_to_change_properties
  void setCVV(String cvv) => securityCode = cvv;
  void setNumber(String number) {

    this.number = number;
    brand = detectCCType(number.replaceAll(' ', '')).toString();

  }

  Map<String, dynamic> toJson(){
    return {
      'cardHolderName': holder,
      'cardNumber': number.replaceAll(' ', ''),
      'expirationMonth': expirationDate.split('/').first,
      'expirationYear': expirationDate.split('/').last,
      'securityCode': securityCode,
      'brandTid': brand
    };
  }

  @override
  String toString() {
    return 'CreditCard{number: $number, holder: $holder, expirationDate: $expirationDate, securityCode: $securityCode, brand: $brand}';
  }
}