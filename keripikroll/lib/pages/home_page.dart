import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/anime.dart';
import '../services/api_service.dart';
import '../theme.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Anime> _animes = [];
  bool _isLoading = true;
  String? _error;
  int _offset = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadAnimes();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200
        && !_isLoadingMore && _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadAnimes() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final list = await ApiService.getAnimeList(limit: 20, offset: 0);
      if (mounted) setState(() { _animes = list; _isLoading = false; _offset = 20; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);
    try {
      final list = await ApiService.getAnimeList(limit: 20, offset: _offset);
      if (mounted) {
        setState(() {
          _animes.addAll(list);
          _offset += 20;
          _hasMore = list.length == 20;
          _isLoadingMore = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        controller: _scrollCtrl,
        slivers: [
          // AppBar
          SliverToBoxAdapter(
            child: Container(
              color: AppTheme.surface,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 20, right: 20, bottom: 16,
              ),
              child: Row(
                children: [
                  const Icon(Icons.play_circle_outline_rounded, color: AppTheme.accent, size: 28),
                  const SizedBox(width: 10),
                  Text('Keripikroll', style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.bone,
                  )),
                ],
              ),
            ),
          ),

          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: AppTheme.accent)),
            )
          else if (_error != null)
            SliverFillRemaining(
              child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off_rounded, color: AppTheme.mossGreen, size: 48),
                  const SizedBox(height: 12),
                  Text('Gagal memuat data', style: GoogleFonts.poppins(color: AppTheme.tan)),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _loadAnimes, child: const Text('Coba Lagi')),
                ],
              )),
            )
          else ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _AnimeCard(anime: _animes[i]),
                  childCount: _animes.length,
                ),
              ),
            ),
            if (_isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator(color: AppTheme.accent, strokeWidth: 2)),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ],
      ),
    );
  }
}

class _AnimeCard extends StatelessWidget {
  final Anime anime;
  const _AnimeCard({required this.anime});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => DetailPage(animeId: anime.id))),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Image
            Expanded(
              flex: 5,
              child: SizedBox(
                width: double.infinity,
                child: anime.posterUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: anime.posterUrl,
                        fit: BoxFit.cover,
                        placeholder: (ctx, url) => Container(
                          color: AppTheme.surface,
                          child: const Center(child: CircularProgressIndicator(
                            color: AppTheme.accent, strokeWidth: 2)),
                        ),
                        errorWidget: (ctx, url, _) => Container(
                          color: AppTheme.surface,
                          child: const Icon(Icons.image_outlined, color: AppTheme.mossGreen, size: 32),
                        ),
                      )
                    : Container(color: AppTheme.surface,
                        child: const Icon(Icons.image_outlined, color: AppTheme.mossGreen, size: 32)),
              ),
            ),
            // Info
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      anime.titleEnJp,
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.bone, height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Age rating + Episodes
                        Text(
                          '${anime.displayAgeRating} · ${anime.displayEpisodes}',
                          style: GoogleFonts.poppins(fontSize: 9, color: AppTheme.mossGreen, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 3),
                        // Rating
                        Row(children: [
                          const Icon(Icons.star_rounded, color: AppTheme.accent, size: 12),
                          const SizedBox(width: 3),
                          Text(
                            anime.displayRating,
                            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.tan),
                          ),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
