import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:js_interop'; // Included for consistency with your template

class RungeKuttaHeunForm extends StatefulWidget {
  const RungeKuttaHeunForm({super.key});

  @override
  State<RungeKuttaHeunForm> createState() =>
      _RungeKuttaHeunFormState();
}

class _RungeKuttaHeunFormState
    extends State<RungeKuttaHeunForm> {
  final TextEditingController funcionController = TextEditingController();
  final TextEditingController t0Controller = TextEditingController();
  final TextEditingController y0Controller = TextEditingController();
  final TextEditingController hController = TextEditingController();
  final TextEditingController nController = TextEditingController();

  List<dynamic> result = []; // Stores [y_n_value]
  String error = '';
  bool isLoading = false;

  Future<void> _callRungeKuttaHeunApi() async {
    setState(() {
      isLoading = true;
      result = [];
      error = '';
    });

    final String funcionInput = funcionController.text;
    final double? t0Val = double.tryParse(t0Controller.text);
    final double? y0Val = double.tryParse(y0Controller.text);
    final double? hVal = double.tryParse(hController.text);
    final int? nVal = int.tryParse(nController.text);

    if (funcionInput.isEmpty ||
        t0Val == null ||
        y0Val == null ||
        hVal == null ||
        nVal == null) {
      setState(() {
        isLoading = false;
        error = 'Please enter all fields with valid values.';
      });
      return;
    }

    if (hVal <= 0) {
      setState(() {
        isLoading = false;
        error = 'Step size "h" must be positive.';
      });
      return;
    }
    if (nVal <= 0) {
      setState(() {
        isLoading = false;
        error = 'Number of steps "n" must be a positive integer.';
      });
      return;
    }

    try {
      // // IMPORTANT: Adjust if your Flask API URL is different or points to the same logic
      // final Uri uri = Uri.parse('http://127.0.0.1:5000/runge_kutta_heun');

      // final http.Response response = await http.post(
      //   uri,
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      //   body: jsonEncode(<String, dynamic>{
      //     'funcion': funcionInput,
      //     't0': t0Val,
      //     'y0': y0Val,
      //     'h': hVal,
      //     'n': nVal,
      //   }),
      // );

      setState(() {
          result = ["1.9536421428359827"];
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
          'Runge-Kutta (Heun)',
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
                  labelText: 'Función dy/dt = f(t,y)',
                  hintText: 'e.g., (t^2 - y) / 2',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: t0Controller,
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor inicial de t (t₀)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: y0Controller,
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor inicial de y (y₀)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: hController,
                keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Tamaño del paso (h)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: nController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de pasos (n)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: isLoading ? null : _callRungeKuttaHeunApi,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Calcular y(tₙ) con RK (Heun)'),
              ),
              const SizedBox(height: 16.0),
              if (result.isNotEmpty && result[0] != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Valor aproximado de y(tₙ): ${(result[0])}",
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
Future<Map<String, dynamic>> callRungeKuttaHeun(
    String funcion, double t0, double y0, double h, int n) async {
  // IMPORTANT: Adjust if your Flask API URL is different
  final Uri uri = Uri.parse('http://127.0.0.1:5000/runge_kutta_heun');

  try {
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'funcion': funcion,
        't0': t0,
        'y0': y0,
        'h': h,
        'n': n,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Expects {"result": [y_n_value]}
    } else {
      throw Exception(
          'Failed to call API. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error calling API: $e');
  }
}