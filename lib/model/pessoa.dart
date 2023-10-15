class Pessoa {
  String _nome = "";
  double _altura = 0;
  List<double> _pesos = [];
  final List<String> _imcClassificacoes = [];

  Pessoa.vazio();
  Pessoa(this._nome, this._altura, this._pesos);

  String getNome() {
    return _nome;
  }

  double getAltura() {
    return _altura;
  }

  void setNome(String nome) {
    _nome = nome;
  }

  void setAltura(double altura) {
    _altura = altura;
  }

  void adicionarPeso(double peso) {
    _pesos.add(peso);
  }

  List<double> getPesos() {
    return _pesos;
  }

  double calcularIMC(double peso) {
    return peso / (_altura * _altura);
  }

  String classificarIMC(double imc) {
    if (imc < 16.0) {
      return "Magreza grave";
    } else if (imc < 17.0) {
      return "Magreza moderada";
    } else if (imc < 18.5) {
      return "Magreza leve";
    } else if (imc < 25.0) {
      return "Saudável";
    } else if (imc < 30.0) {
      return "Sobrepeso";
    } else if (imc < 35.0) {
      return "Obesidade Grau I";
    } else if (imc < 40.0) {
      return "Obesidade Grau II (severa)";
    } else {
      return "Obesidade Grau III (mórbida)";
    }
  }

  List<String> classificarIMCs() {
    _imcClassificacoes.clear();
    for (int index = 0; index < _pesos.length; index++) {
      double peso = _pesos[index];
      double imc = calcularIMC(peso);
      String classificacao = classificarIMC(imc);
      String resultado = '${index + 1}: Peso $peso kg: $classificacao';
      _imcClassificacoes.add(resultado);
    }
    return _imcClassificacoes;
  }
}
