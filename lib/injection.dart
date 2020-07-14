import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import 'injection.iconfig.dart';

final getIt = GetIt.instance;
final GoogleSignIn googleSignIn = getIt.get<GoogleSignIn>();

@injectableInit
void configureDependencies() => $initGetIt(getIt);
