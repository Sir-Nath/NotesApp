import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/views/login_view.dart';
import 'firebase_options.dart';
import 'dart:developer';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'HOME PAGE',
        ),
      ),
      body: FutureBuilder<Object>(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {

            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                final emailVerified = user?.emailVerified ?? false;
                if(emailVerified){
                  log('you email is verified');
                }else{
                  log('you need to verify your email');
                }
                return Center(
                  child: Text('Done'),
                );
              default:
                return const Text('Loading');
            }
          }),
    );
  }
}
