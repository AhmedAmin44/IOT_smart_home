
import 'package:iot_smart_home_secure/core/database/cache/cache_helper.dart';
import 'package:iot_smart_home_secure/core/serveces/service_locator.dart';



// ignore: non_constant_identifier_names
void UserVisited(){
  // the method that store the user are visit the app ,that used in (skip , creat acc , login now)
  getIt<CacheHelper>().saveData(key: "isUserVisited", value: true );
}