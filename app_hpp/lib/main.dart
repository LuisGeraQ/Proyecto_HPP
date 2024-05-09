import 'package:flutter/material.dart';
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
            Stack(
              children: [
                Image.asset(
                  'assets/images/hpp.jpg', // Ruta de tu imagen
                  width:
                      200, // Ajusta el ancho de la imagen según sea necesario
                  height:
                      200, // Ajusta la altura de la imagen según sea necesario
                ),
              ],
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
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
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
            decoration: InputDecoration(labelText: 'Username'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<dynamic>> data1 = [];
  List<List<dynamic>> data2 = [];
  List<List<dynamic>> data3 = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      String token = await obtainToken(
          "paola.aranda", "66A171B7A7F"); // Credenciales del usuario
      List<Map<String, dynamic>> companyData = await fetchCompanyData(token);
      processCompanyData(companyData);
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
  }

  // Simula la función obtainToken y fetchCompanyData, asegúrate de reemplazarlas con tus implementaciones reales
  Future<String> obtainToken(String username, String password) async {
    final response = await http.post(
      Uri.parse(
          'https://api.ibicare.mx/api/login'), // Asegúrate de que esta es la URL correcta para obtener el token
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_name': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Asegúrate del código de estado correcto según tu API
      // Si el servidor devolvió una respuesta exitosa,
      // extrae el token del JSON.
      var responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return responseData[
          'sessiontoken']; // Asegúrate de que 'sessiontoken' es la clave correcta para el token en la respuesta JSON.
    } else {
      // Si el servidor no devolvió una respuesta exitosa,
      // entonces lanza una excepción.
      throw Exception('Failed to obtain token.');
    }
  }

  // Función para obtener datos específicos de la empresa utilizando un token en los encabezados
  Future<List<Map<String, dynamic>>> fetchCompanyData(String token) async {
    final url = Uri.parse(
        'https://api.ibicare.mx/api/clockData/myData?yearI=2024&monthI=04&dayI=01&yearF=2024&monthF=12&dayF=30');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'sessiontoken': token,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> allData = jsonDecode(response.body);
        // Procesa los datos recibidos
        return allData
            .map((data) => {
                  'date': data['date'],
                  'calories': data['calories'],
                  'hrvValueAvg': data['hrvValueAvg'],
                  'stressAvg': data['stressAvg']
                })
            .toList();
      } else {
        // Si el código de estado no es 200, lanza una excepción
        throw Exception(
            'Failed to fetch company data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Manejo de errores generales
      throw Exception('Error fetching data: $e');
    }
  }

  void processCompanyData(List<Map<String, dynamic>> companyData) {
    List<List<dynamic>> dateCalories = [];
    List<List<dynamic>> dateHRV = [];
    List<List<dynamic>> dateStress = [];

    for (var data in companyData) {
      dateCalories.add([data['date'], data['calories']]);
      dateHRV.add([data['date'], data['hrvValueAvg']]);
      dateStress.add([data['date'], data['stressAvg']]);
    }

    setState(() {
      data1 = dateCalories;
      data2 = dateHRV;
      data3 = dateStress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Número total de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text("Health Performance Pro"),
              const SizedBox(width: 20), // Espacio entre el texto y la imagen
              Image.asset(
                "assets/images/hpp.jpg", // Ruta de tu imagen
                width: 60, // Ajusta el ancho de la imagen según sea necesario
                height: 60, // Ajusta la altura de la imagen según sea necesario
              ),
            ],
          ),
          /*  /*  actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Aquí puedes agregar la lógica para la acción del botón
              },
            ), */
          ], */
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Calorías'),
              Tab(text: 'HRV'),
              Tab(text: 'Estrés'),
            ],
          ),
        ),
        // Fondo de pantalla con gradiente
        backgroundColor:
            Colors.transparent, // Hacer transparente el fondo del Scaffold
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 29, 70, 141),
                Color.fromARGB(255, 29, 70, 91),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: TabBarView(
            children: [
              _buildDataTable(data1),
              _buildDataTable(data2),
              _buildDataTable2(data3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataTable2(List<List<dynamic>> data) {
    return ListView.builder(
      itemCount: data.length +
          1, // Aumenta el conteo para incluir la fila de encabezado
      itemBuilder: (_, int index) {
        if (index == 0) {
          // Fila de encabezado
          return Card(
            color: Color.fromARGB(
                255, 195, 16, 52), // Color de fondo para el encabezado
            child: const ListTile(
              leading: Text("Fecha",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              title: Text("Valor",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          );
        } else {
          // Fila de datos
          int dataIndex =
              index - 1; // Ajusta el índice para acceder a los datos
          double value = double.parse(data[dataIndex][1].toString());
          Color rowColor = _getRowColorBasedOnValue(value);

          return Card(
            margin: const EdgeInsets.all(3),
            color: rowColor,
            child: ListTile(
              leading: Text(data[dataIndex][0].toString()), // Fecha
              title: Text(data[dataIndex][1].toString()), // Valor numérico
            ),
          );
        }
      },
    );
  }

  Color _getRowColorBasedOnValue(double value) {
    if (value <= 25) {
      return Colors.green[400] ?? Colors.green; // Verde para valores bajos
    } else if (value <= 50) {
      return Colors.yellow[600] ??
          Colors.yellow; // Amarillo para valores medios
    } else {
      return Colors.red[400] ?? Colors.red; // Rojo para valores altos
    }
  }

  Widget _buildDataTable(List<List<dynamic>> data) {
    return ListView.builder(
      itemCount: data.length +
          1, // Aumenta el conteo para incluir la fila de encabezado
      itemBuilder: (_, int index) {
        if (index == 0) {
          // Fila de encabezado
          return Card(
            color: Color.fromARGB(
                255, 195, 16, 52), // Color de fondo para el encabezado
            child: const ListTile(
              leading: Text("Fecha",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              title: Text("Valor",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          );
        } else {
          // Fila de datos
          int dataIndex =
              index - 1; // Ajusta el índice para acceder a los datos
          return Card(
            margin: const EdgeInsets.all(3),
            color: dataIndex % 2 == 0
                ? const Color.fromARGB(
                    255, 189, 208, 223) // Color alterno para las filas
                : const Color.fromARGB(255, 189, 208, 223),
            child: ListTile(
              leading: Text(data[dataIndex][0].toString()), // Fecha
              title: Text(data[dataIndex][1].toString()), // Valor numérico
            ),
          );
        }
      },
    );
  }
}
