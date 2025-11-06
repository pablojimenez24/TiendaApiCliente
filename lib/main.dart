// Importa el paquete principal de Flutter para construir interfaces gráficas.
import 'package:flutter/material.dart';

// Importa el paquete http para hacer peticiones a APIs REST.
import 'package:http/http.dart' as http;

// Importa las utilidades para manejar JSON (convertir de/para texto).
import 'dart:convert';

void main() {
  // Punto de entrada de la app: ejecuta el widget raíz MyApp.
  runApp(const MyApp());
}

// Widget principal de la aplicación (sin estado).
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo API Local',                     // Título de la app
      theme: ThemeData(primarySwatch: Colors.blue), // Tema (color principal)
      home: const ApiDemoPage(),                    // Página inicial
      debugShowCheckedModeBanner: false,            // Oculta la etiqueta "debug"
    );
  }
}

// Página principal (con estado) donde se muestran los botones y resultados.
class ApiDemoPage extends StatefulWidget {
  const ApiDemoPage({super.key});

  @override
  State<ApiDemoPage> createState() => _ApiDemoPageState();
}

// Estado asociado al widget ApiDemoPage
class _ApiDemoPageState extends State<ApiDemoPage> {
  // Controlador del TextField, usado para mostrar el resultado de las peticiones.
  final TextEditingController _outputController = TextEditingController();

  // URL base de la API (puedes cambiarla a tu servidor local).
  // Ejemplo: "http://192.168.1.10:3000"
  final String baseUrl = "http://localhost:3000/api";

  // Función que hace una llamada GET a un endpoint de la API.
  Future<void> _callApi(String endpoint) async {
    // Crea la URL completa concatenando la base con el endpoint.
    final url = Uri.parse('$baseUrl/$endpoint');

    // Muestra un mensaje mientras se hace la llamada.
    setState(() => _outputController.text = "Llamando a $url ...");

    try {
      // Realiza la llamada GET.
      final response = await http.get(url);

      // Si la respuesta fue exitosa (código 200 OK)
      if (response.statusCode == 200) {
        // Convierte el cuerpo (texto JSON) en un objeto de Dart.
        final data = json.decode(response.body);

        // Muestra el resultado formateado en el área de texto.
        setState(() {
          _outputController.text =
              const JsonEncoder.withIndent('  ').convert(data);
        });
      } else {
        // Si la respuesta tiene error (404, 500, etc.)
        setState(() {
          _outputController.text =
              "Error ${response.statusCode}: ${response.reasonPhrase}";
        });
      }
    } catch (e) {
      // Si ocurre un error de conexión u otro tipo de excepción.
      setState(() {
        _outputController.text = "Error al conectar con la API:\n$e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior con título
      appBar: AppBar(title: const Text('Tienda API Local')),

      // Cuerpo principal con padding
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Contenedor con varios botones en una sola fila adaptable.
            Wrap(
              spacing: 8, // Espacio entre botones
              children: [
                ElevatedButton(
                  onPressed: () => _callApi("productos"), // Llama a /users
                  child: const Text("GET /productos"),
                ),
                ElevatedButton(
                  onPressed: () => _callApi("clientes"), // Llama a /posts
                  child: const Text("GET /clientes"),
                ),
                ElevatedButton(
                  onPressed: () => _callApi("carritos"), // Llama a /status
                  child: const Text("GET /carritos"),
                ),
                ElevatedButton(
                  onPressed: () => _callApi("proveedores"), // Llama a /info
                  child: const Text("GET /proveedores"),
                ),
                ElevatedButton(
                  onPressed: () => _callApi("pedidos"), // Llama a /info
                  child: const Text("GET /pedidos"),
                ),
                ElevatedButton(
                  onPressed: () => _callApi("categorias"), // Llama a /info
                  child: const Text("GET /categorias"),
                ),
              ],
            ),

            const SizedBox(height: 20), // Espacio entre botones y texto

            // Área de texto expandible donde se muestra el resultado.
            Expanded(
              child: TextField(
                controller: _outputController, // Controlador del texto
                readOnly: true,                 // Solo lectura
                maxLines: null,                 // Permite muchas líneas
                expands: true,                  // Ocupa todo el espacio disponible
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), // Borde del cuadro
                  labelText: "Resultado de la API", // Etiqueta
                  alignLabelWithHint: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
