import 'package:material_ui/material_ui.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_widgets.dart';

/// Data model for each feature slide
class _FeatureSlide {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String titleAccent;
  final String description;

  const _FeatureSlide({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.titleAccent,
    required this.description,
  });
}

class FeatureWalkthroughScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const FeatureWalkthroughScreen({super.key, required this.onFinish});

  @override
  State<FeatureWalkthroughScreen> createState() =>
      _FeatureWalkthroughScreenState();
}

class _FeatureWalkthroughScreenState extends State<FeatureWalkthroughScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_FeatureSlide> _slides = [
    _FeatureSlide(
      icon: Icons.checklist_rounded,
      iconBg: Color(0xFF5B7A5E),
      title: 'Organize your',
      titleAccent: 'tasks',
      description:
          'Create, manage, and track your daily tasks.\nStay on top of deadlines and never miss a beat.',
    ),
    _FeatureSlide(
      icon: Icons.groups_rounded,
      iconBg: Color(0xFF7A925B),
      title: 'Study with your',
      titleAccent: 'group',
      description:
          'Join live group study sessions with friends.\nStay motivated and hold each other accountable.',
    ),
    _FeatureSlide(
      icon: Icons.timer_rounded,
      iconBg: Color(0xFF5B6E7A),
      title: 'Focus with',
      titleAccent: 'pomodoro',
      description:
          'Use timed focus sessions with built-in breaks.\nBoost your productivity the proven way.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onFinish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Skip button ──
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: widget.onFinish,
                  child: Text(
                    'Skip',
                    style: AppTextStyles.linkText.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // ── Page content ──
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return _buildSlide(slide);
                },
              ),
            ),

            // ── Page indicators ──
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isActive ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isActive
                          ? AppColors.primaryDark
                          : AppColors.inputBorder,
                    ),
                  );
                }),
              ),
            ),

            // ── Action buttons ──
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 8),
              child: FlowPrimaryButton(
                label:
                    _currentPage == _slides.length - 1 ? 'Let\'s go!' : 'Next',
                onPressed: _nextPage,
              ),
            ),
            const SizedBox(height: 4),
            const ScallopedBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(_FeatureSlide slide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Large icon in a rounded container ──
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: slide.iconBg.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: slide.iconBg.withValues(alpha: 0.25),
                width: 2,
              ),
            ),
            child: Icon(
              slide.icon,
              size: 72,
              color: slide.iconBg,
            ),
          ),
          const SizedBox(height: 40),

          // ── Title ──
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${slide.title}\n',
                  style: AppTextStyles.heading.copyWith(fontSize: 30),
                ),
                TextSpan(
                  text: slide.titleAccent,
                  style: AppTextStyles.headingItalic.copyWith(fontSize: 30),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Description ──
          Text(
            slide.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.subtitle.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}
