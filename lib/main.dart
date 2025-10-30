import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_bayanat/core/extention.dart';
import 'package:task_bayanat/features/approvals/presentation/controller/requestcubit_cubit.dart';
import 'package:window_manager/window_manager.dart';

import 'features/approvals/data/model/employee_model.dart';
import 'features/approvals/data/repo_imp/repo_impl.dart';
import 'features/approvals/domain/repo.dart';
import 'features/approvals/presentation/ui/screen/approval_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print(Firebase.delegatePackingProperty);

  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1034, 768),
      center: true,
      minimumSize: Size(1034, 768),
    );

    // Apply the window options
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ScreenUtilInit(
          designSize: context.isTablet
              ? (context.isLandscape
              ? const Size(1024, 768)
              : const Size(768, 1024))
              : context.isLandscape
              ? const Size(812, 375)
              : const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => RequestCubit(RequestRepositoryImpl()),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: ThemeMode.light,
              home: ApprovalScreen(),
            ),
          ),
        );
      },
    );
  }
}