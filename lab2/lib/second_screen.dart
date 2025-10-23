import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Второй экран'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Второй экран'),
            SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Назад'),
            ),
            
            ElevatedButton(
              onPressed: () {
                context.push('/third');
              },
              child: Text('На третий экран'),
            ),
          ],
        ),
      ),
    );
  }
}