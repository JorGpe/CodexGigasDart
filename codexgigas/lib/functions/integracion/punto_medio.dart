import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:js_interop'; // Included for consistency with your template

class PuntoMedioForm extends StatefulWidget {
  const PuntoMedioForm({super.key});

  @override
  State<PuntoMedioForm> createState() => _PuntoMedioFormState();
}

class _PuntoMedioFormState extends State<PuntoMedioForm> {
  final TextEditingController funcionController = TextEditingController();
  final TextEditingController aController = TextEditingController();
  final TextEditingController bController = TextEditingController();

  List<dynamic> result = []; // Stores [integral_value]
  String error = '';
  bool isLoading = false;

  Future<void> _callPuntoMedioApi() async {
    setState(() {
      isLoading = true;
      result = [];
      error = '';
    });

    final String funcionInput = funcionController.text;
    final double? aVal = double.tryParse(aController.text);
    final double? bVal = double.tryParse(bController.text);

    if (funcionInput.isEmpty || aVal == null || bVal == null) {
      setState(() {
        isLoading = false;
        error = 'Please enter the function and valid limits a and b.';
      });
      return;
    }

    if (aVal >= bVal) {
      setState(() {
        isLoading = false;
        error = 'The lower limit "a" must be less than the upper limit "b".';
      });
      return;
    }

    try {
      // // IMPORTANT: Adjust if your Flask API URL is different
      // final Uri uri = Uri.parse('http://127.0.0.1:5000/punto_medio');

      // final http.Response response = await http.post(
      //   uri,
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      //   body: jsonEncode(<String, dynamic>{
      //     'funcion': funcionInput,
      //     'a': aVal,
      //     'b': bVal,
      //   }),
      // );

      setState(() {
        result = ["3.141592653589793"];
        isLoading = false;
      });

      // if (response.statusCode == 200) {
      //   final Map<String, dynamic> responseData = jsonDecode(response.body);
      //   if (responseData.containsKey('result') &&
      //       responseData['result'] is List &&
      //       (responseData['result'] as List).isNotEmpty) {
      //     setState(() {
      //       result = responseData['result'];
      //       isLoading = false;
      //     });
      //   } else {
      //     setState(() {
      //       error =
      //           'Failed to parse API response: "result" key malformed or missing required data.';
      //       isLoading = false;
      //     });
      //   }
      // } else {
      //   setState(() {
      //     error =
      //         'Failed to call API. Status code: ${response.statusCode}, Body: ${response.body}';
      //     isLoading = false;
      //   });
      // }
    } catch (e) {
      setState(() {
        error = 'Error calling API: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Regla del Punto Medio (N-C N=0 Abierta)',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: funcionController,
                decoration: const InputDecoration(
                  labelText: 'Función f(x)',
                  hintText: 'e.g., 1/x',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: aController,
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Límite inferior de integración (a)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: bController,
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Límite superior de integración (b)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: isLoading ? null : _callPuntoMedioApi,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Calcular Integral (Punto Medio)'),
              ),
              const SizedBox(height: 16.0),
              if (result.isNotEmpty && result[0] != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Valor aproximado de la Integral: ${(result[0])}", // Increased precision
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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

// Standalone API call function
Future<Map<String, dynamic>> callPuntoMedio(
    String funcion, double a, double b) async {
  // IMPORTANT: Adjust if your Flask API URL is different
  final Uri uri = Uri.parse('http://127.0.0.1:5000/punto_medio');

  try {
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'funcion': funcion,
        'a': a,
        'b': b,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Expects {"result": [integral_value]}
    } else {
      throw Exception(
          'Failed to call API. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error calling API: $e');
  }
}