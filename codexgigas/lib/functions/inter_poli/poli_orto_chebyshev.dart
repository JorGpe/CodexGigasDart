import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:js_interop'; // Included for consistency with your template
import 'package:codexgigas/functions/api_ip.dart';

class ChebyshevPolynomialsForm extends StatefulWidget {
  const ChebyshevPolynomialsForm({super.key});

  @override
  State<ChebyshevPolynomialsForm> createState() =>
      _ChebyshevPolynomialsFormState();
}

class _ChebyshevPolynomialsFormState
    extends State<ChebyshevPolynomialsForm> {
  final TextEditingController funcionController = TextEditingController();
  final TextEditingController aController = TextEditingController();
  final TextEditingController bController = TextEditingController();
  final TextEditingController nController = TextEditingController();

  List<dynamic> result = []; // Stores [raiz_value]
  String error = '';
  bool isLoading = false;

  Future<void> _callChebyshevApi() async {
    setState(() {
      isLoading = true;
      result = [];
      error = '';
    });

    final String funcionInput = funcionController.text;
    final double? aVal = double.tryParse(aController.text);
    final double? bVal = double.tryParse(bController.text);
    final int? nVal = int.tryParse(nController.text);

    // if (funcionInput.isEmpty ||
    //     aVal == null ||
    //     bVal == null ||
    //     nVal == null) {
    //   setState(() {
    //     isLoading = false;
    //     error = 'Please enter all fields with valid values.';
    //   });
    //   return;
    // }

    // if (aVal >= bVal) {
    //   setState(() {
    //     isLoading = false;
    //     error = 'The lower bound "a" must be less than the upper bound "b".';
    //   });
    //   return;
    // }
    // if (nVal <= 0) {
    //    setState(() {
    //     isLoading = false;
    //     error = 'The value "n" must be a positive integer.';
    //   });
    //   return;
    // }


    try {
     
      final Uri uri = Uri.parse('$api_ip/poli_orto_chebyshev');

      final http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'funcion_entrada': funcionInput,
          'valor_a': aVal,
          'valor_b': bVal,
          'valor_n': nVal,
        }),
      );

      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('result') &&
            responseData['result'] is List &&
            (responseData['result'] as List).isNotEmpty) {
          // Expecting a single root in the list
          setState(() {
            result = responseData['result'];
            isLoading = false;
          });
        } else {
          setState(() {
            error =
                'Failed to parse API response: "result" key malformed or missing required data.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error =
              'Failed to call API. Status code: ${response.statusCode}, Body: ${response.body}';
          isLoading = false;
        });
      }
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
          'Chebyshev Polynomials Method',
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
              controller: funcionController,
              decoration: const InputDecoration(
                labelText: 'Función f(x)',
                hintText: 'e.g., x^3 - sin(x)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: aController,
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              decoration: const InputDecoration(
                labelText: 'Límite inferior del intervalo (a)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: bController,
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              decoration: const InputDecoration(
                labelText: 'Límite superior del intervalo (b)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: nController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Grado / Orden (n)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: isLoading ? null : _callChebyshevApi,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Calculate with Chebyshev'),
            ),
            const SizedBox(height: 16.0),
            if (result.isNotEmpty && result[0] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Raíz encontrada: ${(result[0] as num).toStringAsFixed(6)}",
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
    );
  }
}

// Standalone API call function
Future<Map<String, dynamic>> callChebyshevMethod(
    String funcion, double a, double b, int n) async {
  // IMPORTANT: Adjust if your Flask API URL is different
  final Uri uri = Uri.parse('$api_ip/poli_orto_chebyshev');

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
        'valor_n': n,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Expects {"result": [root_value]}
    } else {
      throw Exception(
          'Failed to call API. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error calling API: $e');
  }
}