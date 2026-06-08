import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:clover/features/auth/presentation/login_screen.dart';
import 'package:clover/features/auth/presentation/register_screen.dart';
import 'package:clover/features/home/presentation/home_screen.dart';
import 'package:clover/features/trips/presentation/trips_screen.dart';
import 'package:clover/features/trips/presentation/add_trip_screen.dart';
import 'package:clover/features/clover_dna/presentation/dna_screen.dart';
import 'package:clover/features/recommendations/presentation/recommendations_screen.dart';
import 'package:clover/features/itinerary/presentation/itinerary_screen.dart';
import 'package:clover/features/wrapped/presentation/wrapped_screen.dart';
import 'package:clover/features/challenges/presentation/challenges_screen.dart';

final _storage = FlutterSecureStorage();

final appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) async {
    final token = await _storage.read(key: 'access_token');
    final isAuth = token != null;
    final isLoginPage = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';
    if (!isAuth && !isLoginPage) return '/login';
    if (isAuth && isLoginPage) return '/home';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/trips', builder: (_, __) => const TripsScreen()),
    GoRoute(path: '/trips/add', builder: (_, __) => const AddTripScreen()),
    GoRoute(path: '/dna', builder: (_, __) => const DnaScreen()),
    GoRoute(path: '/recommendations', builder: (_, __) => const RecommendationsScreen()),
    GoRoute(path: '/itinerary', builder: (_, __) => const ItineraryScreen()),
    GoRoute(path: '/wrapped', builder: (_, __) => const WrappedScreen()),
    GoRoute(path: '/challenges', builder: (_, __) => const ChallengesScreen()),
  ],
);
