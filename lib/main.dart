import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injector.dart';
import 'core/firebase/firebase_bootstrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await FirebaseBootstrapper.initialise();
  runApp(const PersonalPortfolioApp());
}
