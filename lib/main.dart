import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple/screens/home/home_screen.dart';
import 'package:ripple/screens/select_files/select_files_screen.dart';
import 'package:ripple/screens/splash/splash_screen.dart';
import 'package:ripple/services/selection_manager_service.dart';
import 'package:ripple/viewmodels/fetch_apk_viewmodel.dart';
import 'package:ripple/viewmodels/fetch_media_items_viewmodel.dart';
import 'package:ripple/viewmodels/permission_viewmodel.dart';
import 'package:ripple/viewmodels/fetch_folder_items_viewmodel.dart';

import 'core/constants/app_colors.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PermissionViewModel()),
        ChangeNotifierProvider(create: (_) => FetchFolderItemsViewModel()),
        ChangeNotifierProvider(create: (_) => FetchApkViewModel()),
        ChangeNotifierProvider(create: (_) => FetchMediaItemsViewModel()),
        ChangeNotifierProvider(create: (_) => SelectionManagerService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShareWave', // Updated title
      debugShowCheckedModeBanner: false,
      theme: AppColors.lightTheme,
      // Preload routes for better performance
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashWavesMoving(),
        '/home': (context) => const HomeScreen(),
        '/select_files': (context) => const SelectFilesScreen(),
      },
    );
  }
}
