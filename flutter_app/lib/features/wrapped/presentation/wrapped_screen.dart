import 'package:flutter/material.dart';
import 'package:clover/core/api/api_client.dart';
import 'package:clover/core/theme/app_theme.dart';

class WrappedScreen extends StatefulWidget {
  const WrappedScreen({super.key});
  @override
  State<WrappedScreen> createState() => _WrappedScreenState();
}

class _WrappedScreenState extends State<WrappedScreen> {
  Map? wrapped;
  bool loading = false;
  int _currentCard = 0;
  final PageController _pageController = PageController();

  Future<void> _generate() async {
    setState(() { loading = true; });
    try {
      final res = await ApiClient.dio.post('/clover-wrapped/yearly/2024');
      setState(() { wrapped = res.data; loading = false; });
    } catch (e) {
      setState(() { loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (wrapped != null) {
      return _buildWrappedCards(context, isDark);
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [Color(0xFF0A0A0A), Color(0xFF1A1A1A)],
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
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const Spacer(),
                Text(
                  isDark ? '✦' : '🎁',
                  style: const TextStyle(fontSize: 64),
                ),
                const SizedBox(height: 24),
                Text(
                  'Your 2024\nTravel Era',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(height: 1.1),
                ),
                const SizedBox(height: 12),
                Text(
                  isDark
                      ? 'Every trip. Every memory.\nIntelligently wrapped.'
                      : 'Every adventure. Every story.\nBeautifully told.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: loading ? null : _generate,
                    child: loading
                        ? SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: isDark ? Colors.black : Colors.white,
                            ),
                          )
                        : Text(isDark ? 'Reveal My Era ✦' : 'Generate Wrapped ✨'),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWrappedCards(BuildContext context, bool isDark) {
    final stats = wrapped!['stats'];
    final cards = [
      _WrappedCardData(
        emoji: '✨',
        title: 'This was your\nTravel Era.',
        subtitle: '2024 in Review',
        gradient: isDark
            ? [const Color(0xFF1A1A0A), const Color(0xFF2A2A10)]
            : [const Color(0xFF7DA9D8), const Color(0xFF5B8BCB)],
        isDark: isDark,
      ),
      _WrappedCardData(
        emoji: '✈️',
        title: '${stats['total_trips']}',
        subtitle: 'Trips Completed',
        gradient: isDark
            ? [const Color(0xFF0A1A0A), const Color(0xFF102A10)]
            : [const Color(0xFF5B8BCB), const Color(0xFF4A7ABA)],
        isDark: isDark,
      ),
      _WrappedCardData(
        emoji: '🌍',
        title: '${stats['total_countries']}',
        subtitle: 'Countries Explored',
        gradient: isDark
            ? [const Color(0xFF1A0A0A), const Color(0xFF2A1010)]
            : [const Color(0xFF7DA9D8), const Color(0xFF6B98C7)],
        isDark: isDark,
      ),
      _WrappedCardData(
        emoji: '🏙️',
        title: '${stats['total_cities']}',
        subtitle: 'Cities Visited',
        gradient: isDark
            ? [const Color(0xFF0A0A1A), const Color(0xFF10102A)]
            : [const Color(0xFF5B8BCB), const Color(0xFF7DA9D8)],
        isDark: isDark,
      ),
      _WrappedCardData(
        emoji: '🧬',
        title: stats['personality_type'] ?? 'Explorer',
        subtitle: 'Your Travel Personality',
        gradient: isDark
            ? [const Color(0xFF1A1500), const Color(0xFF2A2200)]
            : [const Color(0xFF4A7ABA), const Color(0xFF7DA9D8)],
        isDark: isDark,
      ),
      _WrappedCardData(
        emoji: '💰',
        title: '₹${stats['total_spend']?.toInt()}',
        subtitle: 'Total Spent on Adventures',
        gradient: isDark
            ? [const Color(0xFF0A1510), const Color(0xFF10251A)]
            : [const Color(0xFF7DA9D8), const Color(0xFF5B8BCB)],
        isDark: isDark,
      ),
      _WrappedCardData(
        emoji: '⭐',
        title: '${stats['avg_rating']}',
        subtitle: 'Average Trip Rating',
        gradient: isDark
            ? [const Color(0xFF1A0A15), const Color(0xFF2A1025)]
            : [const Color(0xFF5B8BCB), const Color(0xFF4A7ABA)],
        isDark: isDark,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentCard = i),
            itemCount: cards.length,
            itemBuilder: (context, i) {
              final card = cards[i];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: card.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('🍀', style: TextStyle(fontSize: 24)),
                            GestureDetector(
                              onTap: () => setState(() => wrapped = null),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text('Close',
                                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(card.emoji, style: const TextStyle(fontSize: 72)),
                        const SizedBox(height: 24),
                        Text(
                          card.title,
                          style: TextStyle(
                            color: isDark ? AppColors.darkRepGold : Colors.white,
                            fontSize: card.title.length > 10 ? 36 : 64,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          card.subtitle,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            cards.length,
                            (dot) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: dot == _currentCard ? 20 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: dot == _currentCard
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            i < cards.length - 1 ? 'Swipe for next →' : 'Swipe to restart',
                            style: const TextStyle(color: Colors.white38, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WrappedCardData {
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final bool isDark;

  _WrappedCardData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.isDark,
  });
}
