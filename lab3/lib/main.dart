import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main  () async {
      await Supabase.initialize(
    url:'https://diatfsydzbqpfdzwcgil.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRpYXRmc3lkemJxcGZkendjZ2lsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEyMTIxNzIsImV4cCI6MjA3Njc4ODE3Mn0.o5w70G_DuDtwR2MEaylJC68g-UTN5dzOJmVVmzVog8w');
 
   runApp(MaterialApp(home:MyApp())); }



class MyApp extends StatelessWidget {
    Future<List<dynamic>> _fetchData() async { 

     final res = await Supabase.instance.client
        .from('messages')
        .select();

     return res; 
    }
    
    @override 
    Widget build(BuildContext context) {

    return Scaffold(body:Container(color:Colors.red,width:200,height:200,
    
    child: FutureBuilder<List<dynamic>>(
            future: _fetchData(),  
            builder: (context, snapshot) {
             return Text('Data: ${snapshot.data}');
            }
        )
      )
    );
  }
}