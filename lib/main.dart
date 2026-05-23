import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';
import 'app/app_initializer.dart';

import 'core/app/block/cubit.dart';

Future<void> main() async {
  await AppInitializer.initialize();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MedicineCubit()..loadMedicines()),
      ],

      child: const MyApp(),
    ),
  );
}
