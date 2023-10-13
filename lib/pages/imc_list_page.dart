import 'package:flutter/material.dart';
import 'package:imcflutter_persistencia/model/pessoa.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImcListPage extends StatefulWidget {
  const ImcListPage({Key? key}) : super(key: key);

  @override
  State<ImcListPage> createState() => _ImcListPageState();
}

class _ImcListPageState extends State<ImcListPage> {
  var nomeController = TextEditingController();
  var alturaController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  Pessoa pessoa = Pessoa.vazio();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool showNameAndHeightFields = true; // Controle de visibilidade

  @override
  void initState() {
    super.initState();
    _loadDataFromSharedPreferences();
  }

  _loadDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String nome = prefs.getString('nome') ?? '';
    double altura = prefs.getDouble('altura') ?? 0.0;

    setState(() {
      nomeController.text = nome;
      alturaController.text = altura.toString();
    });
  }

  void _showAddPesoDialog(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Peso'),
          content: Wrap(
            children: [
              if (showNameAndHeightFields)
                Column(
                  children: [
                    TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(labelText: 'Nome'),
                    ),
                    TextField(
                      controller: alturaController,
                      decoration: const InputDecoration(
                          labelText: 'Altura (em metros)'),
                    ),
                  ],
                ),
              TextField(
                controller: pesoController,
                decoration: const InputDecoration(labelText: 'Peso (em kg)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await prefs.setString('nome', nomeController.text);
                await prefs.setDouble(
                    'altura', double.parse(alturaController.text));

                pessoa.setNome(nomeController.text);
                pessoa.setAltura(double.parse(alturaController.text));
                final peso = double.parse(pesoController.text);
                pessoa.adicionarPeso(peso);
                pesoController.clear();
                setState(() {
                  showNameAndHeightFields = false;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Calculadora de IMC'),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!showNameAndHeightFields &&
                    pessoa.getPesos().isNotEmpty &&
                    pessoa.classificarIMCs().isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Text(
                          "${pessoa.getNome()}, Altura: ${pessoa.getAltura()}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: pessoa.getPesos().length,
                    itemBuilder: (context, index) {
                      final pesos = pessoa.getPesos();
                      final imcs = pessoa.classificarIMCs();
                      return ListTile(
                        title: Text(
                          "${index + 1}: Peso ${pesos[index]} kg: ${imcs[index]}",
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddPesoDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
