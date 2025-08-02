import 'package:dhaka_bus/core/utility/extensions.dart';
import 'package:dhaka_bus/features/main/presentation/ui/main_page.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Onboarding')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Onboarding'),
            ElevatedButton(
              onPressed: () {
                // Navigate to the main page
                context.navigatorPushReplacement(MainPage());
              },
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
