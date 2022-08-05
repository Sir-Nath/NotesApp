import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants/route.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/note/create_update_note_view.dart';
import 'package:notes/views/note/note_screen.dart';
import 'package:notes/views/register_view.dart';
import 'package:notes/views/verify_email_view.dart';
import 'constants/text_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: themeData(),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        noteRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView()
      },
    ),
  );
}

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: AuthService.firebase().initialise(),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             final user = AuthService.firebase().currentUser;
//             if (user != null) {
//               if (user.isEmailVerified) {
//                 return const NotesView();
//               } else {
//                 return const VerifyEmailView();
//               }
//             } else {
//               return const LoginView();
//             }
//           default:
//             return const Scaffold(
//               body: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             );
//         }
//       },
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CounterBloc(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Testing bloc'),
          ),
          body: BlocConsumer<CounterBloc, CounterState>(
            listener: (context, state) {
              _controller.clear();
            },
            builder: (context, state) {
              final invalidValue =
                  (state is CounterStateInvalid) ? state.invalidValue : '';
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Current value => ${state.value}'),
                  Visibility(
                    visible: state is CounterStateInvalid,
                    child: Text('invalid input: $invalidValue'),
                  ),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a number here',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          context.read<CounterBloc>().add(
                                DecrementEvent(_controller.text),
                              );
                        },
                        child: Text('-'),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          context.read<CounterBloc>().add(
                                IncrementEvent(_controller.text),
                              );
                        },
                        child: Text('+'),
                      )
                    ],
                  )
                ],
              );
            },
          ),
        ));
  }
}


//since bloc works with event and state, we will need to create a class for both
//and a central bloc class
//there are two states we are concerned about in this counter app namely; invalid and valid state
//we create an abstract class from which the states and events class will extend from

@immutable
abstract class CounterState {
  final int value;
  const CounterState(
    this.value,
  );
}

class CounterStateValid extends CounterState {
  const CounterStateValid(
    int value,
  ) : super(value);
}

class CounterStateInvalid extends CounterState {
  final String invalidValue;
  const CounterStateInvalid({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  //we must instantiate an initial value which in case is a state displaying 0
  CounterBloc() : super(const CounterStateValid(0)) {
    //on sending an increment event to bloc, we want to first try to parse whatever
    //value into an integer. if successful, we want to go for valid state else invalid state
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        //we use emit to send a state to the UI
        emit(
          CounterStateInvalid(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(
          CounterStateValid(state.value + integer),
        );
      }
    });
    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalid(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(
          CounterStateValid(state.value - integer),
        );
      }
    });
  }
}
