import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Третий экран'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Третий экран'),
            SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Назад'),
            ),
            
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: Text('На главный'),
            ),
          ],
        ),
      ),
    );
  }
}