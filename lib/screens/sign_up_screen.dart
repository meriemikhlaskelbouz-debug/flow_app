import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_ui/material_ui.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_widgets.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onSwitchToLogin;

  const SignUpScreen({super.key, required this.onSwitchToLogin});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms & Privacy to continue.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.registerAccount(
        username: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration failed.')),
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
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // ── Title ──
                      const Text('Create account', style: AppTextStyles.heading),
                      const SizedBox(height: 6),
                      const Text(
                        'Start your learning journey today',
                        style: AppTextStyles.subtitle,
                      ),
                      const SizedBox(height: 32),

                      // ── Full name ──
                      FlowTextField(
                        controller: _nameController,
                        hintText: 'Full name',
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          if (v.trim().length > 50) {
                            return 'Name must be 50 characters or less';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

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
                      const SizedBox(height: 14),

                      // ── Password ──
                      FlowTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: _obscurePassword,
                        suffixIcon: GestureDetector(
                          onTap: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
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
                      const SizedBox(height: 18),

                      // ── Terms checkbox ──
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _agreedToTerms,
                              onChanged: (v) =>
                                  setState(() => _agreedToTerms = v ?? false),
                              activeColor: AppColors.primary,
                              shape: const CircleBorder(),
                              side: const BorderSide(
                                color: AppColors.inputBorder,
                                width: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          RichText(
                            text: const TextSpan(
                              text: 'I agree to the ',
                              style: AppTextStyles.linkText,
                              children: [
                                TextSpan(
                                  text: 'Terms & Privacy',
                                  style: AppTextStyles.linkBold,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── Create account button ──
                      FlowPrimaryButton(
                        label: 'Create account',
                        onPressed: _submit,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 24),

                      // ── Divider ──
                      const FlowDividerText(text: 'or sign up with'),
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
                        leadText: 'Already have an account?',
                        actionText: 'Log in',
                        onPressed: widget.onSwitchToLogin,
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
