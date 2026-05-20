import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/anime.dart';
import '../services/api_service.dart';
import '../services/favorite_service.dart';
import '../theme.dart';
import 'main_page.dart';

class DetailPage extends StatefulWidget {
  final String animeId;
  const DetailPage({super.key, required this.animeId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Anime? _anime;
  bool _isLoading = true;
  bool _isFavorite = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final anime = await ApiService.getAnimeById(widget.animeId);
      if (mounted) {
        setState(() {
          _anime = anime;
          _isLoading = false;
          _isFavorite = FavoriteService.isFavorite(anime.id);
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_anime == null) return;
    if (_isFavorite) {
      await FavoriteService.removeFavorite(_anime!.id);
    } else {
      await FavoriteService.addFavorite(_anime!);
    }
    setState(() => _isFavorite = !_isFavorite);

    if (!mounted) return;

    // Ambil referensi MainPageState untuk refresh tab Favorit & Profil
    final mainState = context.findAncestorStateOfType<MainPageState>();
    mainState?.refreshProfile();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        _isFavorite ? 'Ditambahkan ke favorit ❤️' : 'Dihapus dari favorit',
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
      ),
      backgroundColor: _isFavorite ? AppTheme.success : AppTheme.mossGreen,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      action: _isFavorite
          ? SnackBarAction(
              label: 'Lihat Favorit',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);       // kembali ke MainPage
                mainState?.goToFavorite();    // switch ke tab Favorit & refresh
              },
            )
          : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: Text('Detail', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator(color: AppTheme.accent)),
      );
    }

    if (_error != null || _anime == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(title: const Text('Detail')),
        body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: AppTheme.error, size: 48),
            const SizedBox(height: 12),
            Text('Gagal memuat detail', style: GoogleFonts.poppins(color: AppTheme.tan)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _load, child: const Text('Coba Lagi')),
          ],
        )),
      );
    }

    final anime = _anime!;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // Hero image as SliverAppBar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.surface,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
              ),
            ),
            title: Text('Detail', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.bone)),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  anime.coverUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: anime.coverUrl,
                          fit: BoxFit.cover,
                          placeholder: (ctx, url) => Container(color: AppTheme.surface),
                          errorWidget: (ctx, url, _) => Container(color: AppTheme.surface,
                              child: const Icon(Icons.image_outlined, color: AppTheme.mossGreen, size: 48)),
                        )
                      : Container(color: AppTheme.surface),
                  // gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppTheme.background.withOpacity(0.9)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(anime.titleEnJp,
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.bone, height: 1.2)),
                  const SizedBox(height: 10),

                  // Rating
                  Row(children: [
                    const Icon(Icons.star_rounded, color: AppTheme.accent, size: 18),
                    const SizedBox(width: 5),
                    Text(anime.displayRating,
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.accent)),
                  ]),
                  const SizedBox(height: 8),

                  // Age rating + Episodes
                  Row(children: [
                    _infoBadge(anime.displayAgeRating, AppTheme.kombuGreen, AppTheme.mossGreen),
                    const SizedBox(width: 8),
                    _infoBadge(anime.displayEpisodes, AppTheme.cafeNoir, AppTheme.tan),
                    if (anime.status != null) ...[
                      const SizedBox(width: 8),
                      _infoBadge(anime.status!, AppTheme.surfaceCard, AppTheme.mossGreen),
                    ],
                  ]),
                  const SizedBox(height: 20),

                  // Nonton + Favorite buttons row
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.mossGreen,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.play_arrow_rounded, color: AppTheme.background, size: 20),
                          label: Text('Nonton', style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.background,
                          )),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Favorite button — UI berubah sesuai state
                      GestureDetector(
                        onTap: _toggleFavorite,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 50, height: 50,
                          decoration: BoxDecoration(
                            color: _isFavorite ? AppTheme.accent.withOpacity(0.2) : AppTheme.surfaceCard,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isFavorite ? AppTheme.accent : AppTheme.mossGreen.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: _isFavorite ? AppTheme.accent : AppTheme.mossGreen,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Synopsis
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Color(0xFF2E3D1F), height: 24),
                  Text('Overview', style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.bone,
                  )),
                  const SizedBox(height: 10),
                  Text(
                    anime.synopsis?.isNotEmpty == true ? anime.synopsis! : 'Tidak ada sinopsis.',
                    style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.tan, height: 1.7),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBadge(String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(50)),
      child: Text(label, style: GoogleFonts.poppins(
        fontSize: 11, fontWeight: FontWeight.w600, color: textColor,
      )),
    );
  }
}
