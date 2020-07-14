// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:fluttershare/di/app_module.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get_it/get_it.dart';

void $initGetIt(GetIt g, {String environment}) {
  final appModule = _$AppModule();
  g.registerFactory<GoogleSignIn>(() => appModule.googleSignIn);
}

class _$AppModule extends AppModule {}
