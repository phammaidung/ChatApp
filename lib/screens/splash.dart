import 'dart:async';

import 'package:chat_app/screens/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      // appBar: AppBar(
      //   title: const Text('FlutterChat'),
      // ),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            // Timer(
            //     const Duration(seconds: 1),
            //     () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            //         builder: (BuildContext context) => const AuthScreen())));
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 20, right: 20),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Text('Chit-Chat',
                  style: GoogleFonts.roboto(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
