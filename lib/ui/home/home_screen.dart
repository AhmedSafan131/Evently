import 'package:evently/l10n/app_localizations.dart';
import 'package:evently/ui/create_event/create_event_screen.dart';
import 'package:evently/ui/tabs/love_tab.dart';
import 'package:evently/ui/tabs/map_tab.dart';
import 'package:evently/ui/tabs/home_tab.dart';
import 'package:evently/ui/tabs/profile_tab.dart';
import 'package:evently/utils/app_color.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    MapTab(),
    LoveTab(),
    ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateEventScreen()),
          );
        },
        backgroundColor:
            isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
        shape: isDarkMode
            ? const CircleBorder(
                side: BorderSide(color: Colors.white, width: 1.5))
            : const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: AppColors.whiteColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: SizedBox(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildTabItem(
                  index: 0,
                  icon: Icons.home,
                  label: AppLocalizations.of(context)?.home ?? 'Home'),
              _buildTabItem(
                  index: 1,
                  icon: Icons.location_on_outlined,
                  label: AppLocalizations.of(context)?.map ?? 'Map'),
              const SizedBox(width: 40), // Space for FAB
              _buildTabItem(
                  index: 2,
                  icon: Icons.favorite_border,
                  label: AppLocalizations.of(context)?.love ?? 'Love'),
              _buildTabItem(
                  index: 3,
                  icon: Icons.person_outline,
                  label: AppLocalizations.of(context)?.profile ?? 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(
      {required int index, required IconData icon, required String label}) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.white70),
            Text(label,
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70)),
          ],
        ),
      ),
    );
  }
}
