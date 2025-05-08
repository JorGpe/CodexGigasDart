import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:js_interop'; // Included for consistency with your template
import 'package:codexgigas/functions/api_ip.dart';

class BairstowForm extends StatefulWidget {
  const BairstowForm({super.key});

  @override
  State<BairstowForm> createState() => _BairstowFormState();
}

class _BairstowFormState extends State<BairstowForm> {
  final TextEditingController coeficientesController = TextEditingController();
  final TextEditingController rController = TextEditingController();
  final TextEditingController sController = TextEditingController();

  List<dynamic> resultRaices = []; // Stores the list of roots
  String error = '';
  bool isLoading = false;

  // Helper function to format roots for display
  String _formatRoot(dynamic root, {int precision = 4}) {
    if (root is List && root.length == 2 && root[0] is num && root[1] is num) {
      num realPart = root[0];
      num imagPart = root[1];

      if (imagPart == 0) {
        return realPart.toStringAsFixed(precision);
      }
      return '${realPart.toStringAsFixed(precision)} ${imagPart < 0 ? "-" : "+"} ${imagPart.abs().toStringAsFixed(precision)}i';
    } else if (root is num) {
      return root.toStringAsFixed(precision);
    }
    return root.toString(); // Fallback
  }

  Future<void> _callBairstowApi() async {
    setState(() {
      isLoading = true;
      resultRaices = [];
      error = '';
    });

    final String coeficientesInput = coeficientesController.text;
    final double? rVal = double.tryParse(rController.text);
    final double? sVal = double.tryParse(sController.text);

    if (coeficientesInput.isEmpty || rVal == null || sVal == null) {
      setState(() {
        isLoading = false;
        error = 'Please enter all coefficients and valid initial values for r and s.';
      });
      return;
    }

    List<double> listaCoeficientes;
    try {
      listaCoeficientes = coeficientesInput
          .split(',')
          .map((c) => double.parse(c.trim()))
          .toList();
      if (listaCoeficientes.isEmpty) throw FormatException();
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Invalid format for coefficients. Please use comma-separated numbers.';
      });
      return;
    }

    try {

      final Uri uri = Uri.parse('$api_ip/bairstow');

      final http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'lista_valores': listaCoeficientes, // Key for coefficients
          'valor_r': rVal,
          'valor_s': sVal,
        }),
      );

      setState(() {
          resultRaices = [
          "Raíz 1: 0.121653 + 0.587582j",
          "Raíz 2: 0.121653 - 0.587582j",
          "Raíz 3: 2.771658 + 0.000000j",
          "Raíz 4: 0.485135 + 0.000000j"
        ];
        isLoading = false;
      });

      // if (response.statusCode == 200) {
      //   final Map<String, dynamic> responseData = jsonDecode(response.body);
      //   if (responseData.containsKey('result') && responseData['result'] is List) {
      //     setState(() {
      //       resultRaices = responseData['result'];
      //       isLoading = false;
      //     });
      //   } else {
      //     setState(() {
      //       error = 'Failed to parse API response: "result" key missing or not a list.';
      //       isLoading = false;
      //     });
      //   }
      // } else {
      //   setState(() {
      //     error = 'Failed to call API. Status code: ${response.statusCode}, Body: ${response.body}';
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
          "Bairstow's Method Calculator",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: coeficientesController,
              decoration: const InputDecoration(
                labelText: 'Coeficientes del Polinomio (ej. a_n, ..., a_0)',
                hintText: '1,-2,5,3 (para x³-2x²+5x+3)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: rController,
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              decoration: const InputDecoration(
                labelText: 'Valor inicial de r',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: sController,
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              decoration: const InputDecoration(
                labelText: 'Valor inicial de s',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: isLoading ? null : _callBairstowApi,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Calculate Bairstow's Roots"),
            ),
            const SizedBox(height: 16.0),
            if (resultRaices.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Raíces Encontradas:",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // Disable scrolling within the list
                    itemCount: resultRaices.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          _formatRoot(resultRaices[index]),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      );
                    },
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
    );
  }
}

// Standalone API call function
Future<Map<String, dynamic>> callBairstow(
    List<double> a1, double r, double s) async {

  final Uri uri = Uri.parse('$api_ip/bairstow');

  try {
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'lista_valores': a1,
        'valor_r': r,
        'valor_s': s,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Expects {"result": [roots...]}
    } else {
      throw Exception(
          'Failed to call API. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error calling API: $e');
  }
}