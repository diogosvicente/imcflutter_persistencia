// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:imcflutter_persistencia/model/pessoa.dart';
import 'package:imcflutter_persistencia/services/app_storage_service.dart';

class ImcListPage extends StatefulWidget {
  const ImcListPage({Key? key}) : super(key: key);

  @override
  State<ImcListPage> createState() => _ImcListPageState();
}

class _ImcListPageState extends State<ImcListPage> {
  //nome
  var nomeController = TextEditingController();

  //altura
  final TextEditingController alturaDoubleController = TextEditingController();
  var alturaDouble = 0.0;

  //peso
  TextEditingController pesoController = TextEditingController();

  //instancia do shared_preferences
  AppStorageService storage = AppStorageService();

  //construtor vazio
  Pessoa pessoa = Pessoa.vazio();

  //exibir / esconder nome e altura
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool showNameAndHeightFields = true; // Controle de visibilidade

  @override
  void initState() {
    super.initState();
    carregarImcCalculados();
  }

  void carregarImcCalculados() async {
    nomeController.text = await storage.getImcNome();
    double lastValue = await storage.getImcAltura();
    alturaDoubleController.text = lastValue.toString();

    setState(() {});
  }

  void _showAddPesoDialog(BuildContext context) async {
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
                      controller: alturaDoubleController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Altura (em metros)'),
                    ),
                  ],
                ),
              TextField(
                controller: pesoController,
                keyboardType: TextInputType.number,
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
                try {
                  alturaDouble = double.parse(alturaDoubleController.text);
                } catch (e) {
                  alturaDouble = 0.0;
                }
                await storage.setImcNome(nomeController.text);
                await storage.setImcAltura(alturaDouble);

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
                          "${nomeController.text}, Altura: $alturaDouble",
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
