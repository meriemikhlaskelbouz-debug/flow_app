import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_ui/material_ui.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  final VoidCallback onBackToLogin;

  const ResetPasswordScreen({super.key, required this.onBackToLogin});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.resetPassword(email: _emailController.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reset link sent! Check your email inbox.'),
        ),
      );
      // Navigate back to login after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) widget.onBackToLogin();
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Failed to send reset link.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // ── Back button ──
                      GestureDetector(
                        onTap: widget.onBackToLogin,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.inputBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.inputBorder,
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            color: AppColors.textSecondary,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Envelope icon ──
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.inputBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.inputBorder,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.mark_email_read_outlined,
                          color: AppColors.textSecondary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Title ──
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Reset your\n',
                              style: AppTextStyles.heading,
                            ),
                            TextSpan(
                              text: 'password',
                              style: AppTextStyles.headingItalic,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'No worries – enter your email and we\'ll\nsend a reset link.',
                        style: AppTextStyles.subtitle,
                      ),
                      const SizedBox(height: 32),

                      // ── Email ──
                      FlowTextField(
                        controller: _emailController,
                        hintText: 'Email address',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || !v.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // ── Send reset link button ──
                      FlowPrimaryButton(
                        label: 'Send reset link',
                        onPressed: _submit,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 28),

                      // ── Bottom link ──
                      FlowBottomLink(
                        leadText: 'Remembered it?',
                        actionText: 'Log in',
                        onPressed: widget.onBackToLogin,
                      ),
                    ],
                  ),
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
