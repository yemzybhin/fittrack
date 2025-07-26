import 'package:fittrack/core/routing/router_constants.dart';
import 'package:fittrack/feature/dashboard/presentation/pages/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';

class AppRouter {
  GoRouter router = GoRouter(
      navigatorKey: navigatorKey,
      routes: [
        GoRoute(
            name: RouteConstants.mainpage,
            path: '/',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: Mainpage(),
                transitionDuration: Duration(milliseconds: 300),
                transitionsBuilder: (_, a, __, c) =>
                    FadeTransition(opacity: a, child: c),
              );
            })
      ],
      errorPageBuilder: (context, state) {
        return const MaterialPage(
            child: Scaffold(
                body: Center(
          child: Text('data'),
        )));
      });
}
