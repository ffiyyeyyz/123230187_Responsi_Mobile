import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../services/favorite_service.dart';
import '../theme.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String? _username;
  int _favoriteCount = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Dipanggil dari MainPage atau DetailPage untuk refresh data profil
  void reload() => _load();

  Future<void> _load() async {
    final username = await AuthService.getUsername();
    if (mounted) {
      setState(() {
        _username = username;
        _favoriteCount = FavoriteService.getFavoriteCount();
      });
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Logout', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: AppTheme.bone)),
        content: Text('Yakin ingin keluar?', style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.tan)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Batal', style: GoogleFonts.poppins(color: AppTheme.mossGreen, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Logout', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AuthService.logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              color: AppTheme.surface,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                bottom: 32, left: 20, right: 20,
              ),
              child: Column(
                children: [
                  Container(
                    width: 86, height: 86,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.mossGreen, width: 2),
                    ),
                    child: const Icon(Icons.person_rounded, color: AppTheme.tan, size: 48),
                  ),
                  const SizedBox(height: 14),
                  Text(_username ?? '-', style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.bone)),
                  const SizedBox(height: 4),
                  Text('Member Keripikroll', style: GoogleFonts.poppins(
                    fontSize: 12, color: AppTheme.mossGreen)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Info card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.kombuGreen.withOpacity(0.5), width: 0.5),
                    ),
                    child: Column(
                      children: [
                        _infoRow(
                          icon: Icons.person_outline_rounded,
                          label: 'Username',
                          value: _username ?? '-',
                        ),
                        Divider(color: AppTheme.kombuGreen.withOpacity(0.3), height: 1),
                        _infoRow(
                          icon: Icons.favorite_border_rounded,
                          label: 'Anime Disukai',
                          value: '$_favoriteCount',
                          valueColor: AppTheme.accent,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Logout button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.error.withOpacity(0.15),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: AppTheme.error.withOpacity(0.5), width: 1),
                      ),
                      icon: const Icon(Icons.logout_rounded, color: AppTheme.error, size: 20),
                      label: Text('Logout', style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.error,
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({required IconData icon, required String label, required String value, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.mossGreen, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label, style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.tan)),
          ),
          Text(value, style: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w700,
            color: valueColor ?? AppTheme.bone,
          )),
        ],
      ),
    );
  }
}
