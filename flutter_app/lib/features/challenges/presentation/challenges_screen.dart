import 'package:flutter/material.dart';
import 'package:clover/core/api/api_client.dart';
import 'package:clover/core/theme/app_theme.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});
  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  List challenges = [];
  List badges = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final c = await ApiClient.dio.get('/challenges');
      final b = await ApiClient.dio.get('/challenges/badges');
      setState(() { challenges = c.data; badges = b.data; loading = false; });
    } catch (e) {
      setState(() { loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.darkRepGold : AppColors.light1989Primary;

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
              ? Center(child: CircularProgressIndicator(color: accent))
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
                            Text('Challenges', style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                      ),
                    ),

                    if (badges.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                          child: Text('Badges Earned', style: Theme.of(context).textTheme.titleLarge),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: badges.length,
                            itemBuilder: (context, i) {
                              final b = badges[i];
                              return Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [accent.withOpacity(0.2), accent.withOpacity(0.05)],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: accent.withOpacity(0.3)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(b['badge_icon'], style: const TextStyle(fontSize: 28)),
                                    const SizedBox(height: 4),
                                    Text(b['badge_name'],
                                        style: TextStyle(
                                          color: accent,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                        child: Text('Your Progress', style: Theme.of(context).textTheme.titleLarge),
                      ),
                    ),

                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final c = challenges[i];
                          final progress = c['progress'] as int;
                          final target = c['challenge']['target_count'] as int;
                          final completed = c['is_completed'] as bool;
                          final progressPct = target > 0 ? progress / target : 0.0;

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkRepCard : AppColors.light1989Card,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: completed
                                      ? accent.withOpacity(0.4)
                                      : (isDark ? AppColors.darkRepBorder : AppColors.light1989Border),
                                ),
                                boxShadow: completed && !isDark
                                    ? [BoxShadow(color: accent.withOpacity(0.1), blurRadius: 12)]
                                    : null,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(c['challenge']['badge_icon'],
                                              style: const TextStyle(fontSize: 24)),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(c['challenge']['title'],
                                                  style: Theme.of(context).textTheme.titleMedium),
                                              Text(c['challenge']['category'],
                                                  style: TextStyle(
                                                    color: accent,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.5,
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if (completed)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: accent.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text('Done ✓',
                                              style: TextStyle(
                                                color: accent,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                              )),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(c['challenge']['description'],
                                      style: Theme.of(context).textTheme.bodyMedium),
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                      value: progressPct.toDouble(),
                                      backgroundColor: isDark
                                          ? Colors.white.withOpacity(0.06)
                                          : Colors.black.withOpacity(0.06),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          completed ? accent : accent.withOpacity(0.6)),
                                      minHeight: 8,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('$progress / $target',
                                          style: Theme.of(context).textTheme.bodySmall),
                                      Text('${(progressPct * 100).toInt()}%',
                                          style: TextStyle(
                                            color: accent,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: challenges.length,
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
