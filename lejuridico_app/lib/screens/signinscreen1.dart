import 'package:flutter/material.dart';
import 'signinscreen2.dart'; // Importa a segunda tela

class SignUpStep1 extends StatefulWidget {
  @override
  _SignUpStep1State createState() => _SignUpStep1State();
}

class _SignUpStep1State extends State<SignUpStep1> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Formulário de Cadastro - Passo 1
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'web/assets/LeJurídico.png',
                        width: 200,
                        height: 45,
                      ),
                    ),
                    SizedBox(height: 20),

                    Text(
                      "Qual seu nome?",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),

                    // Campo Nome
                    Text("Nome Completo", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Digite seu nome",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Botão Próximo
                    ElevatedButton(
                      onPressed: () {
                        String nome = nameController.text.trim();
                        if (nome.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpStep2(nome: nome), // Passa o nome para a próxima tela
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Por favor, informe seu nome!")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text("Continuar"),
                    ),
                    SizedBox(height: 20),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Já tem conta? Faça login.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),
                    Center(child: Text("© LeJurídico 2024", style: TextStyle(color: Colors.grey))),
                  ],
                ),
              ),
            ),
          ),

          // Parte cinza
          Expanded(flex: 3, child: Container(color: Colors.grey[300])),
        ],
      ),
    );
  }
}
