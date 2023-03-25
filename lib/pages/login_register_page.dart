import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../auth.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    if (_controllerEmail.text.isEmpty || _controllerPassword.text.isEmpty) {
      setState(() {
        errorMessage = 'Please enter email and password';
      });
      return;
    }
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      setState(() {
        errorMessage = '';
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    final String email = _controllerEmail.text.trim();
    final String password = _controllerPassword.text.trim();

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final passwordRegExp = RegExp(r'^.{6,}$');

    if (!emailRegExp.hasMatch(email)) {
      setState(() {
        errorMessage = 'Please enter a valid email';
      });
      return;
    }

    if (!passwordRegExp.hasMatch(password)) {
      setState(() {
        errorMessage = 'Password should be at least 6 characters long';
      });
      return;
    }

    try {
      await Auth()
          .createUserWithEmailAndPassword(email: email, password: password);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text('Recipe Application');
  }

  Widget _entryFieldem(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      
      decoration: InputDecoration(
        
        labelText: title,
      ),
    );
  }

  Widget _entryFieldpw(
    String title,
    
    TextEditingController controller,
    
  ) {
    return TextField(
      controller: controller,
       obscureText: true,
      
      decoration: InputDecoration(
        
        labelText: title,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage ?? '',
      style: const TextStyle(color: Colors.red),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
      ),
    );
  }

  Widget _loginOrRegistrationButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
          errorMessage = '';
        });
      },
      child: Text(isLogin ? "Doesn't have an account? Register" : 'Have an Account? Sign In'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        backgroundColor: Colors.green,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Login or Register',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _entryFieldem('E-mail', _controllerEmail),
                _entryFieldpw('Password', _controllerPassword),
                _errorMessage(),
                _submitButton(),
                _loginOrRegistrationButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
