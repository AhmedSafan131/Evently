import 'package:evently/firebase_utils.dart';
import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'package:evently/model/event.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoveTab extends StatefulWidget {
  const LoveTab({super.key});

  @override
  State<LoveTab> createState() => _LoveTabState();
}

class _LoveTabState extends State<LoveTab> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor:
          isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      appBar: AppBar(
        backgroundColor:
            isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
        elevation: 0,
        title: Text('Favorite Events',
            style: TextStyle(
                color: isDark
                    ? Theme.of(context).colorScheme.primary
                    : const Color(0xFF5669FF),
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        centerTitle: true,
        iconTheme: IconThemeData(
            color: isDark
                ? Theme.of(context).colorScheme.primary
                : const Color(0xFF5669FF)),
      ),
      body: StreamBuilder<List<Event>>(
        stream: user == null
            ? const Stream.empty()
            : FirebaseUtils.getEventsCollection()
                .where('userId', isEqualTo: user.uid)
                .where('isFavorite', isEqualTo: true)
                .snapshots()
                .map((snapshot) =>
                    snapshot.docs.map((doc) => doc.data()).toList()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return Center(
              child: Text('No favorite events',
                  style: TextStyle(
                      fontSize: 18,
                      color: isDark
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.7)
                          : Colors.grey)),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final event = favorites[index];
              return EventCard(
                event: event,
                isFavorite: true,
                onFavoriteToggle: () {
                  FirebaseUtils.updateEventFavoriteStatus(
                      event.id, !event.isFavorite);
                },
                onDelete: () {
                  FirebaseUtils.deleteEventFromFireStore(event.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
