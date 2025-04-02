import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:codexgigas/landing/landing.dart';
import 'package:codexgigas/functions/punto_fijo.dart';

final GoRouter global_router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => SelectableRegion(selectionControls: materialTextSelectionControls, child: const LandingPage()),
    ),
    GoRoute(
      path: '/functions/:message',
      builder: (BuildContext context, GoRouterState state) {
        final String message = state.pathParameters['message']!;
        return SelectableRegion(selectionControls: materialTextSelectionControls, child: PuntoFijoForm(data: message,));
      }
    ),
  ],
);