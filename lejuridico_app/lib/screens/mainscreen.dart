import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ProcessScreen extends StatefulWidget {
  @override
  _ProcessScreenState createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen> {
  final TextEditingController _processoController = TextEditingController();
  String _responseMessage = "";
  List<String> _suggestions = []; // Lista para armazenar as 3 palavras
  Map<String, dynamic>? _processoDetalhes;

  Future<void> _consultaProcesso(String processo) async {
    final url = Uri.parse('http://localhost:8080/buscaprocesso');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'numero_processo': processo},
      );
      // print("Resposta da primeira requisicao : ${response.body}");
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        setState(() {
          _processoDetalhes = responseData;
          _responseMessage = 'Detalhes do Processo Obtidos com Sucesso!';
        });

        if (responseData.isNotEmpty) {
          await _mandaIA(responseData);
        }
      } else {
        setState(() {
          _responseMessage = 'Erro na requisição para scrape: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = 'Erro na conexão da requisição para scrape: $e';
      });
    }
  }
Future<void> _mandaIA(Map<String, dynamic> processoDetalhes) async {
  final url = Uri.parse('http://localhost:3000/sugest');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(processoDetalhes),  // Enviando o objeto inteiro
    );
    print("Resposta da segunda requisicao : ${response.body}");

    
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      String rawReply = responseData['reply'] ?? "";

      String filteredReply = rawReply.replaceAll(RegExp(r"<think>.*?</think>", dotAll: true), "").trim();
      // Aqui você pode usar a resposta como antes
      setState(() {
        _suggestions = filteredReply.split(',').map((s)=> s.trim()).toList();
      });
    } else {
      setState(() {
        _responseMessage = 'Erro na requisição para a IA: ${response.statusCode}';
      });
    }
  } catch (e) {
    setState(() {
      _responseMessage = 'Erro na conexão da requisição para a IA: $e';
    });
  }
}


 Future<void> _enviaTipoPeca(String tipoPeca) async {
  final url = Uri.parse('http://localhost:3000/peca');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tipoPeca': tipoPeca,
        'detalhesProcesso': _processoDetalhes,
      }),
    );
    print("Resposta da terceira requisicao : ${response.body}");
    
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      String rawReply = responseData['reply'] ?? "";

      // Remover o conteúdo <think>...</think> com regex
      String filteredReply = rawReply.replaceAll(RegExp(r"<think>.*?</think>", dotAll: true), "").trim();

      // Atualizar o estado com a resposta filtrada
      setState(() {
        _responseMessage = filteredReply.isEmpty ? "Resposta não encontrada" : filteredReply;
      });
    } else {
      setState(() {
        _responseMessage = 'Erro ao enviar palavra: ${response.statusCode}';
      });
    }
  } catch (e) {
    setState(() {
      _responseMessage = 'Erro na conexão ao enviar palavra: $e';
    });
  }
}


  void _searchProcess() {
    final processo = _processoController.text.trim();
    if (processo.isNotEmpty) {
      _consultaProcesso(processo);
    } else {
      setState(() {
        _responseMessage = 'Por favor, insira um número de processo válido.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Busca de Processos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Por favor, informe o número do processo"),
            SizedBox(height: 15),
            Container(
              width: 400,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _processoController,
                decoration: InputDecoration(
                  hintText: "Digite o número do processo",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _searchProcess,
              child: Text("Pesquisar"),
            ),
            SizedBox(height: 20),
            if (_suggestions.isNotEmpty) ...[
              Text(
                "Escolha uma das opções sugeridas:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              for (String suggestion in _suggestions)
              Column(
                children: [
                  ElevatedButton(
                  onPressed: () => _enviaTipoPeca(suggestion),
                  child: Text(suggestion),
                ),SizedBox(height: 20,)
                ],
              )
                
            ],
            if (_responseMessage.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                _responseMessage,
                style: TextStyle(color: Colors.green, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
