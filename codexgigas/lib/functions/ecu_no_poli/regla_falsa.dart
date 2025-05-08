import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:js_interop'; // Included for consistency with your template
import 'package:codexgigas/functions/api_ip.dart';


class ReglaFalsaForm extends StatefulWidget {
  const ReglaFalsaForm({super.key});

  @override
  State<ReglaFalsaForm> createState() => _ReglaFalsaFormState();
}

class _ReglaFalsaFormState extends State<ReglaFalsaForm> {
  final TextEditingController funcionController = TextEditingController();
  final TextEditingController aController = TextEditingController();
  final TextEditingController bController = TextEditingController();

  var result = []; // Stores [raiz, iteraciones]
  String error = '';
  bool isLoading = false;

  Future<void> _callReglaFalsaApi() async {
    setState(() {
      isLoading = true;
      result = [];
      error = '';
    });

    final String funcionEntrada = funcionController.text;
    final double? a = double.tryParse(aController.text);
    final double? b = double.tryParse(bController.text);

    if (funcionEntrada.isEmpty || a == null || b == null) {
      setState(() {
        isLoading = false;
        error = 'Please enter the function and valid values for a and b.';
      });
      return;
    }

    try {
      // IMPORTANT: Adjust if your Flask API URL for Regla Falsa is different
      final Uri uri = Uri.parse('$api_ip/regla_falsa');

      final http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'funcion_entrada': funcionEntrada,
          'valor_a': a,
          'valor_b': b,
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
            error = 'Failed to parse Regla Falsa API response: "result" key missing or not a list.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = 'Failed to call Regla Falsa API. Status code: ${response.statusCode}, Body: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error calling Regla Falsa API: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Regla Falsa Calculator',
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
                  labelText: 'Function (e.g., x^3 - x - 2)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: aController,
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Lower bound of interval (a)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: bController,
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Upper bound of interval (b)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: isLoading ? null : _callReglaFalsaApi,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Calculate Regla Falsa'),
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
Future<Map<String, dynamic>> callReglaFalsa(
    String funcion, double a, double b) async {
  // IMPORTANT: Adjust if your Flask API URL for Regla Falsa is different
  final Uri uri = Uri.parse('$api_ip/regla_falsa');

  try {
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'funcion_entrada': funcion,
        'valor_a': a,
        'valor_b': b,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Returns the whole map, expecting {"result": [...]}
    } else {
      throw Exception(
          'Failed to call Regla Falsa API. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error calling Regla Falsa API: $e');
  }
}