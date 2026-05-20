import 'package:hive_flutter/hive_flutter.dart';
import '../models/anime.dart';

class FavoriteService {
  static const String _boxName = 'favorites';

  static Box<Anime> get _box => Hive.box<Anime>(_boxName);

  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<Anime>(_boxName);
    }
  }

  static Future<void> addFavorite(Anime anime) async {
    await _box.put(anime.id, anime);
  }

  static Future<void> removeFavorite(String animeId) async {
    await _box.delete(animeId);
  }

  static bool isFavorite(String animeId) {
    return _box.containsKey(animeId);
  }

  static List<Anime> getFavorites() {
    return _box.values.toList();
  }

  static int getFavoriteCount() {
    return _box.length;
  }
}
