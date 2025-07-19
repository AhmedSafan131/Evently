import 'package:flutter/material.dart';
import '../create_event/create_event_screen.dart';
import 'package:evently/utils/app_color.dart';
import 'package:evently/utils/app_styles.dart';
import 'package:evently/model/event.dart';
import 'package:evently/firebase_utils.dart';

class EditEventScreen extends StatefulWidget {
  final Event event;
  const EditEventScreen({Key? key, required this.event}) : super(key: key);

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late int selectedType;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  // Category data (copied from CreateEventScreen)
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

  @override
  void initState() {
    super.initState();
    selectedType = _findCategoryIndex(widget.event.eventName);
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    selectedDate = widget.event.dateTime;
    // Parse time string to TimeOfDay if needed
    selectedTime = TimeOfDay(
      hour: int.tryParse(widget.event.time.split(':')[0]) ?? 12,
      minute:
          int.tryParse(widget.event.time.split(':')[1].substring(0, 2)) ?? 0,
    );
  }

  int _findCategoryIndex(String title) {
    for (int i = 0; i < categories.length; i++) {
      if (categories[i]['label'] == title) {
        return i;
      }
    }
    return 0;
  }

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
        title: Text('Edit Event', style: AppStyles.bold20Primary),
        centerTitle: true,
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
              // Update Event Button
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
                    final updatedEvent = Event(
                      id: widget.event.id,
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
                      isFavorite: widget.event.isFavorite,
                    );
                    await FirebaseUtils.updateEventInFireStore(updatedEvent);
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/home', (route) => false);
                  },
                  child: Text('Update Event', style: AppStyles.bold16White),
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
    'Dec'
  ];
  return months[month];
}
