import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:imcflutter_persistencia/model/pessoa.dart';
import 'package:imcflutter_persistencia/services/app_storage_service.dart';

class ImcListPage extends StatefulWidget {
  const ImcListPage({Key? key}) : super(key: key);

  @override
  State<ImcListPage> createState() => _ImcListPageState();
}

class _ImcListPageState extends State<ImcListPage> {
  final nomeController = TextEditingController();
  final alturaDoubleController = TextEditingController();
  final pesoDoubleController = TextEditingController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool showNameAndHeightFields = true;

  late Box<List<String>> boxResultados;
  List<String> resultados = [];

  final AppStorageService storage = AppStorageService();
  final Pessoa pessoa = Pessoa.vazio();

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    await _openHiveBox();
    carregarImcCalculados();
  }

  Future<void> _openHiveBox() async {
    if (Hive.isBoxOpen('box_resultados')) {
      boxResultados = await Hive.openBox<List<String>>('box_resultados');
    } else {
      boxResultados = await Hive.openBox<List<String>>('box_resultados');
    }
  }

  void carregarImcCalculados() async {
    nomeController.text = await storage.getImcNome();
    double lastValueAltura = await storage.getImcAltura();
    alturaDoubleController.text = lastValueAltura.toString();

    resultados = boxResultados.get('chave_imcs') ?? [];

    setState(() {});
  }

  void salvarImcCalculados() {
    resultados = pessoa.classificarIMCs();
    boxResultados.put('chave_imcs', resultados);
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
                        labelText: 'Altura (em metros)',
                      ),
                    ),
                  ],
                ),
              TextField(
                controller: pesoDoubleController,
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
                storage.setImcNome(nomeController.text);
                storage.setImcAltura(
                    double.tryParse(alturaDoubleController.text) ?? 0.0);

                pessoa.setNome(nomeController.text);
                pessoa.setAltura(
                    double.tryParse(alturaDoubleController.text) ?? 0.0);

                final peso = double.tryParse(pesoDoubleController.text) ?? 0.0;
                pessoa.adicionarPeso(peso);
                pesoDoubleController.clear();

                resultados = pessoa.classificarIMCs();
                salvarImcCalculados();

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
          onRefresh: () async {
            salvarImcCalculados();
            setState(() {});
          },
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
                          "${nomeController.text}, Altura: ${alturaDoubleController.text}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: resultados.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(resultados[index]),
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
