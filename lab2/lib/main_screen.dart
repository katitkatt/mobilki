import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'second_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главный экран'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Главный экран'),
            SizedBox(height: 20),
            
            // Базовая навигация
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondScreen()),
                );
              },
              child: Text('Базовая навигация'),
            ),
            
            // Named routes
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
              child: Text('Named Routes'),
            ),
            
            // GoRouter
            ElevatedButton(
              onPressed: () {
                context.push('/second');
              },
              child: Text('GoRouter'),
            ),
          ],
        ),
      ),
    );
  }
}