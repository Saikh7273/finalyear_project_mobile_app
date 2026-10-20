import 'package:flutter/material.dart';
import 'package:present_group2/menu/theme.dart';
import 'package:present_group2/screen/main_screen.dart';
import 'package:present_group2/screen/register_screen.dart'; // Make sure this path matches your project structure
//import 'package:present_group2/menu/profile_screen.dart';

// ── LOGIN SCREEN ──────────────────────────────────────────────────────
// No real authentication — tapping "Sign In" just takes you to
// MainScreen. Google/Apple buttons and the Forgot Password / Sign Up
// links show a "Coming soon" snackbar.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late final AnimationController _entrance;
  late final Animation<double> _brandAnim;
  late final Animation<double> _titleAnim;
  late final Animation<double> _formAnim;
  late final Animation<double> _dividerAnim;
  late final Animation<double> _signupAnim;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _brandAnim = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );
    _titleAnim = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.1, 0.55, curve: Curves.easeOut),
    );
    _formAnim = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.25, 0.75, curve: Curves.easeOut),
    );
    _dividerAnim = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.5, 0.9, curve: Curves.easeOut),
    );
    _signupAnim = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _entrance.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Coming soon'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: kTextDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _signIn() {
    // No backend — clear the stack so the back button can't return
    // to the login screen, and go straight to Home.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: DecoratedBox(
        // Subtle gradient wash behind everything — flat kBg on its own
        // reads a bit dead; this gives the screen some depth.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kGreen.withValues(alpha: 0.05), kBg, kBg],
            stops: const [0.0, 0.35, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // ── Decorative background blobs ─────────────────────────
            Positioned(
              top: -90,
              right: -70,
              child: _Blob(size: 240, color: kGreen.withValues(alpha: 0.14)),
            ),
            Positioned(
              top: 60,
              left: -100,
              child: _Blob(
                size: 200,
                color: kBadgePink.withValues(alpha: 0.10),
              ),
            ),
            Positioned(
              bottom: -60,
              right: -60,
              child: _Blob(
                size: 160,
                color: kGreenDark.withValues(alpha: 0.08),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // ── Brand mark ───────────────────────────────────
                    _FadeSlide(
                      animation: _brandAnim,
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [kGreen, kGreenDark],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: kGreen.withValues(alpha: 0.35),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.shopping_bag_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Angkor Fashion',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: kTextDark,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),

                    // ── Title ─────────────────────────────────────────
                    _FadeSlide(
                      animation: _titleAnim,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome back 👋',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: kTextDark,
                              letterSpacing: -0.6,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Sign in to your Angkor Fashion account for a\npersonalized shopping experience.',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: kTextGrey.withValues(alpha: 0.9),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // ── Form card ───────────────────────────────────
                    _FadeSlide(
                      animation: _formAnim,
                      child: Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(
                            color: kGreen.withValues(alpha: 0.06),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: kShadow,
                              blurRadius: 28,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _AuthField(
                              controller: _emailController,
                              icon: Icons.mail_outline_rounded,
                              hint: 'Email address',
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 14),
                            _AuthField(
                              controller: _passwordController,
                              icon: Icons.lock_outline_rounded,
                              hint: 'Password',
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: kTextGrey,
                                  size: 19,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _showComingSoon,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: kGreenDark,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // ── Sign in button ─────────────────────────
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [kGreen, kGreenDark],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(17),
                                  boxShadow: [
                                    BoxShadow(
                                      color: kGreen.withValues(alpha: 0.38),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(17),
                                    onTap: _signIn,
                                    child: const Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Sign In',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15.5,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),

                    // ── Divider + social ─────────────────────────────
                    _FadeSlide(
                      animation: _dividerAnim,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: kTextGrey.withValues(alpha: 0.3),
                                  thickness: 0.6,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  'Or continue with',
                                  style: TextStyle(
                                    color: kTextGrey.withValues(alpha: 0.9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: kTextGrey.withValues(alpha: 0.3),
                                  thickness: 0.6,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _SocialButton(
                                  label: 'Google',
                                  onTap: _showComingSoon,
                                  child: const _GoogleMark(size: 20),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _SocialButton(
                                  label: 'Apple',
                                  onTap: _showComingSoon,
                                  child: const Icon(
                                    Icons.apple_rounded,
                                    color: kTextDark,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // ── Sign up prompt ─────────────────────────────────
                    _FadeSlide(
                      animation: _signupAnim,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: kTextGrey.withValues(alpha: 0.9),
                                fontSize: 13,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: kGreenDark,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Fade + slide-up entrance wrapper, used to stagger sections in ──────
class _FadeSlide extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  const _FadeSlide({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - animation.value) * 18),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

// ── Soft decorative circle used in the background ─────────────────────
class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ── Reusable email/password field ─────────────────────────────────────
class _AuthField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const _AuthField({
    required this.controller,
    required this.icon,
    required this.hint,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kTextGrey.withValues(alpha: 0.14)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: kTextDark,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: kGreenDark,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: kTextGrey.withValues(alpha: 0.85),
            fontSize: 14,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: kGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: kGreenDark, size: 16),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: kGreen, width: 1.6),
          ),
          filled: true,
          fillColor: kBg,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

// ── Google / Apple sign-in button ──────────────────────────────────────
class _SocialButton extends StatelessWidget {
  final Widget child;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.child,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kTextGrey.withValues(alpha: 0.14)),
            boxShadow: [
              BoxShadow(
                color: kShadow,
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              child,
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: kTextDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Real multi-color Google "G" mark, traced from Google's own
// 18x18 icon path data — pixel-accurate, no image assets needed ───────
class _GoogleMark extends StatelessWidget {
  final double size;
  const _GoogleMark({this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Original artwork is defined on an 18x18 viewBox — scale to fit.
    final scale = size.width / 18.0;
    canvas.save();
    canvas.scale(scale);

    final paint = Paint()..style = PaintingStyle.fill;

    // Blue
    paint.color = const Color(0xFF4285F4);
    canvas.drawPath(
      Path()
        ..moveTo(17.64, 9.2045)
        ..cubicTo(17.64, 8.5664, 17.5827, 7.9527, 17.4764, 7.3636)
        ..lineTo(9, 7.3636)
        ..lineTo(9, 10.845)
        ..lineTo(13.8436, 10.845)
        ..cubicTo(13.635, 11.97, 13.0009, 12.9232, 12.0477, 13.5614)
        ..lineTo(12.0477, 15.8195)
        ..lineTo(14.9564, 15.8195)
        ..cubicTo(16.6582, 14.2527, 17.64, 11.9454, 17.64, 9.2045)
        ..close(),
      paint,
    );

    // Green
    paint.color = const Color(0xFF34A853);
    canvas.drawPath(
      Path()
        ..moveTo(9, 18)
        ..cubicTo(11.43, 18, 13.4673, 17.194, 14.9564, 15.8195)
        ..lineTo(12.0477, 13.5614)
        ..cubicTo(11.2418, 14.1014, 10.2109, 14.4204, 9, 14.4204)
        ..cubicTo(6.656, 14.4204, 4.6718, 12.8373, 3.964, 10.71)
        ..lineTo(0.9573, 10.71)
        ..lineTo(0.9573, 13.0418)
        ..cubicTo(2.4382, 15.9832, 5.4818, 18, 9, 18)
        ..close(),
      paint,
    );

    // Yellow
    paint.color = const Color(0xFFFBBC05);
    canvas.drawPath(
      Path()
        ..moveTo(3.964, 10.71)
        ..cubicTo(3.784, 10.17, 3.6818, 9.5932, 3.6818, 9)
        ..cubicTo(3.6818, 8.4068, 3.7841, 7.83, 3.9641, 7.29)
        ..lineTo(3.9641, 4.9582)
        ..lineTo(0.9573, 4.9582)
        ..cubicTo(0.3477, 6.1732, 0, 7.5477, 0, 9)
        ..cubicTo(0, 10.4523, 0.3477, 11.8268, 0.9573, 13.0418)
        ..lineTo(3.964, 10.71)
        ..close(),
      paint,
    );

    // Red
    paint.color = const Color(0xFFEA4335);
    canvas.drawPath(
      Path()
        ..moveTo(9, 3.5795)
        ..cubicTo(10.3214, 3.5795, 11.5077, 4.0336, 12.4405, 4.9255)
        ..lineTo(15.0218, 2.3441)
        ..cubicTo(13.4632, 0.8918, 11.426, 0, 9, 0)
        ..cubicTo(5.4818, 0, 2.4382, 2.0168, 0.9573, 4.9582)
        ..lineTo(3.964, 7.29)
        ..cubicTo(4.6718, 5.1627, 6.656, 3.5795, 9, 3.5795)
        ..close(),
      paint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
