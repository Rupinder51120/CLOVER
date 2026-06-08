import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clover/core/api/api_client.dart';
import 'package:clover/core/theme/app_theme.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});
  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _destination = TextEditingController();
  final _city = TextEditingController();
  final _country = TextEditingController();
  final _cost = TextEditingController();
  final _notes = TextEditingController();
  String _tripType = 'adventure';
  int _rating = 5;
  bool _loading = false;

  final _types = ['adventure', 'leisure', 'business', 'cultural', 'nature'];

  Future<void> _submit() async {
    setState(() { _loading = true; });
    try {
      await ApiClient.dio.post('/trips', data: {
        'destination': _destination.text,
        'city': _city.text,
        'country': _country.text,
        'start_date': '2024-12-01',
        'end_date': '2024-12-05',
        'total_cost': double.tryParse(_cost.text) ?? 0,
        'trip_type': _tripType,
        'notes': _notes.text,
        'rating': _rating,
        'tags': [_tripType],
        'attractions': [],
      });
      if (mounted) context.pop();
    } catch (e) {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Trip')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: _destination, decoration: const InputDecoration(labelText: 'Destination')),
            const SizedBox(height: 16),
            TextField(controller: _city, decoration: const InputDecoration(labelText: 'City')),
            const SizedBox(height: 16),
            TextField(controller: _country, decoration: const InputDecoration(labelText: 'Country')),
            const SizedBox(height: 16),
            TextField(controller: _cost, decoration: const InputDecoration(labelText: 'Total Cost (₹)'),
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            Text('Trip Type', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _types.map((type) => ChoiceChip(
                label: Text(type),
                selected: _tripType == type,
                onSelected: (_) => setState(() { _tripType = type; }),
                selectedColor: AppColors.primary,
              )).toList(),
            ),
            const SizedBox(height: 16),
            Text('Rating: $_rating ⭐', style: Theme.of(context).textTheme.bodyMedium),
            Slider(
              value: _rating.toDouble(),
              min: 1, max: 5, divisions: 4,
              onChanged: (v) => setState(() { _rating = v.toInt(); }),
            ),
            const SizedBox(height: 16),
            TextField(controller: _notes, decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Trip'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
