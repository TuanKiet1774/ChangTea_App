import 'package:changtea/HomeChangTea/home.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qvqpbpcnmjruzlmudzpe.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF2cXBicGNubWpydXpsbXVkenBlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIxODEyNzUsImV4cCI6MjA1Nzc1NzI3NX0.rG1hmzLhhLRSAFn-VJQx2kE82XpSEcr8Llwo0PkKTM0',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trà Sữa ChangTea',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 255, 200, 0),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
