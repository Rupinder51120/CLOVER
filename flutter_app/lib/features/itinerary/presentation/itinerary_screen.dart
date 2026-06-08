import 'package:flutter/material.dart';
import 'package:clover/core/api/api_client.dart';
import 'package:clover/core/theme/app_theme.dart';

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});
  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  final _destination = TextEditingController();
  final _days = TextEditingController(text: '3');
  final _budget = TextEditingController();
  bool _loading = false;
  Map? _result;

  Future<void> _generate() async {
    setState(() { _loading = true; _result = null; });
    try {
      final res = await ApiClient.dio.post('/itinerary/generate', data: {
        'destination': _destination.text,
        'days': int.tryParse(_days.text) ?? 3,
        'budget': double.tryParse(_budget.text),
        'interests': ['adventure', 'photography'],
      });
      setState(() { _result = res.data; _loading = false; });
    } catch (e) {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Itinerary')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Generate Itinerary', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 8),
            Text('Powered by Qwen AI', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            TextField(controller: _destination, decoration: const InputDecoration(labelText: 'Destination')),
            const SizedBox(height: 16),
            TextField(controller: _days, decoration: const InputDecoration(labelText: 'Number of Days'),
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            TextField(controller: _budget, decoration: const InputDecoration(labelText: 'Budget (₹)'),
                keyboardType: TextInputType.number),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _generate,
                child: _loading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20, width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                          SizedBox(width: 12),
                          Text('Generating...'),
                        ],
                      )
                    : const Text('Generate with AI'),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 32),
              Text(_result!['content']['destination'] ?? '',
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 8),
              Text(_result!['content']['overview'] ?? '',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              ...(_result!['content']['day_plans'] as List? ?? []).map((day) =>
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Day ${day['day']}: ${day['theme']}',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      ...(day['activities'] as List? ?? []).map((a) =>
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('${a['time']} - ${a['activity']}',
                              style: Theme.of(context).textTheme.bodyMedium),
                        )
                      ),
                    ],
                  ),
                )
              ),
            ],
          ],
        ),
      ),
    );
  }
}
