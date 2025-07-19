import 'package:flutter/material.dart';
import 'package:evently/utils/app_color.dart';
import 'package:evently/utils/app_styles.dart';
import 'package:hive/hive.dart';
import 'package:evently/model/event.dart';
import 'package:evently/firebase_utils.dart';
part 'create_event_screen.g.dart';

// Copied from home_tab.dart for global event sharing
@HiveType(typeId: 0)
class EventData {
  @HiveField(0)
  final String day;
  @HiveField(1)
  final String month;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final String? image;
  @HiveField(5)
  final bool isFavorite;
  @HiveField(6)
  final String time; // New field for time (e.g., '12:22PM')
  @HiveField(7)
  final DateTime? date; // Optional: store the full date
  @HiveField(8)
  final String? category;
  EventData({
    required this.day,
    required this.month,
    required this.title,
    required this.description,
    required this.image,
    required this.isFavorite,
    required this.time,
    this.date,
    this.category,
  });
  EventData copyWith({
    String? day,
    String? month,
    String? title,
    String? description,
    String? image,
    bool? isFavorite,
    String? time,
    DateTime? date,
    String? category,
  }) {
    return EventData(
      day: day ?? this.day,
      month: month ?? this.month,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
      time: time ?? this.time,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }
}

// Simple global event list for demonstration
class GlobalEventStore {
  static Box<EventData> get _box => Hive.box<EventData>('events');

  static List<EventData> get events => _box.values.toList();

  static void add(EventData event) => _box.add(event);

  static void update(int index, EventData event) => _box.putAt(index, event);

  static void delete(int index) => _box.deleteAt(index);
}

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  int selectedType = 1; // 0: Book Club, 1: Sport, 2: Birthday, ...
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Category data
  static const List<Map<String, dynamic>> categories = [
    {
      'label': 'Book Club',
      'icon': Icons.menu_book,
      'image': 'assets/images/bookclub.png'
    },
    {
      'label': 'Sport',
      'icon': Icons.directions_bike,
      'image': 'assets/images/sport card.png'
    },
    {
      'label': 'Birthday',
      'icon': Icons.cake,
      'image': 'assets/images/birthday card.png'
    },
    {
      'label': 'Gaming',
      'icon': Icons.sports_esports,
      'image': 'assets/images/gaming.png'
    },
    {
      'label': 'Workshop',
      'icon': Icons.handyman,
      'image': 'assets/images/workshop.png'
    },
    {
      'label': 'Eating',
      'icon': Icons.restaurant_menu,
      'image': 'assets/images/eating.png'
    },
    {
      'label': 'Exhibition',
      'icon': Icons.museum,
      'image': 'assets/images/Exhibition.png'
    },
    {
      'label': 'Meeting',
      'icon': Icons.people_alt,
      'image': 'assets/images/metting card.png'
    },
  ];

  DateTime selectedDate = DateTime(2024, 11, 22);
  TimeOfDay selectedTime = const TimeOfDay(hour: 12, minute: 22);

  String get eventImage => categories[selectedType]['image'] as String;

  String get formattedDate =>
      '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';
  String get formattedTime {
    final hour = selectedTime.hourOfPeriod.toString().padLeft(2, '0');
    final minute = selectedTime.minute.toString().padLeft(2, '0');
    final period = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute$period';
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryLight),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Create Event', style: AppStyles.bold20Primary),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.primaryLight),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  eventImage,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              // Event Type Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                      categories.length,
                      (i) => Row(
                            children: [
                              _EventTypeChip(
                                icon: categories[i]['icon'],
                                label: categories[i]['label'],
                                selected: selectedType == i,
                                onTap: () => setState(() => selectedType = i),
                              ),
                              if (i != categories.length - 1)
                                const SizedBox(width: 8),
                            ],
                          )),
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Text('Title', style: AppStyles.bold14Black),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                style: TextStyle(color: AppColors.greyColor),
                decoration: InputDecoration(
                  hintText: 'Event Title',
                  hintStyle: TextStyle(color: AppColors.greyColor),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: AppColors.whiteColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.greyColor, width: 1.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.greyColor, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.greyColor, width: 1.2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Description
              Text('Description', style: AppStyles.bold14Black),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                style: TextStyle(color: AppColors.greyColor),
                decoration: InputDecoration(
                  hintText: 'Event Description',
                  hintStyle: TextStyle(color: AppColors.greyColor),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: AppColors.whiteColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.greyColor, width: 1.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.greyColor, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.greyColor, width: 1.2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Date & Time
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    const Icon(Icons.event,
                        color: AppColors.primaryLight, size: 20),
                    const SizedBox(width: 8),
                    Text('Event Date', style: AppStyles.bold14Black),
                    const Spacer(),
                    Text(formattedDate, style: AppStyles.bold14Primary),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickTime,
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    const Icon(Icons.access_time,
                        color: AppColors.primaryLight, size: 20),
                    const SizedBox(width: 8),
                    Text('Event Time', style: AppStyles.bold14Black),
                    const Spacer(),
                    Text(formattedTime, style: AppStyles.bold14Primary),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Location
              Text('Location', style: AppStyles.bold14Black),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryLight, width: 1.2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: AppColors.primaryLight),
                    const SizedBox(width: 8),
                    Expanded(
                      child:
                          Text('Cairo , Egypt', style: AppStyles.bold14Black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Add Event Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    // Add event to Firestore
                    final event = Event(
                      image: eventImage,
                      title: _titleController.text.trim().isEmpty
                          ? categories[selectedType]['label']
                          : _titleController.text.trim(),
                      description: _descriptionController.text.trim().isEmpty
                          ? 'Event Description'
                          : _descriptionController.text.trim(),
                      eventName: categories[selectedType]['label'],
                      dateTime: selectedDate,
                      time: formattedTime,
                      isFavorite: false,
                    );
                    await FirebaseUtils.addEventToFireStore(event);
                    // Navigate to HomeScreen
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/home', (route) => false);
                  },
                  child: Text('Add Event', style: AppStyles.bold16White),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventTypeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  const _EventTypeChip({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.whiteBgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primaryLight : AppColors.whiteBgColor,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 18,
                color: selected ? Colors.white : AppColors.primaryLight),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.primaryLight,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
    'Dec'
  ];
  return months[month];
}
