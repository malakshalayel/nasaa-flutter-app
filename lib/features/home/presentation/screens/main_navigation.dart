import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/features/activities/presentation/cubit/activity_cubit.dart';
import 'package:nasaa/features/activities/presentation/screens/activities_screen.dart';
import 'package:nasaa/features/coaches/presentation/cubits/cubit_coach_list/coach_list_cubit.dart';
import 'package:nasaa/features/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:nasaa/features/favorites/presentation/screens/favorite_coaches_screen.dart';
import 'package:nasaa/features/home/presentation/screens/home_screen.dart';
import 'package:nasaa/features/profile/presentation/screens/settings_screen.dart';
import 'package:nasaa/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:nasaa/generated/l10n.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // List of screens
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const FavoriteCoachesScreen(),
      const ActivitiesScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: scheme.secondary,
        unselectedItemColor: scheme.onBackground,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: S.of(context).home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: S.of(context).favorite,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run_outlined),
            activeIcon: Icon(Icons.directions_run),
            label: S.of(context).activities,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: S.of(context).setting,
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;

      void _onTabTapped(int index) {
        setState(() {
          _currentIndex = index;
        });

        if (index == 1) {
          // Favorites tab
          context.read<FavoriteCubit>().loadFavorites();
        } else if (index == 3) {
          // Settings tab
          context.read<ProfileCubit>().loadUser();
        }
      }
    });

    if (index == 0) {
      context.read<CoachCubit>().getFeaturedCoaches();
      context.read<ActivityCubit>().getActivities();
    }
  }
}
