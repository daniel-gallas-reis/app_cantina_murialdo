import 'package:app_cantina_murialdo/models/cepaberto_address.dart';
import 'package:dio/dio.dart';
import 'dart:io';

const token = 'b02646f50dc7bbba384eaac71fb9f32e';

class CepAbertoService {
  // ignore: missing_return
  Future<CepAbertoAddress> getAdressFromCep(String cep) async {
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endPoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";

    final Dio dio = Dio();

    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {
      final response = await dio.get<Map<String, dynamic>>(endPoint);

      if (response.data.isEmpty) {
        return Future.error('Cep inválido!');
      }
      final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data);

      return address;
    } on DioError catch (e) {
      Future.error('Falha ao buscar CEP');
    }
  }
}
