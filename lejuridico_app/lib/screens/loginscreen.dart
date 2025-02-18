import 'package:flutter/material.dart';
import 'signinscreen1.dart';
import 'mainscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Formulário
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
                    // Logo
                    Center(
                      child: Image.asset(
                        'web/assets/LeJurídico.png',
                        width: 200,
                        height: 45,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Mensagem de boas-vindas
                    Text(
                      "Bem-vindo de volta!",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    
                    // Campo de E-mail
                    Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "exemplo@email.com",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Campo de Senha
                    Text("Senha", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: "********",
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Switch e esqueceu a senha
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Switch(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value;
                                });
                              },
                            ),
                            Text("Lembrar"),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("Esqueceu a Senha?", style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Botão Sign In
                    ElevatedButton(
                      onPressed: () {Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProcessScreen()),
                  );},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text("Continuar"),
                    ),
                    SizedBox(height: 20),

                    // Link para cadastro
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpStep1()),
                          );
                        },
                        child: Text(
                          "Não tem conta? Cadastre-se agora.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Rodapé
                    Center(
                      child: Text("© LeJurídico 2024", style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Parte cinza
          Expanded(
            flex: 3,
            child: Container(color: Colors.grey[300]),
          ),
        ],
      ),
    );
  }
}
