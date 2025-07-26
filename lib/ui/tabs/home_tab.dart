import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/theme_provider.dart';
import '../create_event/create_event_screen.dart';
import 'love_tab.dart';
import 'package:evently/utils/app_color.dart';
import '../event_details/event_details_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:evently/utils/app_styles.dart';
import 'package:evently/model/event.dart';
import 'package:evently/firebase_utils.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<bool>? _favorites;
  String selectedCategory = 'All';

  List<EventData> _getEvents(bool isDark) => [];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: user == null
          ? const Stream.empty()
          : FirebaseUtils.getEventsCollection()
              .where('userId', isEqualTo: user.uid)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: \\${snapshot.error}'));
        }
        final events =
            snapshot.data?.docs.map((doc) => doc.data()).toList() ?? [];
        final filteredEvents = selectedCategory == 'All'
            ? events
            : events.where((e) => (e.eventName) == selectedCategory).toList();
        final List<bool> favorites =
            _favorites ?? List.generate(events.length, (_) => false);
        return Column(
          children: [
            _HomeAppBar(
              categorySelector: _CategorySelector(
                onCategorySelected: (label) {
                  setState(() {
                    selectedCategory = label;
                  });
                },
                selectedLabel: selectedCategory,
              ),
            ),
            Expanded(
              child: filteredEvents.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.event_busy, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No events found',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      key: ValueKey(isDark),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      itemCount: filteredEvents.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EventDetailsScreen(event: event),
                              ),
                            );
                          },
                          child: EventCard(
                            event: event,
                            isFavorite: event.isFavorite,
                            onFavoriteToggle: () {
                              FirebaseUtils.updateEventFavoriteStatus(
                                  event.id, !event.isFavorite);
                            },
                            onDelete: () async {
                              await FirebaseUtils.deleteEventFromFireStore(
                                  event.id);
                              setState(() {});
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  void _toggleFavorite(int index, int eventCount) {
    setState(() {
      _favorites ??= List.generate(eventCount, (_) => false);
      _favorites![index] = !_favorites![index];
    });
  }
}

class _HomeAppBar extends StatelessWidget {
  final Widget categorySelector;
  const _HomeAppBar({Key? key, required this.categorySelector})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'Guest';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF5B7FFF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back ✨',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 4),
                    // Show the user's display name
                    Text(
                      displayName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      themeProvider.setThemeMode(
                        isDark ? ThemeMode.light : ThemeMode.dark,
                      );
                    },
                    child: Icon(
                      isDark ? Icons.nightlight_round : Icons.wb_sunny_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'EN',
                      style: TextStyle(
                        color: Color(0xFF5B7FFF),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          categorySelector,
          const SizedBox(height: 18),
          Row(
            children: const [
              Icon(Icons.location_on, color: Colors.white, size: 18),
              SizedBox(width: 4),
              Text(
                'Cairo , Egypt',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  final void Function(String label) onCategorySelected;
  final String selectedLabel;
  const _CategorySelector(
      {required this.onCategorySelected, required this.selectedLabel});

  @override
  Widget build(BuildContext context) {
    final categories = [
      _CategoryData('All', Icons.explore_outlined, true),
      _CategoryData('Sport', Icons.directions_bike, false),
      _CategoryData('Birthday', Icons.cake_outlined, false),
      _CategoryData('Eating', Icons.restaurant_menu, false),
      _CategoryData('Gaming', Icons.sports_esports, false),
      _CategoryData('Meeting', Icons.people_alt_outlined, false),
      _CategoryData('Work Shop', Icons.handyman, false),
      _CategoryData('Exhibition', Icons.museum, false),
      _CategoryData('Book Club', Icons.menu_book, false),
      // Add more categories as needed
    ];
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return ChoiceChip(
            label: Row(
              children: [
                Icon(cat.icon,
                    size: 20,
                    color: selectedLabel == cat.label
                        ? AppColors.primaryLight
                        : Colors.white),
                const SizedBox(width: 4),
                Text(
                  cat.label,
                  style: TextStyle(
                    color: selectedLabel == cat.label
                        ? AppColors.primaryLight
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            selected: selectedLabel == cat.label,
            selectedColor: Colors.white,
            backgroundColor: AppColors.primaryLight,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onSelected: (_) => onCategorySelected(cat.label),
          );
        },
      ),
    );
  }
}

class _CategoryData {
  final String label;
  final IconData icon;
  final bool selected;
  _CategoryData(this.label, this.icon, this.selected);
}

class _CategoryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  const _CategoryButton(
      {required this.label, required this.icon, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        border: Border.all(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 20, color: selected ? Color(0xFF5B7FFF) : Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: selected ? Color(0xFF5B7FFF) : Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onDelete;

  const EventCard({
    super.key,
    required this.event,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final day = event.dateTime.day.toString().padLeft(2, '0');
    final month = _monthName(event.dateTime.month);
    final title = event.title;
    final description = event.description;
    final image = event.image;
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF232323) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF5B7FFF) : const Color(0xFF5B7FFF),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (image != null)
            Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          Container(
            color: Colors.black.withOpacity(0.45),
          ),
          if (onDelete != null)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.delete, color: Colors.red, size: 22),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7ECFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            day,
                            style: const TextStyle(
                              color: Color(0xFF5B7FFF),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            month,
                            style: const TextStyle(
                              color: Color(0xFF5B7FFF),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Description and love icon in white container
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onFavoriteToggle,
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color:
                              isFavorite ? AppColors.primaryLight : Colors.grey,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper to get month name
String _monthName(int month) {
  const months = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  if (month < 1 || month > 12) return '';
  return months[month];
}
