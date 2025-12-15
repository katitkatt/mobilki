import 'package:flutter/material.dart';
import 'supabase_service.dart';

class AddMovieScreen extends StatefulWidget {
  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _posterController = TextEditingController();
  final _descController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Добавить фильм')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Название фильма*',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Дата выхода* (ДД.ММ.ГГГГ)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _posterController,
              decoration: InputDecoration(
                labelText: 'Ссылка на картинку*',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              minLines: 3,
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: _isLoading ? null : () => _addMovie(context),
              child: _isLoading 
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Добавить фильм'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            if (_posterController.text.isNotEmpty) 
              _buildPosterPreview(),
          ],
        ),
      ),
    );
  }

  Widget _buildPosterPreview() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Image.network(
        _posterController.text,
        height: 200,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            color: Colors.grey[200],
            child: Center(child: Text('Не удалось загрузить')),
          );
        },
      ),
    );
  }

  Future<void> _addMovie(BuildContext context) async {
    if (_titleController.text.isEmpty || 
        _dateController.text.isEmpty || 
        _posterController.text.isEmpty) {
      _showError(context, 'Заполните все обязательные поля');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Конвертируем дату
      final parts = _dateController.text.split('.');
      if (parts.length != 3) throw 'Неверный формат даты';
      
      final dbDate = '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';

      final service = SupabaseService();
      await service.addMovie(
        title: _titleController.text,
        releaseDate: dbDate,
        posterUrl: _posterController.text,
        description: _descController.text,
      );
      
      Navigator.pop(context);
    } catch (e) {
      _showError(context, 'Ошибка: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _posterController.dispose();
    _descController.dispose();
    super.dispose();
  }
}