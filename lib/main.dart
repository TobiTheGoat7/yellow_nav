import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:yellow_nav/providers/auth_provider.dart';
import 'package:yellow_nav/providers/place_provider.dart';
import 'package:yellow_nav/screens/homescreen.dart';
import 'package:yellow_nav/screens/homescreen2.dart';
import 'package:yellow_nav/screens/login_screen.dart';
import 'package:yellow_nav/screens/sign_up.dart';
import 'package:yellow_nav/services/firebase_services.dart';
import 'package:yellow_nav/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseService>(create: (_) => FirebaseService()),
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (context) =>
              AuthenticationProvider(context.read<FirebaseService>()),
        ),
        ChangeNotifierProvider(create: (_) => PlaceProvider()),
      ],
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            return MaterialApp(
              theme: lightTheme(),
              darkTheme: darkTheme(),
              debugShowCheckedModeBanner: false,
              home: user != null ? HomeScreen() : LoginScreen(),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
