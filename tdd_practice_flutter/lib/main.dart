import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_practice_flutter/core/services/injection_container.dart';
import 'package:tdd_practice_flutter/src/authentication/presentation/cubit/cubit/authentication_cubit.dart';
import 'package:tdd_practice_flutter/src/authentication/presentation/view/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthenticationCubit>(),
      child: MaterialApp(
          theme: ThemeData(
              useMaterial3: true,
              visualDensity: VisualDensity.adaptivePlatformDensity),
          home: const HomeScreen()),
    );
  }
}
