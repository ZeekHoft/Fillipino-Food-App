import 'package:flilipino_food_app/common_widgets/link_text_button.dart';
import 'package:flilipino_food_app/pages/authentication_page/authentication_widgets/profile_setup_pages.dart';
import 'package:flutter/material.dart';

const setupPages = <Widget>[
  UserDetails(),
  Center(child: Text("This is page 2")),
  Center(child: Text("This is page 3")),
];

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 32,
              ),
              child: PageIndicator(
                  totalPages: setupPages.length,
                  currentPageIndex: _currentPageIndex,
                  onUpdateCurrentPage: (index) {}),
            ),
            Expanded(
              child: PageView(
                  controller: _pageViewController,
                  onPageChanged: _handlePageChanged,
                  // physics: NeverScrollableScrollPhysics(),
                  children: setupPages),
            ),
            ElevatedButton(onPressed: _goNextPage, child: const Text("Next")),
            const SizedBox(height: 16),
            Center(child: LinkTextButton(text: "Skip")),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _handlePageChanged(int currentPageIndex) {
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _goNextPage() {
    _currentPageIndex += 1;
    _pageViewController.animateToPage(_currentPageIndex,
        duration: Durations.medium3, curve: Easing.standard);
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.totalPages,
    required this.currentPageIndex,
    required this.onUpdateCurrentPage,
  });

  final int totalPages;
  final int currentPageIndex;
  final void Function(int) onUpdateCurrentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: List.generate(
      totalPages,
      (index) {
        return IndicatorSegment(
          isCurrentIndex: index == currentPageIndex,
        );
      },
    ));
  }
}

class IndicatorSegment extends StatelessWidget {
  const IndicatorSegment({super.key, required this.isCurrentIndex});

  final bool isCurrentIndex;

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).colorScheme.primary;
    final unactiveColor = Theme.of(context).colorScheme.surface;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Container(
          height: 6,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isCurrentIndex ? activeColor : unactiveColor),
        ),
      ),
    );
  }
}
