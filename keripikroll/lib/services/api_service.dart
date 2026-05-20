import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime.dart';

class ApiService {
  static const String _baseUrl = 'https://kitsu.io/api/edge';
  static const Map<String, String> _headers = {
    'Accept': 'application/vnd.api+json',
    'Content-Type': 'application/vnd.api+json',
  };

  /// Fetch daftar anime (paginasi 20 per page)
  static Future<List<Anime>> getAnimeList({int limit = 20, int offset = 0}) async {
    final uri = Uri.parse(
      '$_baseUrl/anime?page[limit]=$limit&page[offset]=$offset',
    );
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      final dataList = decoded['data'] as List<dynamic>;
      return dataList.map((item) => Anime.fromJson(item as Map<String, dynamic>)).toList();
    }
    throw Exception('Gagal memuat daftar anime (${response.statusCode})');
  }

  /// Fetch detail anime berdasarkan ID
  static Future<Anime> getAnimeById(String id) async {
    final uri = Uri.parse('$_baseUrl/anime/$id');
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>;
      return Anime.fromJson(data);
    }
    throw Exception('Gagal memuat detail anime (${response.statusCode})');
  }
}
