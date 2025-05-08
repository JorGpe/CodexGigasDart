import 'package:flutter/material.dart';

import 'package:codexgigas/navigation/navigation.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List items = [
    {'name': 'Ecuaciones no lineales no polinomiales'},
    {'name': 'Ecuaciones polinomiales'},
    {'name': 'Interpolación polinomial, polinomios ortogonales y ajuste de curvas'},
    {'name': 'Integración Numérica'},
    {'name': 'Ecuaciones diferenciales, ordinarias y parciales'},
  ];

  List<Map<String, String>> ecu_no_lin_no_poli = [
    {'subname': "Bisección"},
    {'subname': "Regla Falsa"},
    {'subname': "Secante"},
    {'subname': "Newton Rapson"},
    {'subname': "Punto fijo"},
    {'subname': "Newton-Raphson aplicado a sistemas de ecuaciones no lineales"},
    {'subname': "Punto fijo aplicado a sistemas de ecuaciones no lineales"}
  ];

  List<Map<String, String>> ecu_poli = [
    {'subname': "Bairstow"},
    {'subname': "Newton"},
  ];

  List<Map<String, String>> interpol_polinomial_poli_orto_ajuste_curvas = [
    {'subname': "Vandermonde"},
    {'subname': "Interpolación de Newton"},
    {'subname': "Interpolación Baricéntrica (Lagrange)"},
    {'subname': "Mínimos cuadrados"},
    {'subname': "Polinomios ortogonales de Chebyshev"},
  ];

  List<Map<String, String>> integracion_num = [
    {'subname': "Fórmula cerrada de Newton-Cotes “N = 1”"},
    {'subname': "Fórmula cerrada de Newton-Cotes “N = 2”"},
    {'subname': "Fórmula cerrada de Newton-Cotes “N = 3”"},
    {'subname': "Fórmula abierta de Newton-Cotes “N = 0”"},
    {'subname': "Fórmula abierta de Newton-Cotes “N = 1”"},
    {'subname': "Fórmula abierta de Newton-Cotes “N = 2”"},
    {'subname': "Fórmula de integración de Romberg"},
    {'subname': "Cuadraturas de Gauss-Legendre “N = 2”"},
    {'subname': "Cuadraturas de Gauss-Legendre “N = 3”"}
  ];

  List<Map<String, String>> ecu_dif__ord_partial = [
    {'subname': "Método de un paso - Euler"},
    {'subname': "Método de un paso - Euler-Cauchy (regla trapezoidal)"},
    {'subname': "Método de un paso - Runge-Kutta (euler modificado)"},
    {'subname': "Método de un paso - Runge-Kutta [Orden 2]"},
    {'subname': "Métodos multipaso - Método predictor-corrector Correctos iterativo para “M = 0”"},
    {'subname': "Sistemas de ecuaciones diferenciales"},
    {'subname': "Sistemas de ecuaciones diferenciales - Euler"},
    {'subname': "Sistemas de ecuaciones diferenciales - Euler-Cauchy (regla trapezoidal)"},
    {'subname': "Sistemas de ecuaciones diferenciales - Runge-Kutta (euler modificado)"},
    {'subname': "Sistemas de ecuaciones diferenciales - Runge-Kutta [Orden 2]"},
  ];

  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List<List<Map<String, String>>> allSubItems = [
      ecu_no_lin_no_poli,
      ecu_poli,
      interpol_polinomial_poli_orto_ajuste_curvas,
      integracion_num,
      ecu_dif__ord_partial,
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Codex Gigas - Analisis Numérico",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final subItemList = allSubItems[index];
          final item = items[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding( // Add padding for better spacing
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? 'No Name',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8), // Add some spacing between the main title and sub-items
                  Wrap( // Use Wrap to arrange sub-items in a row that wraps
                    spacing: 5.0, // Spacing between sub-item widgets
                    runSpacing: 5.0, // Spacing between rows of sub-item widgets
                    children: subItemList.map<Widget>((subItem) {
                     return Chip(
                      padding: EdgeInsets.only(top: 3, bottom: 3),
                       label: TextButton(
                          onPressed: (){
                            context.go("/functions/${subItem['subname']!.toLowerCase()}");
                          }, 
                          child: Text('${subItem['subname']}'),
                        ),
                     );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}