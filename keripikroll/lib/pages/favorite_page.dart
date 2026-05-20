import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/anime.dart';
import '../services/favorite_service.dart';
import '../theme.dart';
import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => FavoritePageState();
}

class FavoritePageState extends State<FavoritePage> {
  List<Anime> _favorites = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Dipanggil dari MainPage atau DetailPage untuk refresh daftar favorit
  void reload() => _load();

  void _load() => setState(() => _favorites = FavoriteService.getFavorites());

  Future<void> _remove(String id) async {
    await FavoriteService.removeFavorite(id);
    _load();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Dihapus dari favorit', style: GoogleFonts.poppins(color: Colors.white, fontSize: 13)),
      backgroundColor: AppTheme.mossGreen,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              color: AppTheme.surface,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 20, right: 20, bottom: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Daftar Favorit', style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.bone,
                  )),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppTheme.accent.withOpacity(0.4)),
                    ),
                    child: Text('${_favorites.length} anime',
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.accent)),
                  ),
                ],
              ),
            ),
          ),

          if (_favorites.isEmpty)
            SliverFillRemaining(
              child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 80, height: 80,
                    decoration: BoxDecoration(color: AppTheme.surfaceCard, shape: BoxShape.circle),
                    child: const Icon(Icons.favorite_border_rounded, color: AppTheme.mossGreen, size: 40)),
                  const SizedBox(height: 16),
                  Text('Belum ada anime favorit', style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.bone)),
                  const SizedBox(height: 8),
                  Text('Tambahkan dari halaman detail anime',
                    style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.mossGreen)),
                ],
              )),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((ctx, i) {
                  final anime = _favorites[i];
                  return _FavoriteItem(
                    anime: anime,
                    onDelete: () => _remove(anime.id),
                    onTap: () async {
                      await Navigator.push(ctx, MaterialPageRoute(
                          builder: (_) => DetailPage(animeId: anime.id)));
                      _load();
                    },
                  );
                }, childCount: _favorites.length),
              ),
            ),
        ],
      ),
    );
  }
}

class _FavoriteItem extends StatelessWidget {
  final Anime anime;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _FavoriteItem({required this.anime, required this.onDelete, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.kombuGreen.withOpacity(0.4), width: 0.5),
        ),
        child: Row(
          children: [
            // Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: anime.posterUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: anime.posterUrl,
                      width: 56, height: 72,
                      fit: BoxFit.cover,
                      placeholder: (ctx, url) => Container(width: 56, height: 72, color: AppTheme.surface),
                      errorWidget: (ctx, url, _) => Container(
                        width: 56, height: 72, color: AppTheme.surface,
                        child: const Icon(Icons.image_outlined, color: AppTheme.mossGreen, size: 20)),
                    )
                  : Container(width: 56, height: 72, color: AppTheme.surface),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(anime.titleEnJp, style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.bone, height: 1.3),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.star_rounded, color: AppTheme.accent, size: 13),
                    const SizedBox(width: 3),
                    Text(anime.displayRating, style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.tan)),
                    const SizedBox(width: 8),
                    Text(anime.displayAgeRating, style: GoogleFonts.poppins(
                      fontSize: 11, color: AppTheme.mossGreen)),
                  ]),
                ],
              ),
            ),
            // Delete button
            GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.error.withOpacity(0.3), width: 0.5),
                ),
                child: const Icon(Icons.delete_outline_rounded, color: AppTheme.error, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
