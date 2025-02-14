
import 'package:get_it/get_it.dart';
import 'package:iot_smart_home_secure/core/database/cache/cache_helper.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<CacheHelper>(CacheHelper());
  // getIt.registerSingleton<AuthCubit>(AuthCubit());

}