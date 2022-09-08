import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../src/bloc/auth/auth_bloc.dart';
import '../../src/bloc/auth/auth_event.dart';

class MainNoteScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!.displayName;
  MainNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.07),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.08,
            ),
            Row(
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Hi,',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: ' $user',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )
                  ]),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Row(
              children: [
                SizedBox(
                  child: SvgPicture.asset(
                    'assets/svgs/search.svg',
                  ),
                ),
                SizedBox(
                  width: width * 0.03,
                ),
                const Text(
                  'Search',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                )
              ],
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Wrap(
              runSpacing: width * 0.05,
              direction: Axis.horizontal,
              children: [
                FolderCard(
                  svgPicture: 'assets/svgs/Add.svg',
                  text: 'Create Folder',
                  color: const Color(0xffececec),
                  press: () {},
                ),
                SizedBox(width: width * 0.05,),
                FolderCard(
                  svgPicture: 'assets/svgs/Notes.svg',
                  text: 'My Notes',
                  color: const Color(0xffd5ebf4),
                  press: () {
                    context.read<AuthBloc>().add(const AuthEventGoToNotes());
                  },
                ),
                FolderCard(
                  svgPicture: 'assets/svgs/Checklist.svg',
                  text: 'To-Do List',
                  color: const Color(0xffebe6b8),
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FolderCard extends StatelessWidget {
  final String svgPicture;
  final String text;
  final Color color;
  final VoidCallback press;
  const FolderCard({
    super.key,
    required this.svgPicture,
    required this.text,
    required this.color,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: press,
      child: Container(
        width: width * 0.4,
        height: width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgPicture,
              width: 27.59,
              height: 27.59,
            ),
            SizedBox(
              height: width * 0.02,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
