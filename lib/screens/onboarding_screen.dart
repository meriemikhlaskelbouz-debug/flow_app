import 'package:material_ui/material_ui.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_widgets.dart';

class OnboardingScreen extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onLogIn;

  const OnboardingScreen({
    super.key,
    required this.onGetStarted,
    required this.onLogIn,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // ── Hero illustration ──
                    Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xFFD5E0CC),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          'assets/images/onboarding_hero.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),

                    // ── Dot indicators ──
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == 0
                                ? AppColors.primary
                                : AppColors.inputBorder,
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 28),

                    // ── Title ──
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Master your\n',
                              style: AppTextStyles.heading,
                            ),
                            TextSpan(
                              text: 'focus',
                              style: AppTextStyles.headingItalic,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Reach your goals with gentle, guided\nstudy sessions.',
                        style: AppTextStyles.subtitle,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Page indicator dots (small) ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.inputBorder,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // ── Get started button ──
                    FlowPrimaryButton(
                      label: 'Get started',
                      onPressed: onGetStarted,
                    ),
                    const SizedBox(height: 14),

                    // ── Log in button ──
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onLogIn,
                        child: const Text(
                          'Log in',
                          style: AppTextStyles.socialButtonLabel,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            const ScallopedBottomBar(),
          ],
        ),
      ),
    );
  }
}
