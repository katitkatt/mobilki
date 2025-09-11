import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView( // ← Прокрутка при необходимости
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 1. Верхний контейнер с текстом
              Container(
                width: screenWidth * 0.8,
                height: 60,
                color: Colors.blue[100],
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                alignment: Alignment.center,
                child: const Text(
                  'Hello!!!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              // 2. Отступ
              SizedBox(height: screenHeight * 0.05),

              // 3. Картинка + FloatingActionButton сбоку → используем Stack
              Stack(
                alignment: Alignment.center,
                children: [
                  // Картинка (новая, без ошибок)
                  Container(
                    width: screenWidth * 0.6,
                    height: screenWidth * 0.6,
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child:Image.asset('assets/images/26009f58d792dcfffd2ef046e5edd22b.jpg')
                  ),
                  // FloatingActionButton справа от картинки
                  Positioned(
                    right: 0,
                    top: screenWidth * 0.3 - 30,
                    child: FloatingActionButton(
                      onPressed: () {},
                      child: const Text('тык'),
                    ),
                  ),
                ],
              ),

              // 4. Отступ
              SizedBox(height: screenHeight * 0.05),

              // 5. Вместо кружков — кнопки (например, 5 кнопок в строке)
            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    for (int i = 0; i < 5; i++)
      ...[
        ElevatedButton(
          onPressed: () {
            print('Кнопка $i нажата!');
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.grey[300],
          ),
          child: Text(
            '${i + 1}',
            style: const TextStyle(fontSize: 12),
          ),
        ),
        if (i < 4) const SizedBox(width: 20), // ← Отступ между кнопками
      ]
  ],
),
              // 6. Footer — в самом низу экрана
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                color: Colors.grey[200],
                child: const Text(
                  'Footer',
                  style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}