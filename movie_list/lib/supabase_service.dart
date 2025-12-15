import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // === АВТОРИЗАЦИЯ ===
  
  // Регистрация
  Future<void> signUp(String email, String password) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // Вход
  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Выход
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Получить ID текущего пользователя
  String? get currentUserId => _supabase.auth.currentUser?.id;

  // === ФИЛЬМЫ ===
  
  // Получить все фильмы
  Future<List<Map<String, dynamic>>> getMovies() async {
    final response = await _supabase
        .from('movies')
        .select()
        .order('release_date', ascending: false);
    
    return response;
  }

  // Добавить фильм
  Future<void> addMovie({
    required String title,
    required String releaseDate,
    required String posterUrl,
    required String description,
  }) async {
    await _supabase.from('movies').insert({
      'title': title,
      'release_date': releaseDate,
      'poster_url': posterUrl,
      'description': description,
      'user_id': _supabase.auth.currentUser!.id,
    });
  }

  // Удалить фильм
  Future<void> deleteMovie(int movieId) async {
    await _supabase
        .from('movies')
        .delete()
        .eq('id', movieId)
        .eq('user_id', _supabase.auth.currentUser!.id);
  }

  // === ИЗБРАННОЕ ===
  
  // Получить избранные фильмы пользователя
  Future<List<Map<String, dynamic>>> getFavorites() async {
    final response = await _supabase
        .from('favorites')
        .select()
        .eq('user_id', _supabase.auth.currentUser!.id);
    
    return response;
  }

  // Добавить фильм в избранное
  Future<void> addToFavorites(int movieId) async {
    await _supabase.from('favorites').insert({
      'movie_id': movieId,
      'user_id': _supabase.auth.currentUser!.id,
    });
  }

  // Удалить фильм из избранного
  Future<void> removeFromFavorites(int movieId) async {
    await _supabase
        .from('favorites')
        .delete()
        .eq('movie_id', movieId)
        .eq('user_id', _supabase.auth.currentUser!.id);
  }

  // Проверить, находится ли фильм в избранном
  Future<bool> isMovieFavorite(int movieId) async {
    final response = await _supabase
        .from('favorites')
        .select()
        .eq('movie_id', movieId)
        .eq('user_id', _supabase.auth.currentUser!.id);
    
    return response.isNotEmpty;
  }

  // Получить детали фильма по ID
  Future<Map<String, dynamic>?> getMovieById(int movieId) async {
    try {
      final response = await _supabase
          .from('movies')
          .select()
          .eq('id', movieId)
          .single();
      return response;
    } catch (e) {
      return null;
    }
  }
}