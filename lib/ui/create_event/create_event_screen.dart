import 'package:flutter/material.dart';
import 'package:evently/utils/app_color.dart';
import 'package:evently/utils/app_styles.dart';
import 'package:hive/hive.dart';
import 'package:evently/model/event.dart';
import 'package:evently/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final _formKey = GlobalKey<FormState>();
  bool _dateError = false;
  bool _timeError = false;
  bool _showTitleError = false;
  bool _showDescriptionError = false;

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

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String get eventImage => categories[selectedType]['image'] as String;

  String get formattedDate => selectedDate == null
      ? 'Choose Date'
      : '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}';
  String get formattedTime {
    if (selectedTime == null) return 'Choose Time';
    final hour = selectedTime!.hourOfPeriod.toString().padLeft(2, '0');
    final minute = selectedTime!.minute.toString().padLeft(2, '0');
    final period = selectedTime!.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute$period';
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateError = false;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _timeError = false;
      });
    }
  }

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
        title: Text('Create Event',
            style: isDark
                ? TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)
                : AppStyles.bold20Primary),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert,
                color: isDark
                    ? Theme.of(context).colorScheme.primary
                    : AppColors.primaryLight),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Theme.of(context).scaffoldBackgroundColor
                : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Form(
            key: _formKey,
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
                Text('Title',
                    style: isDark
                        ? TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)
                        : AppStyles.bold14Black),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  style: TextStyle(
                      color: isDark
                          ? Theme.of(context).colorScheme.primary
                          : AppColors.greyColor),
                  decoration: InputDecoration(
                    hintText: 'Event Title',
                    hintStyle: TextStyle(
                        color: isDark
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5)
                            : AppColors.greyColor),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    filled: true,
                    fillColor: isDark
                        ? Theme.of(context).cardColor
                        : AppColors.whiteColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: _titleController.text.trim().isEmpty &&
                                  _showTitleError
                              ? Colors.red
                              : (isDark
                                  ? Theme.of(context).dividerColor
                                  : AppColors.greyColor),
                          width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: _titleController.text.trim().isEmpty &&
                                  _showTitleError
                              ? Colors.red
                              : (isDark
                                  ? Theme.of(context).colorScheme.primary
                                  : AppColors.greyColor),
                          width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: _titleController.text.trim().isEmpty &&
                                  _showTitleError
                              ? Colors.red
                              : (isDark
                                  ? Theme.of(context).dividerColor
                                  : AppColors.greyColor),
                          width: 1.2),
                    ),
                    errorStyle: const TextStyle(
                        height: 0,
                        color: Colors.transparent), // Hide default error
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
                if (_showTitleError && _titleController.text.trim().isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: Text('Please enter event title',
                        style: TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 16),
                // Description
                Text('Description',
                    style: isDark
                        ? TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)
                        : AppStyles.bold14Black),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  style: TextStyle(
                      color: isDark
                          ? Theme.of(context).colorScheme.primary
                          : AppColors.greyColor),
                  decoration: InputDecoration(
                    hintText: 'Event Description',
                    hintStyle: TextStyle(
                        color: isDark
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5)
                            : AppColors.greyColor),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    filled: true,
                    fillColor: isDark
                        ? Theme.of(context).cardColor
                        : AppColors.whiteColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: _descriptionController.text.trim().isEmpty &&
                                  _showDescriptionError
                              ? Colors.red
                              : (isDark
                                  ? Theme.of(context).dividerColor
                                  : AppColors.greyColor),
                          width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: _descriptionController.text.trim().isEmpty &&
                                  _showDescriptionError
                              ? Colors.red
                              : (isDark
                                  ? Theme.of(context).colorScheme.primary
                                  : AppColors.greyColor),
                          width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: _descriptionController.text.trim().isEmpty &&
                                  _showDescriptionError
                              ? Colors.red
                              : (isDark
                                  ? Theme.of(context).dividerColor
                                  : AppColors.greyColor),
                          width: 1.2),
                    ),
                    errorStyle: const TextStyle(
                        height: 0,
                        color: Colors.transparent), // Hide default error
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
                if (_showDescriptionError &&
                    _descriptionController.text.trim().isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: Text('Please enter event description',
                        style: TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 16),
                // Date & Time
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _dateError
                            ? Colors.red
                            : (isDark
                                ? Theme.of(context).dividerColor
                                : AppColors.greyColor),
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Row(
                      children: [
                        Icon(Icons.event,
                            color: isDark
                                ? Theme.of(context).colorScheme.primary
                                : AppColors.primaryLight,
                            size: 20),
                        const SizedBox(width: 8),
                        Text('Event Date',
                            style: isDark
                                ? TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)
                                : AppStyles.bold14Black),
                        const Spacer(),
                        Text(formattedDate,
                            style: isDark
                                ? TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold)
                                : AppStyles.bold14Primary),
                      ],
                    ),
                  ),
                ),
                if (_dateError)
                  const Padding(
                    padding: EdgeInsets.only(left: 8, top: 4),
                    child: Text('Please choose event date',
                        style: TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickTime,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _timeError
                            ? Colors.red
                            : (isDark
                                ? Theme.of(context).dividerColor
                                : AppColors.greyColor),
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Row(
                      children: [
                        Icon(Icons.access_time,
                            color: isDark
                                ? Theme.of(context).colorScheme.primary
                                : AppColors.primaryLight,
                            size: 20),
                        const SizedBox(width: 8),
                        Text('Event Time',
                            style: isDark
                                ? TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)
                                : AppStyles.bold14Black),
                        const Spacer(),
                        Text(formattedTime,
                            style: isDark
                                ? TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold)
                                : AppStyles.bold14Primary),
                      ],
                    ),
                  ),
                ),
                if (_timeError)
                  const Padding(
                    padding: EdgeInsets.only(left: 8, top: 4),
                    child: Text('Please choose event time',
                        style: TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 16),
                // Location
                Text('Location',
                    style: isDark
                        ? TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)
                        : AppStyles.bold14Black),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Theme.of(context).cardColor
                        : AppColors.whiteColor,
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)
                                : AppStyles.bold14Black),
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
                      backgroundColor: isDark
                          ? Theme.of(context).colorScheme.primary
                          : AppColors.primaryLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final isValid =
                          _formKey.currentState?.validate() ?? false;
                      setState(() {
                        _showTitleError = _titleController.text.trim().isEmpty;
                        _showDescriptionError =
                            _descriptionController.text.trim().isEmpty;
                        _dateError = selectedDate == null;
                        _timeError = selectedTime == null;
                      });
                      if (!isValid ||
                          _showTitleError ||
                          _showDescriptionError ||
                          _dateError ||
                          _timeError) return;
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) return; // Optionally show an error
                      // Add event to Firestore
                      final event = Event(
                        image: eventImage,
                        title: _titleController.text.trim(),
                        description: _descriptionController.text.trim(),
                        eventName: categories[selectedType]['label'],
                        dateTime: selectedDate!,
                        time: formattedTime,
                        isFavorite: false,
                        userId: user.uid,
                      );
                      await FirebaseUtils.addEventToFireStore(event);
                      // Navigate to HomeScreen
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/home', (route) => false);
                    },
                    child: Text('Add Event',
                        style: isDark
                            ? TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)
                            : AppStyles.bold16White),
                  ),
                ),
              ],
            ),
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
