 import 'package:flutter/material.dart';
import 'supabase_service.dart';

class FavScreen extends StatefulWidget {
  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  final SupabaseService _service = SupabaseService();
  List<Map<String, dynamic>> _favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await _service.getFavorites();
      final movies = <Map<String, dynamic>>[];
      
      for (final fav in favorites) {
        final movieId = fav['movie_id'] as int;
        final movie = await _service.getMovieById(movieId);
        if (movie != null) {
          movies.add(movie);
        }
      }
      
      setState(() => _favoriteMovies = movies);
    } catch (e) {
      print('Ошибка загрузки избранного: $e');
    }
  }

  Future<void> _removeFromFavorites(int movieId) async {
    try {
      await _service.removeFromFavorites(movieId);
      _loadFavorites();
    } catch (e) {
      print('Ошибка удаления из избранного: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Избранные')),
      body: _favoriteMovies.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'Нет избранных фильмов',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: _favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = _favoriteMovies[index];
                
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                movie['title'] ?? 'Без названия',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.favorite, color: Colors.red),
                              onPressed: () => _removeFromFavorites(movie['id']),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 8),
                        
                        if (movie['release_date'] != null)
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                              SizedBox(width: 6),
                              Text(
                                _formatDate(movie['release_date']),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        
                        SizedBox(height: 12),
                        
                        if (movie['poster_url'] != null && movie['poster_url'].isNotEmpty)
                          Center(
                            child: Container(
                              constraints: BoxConstraints(
                                maxHeight: 250,
                                maxWidth: 180,
                              ),
                              child: Image.network(
                                movie['poster_url'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        
                        SizedBox(height: 12),
                        
                        if (movie['description'] != null && movie['description'].isNotEmpty)
                          Text(
                            movie['description'],
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatDate(String dateString) {
    try {
      if (dateString.contains('-')) {
        final date = DateTime.parse(dateString);
        return 'Дата выхода: ${date.day}.${date.month}.${date.year}';
      }
      return 'Дата выхода: $dateString';
    } catch (e) {
      return 'Дата: $dateString';
    }
  }
}