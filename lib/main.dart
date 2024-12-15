import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stocks_app/providers/stocks_provider.dart';
import 'package:stocks_app/screens/auth/login_screen.dart';
import 'package:stocks_app/screens/home_screen.dart';
import 'package:stocks_app/screens/web_home_screen.dart';
import 'package:stocks_app/widgets/responsive_layout.dart';
import 'package:stocks_app/core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StocksProvider()),
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Stocks App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: StreamBuilder<User?>(
          stream: AuthService().authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              return const ResponsiveLayout(
                mobileBody: HomeScreen(),
                webBody: WebHomeScreen(),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
