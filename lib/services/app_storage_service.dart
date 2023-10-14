// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
enum STORAGE_CHAVES { CHAVE_IMC_NOME, CHAVE_IMC_ALTURA }

class AppStorageService {
  //métodos principais
  //NOME
  Future<void> setImcNome(String nome) async {
    await _setString(STORAGE_CHAVES.CHAVE_IMC_NOME.toString(), nome);
  }

  Future<String> getImcNome() async {
    return _getString(STORAGE_CHAVES.CHAVE_IMC_NOME.toString());
  }

  //ALTURA
  Future<void> setImcAltura(double value) async {
    await _setDouble(STORAGE_CHAVES.CHAVE_IMC_ALTURA.toString(), value);
  }

  Future<double> getImcAltura() async {
    return _getDouble(STORAGE_CHAVES.CHAVE_IMC_ALTURA.toString());
  }

  //métodos auxiliares
  Future<void> _setString(String chave, String value) async {
    var storage = await SharedPreferences.getInstance();
    storage.setString(chave, value);
  }

  Future<String> _getString(String chave) async {
    var storage = await SharedPreferences.getInstance();
    return storage.getString(chave) ?? "";
  }

  Future<void> _setDouble(String chave, double value) async {
    var storage = await SharedPreferences.getInstance();
    await storage.setDouble(chave, value);
  }

  Future<double> _getDouble(String chave) async {
    var storage = await SharedPreferences.getInstance();
    return storage.getDouble(chave) ?? 0;
  }
}
