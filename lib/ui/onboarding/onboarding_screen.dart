import 'package:evently/models/onboarding_model.dart';
import 'package:evently/ui/home/home_screen.dart';
import 'package:evently/ui/onboarding/setting_first_screeen.dart';
import 'package:evently/utils/app_color.dart';
import 'package:evently/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:evently/ui/login.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routName = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showOnboardingPages = false;

  final List<OnboardingModel> _onboardingData = [
    OnboardingModel(
      image: 'assets/images/onboarding/onbording2.png',
      title: 'Find Events That Inspire You',
      description:
          'Dive into a world of events crafted to fit your unique interests. Whether you\'re into live music, art workshops, professional networking, or simply discovering new experiences, we have something for everyone. Our curated recommendations will help you explore, connect, and make the most of every opportunity around you.',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding/onbording3.png',
      title: 'Effortless Event Planning',
      description:
          'Take the hassle out of organizing events with our all-in-one planning tools. From setting up invites and managing RSVPs to scheduling reminders and coordinating details, we\'ve got you covered. Plan with ease and focus on what matters - creating an unforgettable experience for you and your guests.',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding/onbording4.png',
      title: 'Connect with Friends & Share Moments',
      description:
          'Make every event memorable by sharing the experience with others. Our platform lets you invite friends, keep everyone in the loop, and celebrate moments together. Capture and share the excitement with your network so you can relive the highlights and cherish the memories.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (!_showOnboardingPages) {
      return SettingFirstScreen(
        onNext: () {
          setState(() {
            _showOnboardingPages = true;
          });
        },
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(model: _onboardingData[index]);
                },
              ),
            ),
            _buildControls(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage != 0)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryLight, width: 0.8),
              ),
              child: IconButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.primaryLight,
                ),
                iconSize: 20.0,
              ),
            )
          else
            const SizedBox(width: 44), // Placeholder for alignment

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingData.length,
              (index) => buildDot(index, context),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryLight, width: 0.8),
            ),
            child: IconButton(
              onPressed: () {
                if (_currentPage == _onboardingData.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
              icon: const Icon(
                Icons.arrow_forward,
                color: AppColors.primaryLight,
              ),
              iconSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: _currentPage == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _currentPage == index
            ? AppColors.primaryLight
            : AppColors.primaryLight,
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingModel model;
  const OnboardingPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // You need to add your images to assets/images/onboarding/
          Image.asset(
            model.image,
            height: 320,
            errorBuilder: (context, error, stackTrace) =>
                const Placeholder(fallbackHeight: 350),
          ),
          const SizedBox(height: 40),
          Text(
            model.title,
            style: AppStyles.bold20Primary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            model.description,
            style: AppStyles.bold14Black.copyWith(color: AppColors.greyColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
