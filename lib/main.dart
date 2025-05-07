import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:incasator/data/bloc/auth_bloc/auth_bloc_cubit.dart';
import 'package:incasator/data/bloc/deposit_bloc/deposit_cubit.dart';
import 'package:incasator/data/bloc/statistika_bloc/statistika__cubit.dart';
import 'package:incasator/data/bloc/userme/user_me_cubit.dart';
import 'package:incasator/data/network/auth_api.dart';
import 'package:incasator/data/network/precessing_api.dart';
import 'package:incasator/data/network/statistika_api.dart';
import 'package:incasator/data/network/user_me.dart';
import 'package:incasator/presentation/screens/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'data/bloc/collect_cubit.dart';
import 'data/bloc/precessing_bloc/precessing_bloc_cubit.dart';
import 'data/network/deposit_api.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(seconds: 3));
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
      // dark: ThemeData(brightness: Brightness.dark),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AuthBlocCubit>(
                create: (context) => AuthBlocCubit(AuthApiRequest()),
              ),
              BlocProvider<ProcessingCubit>(
                create: (context) => ProcessingCubit(PrecessingApi()),
              ),
              BlocProvider<DepositCubit>(
                create: (context) =>
                    DepositCubit(DepositReplenishmentsListRequest()),
              ),
              BlocProvider(create: (context) => CollectCubit()),
              BlocProvider<StatistikaCubit>(
                  create: (context) => StatistikaCubit(StatistikaApi())),
              BlocProvider<UserMeCubit>(
                create: (context) => UserMeCubit(UserMeRequest()),
              ),
            ],
            child: MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              theme: theme,
              darkTheme: darkTheme,
              home: child,
            ),
          );
        },
        child: SplashScreen(),
      ),
    );
  }
}
