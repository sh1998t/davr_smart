import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:incasator/data/bloc/auth_bloc/auth_bloc_cubit.dart';
import 'package:incasator/data/bloc/deposit_bloc/deposit_cubit.dart';
import 'package:incasator/data/network/auth_api.dart';
import 'package:incasator/data/network/precessing_api.dart';
import 'package:incasator/presentation/screens/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'data/bloc/precessing_bloc/precessing_bloc_cubit.dart';
import 'data/network/deposit_api.dart';

void main() async {
  // await initDi();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('uz_UZ', null);
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ru'),
        Locale('uz'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('uz'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(brightness: Brightness.light),
      dark: ThemeData(brightness: Brightness.dark),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AuthBlocCubit>(
                create: (context) => AuthBlocCubit(AuthApiRequest()),
              ),
              BlocProvider<PrecessingBlocCubit>(
                create: (context) => PrecessingBlocCubit(PrecessingApi()),
              ),
              BlocProvider<DepositCubit>(
                create: (context) =>
                    DepositCubit(DepositReplenishmentsListRequest()),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme, // Light tema
              darkTheme: darkTheme, // Dark tema
              home: child,
            ),
          );
        },
        child: const SplashScreen(),
      ),
    );
  }
}
