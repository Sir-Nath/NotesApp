import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('im working now now');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Register',
        ),
      ),
      body: FutureBuilder<Object>(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    autocorrect: false,
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'input your email here',
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    controller: _password,
                    decoration: const InputDecoration(hintText: 'input your password here'),
                  ),
                  TextButton(
                    //this is an application of future, async and await
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      final userCredential =
                      await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: email, password: password);
                      print(userCredential);
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextButton(onPressed: (){
                    setState(() {
                      print('printed');
                    });
                  },
                      child: Text('Print'))
                ],
              );
            default:
              return Text('Loading');
          }

        }
      ),
    );
  }
}
