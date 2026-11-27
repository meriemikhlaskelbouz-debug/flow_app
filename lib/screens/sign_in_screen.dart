import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_ui/material_ui.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_widgets.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback onSwitchToSignUp;
  final VoidCallback onForgotPassword;

  const SignInScreen({
    super.key,
    required this.onSwitchToSignUp,
    required this.onForgotPassword,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Sign in failed.')),
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
                      const SizedBox(height: 20),

                      // ── Icon badge ──
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.settings,
                          color: AppColors.buttonText,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Title ──
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                                text: 'Welcome ',
                                style: AppTextStyles.heading),
                            TextSpan(
                                text: 'back',
                                style: AppTextStyles.headingItalic),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Sign in to continue your progress',
                        style: AppTextStyles.subtitle,
                      ),
                      const SizedBox(height: 32),

                      // ── Email ──
                      FlowTextField(
                        controller: _emailController,
                        hintText: 'student@example.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || !v.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // ── Password ──
                      FlowTextField(
                        controller: _passwordController,
                        hintText: '••••••••',
                        obscureText: _obscurePassword,
                        suffixIcon: GestureDetector(
                          onTap: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Text(
                              _obscurePassword ? 'show' : 'hide',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),

                      // ── Forgot password ──
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: widget.onForgotPassword,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Forgot password?',
                            style: AppTextStyles.linkText.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Sign in button ──
                      FlowPrimaryButton(
                        label: 'Sign in',
                        onPressed: _submit,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 24),

                      // ── Divider ──
                      const FlowDividerText(text: 'or continue with'),
                      const SizedBox(height: 18),

                      // ── Social buttons ──
                      Row(
                        children: [
                          FlowSocialButton(
                            label: 'Google',
                            icon: Icons.g_mobiledata,
                            onPressed: () {
                              // TODO: Google Sign-In
                            },
                          ),
                          const SizedBox(width: 14),
                          FlowSocialButton(
                            label: 'Apple',
                            icon: Icons.apple,
                            onPressed: () {
                              // TODO: Apple Sign-In
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // ── Bottom link ──
                      FlowBottomLink(
                        leadText: 'New to Flow?',
                        actionText: 'Create one',
                        onPressed: widget.onSwitchToSignUp,
                      ),
                      const SizedBox(height: 8),
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
