import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/anime.dart';
import 'services/auth_service.dart';
import 'services/favorite_service.dart';
import 'theme.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await Hive.initFlutter();
  Hive.registerAdapter(AnimeAdapter());
  await FavoriteService.init();

  runApp(const KeripikrollApp());
}

class KeripikrollApp extends StatelessWidget {
  const KeripikrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keripikroll',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _scale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
    _check();
  }

  Future<void> _check() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    final loggedIn = await AuthService.isLoggedIn();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => loggedIn ? const MainPage() : const LoginPage()),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppTheme.mossGreen, width: 2),
                  ),
                  child: const Icon(Icons.play_circle_outline_rounded,
                      color: AppTheme.accent, size: 54),
                ),
                const SizedBox(height: 24),
                Text('Keripikroll', style: TextStyle(
                  fontSize: 36, fontWeight: FontWeight.w900,
                  color: AppTheme.bone, fontFamily: 'Poppins', letterSpacing: 0.5,
                )),
                const SizedBox(height: 6),
                Text('Temukan anime favoritmu', style: TextStyle(
                  fontSize: 13, color: AppTheme.mossGreen, fontFamily: 'Poppins',
                )),
                const SizedBox(height: 60),
                SizedBox(width: 28, height: 28,
                  child: CircularProgressIndicator(
                    color: AppTheme.mossGreen.withOpacity(0.6), strokeWidth: 2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
