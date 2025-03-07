import 'package:get_it/get_it.dart';
import 'package:incasator/data/Di/di_container.config.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> initDi() async {
  await getIt.init();
  return getIt.allReady();
}

Future<void> disposeDi() {
  return getIt.reset();
}

T inject<T extends Object>() {
  return GetIt.I.get<T>();
}
