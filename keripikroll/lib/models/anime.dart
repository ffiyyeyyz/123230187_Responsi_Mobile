import 'package:hive/hive.dart';

part 'anime.g.dart';

@HiveType(typeId: 0)
class Anime extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String titleEnJp;

  @HiveField(2)
  final String titleEn;

  @HiveField(3)
  final String? synopsis;

  @HiveField(4)
  final String? averageRating;

  @HiveField(5)
  final String? ageRating;

  @HiveField(6)
  final String? ageRatingGuide;

  @HiveField(7)
  final int? episodeCount;

  @HiveField(8)
  final String? posterImageSmall;

  @HiveField(9)
  final String? posterImageLarge;

  @HiveField(10)
  final String? coverImageOriginal;

  @HiveField(11)
  final String? status;

  @HiveField(12)
  final String? startDate;

  Anime({
    required this.id,
    required this.titleEnJp,
    required this.titleEn,
    this.synopsis,
    this.averageRating,
    this.ageRating,
    this.ageRatingGuide,
    this.episodeCount,
    this.posterImageSmall,
    this.posterImageLarge,
    this.coverImageOriginal,
    this.status,
    this.startDate,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    final attr = json['attributes'] as Map<String, dynamic>;
    final titles = attr['titles'] as Map<String, dynamic>? ?? {};
    final posterImage = attr['posterImage'] as Map<String, dynamic>? ?? {};
    final coverImage = attr['coverImage'] as Map<String, dynamic>? ?? {};

    return Anime(
      id: json['id']?.toString() ?? '',
      titleEnJp: titles['en_jp']?.toString() ?? titles['en']?.toString() ?? 'Unknown',
      titleEn: titles['en']?.toString() ?? titles['en_jp']?.toString() ?? 'Unknown',
      synopsis: attr['synopsis']?.toString(),
      averageRating: attr['averageRating']?.toString(),
      ageRating: attr['ageRating']?.toString(),
      ageRatingGuide: attr['ageRatingGuide']?.toString(),
      episodeCount: attr['episodeCount'] as int?,
      posterImageSmall: posterImage['small']?.toString() ?? posterImage['tiny']?.toString(),
      posterImageLarge: posterImage['large']?.toString() ?? posterImage['original']?.toString(),
      coverImageOriginal: coverImage['original']?.toString() ?? coverImage['large']?.toString(),
      status: attr['status']?.toString(),
      startDate: attr['startDate']?.toString(),
    );
  }

  String get displayRating => averageRating != null ? averageRating! : 'N/A';
  String get displayEpisodes => episodeCount != null ? '${episodeCount} Eps' : 'N/A Eps';
  String get displayAgeRating => ageRating ?? 'N/A';
  String get posterUrl => posterImageSmall ?? posterImageLarge ?? '';
  String get coverUrl => coverImageOriginal ?? posterImageLarge ?? posterImageSmall ?? '';
}
