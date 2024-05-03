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
  List<List<dynamic>> _data = [];

  void _loadCSV() async {
    final rawData = await rootBundle.loadString("assets/data/heart_rate.csv");
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
    setState(() {
      _data = listData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Health Performance Pro"),
            const SizedBox(width: 85), // Espacio entre el texto y la imagen
            Image.asset(
              "assets/images/hpp.jpg", // Ruta de tu imagen
              width: 64, // Ajusta el ancho de la imagen según sea necesario
              height: 64, // Ajusta la altura de la imagen según sea necesario
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (_, int index) {
          return Card(
            margin: const EdgeInsets.all(3),
            color: index == 0 ? Colors.amber : Colors.white,
            child: ListTile(
              leading: Text((_data[index][0].toString())),
              title: Text(_data[index][1].toString()),
              trailing: Text(_data[index][2].toString()),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadCSV,
        child: const Icon(Icons.add),
      ),
      // Display the contents from the CSV file
    );
  }
}
