import 'package:flutter/material.dart';
import 'package:clover/core/api/api_client.dart';
import 'package:clover/core/theme/app_theme.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});
  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  List recs = [];
  List gems = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final r = await ApiClient.dio.get('/recommendations');
      final g = await ApiClient.dio.get('/recommendations/hidden-gems');
      setState(() { recs = r.data; gems = g.data; loading = false; });
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
                  colors: [Color(0xFF0A0A0A), Color(0xFF111111)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : const LinearGradient(
                  colors: [Color(0xFFF8FAFD), Color(0xFFEEF6FF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: SafeArea(
          child: loading
              ? Center(child: CircularProgressIndicator(
                  color: isDark ? AppColors.darkRepGold : AppColors.light1989Primary))
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
                            Text('Discover', style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                      ),
                    ),

                    if (recs.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                          child: Text('Matched For You',
                              style: Theme.of(context).textTheme.titleLarge),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            final rec = recs[i];
                            final dest = rec['destination'];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                              child: _DestCard(rec: rec, dest: dest, isDark: isDark),
                            );
                          },
                          childCount: recs.length,
                        ),
                      ),
                    ],

                    if (gems.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                          child: Row(
                            children: [
                              Text('Hidden Gems', style: Theme.of(context).textTheme.titleLarge),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (isDark ? AppColors.darkRepGold : AppColors.light1989Primary)
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('✦ Rare',
                                    style: TextStyle(
                                      color: isDark ? AppColors.darkRepGold : AppColors.light1989Primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            final rec = gems[i];
                            final dest = rec['destination'];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                              child: _DestCard(rec: rec, dest: dest, isDark: isDark, isGem: true),
                            );
                          },
                          childCount: gems.length,
                        ),
                      ),
                    ],

                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                  ],
                ),
        ),
      ),
    );
  }
}

class _DestCard extends StatelessWidget {
  final Map rec;
  final Map dest;
  final bool isDark;
  final bool isGem;

  const _DestCard({
    required this.rec,
    required this.dest,
    required this.isDark,
    this.isGem = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? AppColors.darkRepGold : AppColors.light1989Primary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkRepCard : AppColors.light1989Card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isGem ? accent.withOpacity(0.3) : (isDark ? AppColors.darkRepBorder : AppColors.light1989Border),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.light1989Primary.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(dest['name'],
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              if (isGem)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Hidden Gem',
                      style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text('${dest['city']}, ${dest['country']}',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Text(rec['reason'],
              style: TextStyle(
                color: isDark ? AppColors.darkRepTextSecondary : AppColors.light1989TextSecondary,
                fontSize: 13,
                height: 1.4,
              )),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${rec['score']}% Match',
                  style: TextStyle(
                    color: accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (dest['avg_cost_per_day'] != null) ...[
                const SizedBox(width: 8),
                Text(
                  '₹${dest['avg_cost_per_day']?.toInt()}/day',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
