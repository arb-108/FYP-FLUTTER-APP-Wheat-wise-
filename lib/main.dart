import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/scan_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/diagnose_history_provider.dart';
import 'providers/language_provider.dart';
import 'screens/home_screen.dart';
import 'screens/result_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Transparent status bar + system nav
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const PlantiaApp());
}

class PlantiaApp extends StatelessWidget {
  const PlantiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScanProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => DiagnoseHistoryProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, lang, _) => MaterialApp(
          title: lang.get('appTitle'),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(fontFamily: lang.fontFamily),
          darkTheme: AppTheme.darkTheme(fontFamily: lang.fontFamily),
          themeMode: ThemeMode.system,
          locale: lang.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('ur'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: '/',
          routes: {
            '/': (context) => const HomeScreen(),
            '/result': (context) => const ResultScreen(),
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: Text(lang.get('error'))),
                body: Center(child: Text(lang.get('pageNotFound'))),
              ),
            );
          },
        ),
      ),
    );
  }
}
