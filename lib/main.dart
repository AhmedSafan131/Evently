import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/firebase_options.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:evently/ui/home/home_screen.dart';
import 'package:evently/ui/onboarding/onboarding_screen.dart';
import 'package:evently/utils/app_theme.dart';
import 'package:evently/utils/locale_provider.dart';
import 'package:evently/utils/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'ui/create_event/create_event_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Firestore offline persistence is enabled by default on mobile/desktop. Do not call enablePersistence().
  await Hive.initFlutter();
  Hive.registerAdapter(EventDataAdapter());
  var box = await Hive.openBox<EventData>('events');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: localeProvider.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: OnboardingScreen.routName,
        routes: {
          OnboardingScreen.routName: (context) => const OnboardingScreen(),
          HomeScreen.routName: (context) => const HomeScreen()
        },
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeProvider.themeMode,
      ),
    );
  }
}
