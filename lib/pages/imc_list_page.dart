import 'package:flutter/material.dart';
import 'package:imcflutter_persistencia/model/pessoa.dart';
import 'package:imcflutter_persistencia/repository/pessoa_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImcListPage extends StatefulWidget {
  const ImcListPage({Key? key}) : super(key: key);

  @override
  State<ImcListPage> createState() => _ImcListPageState();
}

class _ImcListPageState extends State<ImcListPage> {
  var nomeController = TextEditingController();
  var pesoController = TextEditingController();
  var alturaController = TextEditingController();
  double pesoDouble = 0.0;
  double alturaDouble = 0.0;
  List<Pessoa> pessoas = [];
  var pessoaRepository = PessoaRepository();
  var _pessoas = const <Pessoa>[];

  @override
  void initState() {
    super.initState();
    carregarImcCalculados();
  }

  void carregarImcCalculados() {
    _pessoas = pessoaRepository.listar();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculadora IMC")),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            nomeController.text = "";
            pesoController.text = "";
            alturaController.text = "";
            showDialog(
                context: context,
                builder: (BuildContext bc) {
                  return AlertDialog(
                    title: const Text("Adicionar pessoa"),
                    content: Wrap(
                      children: [
                        TextField(
                          controller: nomeController,
                          decoration: const InputDecoration(
                            labelText: 'Nome',
                          ),
                        ),
                        TextField(
                          controller: pesoController,
                          decoration:
                              const InputDecoration(labelText: 'Peso (kg)'),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: alturaController,
                          decoration:
                              const InputDecoration(labelText: 'Altura (m)'),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancelar")),
                      TextButton(
                          onPressed: () {
                            final storage = SharedPreferences.getInstance();
                            if (nomeController.text.trim() == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Nome deve ser preenchido")));
                              return;
                            }
                            if (pesoController.text.trim() == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Peso deve ser preenchido")));
                              return;
                            }
                            if (alturaController.text.trim() == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Altura deve ser preenchida")));
                              return;
                            }
                            setState(() {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Dados salvos com sucesso!")));
                            });
                            try {
                              pesoDouble = double.parse(pesoController.text);
                            } catch (e) {
                              pesoDouble = 0.0;
                            }
                            try {
                              alturaDouble =
                                  double.parse(alturaController.text);
                            } catch (e) {
                              alturaDouble = 0.0;
                            }
                            pessoaRepository.adicionar(Pessoa(
                                nomeController.text, pesoDouble, alturaDouble));
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: const Text("Salvar"))
                    ],
                  );
                });
          }),
      body: ListView.builder(
          itemCount: _pessoas.length,
          itemBuilder: (BuildContext bc, int index) {
            var pessoa = _pessoas[index];
            return Container(
              margin: const EdgeInsets.all(5),
              child: Text(
                  '${pessoa.getNome()} IMC: ${pessoa.calcularImc().toStringAsFixed(2)} - ${pessoa.classificarImc()}\nPeso: ${pessoa.getPeso()} Altura: ${pessoa.getAltura()}'),
            );
          }),
    );
  }
}
