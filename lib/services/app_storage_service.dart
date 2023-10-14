import 'package:shared_preferences/shared_preferences.dart';

enum STORAGE_CHAVES { CHAVE_IMC_NOME, CHAVE_IMC_ALTURA, CHAVE_IMC_PESO }

class AppStorageService {
  //métodos principais
  //NOME
  void setImcNome(String nome) async {
    _setString(STORAGE_CHAVES.CHAVE_IMC_NOME.toString(), nome);
  }

  Future<String> getImcNome() async {
    return _getString(STORAGE_CHAVES.CHAVE_IMC_NOME.toString());
  }

  //ALTURA
  void setImcAltura(double value) async {
    _setDouble(STORAGE_CHAVES.CHAVE_IMC_ALTURA.toString(), value);
  }

  Future<double> getImcAltura() async {
    return _getDouble(STORAGE_CHAVES.CHAVE_IMC_NOME.toString());
  }

  //PESO
  void setImcPeso(List<String> values) async {
    _setStringList(STORAGE_CHAVES.CHAVE_IMC_PESO.toString(), values);
  }

  Future<List<String>> getImcPeso() async {
    return _getStringList(STORAGE_CHAVES.CHAVE_IMC_NOME.toString());
  }

  //métodos auxiliares
  _setString(String chave, String value) async {
    var storage = await SharedPreferences.getInstance();
    storage.setString(chave, value);
  }

  Future<String> _getString(String chave) async {
    var storage = await SharedPreferences.getInstance();
    return storage.getString(chave) ?? "";
  }

  _setDouble(String chave, double value) async {
    var storage = await SharedPreferences.getInstance();
    storage.setDouble(chave, value);
  }

  Future<double> _getDouble(String chave) async {
    var storage = await SharedPreferences.getInstance();
    return storage.getDouble(chave) ?? 0;
  }

  _setStringList(String chave, List<String> values) async {
    var storage = await SharedPreferences.getInstance();
    storage.setStringList(chave, values);
  }

  Future<List<String>> _getStringList(String chave) async {
    var storage = await SharedPreferences.getInstance();
    return storage.getStringList(chave) ?? [];
  }
}
