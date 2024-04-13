import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokewiki/bloc/cubits/page_cubit.dart';
import 'package:pokewiki/bloc/cubits/user_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameControler = TextEditingController();
  final _passwordControler = TextEditingController();

  void _onSubmit() {
    if (_usernameControler.text.trim().isEmpty ||
        _passwordControler.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            "Invalid input",
          ),
          content: const Text(
            "Please, make sure a valid username and password was entered.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("Okay"),
            ),
          ],
        ),
      );
      return;
    }

    context.read<PageCubit>().changePage(1);
    context.read<UserCubit>().setUser(_usernameControler.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Login",
            style: GoogleFonts.dmSerifDisplay(
              textStyle: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            controller: _usernameControler,
            keyboardType: TextInputType.text,
            maxLength: 20,
            decoration: const InputDecoration(
              label: Text(
                "Username",
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            controller: _passwordControler,
            keyboardType: TextInputType.text,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            maxLength: 20,
            decoration: const InputDecoration(
              label: Text(
                "Password",
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          FilledButton(
            onPressed: _onSubmit,
            child: const Text(
              "Login",
            ),
          ),
        ],
      ),
    );
  }
}
