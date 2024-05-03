import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<dynamic>> _data1 = [];
  List<List<dynamic>> _data2 = [];
  List<List<dynamic>> _data3 = [];

  @override
  void initState() {
    super.initState();
    _loadCSV("assets/data/heart_rate.csv", 1);
    _loadCSV("assets/data/calorias.csv", 2);
    _loadCSV("assets/data/estres.csv", 3);
  }

  void _loadCSV(String path, int dataSet) async {
    final rawData = await rootBundle.loadString(path);
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
    setState(() {
      if (dataSet == 1) {
        _data1 = listData;
      } else if (dataSet == 2) {
        _data2 = listData;
      } else if (dataSet == 3) {
        _data3 = listData;
      }
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
              const SizedBox(width: 40), // Espacio entre el texto y la imagen
              Image.asset(
                "assets/images/hpp.jpg", // Ruta de tu imagen
                width: 64, // Ajusta el ancho de la imagen según sea necesario
                height: 64, // Ajusta la altura de la imagen según sea necesario
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Aquí puedes agregar la lógica para la acción del botón
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Heart Rate'),
              Tab(text: 'Calorías'),
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
              _buildDataTable(_data1),
              _buildDataTable(_data2),
              _buildDataTable(_data3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataTable(List<List<dynamic>> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (_, int index) {
        return Card(
          margin: const EdgeInsets.all(3),
          color: index == 0
              ? Color.fromARGB(255, 236, 33, 81)
              : Color.fromARGB(255, 189, 208, 223),
          child: ListTile(
            leading: Text((data[index][0].toString())),
            title: Text(data[index][1].toString()),
            trailing: Text(data[index][2].toString()),
          ),
        );
      },
    );
  }
}
