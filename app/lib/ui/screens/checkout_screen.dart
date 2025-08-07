import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Оформление заказа')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Адрес доставки'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Дата доставки'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Время доставки'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Заказ оформлен!')),
                );
              },
              child: const Text('Подтвердить заказ'),
            ),
          ],
        ),
      ),
    );
  }
}