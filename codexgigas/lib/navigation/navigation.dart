import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:codexgigas/error/error_screen.dart';
import 'package:codexgigas/landing/landing.dart';

import 'package:codexgigas/functions/ecu_no_poli/newton_raphson.dart';
import 'package:codexgigas/functions/ecu_no_poli/biseccion.dart';
import 'package:codexgigas/functions/ecu_no_poli/newton_raphson_ecu_no_lineales.dart';
import 'package:codexgigas/functions/ecu_no_poli/secante.dart';
import 'package:codexgigas/functions/ecu_no_poli/regla_falsa.dart';
import 'package:codexgigas/functions/ecu_no_poli/punto_fijo.dart';
import 'package:codexgigas/functions/ecu_no_poli/punto_fijo_ecu_no_lineales.dart';

import 'package:codexgigas/functions/ecu_poli/newton.dart';
import 'package:codexgigas/functions/ecu_poli/bairstow.dart';

import 'package:codexgigas/functions/inter_poli/interpolacion_lagrange.dart';
import 'package:codexgigas/functions/inter_poli/interpolacion_newton.dart';
import 'package:codexgigas/functions/inter_poli/minimos_cuadrados.dart';
import 'package:codexgigas/functions/inter_poli/poli_orto_chebyshev.dart';
import 'package:codexgigas/functions/inter_poli/vandermode.dart';

import 'package:codexgigas/functions/integracion/gauss_legendre_n2.dart';
import 'package:codexgigas/functions/integracion/gauss_legendre_n3.dart';
import 'package:codexgigas/functions/integracion/integracion_romberg.dart';
import 'package:codexgigas/functions/integracion/punto_medio.dart';
import 'package:codexgigas/functions/integracion/simpson.dart';
import 'package:codexgigas/functions/integracion/simpson38.dart';
import 'package:codexgigas/functions/integracion/simpson_abierto.dart';
import 'package:codexgigas/functions/integracion/trapecio.dart';
import 'package:codexgigas/functions/integracion/trapecio_abierto.dart';

import 'package:codexgigas/functions/edo/euler.dart';
import 'package:codexgigas/functions/edo/euler_cauchy.dart';
import 'package:codexgigas/functions/edo/euler_cauchy_sistemas.dart';
import 'package:codexgigas/functions/edo/euler_sistemas.dart';
import 'package:codexgigas/functions/edo/predictor_corrector.dart';
import 'package:codexgigas/functions/edo/runge_kutta_euler_modificado.dart';
import 'package:codexgigas/functions/edo/runge_kutta_euler_modificado_sistemas.dart';
import 'package:codexgigas/functions/edo/runge_kutta_heun.dart';
import 'package:codexgigas/functions/edo/runge_kutta_heun_sistemas.dart';


final GoRouter globalRouter = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => SelectableRegion(selectionControls: materialTextSelectionControls, child: const LandingPage()),
    ),
    GoRoute(
      path: '/functions/:message',
      builder: (BuildContext context, GoRouterState state) {
        final String message = state.pathParameters['message']!;

        switch(message){
          case "bisección":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: BiseccionForm());
          case "punto fijo":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: PuntoFijoForm());
          case "secante":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: SecanteForm());
          case "newton rapson":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: NewtonRaphsonForm());
          case "newton-raphson aplicado a sistemas de ecuaciones no lineales":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: NewtonRaphsonSistemasForm());
          case "punto fijo aplicado a sistemas de ecuaciones no lineales":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: PuntoFijoSistemasForm());
          case "regla falsa":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: ReglaFalsaForm());
          
          case "bairstow":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: BairstowForm());
          case "newton":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: NewtonInterpolationForm());

          case "vandermonde":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: VandermondeForm());
          case "interpolación de newton":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: NewtonEvaluatePolynomialForm());
          case "interpolación baricéntrica (lagrange)":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: LagrangeEvaluatePolynomialForm());
          case "mínimos cuadrados":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: MinimosCuadradosForm());
          case "polinomios ortogonales de chebyshev":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: ChebyshevPolynomialsForm());

          case "fórmula cerrada de newton-cotes “n = 1”":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: TrapecioForm());
          case "fórmula cerrada de newton-cotes “n = 2”":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: SimpsonUnTercioForm());
          case "fórmula cerrada de newton-cotes “n = 3”":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: SimpsonTresOctavosForm());
          case "fórmula abierta de newton-cotes “n = 0”":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: PuntoMedioForm());
          case "fórmula abierta de newton-cotes “n = 1”":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: TrapecioAbiertoN1Form());
          case "fórmula abierta de newton-cotes “n = 2”":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: SimpsonAbiertoN2Form());
          case "fórmula de integración de romberg":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: RombergForm());
          case "cuadraturas de gauss-legendre “n = 2”":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: GaussLegendreN2Form());
          case "cuadraturas de gauss-legendre “n = 3”":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: GaussLegendreN3Form());

          case "método de un paso - euler":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: EulerMethodForm());
          case "método de un paso - euler-cauchy (regla trapezoidal)":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: EulerCauchyForm());
          case "método de un paso - runge-kutta (euler modificado)":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: RungeKuttaModificadoForm());
          case "método de un paso - runge-kutta [orden 2]":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: RungeKuttaHeunForm());
          case "métodos multipaso - método predictor-corrector correctos iterativo para “m = 0”":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: PredictorCorrectorIterativoForm());
          case "sistemas de ecuaciones diferenciales - euler":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: EulerSistemasForm());
          case "sistemas de ecuaciones diferenciales - euler-cauchy (regla trapezoidal)":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: EulerCauchySistemasForm());
          case "sistemas de ecuaciones diferenciales - runge-kutta (euler modificado)":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: RungeKuttaModificadoSistemasForm());
          case "sistemas de ecuaciones diferenciales - runge-kutta [orden 2]":
            return SelectableRegion(selectionControls: materialTextSelectionControls, child: RungeKuttaHeunSistemasForm());

          default: 
            return ErrorScreen();
        }
      }
    ),
  ],
);