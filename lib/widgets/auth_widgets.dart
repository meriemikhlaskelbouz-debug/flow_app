import 'package:material_ui/material_ui.dart';
import '../theme/app_theme.dart';

/// Scalloped bottom decoration that matches the design's wavy green footer
class ScallopedBottomBar extends StatelessWidget {
  const ScallopedBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width, 48),
        painter: _ScallopPainter(),
      ),
    );
  }
}

class _ScallopPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.navBarGreen;
    final path = Path();

    const scallopCount = 5;
    final scallopWidth = size.width / scallopCount;
    const scallopHeight = 18.0;

    path.moveTo(0, scallopHeight);
    for (int i = 0; i < scallopCount; i++) {
      final startX = i * scallopWidth;
      final midX = startX + scallopWidth / 2;
      final endX = startX + scallopWidth;
      path.quadraticBezierTo(midX, 0, endX, scallopHeight);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Styled text input matching the design
class FlowTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const FlowTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontSize: 15,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

/// Primary action button (Create account, Sign in, Send reset link)
class FlowPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const FlowPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.buttonText,
                ),
              )
            : Text(label),
      ),
    );
  }
}

/// Social sign-in button (Google / Apple)
class FlowSocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const FlowSocialButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: AppColors.textPrimary),
        label: Text(label, style: AppTextStyles.socialButtonLabel),
      ),
    );
  }
}

/// Divider with text in the middle ("or sign up with", "or continue with")
class FlowDividerText extends StatelessWidget {
  final String text;

  const FlowDividerText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.inputBorder, thickness: 0.8),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(text, style: AppTextStyles.dividerText),
        ),
        const Expanded(
          child: Divider(color: AppColors.inputBorder, thickness: 0.8),
        ),
      ],
    );
  }
}

/// Bottom link row ("Already have an account? Log in")
class FlowBottomLink extends StatelessWidget {
  final String leadText;
  final String actionText;
  final VoidCallback onPressed;

  const FlowBottomLink({
    super.key,
    required this.leadText,
    required this.actionText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(leadText, style: AppTextStyles.linkText),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(actionText, style: AppTextStyles.linkBold),
        ),
      ],
    );
  }
}
