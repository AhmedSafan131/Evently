import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:evently/utils/theme_provider.dart';
import 'package:evently/utils/app_color.dart';
import 'package:evently/utils/locale_provider.dart';
import 'package:country_icons/country_icons.dart';

class SettingFirstScreen extends StatelessWidget {
  final VoidCallback onNext;
  const SettingFirstScreen({Key? key, required this.onNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.locale.languageCode == 'ar';
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Logo (replace with your logo asset if needed)

              const SizedBox(height: 24),
              // Illustration
              Expanded(
                flex: 7,
                child: Center(
                  child: Image.asset(
                    'assets/images/onboarding/onbording1.png',
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Personalize Your Experience',
                  style: const TextStyle(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Description
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose your preferred theme and language to get started with a comfortable, tailored experience that suits your style.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 24),
              // Language and Theme Switches
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Language',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: const Color(0xFF5669FF))),
                  Container(
                    height: 40,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border:
                          Border.all(color: const Color(0xFF5669FF), width: 3),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              localeProvider.setLocale(const Locale('en')),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: !isArabic
                                    ? const Color(0xFF5669FF)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              backgroundImage: const AssetImage(
                                'icons/flags/png/us.png',
                                package: 'country_icons',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () =>
                              localeProvider.setLocale(const Locale('ar')),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isArabic
                                    ? const Color(0xFF5669FF)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              backgroundImage: const AssetImage(
                                'icons/flags/png/eg.png',
                                package: 'country_icons',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Theme',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: const Color(0xFF5669FF))),
                  Container(
                    height: 40,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border:
                          Border.all(color: const Color(0xFF5669FF), width: 3),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              themeProvider.setThemeMode(ThemeMode.light),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: !isDark
                                    ? const Color(0xFF5669FF)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.wb_sunny_outlined,
                                color: !isDark
                                    ? const Color(0xFF5669FF)
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () =>
                              themeProvider.setThemeMode(ThemeMode.dark),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF5669FF)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.nightlight_round,
                                color: isDark
                                    ? const Color(0xFF5669FF)
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5669FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Let's Start",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
