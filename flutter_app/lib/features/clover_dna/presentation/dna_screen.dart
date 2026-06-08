import 'package:flutter/material.dart';
import 'package:clover/core/api/api_client.dart';
import 'package:clover/core/theme/app_theme.dart';

class DnaScreen extends StatefulWidget {
  const DnaScreen({super.key});
  @override
  State<DnaScreen> createState() => _DnaScreenState();
}

class _DnaScreenState extends State<DnaScreen> with SingleTickerProviderStateMixin {
  Map? dna;
  bool loading = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _loadDna();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadDna() async {
    try {
      await ApiClient.dio.post('/clover-dna/recalculate');
      final res = await ApiClient.dio.get('/clover-dna');
      setState(() { dna = res.data; loading = false; });
      _controller.forward();
    } catch (e) {
      setState(() { loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          child: loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: isDark ? AppColors.darkRepGold : AppColors.light1989Primary,
                  ),
                )
              : dna == null
                  ? const Center(child: Text('No DNA data yet'))
                  : CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.darkRepCard : AppColors.light1989Card,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isDark ? AppColors.darkRepBorder : AppColors.light1989Border,
                                      ),
                                    ),
                                    child: Icon(Icons.arrow_back_ios_rounded, size: 16,
                                        color: isDark ? AppColors.darkRepText : AppColors.light1989Text),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text('Clover DNA', style: Theme.of(context).textTheme.titleLarge),
                              ],
                            ),
                          ),
                        ),

                        // Personality Hero
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: isDark
                                    ? LinearGradient(
                                        colors: [
                                          AppColors.darkRepGold.withOpacity(0.2),
                                          AppColors.darkRepCard,
                                        ],
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
                                  Text(
                                    'Your Travel Personality',
                                    style: TextStyle(
                                      color: isDark ? AppColors.darkRepGold : Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    dna!['personality_type'] ?? 'Explorer',
                                    style: TextStyle(
                                      color: isDark ? AppColors.darkRepText : Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'You feel most alive among mountains,\nscenic roads, and peaceful landscapes.',
                                    style: TextStyle(
                                      color: isDark ? AppColors.darkRepTextSecondary : Colors.white70,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      _StatPill(
                                        label: '${dna!['total_trips']} Trips',
                                        isDark: isDark,
                                      ),
                                      const SizedBox(width: 8),
                                      _StatPill(
                                        label: '${dna!['total_countries']} Countries',
                                        isDark: isDark,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // DNA Scores
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                            child: Text('DNA Scores', style: Theme.of(context).textTheme.titleLarge),
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkRepCard : AppColors.light1989Card,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isDark ? AppColors.darkRepBorder : AppColors.light1989Border,
                                ),
                              ),
                              child: Column(
                                children: [
                                  _AnimatedScoreRow(
                                    label: '🏔️  Adventure',
                                    score: (dna!['adventure_score'] as num).toDouble(),
                                    isDark: isDark,
                                    animation: _controller,
                                    color: isDark ? AppColors.darkRepGold : AppColors.light1989Primary,
                                  ),
                                  _AnimatedScoreRow(
                                    label: '🌿  Nature',
                                    score: (dna!['nature_score'] as num).toDouble(),
                                    isDark: isDark,
                                    animation: _controller,
                                    color: const Color(0xFF4ADE80),
                                  ),
                                  _AnimatedScoreRow(
                                    label: '🍜  Food',
                                    score: (dna!['food_score'] as num).toDouble(),
                                    isDark: isDark,
                                    animation: _controller,
                                    color: const Color(0xFFFF6B35),
                                  ),
                                  _AnimatedScoreRow(
                                    label: '🏛️  Culture',
                                    score: (dna!['culture_score'] as num).toDouble(),
                                    isDark: isDark,
                                    animation: _controller,
                                    color: const Color(0xFFFF6B9D),
                                  ),
                                  _AnimatedScoreRow(
                                    label: '📸  Photography',
                                    score: (dna!['photography_score'] as num).toDouble(),
                                    isDark: isDark,
                                    animation: _controller,
                                    color: isDark ? AppColors.darkRepGold : AppColors.light1989Accent,
                                  ),
                                  _AnimatedScoreRow(
                                    label: '🛋️  Relaxation',
                                    score: (dna!['relaxation_score'] as num).toDouble(),
                                    isDark: isDark,
                                    animation: _controller,
                                    color: const Color(0xFF7DA9D8),
                                  ),
                                  _AnimatedScoreRow(
                                    label: '💎  Luxury',
                                    score: (dna!['luxury_score'] as num).toDouble(),
                                    isDark: isDark,
                                    animation: _controller,
                                    color: isDark ? AppColors.darkRepGold : AppColors.light1989Primary,
                                    isLast: true,
                                  ),
                                ],
                              ),
                            ),
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

class _StatPill extends StatelessWidget {
  final String label;
  final bool isDark;
  const _StatPill({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDark ? AppColors.darkRepText : Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AnimatedScoreRow extends StatelessWidget {
  final String label;
  final double score;
  final bool isDark;
  final Animation<double> animation;
  final Color color;
  final bool isLast;

  const _AnimatedScoreRow({
    required this.label,
    required this.score,
    required this.isDark,
    required this.animation,
    required this.color,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyLarge),
              Text(
                '${score.toInt()}',
                style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (score / 100) * animation.value,
                  backgroundColor: isDark
                      ? Colors.white.withOpacity(0.06)
                      : Colors.black.withOpacity(0.06),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 8,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
