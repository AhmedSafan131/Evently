import 'package:flutter/material.dart';
import '../create_event/create_event_screen.dart';
import 'home_tab.dart';
import 'package:evently/model/event.dart';

class GlobalFavoriteStore {
  static final List<Event> favorites = [];
}

class LoveTab extends StatefulWidget {
  const LoveTab({super.key});

  @override
  State<LoveTab> createState() => _LoveTabState();
}

class _LoveTabState extends State<LoveTab> {
  @override
  Widget build(BuildContext context) {
    final favorites = GlobalFavoriteStore.favorites;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Favorite Events',
            style: TextStyle(
                color: Color(0xFF5669FF),
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF5669FF)),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text('No favorite events',
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final event = favorites[index];
                return EventCard(
                  event: event,
                  isFavorite: true,
                  onFavoriteToggle: () {
                    setState(() {
                      GlobalFavoriteStore.favorites.remove(event);
                    });
                  },
                  onDelete: () {
                    setState(() {
                      GlobalFavoriteStore.favorites.remove(event);
                    });
                  },
                );
              },
            ),
    );
  }
}
