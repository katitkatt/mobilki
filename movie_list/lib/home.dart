import 'package:flutter/material.dart';
import 'supabase_service.dart';
import 'add_movie.dart';
import 'fav.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseService _service = SupabaseService();
  List<Map<String, dynamic>> _movies = [];
  List<int> _favoriteIds = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final movies = await _service.getMovies();
      final favorites = await _service.getFavorites();
      final favoriteIds = favorites.map((f) => f['movie_id'] as int).toList();
      
      setState(() {
        _movies = movies;
        _favoriteIds = favoriteIds;
      });
    } catch (e) {
      print('Ошибка загрузки данных: $e');
    }
  }

  Future<void> _toggleFavorite(int movieId, bool isCurrentlyFavorite) async {
    try {
      if (isCurrentlyFavorite) {
        await _service.removeFromFavorites(movieId);
      } else {
        await _service.addToFavorites(movieId);
      }
      _loadData();
    } catch (e) {
      print('Ошибка обновления избранного: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мои фильмы'),
        actions: [
          IconButton(
            icon: Text('избранное'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavScreen()),
              );
            },
          ),
        ],
      ),
      body: _movies.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Нет фильмов в коллекции. Нажмите "+" чтобы добавить первый фильм',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),             
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                final movie = _movies[index];
                final movieId = movie['id'] as int;
                final isFavorite = _favoriteIds.contains(movieId);
                
                return MovieCard(
                  movie: movie,
                  isFavorite: isFavorite,
                  onFavoriteToggle: () => _toggleFavorite(movieId, isFavorite),
                  onDelete: () => _deleteMovie(movieId),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMovieScreen()),
          );
          _loadData();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteMovie(int movieId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Удалить фильм?'),
        content: Text('Вы уверены, что хотите удалить этот фильм из коллекции?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      try {
        await _service.deleteMovie(movieId);
        _loadData();
      } catch (e) {
        print('Ошибка удаления: $e');
      }
    }
  }
}

// ОБНОВЛЕННАЯ КАРТОЧКА ФИЛЬМА
class MovieCard extends StatelessWidget {
  final Map<String, dynamic> movie;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onDelete;

  const MovieCard({
    required this.movie,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final posterUrl = movie['poster_url'];
    final title = movie['title'] ?? 'Без названия';
    final releaseDate = movie['release_date'];
    final description = movie['description'];

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
            // ЗАГОЛОВОК И КНОПКИ
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Кнопка избранного
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: onFavoriteToggle,
                ),
                // Кнопка удаления
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            
            SizedBox(height: 10),
            
            // ДАТА ВЫХОДА
            if (releaseDate != null)
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  SizedBox(width: 6),
                  Text(
                    _formatDate(releaseDate),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            
            SizedBox(height: 12),
            
            // ОБЛОЖКА (ЕСЛИ ЕСТЬ)
            if (posterUrl != null && posterUrl.isNotEmpty)
              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 300,
                    maxWidth: 200,
                  ),
                  child: Image.network(
                    posterUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              Text('Не удалось загрузить обложку'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            
            SizedBox(height: 12),
            
            // ОПИСАНИЕ (ЕСЛИ ЕСТЬ)
            if (description != null && description.isNotEmpty)
              Container(
                width: double.infinity,
                child: Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      // Если дата уже в формате ГГГГ-ММ-ДД
      if (dateString.contains('-')) {
        final date = DateTime.parse(dateString);
        return 'Дата выхода: ${date.day}.${date.month}.${date.year}';
      }
      // Если дата уже в формате ДД.ММ.ГГГГ
      return 'Дата выхода: $dateString';
    } catch (e) {
      return 'Дата: $dateString';
    }
  }
} 