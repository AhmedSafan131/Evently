import 'package:flutter/material.dart';
import '../create_event/create_event_screen.dart';
import 'package:evently/utils/app_color.dart';
import 'package:evently/utils/app_styles.dart';
import 'edit_event_screen.dart';
import 'package:evently/model/event.dart';
import 'package:evently/firebase_utils.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;
  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: isDark
            ? Theme.of(context).scaffoldBackgroundColor
            : AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: isDark
                  ? Theme.of(context).colorScheme.primary
                  : AppColors.primaryLight),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Event Details',
            style: isDark
                ? TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)
                : AppStyles.bold20Primary),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit,
                color: isDark
                    ? Theme.of(context).colorScheme.primary
                    : AppColors.primaryLight),
            onPressed: () async {
              final updated = await Navigator.push<Event>(
                context,
                MaterialPageRoute(
                  builder: (_) => EditEventScreen(event: event),
                ),
              );
              if (updated != null) {
                // Refresh details with updated event
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EventDetailsScreen(event: updated),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete,
                color: isDark
                    ? Theme.of(context).colorScheme.error
                    : AppColors.redColor),
            onPressed: () async {
              await FirebaseUtils.deleteEventFromFireStore(event.id);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                event.image ?? '',
                fit: BoxFit.contain,
                height: 120,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Text(event.title,
                style: isDark
                    ? TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)
                    : AppStyles.bold16Primary),
            const SizedBox(height: 12),
            // Date & Time
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color:
                    isDark ? Theme.of(context).cardColor : AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDark
                        ? Theme.of(context).colorScheme.primary
                        : AppColors.primaryLight,
                    width: 1.2),
              ),
              child: Row(
                children: [
                  Icon(Icons.event,
                      color: isDark
                          ? Theme.of(context).colorScheme.primary
                          : AppColors.primaryLight),
                  const SizedBox(width: 8),
                  Text(
                      '${event.dateTime.day.toString().padLeft(2, '0')} ${_monthName(event.dateTime.month)} ${event.dateTime.year}',
                      style: isDark
                          ? TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)
                          : AppStyles.bold14Primary),
                  const Spacer(),
                  Icon(Icons.access_time,
                      color: isDark
                          ? Theme.of(context).colorScheme.primary
                          : AppColors.primaryLight),
                  const SizedBox(width: 4),
                  Text(event.time,
                      style: isDark
                          ? TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)
                          : AppStyles.bold14Primary),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Location
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color:
                    isDark ? Theme.of(context).cardColor : AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDark
                        ? Theme.of(context).colorScheme.primary
                        : AppColors.primaryLight,
                    width: 1.2),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on,
                      color: isDark
                          ? Theme.of(context).colorScheme.primary
                          : AppColors.primaryLight),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text('Cairo , Egypt',
                          style: isDark
                              ? TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)
                              : AppStyles.bold14Primary)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Map Placeholder
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark
                    ? Theme.of(context).cardColor
                    : AppColors.whiteBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: (isDark
                            ? Theme.of(context).colorScheme.primary
                            : AppColors.primaryLight)
                        .withOpacity(0.2)),
              ),
              child: Center(
                  child: Icon(Icons.map,
                      size: 60,
                      color: isDark
                          ? Theme.of(context).colorScheme.primary
                          : AppColors.primaryLight)),
            ),
            const SizedBox(height: 12),
            // Description
            Text('Description',
                style: isDark
                    ? TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)
                    : AppStyles.bold14Black),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isDark ? Theme.of(context).cardColor : AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: (isDark
                            ? Theme.of(context).colorScheme.primary
                            : AppColors.primaryLight)
                        .withOpacity(0.2)),
              ),
              child: Text(
                event.description,
                style: isDark
                    ? TextStyle(
                        fontSize: 14,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.7))
                    : TextStyle(fontSize: 14, color: AppColors.greyColor),
              ),
            ),
          ],
        ),
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
