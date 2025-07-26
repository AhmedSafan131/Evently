import 'package:evently/l10n/app_localizations.dart';
import 'package:evently/utils/app_color.dart';
import 'package:evently/utils/app_styles.dart';
import 'package:evently/utils/locale_provider.dart';
import 'package:evently/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildHeader(user),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownSection(
                    title: AppLocalizations.of(context)?.language ?? 'Language',
                    value: currentLocale.languageCode == 'ar'
                        ? 'Arabic'
                        : 'English',
                    items: ['Arabic', 'English'],
                    onChanged: (newValue) {
                      if (newValue == 'Arabic') {
                        localeProvider.setLocale(const Locale('ar'));
                      } else {
                        localeProvider.setLocale(const Locale('en'));
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildDropdownSection(
                    title: AppLocalizations.of(context)?.theme ?? 'Theme',
                    value: themeProvider.themeMode == ThemeMode.dark
                        ? 'Dark'
                        : 'Light',
                    items: ['Light', 'Dark'],
                    onChanged: (newValue) {
                      final mode =
                          newValue == 'Dark' ? ThemeMode.dark : ThemeMode.light;
                      themeProvider.setThemeMode(mode);
                    },
                  ),
                  const Spacer(),
                  _buildLogoutButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(User? user) {
    final displayName = user?.displayName ?? 'Guest';
    final email = user?.email ?? 'No email';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: BoxDecoration(
        color: isDark
            ? Theme.of(context).colorScheme.primary
            : AppColors.primaryLight,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(60),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/as.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayName, style: AppStyles.bold20White),
              const SizedBox(height: 5),
              Text(
                email,
                style: AppStyles.bold14White.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSection({
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppStyles.bold16Black
                .copyWith(color: isDarkMode ? Colors.white : Colors.black)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.primaryDark : Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
                color:
                    isDarkMode ? AppColors.primaryLight : Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: isDarkMode ? AppColors.primaryDark : Colors.white,
              icon: Icon(Icons.keyboard_arrow_down,
                  color: isDarkMode ? Colors.white70 : AppColors.primaryLight),
              items: items.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item, style: AppStyles.bold14Primary),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: () async {
        // Sign out from Firebase and Google
        await FirebaseAuth.instance.signOut();
        try {
          await GoogleSignIn().signOut();
        } catch (_) {}
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.redColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.logout, color: Colors.white),
          const SizedBox(width: 10),
          Text(AppLocalizations.of(context)?.logout ?? 'Logout',
              style: AppStyles.bold16White),
        ],
      ),
    );
  }
}
