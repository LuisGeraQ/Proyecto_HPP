import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 3, 34, 59), // Color de fondo de la pantalla de bienvenida
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/hpp.jpg',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('Empezar'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
            validator: (value) =>
                value!.isEmpty ? 'Please enter your username' : null,
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (value) =>
                value!.isEmpty ? 'Please enter your password' : null,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                loginAndGetData();
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  Future<void> loginAndGetData() async {
    const baseUrl =
        'https://api.ibicare.mx'; // Replace with your actual server URL or IP
    const loginUrl = '$baseUrl/api/login';
    const dataUrl =
        'https://api.ibicare.mx/api/clockData/myData?yearI=2024&monthI=04&dayI=1&yearF=2024&monthF=04&dayF=30';

    try {
      final loginResponse = await http.post(Uri.parse(loginUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'paola.aranda': _usernameController.text,
            '66A171B7A7F': _passwordController.text
          }));

      if (loginResponse.statusCode == 200) {
        final token = jsonDecode(loginResponse.body)['token'];
        final dataResponse = await http.get(Uri.parse(dataUrl),
            headers: {'Authorization': 'Bearer $token'});

        if (dataResponse.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomePage(data: jsonDecode(dataResponse.body))),
          );
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class HomePage extends StatelessWidget {
  final List<dynamic> data;

  const HomePage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Loaded")),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, index) {
          return ListTile(
            title: Text(data[index]['calories'].toString()),
            subtitle: Text(
                'HRV: ${data[index]['hrvValueAvg']} - Stress: ${data[index]['stressAvg']}'),
          );
        },
      ),
    );
  }
}
