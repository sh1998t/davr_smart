import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:incasator/data/bloc/auth_bloc/auth_bloc_cubit.dart';
import 'package:incasator/data/bloc/deposit_bloc/deposit_bloc_cubit.dart';
import 'package:incasator/data/network/auth_api.dart';
import 'package:incasator/data/network/deposit_api.dart';
import 'package:incasator/presentation/screens/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

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
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
            providers: [
              BlocProvider<AuthBlocCubit>(
                create: (context) => AuthBlocCubit(AuthApiRequest()),
              ),
              BlocProvider<DepositBlocCubit>(
                create: (context) =>
                    DepositBlocCubit(DepositReplenishmentsListRequest()),
              )
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: child,
            ));
      },
      child: const SplashScreen(),
    );
  }
}
