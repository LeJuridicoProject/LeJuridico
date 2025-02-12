import 'package:flutter/material.dart';

class SignUpStep2 extends StatefulWidget {
  final String nome; // Recebe o nome da tela anterior

  SignUpStep2({required this.nome});

  @override
  _SignUpStep2State createState() => _SignUpStep2State();
}

class _SignUpStep2State extends State<SignUpStep2> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Formulário de Cadastro - Passo 2
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
                      "Olá, ${widget.nome}! Bem vindo ao Lejurídico!",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),

                    // Campo E-mail
                    Text("E-mail", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Digite seu e-mail",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Campo Senha
                    Text("Senha", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: "Digite sua senha",
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
                    SizedBox(height: 15),

                    // Campo Confirmar Senha
                    Text("Confirmar Senha", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        hintText: "Digite novamente sua senha",
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Botão Finalizar Cadastro
                    ElevatedButton(
                      onPressed: () {
                        String email = emailController.text.trim();
                        String senha = passwordController.text.trim();
                        String confirmarSenha = confirmPasswordController.text.trim();

                        if (email.isEmpty || senha.isEmpty || confirmarSenha.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Preencha todos os campos!")),
                          );
                        } else if (senha != confirmarSenha) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("As senhas não coincidem!")),
                          );
                        } else {
                          // Aqui pode-se enviar os dados para o backend
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Cadastro concluído com sucesso!")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text("Cadastrar"),
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
