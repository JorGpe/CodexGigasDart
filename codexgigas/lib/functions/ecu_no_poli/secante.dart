import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:js_interop'; // Included for consistency with your template

import 'package:codexgigas/functions/api_ip.dart';


class SecanteForm extends StatefulWidget {
  const SecanteForm({super.key});

  @override
  State<SecanteForm> createState() => _SecanteFormState();
}

class _SecanteFormState extends State<SecanteForm> {
  final TextEditingController funcionController = TextEditingController();
  final TextEditingController x0Controller = TextEditingController(); // For first initial guess
  final TextEditingController x1Controller = TextEditingController(); // For second initial guess

  var result = []; // Stores [raiz, iteraciones]
  String error = '';
  bool isLoading = false;

  Future<void> _callSecanteApi() async {
    setState(() {
      isLoading = true;
      result = [];
      error = '';
    });

    final String funcionEntrada = funcionController.text;
    final double? x0 = double.tryParse(x0Controller.text);
    final double? x1 = double.tryParse(x1Controller.text);

    if (funcionEntrada.isEmpty || x0 == null || x1 == null) {
      setState(() {
        isLoading = false;
        error = 'Please enter the function and valid initial values for x0 and x1.';
      });
      return;
    }

    try {
      final Uri uri = Uri.parse('$api_ip/secante');

      final http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'funcion_entrada': funcionEntrada,
          'valor_a': x0, // Key for first initial guess
          'valor_b': x1, // Key for second initial guess
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('result') && responseData['result'] is List) {
          setState(() {
            result = responseData['result'];
            isLoading = false;
          });
        } else {
           setState(() {
            error = 'Failed to parse Secante API response: "result" key missing or not a list.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = 'Failed to call Secante API. Status code: ${response.statusCode}, Body: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error calling Secante API: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Secante Calculator',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                  labelText: 'Función (ej. x^3 - x - 2)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: x0Controller,
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Primer valor inicial (x₀)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: x1Controller,
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Segundo valor inicial (x₁)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: isLoading ? null : _callSecanteApi,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Calculate Secante'),
              ),
              const SizedBox(height: 16.0),
              if (result.isNotEmpty && result.length >= 2)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Raíz: ",
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          result[0]?.toStringAsFixed(6) ?? 'N/A', // Assuming result[0] is the root
                          style: const TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Iteraciones: ",
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          result[1]?.toStringAsFixed(0) ?? 'N/A', // Assuming result[1] is iterations
                          style: const TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              if (error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    error,
                    style: const TextStyle(fontSize: 16.0, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Standalone API call function (optional, for consistency with the template)
Future<Map<String, dynamic>> callSecante(
    String funcion, double x0, double x1) async {
  // IMPORTANT: Adjust if your Flask API URL for Secante is different
  final Uri uri = Uri.parse('$api_ip/secante');

  try {
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'funcion_entrada': funcion,
        'valor_a': x0,
        'valor_b': x1,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Returns the whole map, expecting {"result": [...]}
    } else {
      throw Exception(
          'Failed to call Secante API. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error calling Secante API: $e');
  }
}