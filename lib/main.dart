import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'core/routing/app_router.dart';
import 'feature/dashboard/presentation/cubit/dashboard_cubit.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
  FlutterNativeSplash.remove();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DashboardCubit(),
          ),
        ],
        child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            color: Colors.white,
            routerDelegate: AppRouter().router.routerDelegate,
            routeInformationParser: AppRouter().router.routeInformationParser,
            routeInformationProvider:
                AppRouter().router.routeInformationProvider,
            title: 'Fit Track',
            theme: ThemeData(
                fontFamily: "Roboto",
                colorScheme: ColorScheme.light().copyWith(
                    surface: Colors.transparent,
                    surfaceTint: Colors.transparent),
                bottomSheetTheme:
                    BottomSheetThemeData(backgroundColor: Colors.transparent),
                canvasColor: Colors.transparent)));
  }
}
