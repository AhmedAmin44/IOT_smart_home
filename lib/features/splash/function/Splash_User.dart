
import 'package:IOT_SmartHome/core/database/cache/cache_helper.dart';
import 'package:IOT_SmartHome/core/serveces/service_locator.dart';



// ignore: non_constant_identifier_names
void UserVisited(){
  // the method that store the user are visit the app ,that used in (skip , creat acc , login now)
  getIt<CacheHelper>().saveData(key: "isUserVisited", value: true );
}