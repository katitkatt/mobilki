import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main  () async {
      await Supabase.initialize(
    url:'https://diatfsydzbqpfdzwcgil.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRpYXRmc3lkemJxcGZkendjZ2lsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEyMTIxNzIsImV4cCI6MjA3Njc4ODE3Mn0.o5w70G_DuDtwR2MEaylJC68g-UTN5dzOJmVVmzVog8w');
 
   runApp(MaterialApp(home:MyApp())); }

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
    Future<List<dynamic>> _fetchData() async { 

     final res = await Supabase.instance.client
        .from('messages')
        .select();

     return res; 
    }

     Future<void> _addData() async {
      try{
    await Supabase.instance.client
        .from('messages')
        .insert({
          'id': '28', 
          'created_at': DateTime.now().toIso8601String(),
          'text': '20:31 прибыл годжо сатору',
          'username': 'kittika'
        });
         print(' Запись успешно добавлена в таблицу messages!');
    
    setState(() {});
  } catch (e) {
    print('Ошибка при добавлении записи: $e');
  }
  }
    
    @override 
    Widget build(BuildContext context) {

    return Scaffold(body:
    Column(children:[Container(color:Color.fromARGB(255, 174, 211, 224),width:800,height:600,
    child: 
     FutureBuilder<List<dynamic>>(
              future: _fetchData(),
              builder: (context, snapshot) { 
     return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    final item = snapshot.data![i];
                    return Card(
                        child: Column(                        
                          children: [              
                            Row(
                              children: [
                                Text(
                                  'ID: ${item['id']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(255, 163, 33, 243),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Text(
                                  'User: ${item['username']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            
                            
                            Text(
                              'Сообщение: ${item['text']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            
                            
                            Text(
                              'Дата: ${item['created_at']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color.fromARGB(255, 71, 5, 102),
                              ),
                            ),
                          ],
                        ),
                      
                    );
                  },
                );
              },
            ),
          ),
       // Кнопка для добавления данных
           ElevatedButton(
              onPressed: _addData,
              child: Text('Добавить запись'),
            ),
    ]
    )
    );
  }
}