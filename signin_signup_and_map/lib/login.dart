import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _supabase = Supabase.instance.client;

  Future<void> _login() async {
    try {
      await _supabase.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      
      // После успешного входа переходим на главный экран
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => HomePage())
      );
    } catch (e) {
      print('Ошибка входа: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Вход')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}