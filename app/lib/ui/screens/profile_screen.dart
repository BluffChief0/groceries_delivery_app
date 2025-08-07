import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_delivery/logic/models/user.dart';
import 'package:grocery_delivery/main.dart';

class ProfileScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: BlocBuilder<ProfileCubit, User?>(
        builder: (context, user) {
          if (user == null) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(labelText: 'Email или телефон'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context
                        .read<ProfileCubit>()
                        .authenticate(_controller.text),
                    child: const Text('Войти'),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Имя: ${user.name}'),
                Text('Email/Телефон: ${user.emailOrPhone}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => context.read<ProfileCubit>().logout(),
                  child: const Text('Выйти'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
