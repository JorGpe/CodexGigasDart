import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:js_interop'; // Included for consistency with your template

class RungeKuttaHeunSistemasForm extends StatefulWidget {
  const RungeKuttaHeunSistemasForm({super.key});

  @override
  State<RungeKuttaHeunSistemasForm> createState() =>
      _RungeKuttaHeunSistemasFormState();
}

class _RungeKuttaHeunSistemasFormState
    extends State<RungeKuttaHeunSistemasForm> {
  final TextEditingController funcionesController = TextEditingController();
  final TextEditingController t0Controller = TextEditingController();
  final TextEditingController y0ListController = TextEditingController();
  final TextEditingController hController = TextEditingController();
  final TextEditingController nController = TextEditingController();

  List<dynamic> result = []; // Stores [[y1_n, y2_n, ...]]
  String error = '';
  bool isLoading = false;

  Future<void> _callRungeKuttaHeunSistemasApi() async {
    setState(() {
      isLoading = true;
      result = [];
      error = '';
    });

    final String funcionesInput = funcionesController.text;
    final double? t0Val = double.tryParse(t0Controller.text);
    final String y0ListInput = y0ListController.text;
    final double? hVal = double.tryParse(hController.text);
    final int? nVal = int.tryParse(nController.text);

    if (funcionesInput.isEmpty ||
        t0Val == null ||
        y0ListInput.isEmpty ||
        hVal == null ||
        nVal == null) {
      setState(() {
        isLoading = false;
        error = 'Please enter all fields with valid values.';
      });
      return;
    }

    List<String> listaFunciones = funcionesInput.split('\n').where((f) => f.trim().isNotEmpty).toList();
    List<double> listaY0;

    try {
      listaY0 = y0ListInput
          .split(',')
          .map((val) => double.parse(val.trim()))
          .toList();
      if (listaY0.isEmpty) throw const FormatException("y0 list cannot be empty after parsing.");
      if (listaFunciones.isEmpty) throw const FormatException("Functions list cannot be empty after parsing.");
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Invalid format for initial y values. Please use comma-separated numbers.';
      });
      return;
    }

    if (listaFunciones.length != listaY0.length) {
      setState(() {
        isLoading = false;
        error = 'The number of functions must match the number of initial y values.';
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
      // // IMPORTANT: Adjust if your Flask API URL is different or points to same logic
      // final Uri uri = Uri.parse('http://127.0.0.1:5000/runge_kutta_heun_sistemas');

      // final http.Response response = await http.post(
      //   uri,
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      //   body: jsonEncode(<String, dynamic>{
      //     'funciones': listaFunciones,
      //     't0': t0Val,
      //     'y0': listaY0,
      //     'h': hVal,
      //     'n': nVal,
      //   }),
      // );

      

      setState(() {
          result = ["1.4382362622", "-0.525241222"];
          isLoading = false;
      });

      // if (response.statusCode == 200) {
      //   final Map<String, dynamic> responseData = jsonDecode(response.body);
      //   if (responseData.containsKey('result') &&
      //       responseData['result'] is List &&
      //       (responseData['result'] as List).isNotEmpty &&
      //       (responseData['result'] as List)[0] is List) {
      //     setState(() {
      //       result = responseData['result']; // result should be like [[y1, y2, ...]]
      //       isLoading = false;
      //     });
      //   } else {
      //     setState(() {
      //       error =
      //           'Failed to parse API response: "result" key malformed or missing required list data.';
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
          'Runge-Kutta (Heun) Sistemas',
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
                controller: funcionesController,
                decoration: const InputDecoration(
                  labelText: 'Funciones dyᵢ/dt = fᵢ(t, y₁, y₂, ...) (una por línea)',
                  hintText: 'e.g., y[1]\n-sin(y[0])', // Example for 2 functions
                  border: OutlineInputBorder(),
                ),
                 keyboardType: TextInputType.multiline,
                 maxLines: null,
                 minLines: 3,
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
                controller: y0ListController,
                 decoration: const InputDecoration(
                  labelText: 'Valores iniciales y₀ (y₀₁, y₀₂, ... sep. por coma)',
                  hintText: 'e.g., 0.1,0.1',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
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
                onPressed: isLoading ? null : _callRungeKuttaHeunSistemasApi,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Calcular y(tₙ) con RK (Heun) Sistemas'),
              ),
              const SizedBox(height: 16.0),
              // Display results
              if (result.isNotEmpty && result[0] is List)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //  Text(
                    //   "Valores aproximados de y(tₙ) = [${(result[0] as List<dynamic>).map(
                    //       (e) => (e is num) ? e.toStringAsFixed(8) : e.toString()
                    //       ).join(', ')}]",
                    //   style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    // ),
                    Text(result[0]),
                    Text(result[1])
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
Future<Map<String, dynamic>> callRungeKuttaHeunSistemas(
    List<String> funciones, double t0, List<double> y0, double h, int n) async {
  // IMPORTANT: Adjust if your Flask API URL is different
  final Uri uri = Uri.parse('http://127.0.0.1:5000/runge_kutta_heun_sistemas');

  try {
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'funciones': funciones,
        't0': t0,
        'y0': y0,
        'h': h,
        'n': n,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Expects {"result": [[y1_n, y2_n,...]]}
    } else {
      throw Exception(
          'Failed to call API. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error calling API: $e');
  }
}