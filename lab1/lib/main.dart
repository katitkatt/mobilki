import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            
            // Аватарка
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://avatars.mds.yandex.net/i?id=a8e1cfeb2eda22637c1b49ecc2a3b623_l-6960551-images-thumbs&n=13',
              ),
            ),
            
            SizedBox(height: 20),
            
            // Имя
            Text(
              'Годжо Сатору',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 8, 206, 241),
              ),
            ),
            
            SizedBox(height: 10),
            
            // Город
            Text(
              'Токио',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            
            SizedBox(height: 30),
            
            // Контейнер с информацией
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 180, 255, 255),
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'О себе:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Маг особого уровня. Способность: бесконечность. \n "Ты сильный потому что ты Годжо Сатору, или ты Годжо Сатору потому что ты сильный',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Ряд с кнопками
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print('Нажата кнопка "Лайк"');
                  },
                  child: Text('Лайк'),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('Нажата кнопка "Сообщение"');
                  },
                  child: Text('Сообщение'),
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            // Большая кнопка
            Container(
              margin: EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  print('Нажата основная кнопка');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: Size(200, 50),
                ),
                child: Text('Подписаться'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}