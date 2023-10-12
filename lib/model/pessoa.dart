class Pessoa {
  String _nome = "";
  double _peso = 0;
  double _altura = 0;

  Pessoa(String nome, double peso, double altura) {
    setNome(nome);
    setPeso(peso);
    setAltura(altura);
  }

  void setNome(String nome) {
    _nome = nome;
  }

  void setPeso(double peso) {
    _peso = peso;
  }

  void setAltura(double altura) {
    _altura = altura;
  }

  String getNome() {
    return _nome;
  }

  double getPeso() {
    return _peso;
  }

  double getAltura() {
    return _altura;
  }

  double calcularImc() {
    return _peso / (_altura * _altura);
  }

  String classificarImc() {
    double imc = calcularImc();

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
}
