import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clover/core/api/api_client.dart';
import 'package:clover/core/theme/app_theme.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});
  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  List trips = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    try {
      final res = await ApiClient.dio.get('/trips');
      setState(() { trips = res.data; loading = false; });
    } catch (e) {
      setState(() { loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Trips')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/trips/add').then((_) => _loadTrips()),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : trips.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('✈️', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: 16),
                      Text('No trips yet', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('Add your first trip!', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: trips.length,
                  itemBuilder: (context, index) {
                    final trip = trips[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Text('✈️', style: TextStyle(fontSize: 32)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(trip['destination'],
                                    style: Theme.of(context).textTheme.titleLarge),
                                Text('${trip['city']}, ${trip['country']}',
                                    style: Theme.of(context).textTheme.bodyMedium),
                                Text(trip['trip_type'],
                                    style: const TextStyle(color: AppColors.primary, fontSize: 12)),
                              ],
                            ),
                          ),
                          if (trip['rating'] != null)
                            Text('⭐ ${trip['rating']}',
                                style: const TextStyle(color: AppColors.warning)),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
