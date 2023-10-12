import 'package:imcflutter_persistencia/model/pessoa.dart';

class PessoaRepository {
  final List<Pessoa> _pessoas = [];

  void adicionar(Pessoa pessoa) {
    _pessoas.add(pessoa);
  }

  List<Pessoa> listar() {
    return _pessoas;
  }
}
