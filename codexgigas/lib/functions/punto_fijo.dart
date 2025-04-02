import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:js_interop';


class PuntoFijoForm extends StatefulWidget {
  const PuntoFijoForm({super.key, required this.data});
  final String data; // Keep the 'data' argument if you need it

  @override
  State<PuntoFijoForm> createState() => _PuntoFijoFormState();
}

class _PuntoFijoFormState extends State<PuntoFijoForm> {
  final TextEditingController funcionController = TextEditingController();
  final TextEditingController valorInicialController = TextEditingController();
  var result = [];
  String error = '';
  bool isLoading = false;

  Future<void> _callPuntoFijo() async {
    setState(() {
      isLoading = true;
      result = [];
      error = '';
    });

    final String funcionEntrada = funcionController.text;
    final double? valorInicial = double.tryParse(valorInicialController.text);

    if (funcionEntrada.isEmpty || valorInicial == null) {
      setState(() {
        isLoading = false;
        error = 'Please enter a function and a valid initial value.';
      });
      return;
    }

    try {
      final Uri uri = Uri.parse('http://127.0.0.1:5000/punto_fijo'); // Replace with your Flask API URL

      final http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'funcion_entrada': funcionEntrada,
          'valor_inicial': valorInicial,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          result = responseData['result'];
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to call punto_fijo API. Status code: ${response.statusCode}, Body: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error calling punto_fijo API: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Added Scaffold as the root widget
      appBar: AppBar(
        title: const Text('Punto Fijo Calculator'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: funcionController,
                decoration: const InputDecoration(
                  labelText: 'Function (e.g., x^2 - 2)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: valorInicialController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Initial Value',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: isLoading ? null : _callPuntoFijo,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Calculate Punto Fijo'),
              ),
              const SizedBox(height: 16.0),
              if (result.isNotEmpty)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Resultado: ",
                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 10,),
                        Text(
                          result[0].toString(),
                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Iteraciones: ",
                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 10,),
                        Text(
                          result[1].toString(),
                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              if (error.isNotEmpty)
                Text(
                  error,
                  style: const TextStyle(fontSize: 16.0, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>> callPuntoFijo(
  String funcionEntrada, double valorInicial) async {
  final Uri uri = Uri.parse('http://127.0.0.1:5000/punto_fijo'); // Replace with your Flask API URL

  try {
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'funcion_entrada': funcionEntrada,
        'valor_inicial': valorInicial,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to call punto_fijo API. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error calling punto_fijo API: $e');
  }
}