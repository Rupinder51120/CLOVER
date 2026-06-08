import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clover/core/api/api_client.dart';
import 'package:clover/core/theme/app_theme.dart';
import 'package:clover/main.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Map? dna;
  Map? wrapped;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final dnaRes = await ApiClient.dio.get('/clover-dna');
      setState(() { dna = dnaRes.data; });
    } catch (e) {}
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A0A0A), Color(0xFF111111)],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF8FAFD), Color(0xFFEEF6FF)],
                ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkRepGold.withOpacity(0.15)
                                  : AppColors.light1989Primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(child: Text('🍀', style: TextStyle(fontSize: 20))),
                          ),
                          const SizedBox(width: 12),
                          Text('Clover',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: isDark ? AppColors.darkRepGold : AppColors.light1989Primary,
                                  )),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              themeMode == ThemeMode.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                              color: isDark ? AppColors.darkRepGold : AppColors.light1989Primary,
                            ),
                            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
                          ),
                          IconButton(
                            icon: Icon(Icons.logout_rounded,
                                color: isDark ? AppColors.darkRepTextSecondary : AppColors.light1989TextSecondary),
                            onPressed: () async {
                              await ApiClient.clearTokens();
                              if (context.mounted) context.go('/login');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Greeting
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_greeting()} ✨',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Where will your\nnext era take you?',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              height: 1.2,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              // DNA Hero Card
              if (dna != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: GestureDetector(
                      onTap: () => context.push('/dna'),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: isDark
                              ? const LinearGradient(
                                  colors: [Color(0xFF1A1A1A), Color(0xFF2A2A1A)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : const LinearGradient(
                                  colors: [Color(0xFF7DA9D8), Color(0xFF5B8BCB)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          borderRadius: BorderRadius.circular(24),
                          border: isDark
                              ? Border.all(color: AppColors.darkRepGold.withOpacity(0.3))
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Clover DNA',
                                  style: TextStyle(
                                    color: isDark ? AppColors.darkRepGold : Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: isDark ? AppColors.darkRepGold : Colors.white70),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              dna!['personality_type'] ?? 'Explorer',
                              style: TextStyle(
                                color: isDark ? AppColors.darkRepText : Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${dna!['total_trips']} trips · ${dna!['total_countries']} countries',
                              style: TextStyle(
                                color: isDark ? AppColors.darkRepTextSecondary : Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _DnaMini(label: '🏔️', value: dna!['adventure_score'], isDark: isDark),
                                const SizedBox(width: 12),
                                _DnaMini(label: '🌿', value: dna!['nature_score'], isDark: isDark),
                                const SizedBox(width: 12),
                                _DnaMini(label: '📸', value: dna!['photography_score'], isDark: isDark),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // Section title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                  child: Text('Explore', style: Theme.of(context).textTheme.titleLarge),
                ),
              ),

              // Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildListDelegate([
                    _NavCard(
                      icon: '✈️',
                      label: 'My Trips',
                      subtitle: 'Log your adventures',
                      route: '/trips',
                      isDark: isDark,
                      accent: isDark ? AppColors.darkRepGold : AppColors.light1989Primary,
                    ),
                    _NavCard(
                      icon: '🗺️',
                      label: 'Discover',
                      subtitle: 'Find new places',
                      route: '/recommendations',
                      isDark: isDark,
                      accent: isDark ? const Color(0xFF4ADE80) : const Color(0xFF5B8BCB),
                    ),
                    _NavCard(
                      icon: '🤖',
                      label: 'AI Itinerary',
                      subtitle: 'Plan with AI',
                      route: '/itinerary',
                      isDark: isDark,
                      accent: isDark ? const Color(0xFFFF6B9D) : const Color(0xFF7DA9D8),
                    ),
                    _NavCard(
                      icon: '🎁',
                      label: 'Wrapped',
                      subtitle: 'Your travel story',
                      route: '/wrapped',
                      isDark: isDark,
                      accent: isDark ? AppColors.darkRepGold : const Color(0xFF5B8BCB),
                    ),
                    _NavCard(
                      icon: '🏆',
                      label: 'Challenges',
                      subtitle: 'Earn badges',
                      route: '/challenges',
                      isDark: isDark,
                      accent: isDark ? const Color(0xFF4ADE80) : AppColors.light1989Primary,
                    ),
                    _NavCard(
                      icon: '🧬',
                      label: 'Clover DNA',
                      subtitle: 'Your travel self',
                      route: '/dna',
                      isDark: isDark,
                      accent: isDark ? AppColors.darkRepGold : AppColors.light1989Accent,
                    ),
                  ]),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DnaMini extends StatelessWidget {
  final String label;
  final dynamic value;
  final bool isDark;
  const _DnaMini({required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 2),
        Text(
          '${(value as num).toInt()}',
          style: TextStyle(
            color: isDark ? AppColors.darkRepGold : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _NavCard extends StatelessWidget {
  final String icon;
  final String label;
  final String subtitle;
  final String route;
  final bool isDark;
  final Color accent;

  const _NavCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.route,
    required this.isDark,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkRepCard : AppColors.light1989Card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withOpacity(0.2)),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: accent.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15)),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
