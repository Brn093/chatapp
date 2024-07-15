import 'package:chatapp/auth_provider.dart';
import 'package:chatapp/home_screen.dart';
import 'package:chatapp/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("DropCell Chat"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Digite o seu Email";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: "Senha",
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Digite a sua Senha";
                }
                return null;
              },
            ),
            SizedBox(height: 50),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await authProvider.signIn(
                        _emailController.text, _passwordController.text);
                    Fluttertoast.showToast(msg: "Usuário logado");
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ));
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text("Entrar"),
              ),
            ),
            SizedBox(height: 20),
            Text("OU"),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              child: Text("Criar Conta"),
            ),
          ],
        ),
      ),
    );
  }
}
