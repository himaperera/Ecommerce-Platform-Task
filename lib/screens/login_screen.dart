import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _showEmailForm = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  late VideoPlayerController _videoController;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();

    // Video setup — replace the asset path with your actual video file
    // e.g. 'assets/videos/hero_skin.mp4'
    _videoController = VideoPlayerController.asset('assets/videos/cover.mp4')
      ..initialize()
          .then((_) {
            if (mounted) {
              setState(() => _videoReady = true);
              _videoController.setLooping(true);
              _videoController.setVolume(0);
              _videoController.play();
            }
          })
          .catchError((_) {
            // Video failed to load — fallback image will show
            if (mounted) setState(() => _videoReady = false);
          });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) {
          setState(() => _isLoading = false);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      });
    }
  }

  void _skipLogin() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void _mockSocialLogin(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider login is mocked!'),
        duration: const Duration(milliseconds: 1000),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const Color brandPink = Color(0xFFF68D9A);
    const Color textDark = Color(0xFF2C2C2C);
    const Color subtleGray = Color(0xFFF5F5F5);
    final Color cardBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0E0E0E)
          : const Color(0xFFFDF6F7),
      body: Stack(
        children: [
          // ── THIN PINK BORDER LAYER (full page outline) ───────────────
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: brandPink.withOpacity(0.35),
                  width: 1.2,
                ),
              ),
            ),
          ),

          // ── MAIN CONTENT ─────────────────────────────────────────────
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // ── VIDEO / IMAGE HERO ───────────────────────────────
                  SizedBox(
                    height: size.height * 0.52,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        // Video or fallback image
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(28),
                              topRight: Radius.circular(28),
                            ),
                            child: _videoReady
                                ? FittedBox(
                                    fit: BoxFit.cover,
                                    clipBehavior: Clip.hardEdge,
                                    child: SizedBox(
                                      width: _videoController.value.size.width,
                                      height:
                                          _videoController.value.size.height,
                                      child: VideoPlayer(_videoController),
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/image.png',
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: const Color(0xFFF5D5DB),
                                    ),
                                  ),
                          ),
                        ),

                        // Subtle dark gradient overlay at bottom of video
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 120,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  cardBg.withOpacity(0.9),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // ── earth rhythm LOGO ────────────────────────
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                            child: const _EarthRhythmLogo(size: 38),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── FORM CARD ────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(minHeight: size.height * 0.48),
                    decoration: BoxDecoration(
                      color: cardBg,
                      // Thin pink top border only on the card
                      border: Border(
                        top: BorderSide(
                          color: brandPink.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(28, 32, 28, 48),
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Heading
                            Text(
                              'Your Skin Journey\nStarts Here!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : textDark,
                                height: 1.3,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Apple
                            _SocialButton(
                              onTap: () => _mockSocialLogin('Apple'),
                              icon: _AppleIcon(
                                color: isDark
                                    ? const Color(0xFF1C1C1E)
                                    : Colors.white,
                              ),
                              label: 'Sign up with Apple',
                              backgroundColor: isDark
                                  ? Colors.white
                                  : const Color(0xFF1C1C1E),
                              textColor: isDark
                                  ? const Color(0xFF1C1C1E)
                                  : Colors.white,
                              borderColor: Colors.transparent,
                            ),
                            const SizedBox(height: 12),

                            // Google
                            _SocialButton(
                              onTap: () => _mockSocialLogin('Google'),
                              icon: const _GoogleColorIcon(),
                              label: 'Sign up with Google',
                              backgroundColor: isDark
                                  ? const Color(0xFF2C2C2E)
                                  : Colors.white,
                              textColor: isDark ? Colors.white : textDark,
                              borderColor: isDark
                                  ? Colors.white12
                                  : const Color(0xFFE0E0E0),
                            ),
                            const SizedBox(height: 12),

                            // Email toggle / expanded form
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 350),
                              crossFadeState: _showEmailForm
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              firstChild: _SocialButton(
                                onTap: () =>
                                    setState(() => _showEmailForm = true),
                                icon: Icon(
                                  Icons.mail_outline_rounded,
                                  size: 20,
                                  color: isDark ? Colors.white : textDark,
                                ),
                                label: 'Sign up with Email',
                                backgroundColor: isDark
                                    ? const Color(0xFF2C2C2E)
                                    : subtleGray,
                                textColor: isDark ? Colors.white : textDark,
                                borderColor: Colors.transparent,
                              ),
                              secondChild: _EmailForm(
                                formKey: _formKey,
                                emailController: _emailController,
                                passwordController: _passwordController,
                                obscurePassword: _obscurePassword,
                                isLoading: _isLoading,
                                isDark: isDark,
                                textDark: textDark,
                                brandPink: brandPink,
                                onTogglePassword: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                onLogin: _handleLogin,
                                onForgotPassword: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Forgot Password flow is mocked!',
                                      ),
                                      duration: Duration(milliseconds: 1000),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Divider
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: isDark
                                        ? Colors.white12
                                        : Colors.black12,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    'or',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.white38
                                          : Colors.black38,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: isDark
                                        ? Colors.white12
                                        : Colors.black12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Skip
                            Center(
                              child: GestureDetector(
                                onTap: _skipLogin,
                                child: Text(
                                  'Skip for now',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.black45,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Footer
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.black45,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _showEmailForm = true),
                                  child: Text(
                                    'Sign in here',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: brandPink,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── earth rhythm LOGO ─────────────────────────────────────────────────────────
class _EarthRhythmLogo extends StatelessWidget {
  final double size;
  const _EarthRhythmLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'earth',
                style: TextStyle(
                  fontSize: size,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1.5,
                  height: 0.9,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'rhythm',
                style: TextStyle(
                  fontSize: size,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  letterSpacing: -1.2,
                  height: 0.95,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'CLEAN. KIND. EFFECTIVE.',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white.withOpacity(0.85),
            letterSpacing: 3.5,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── SOCIAL BUTTON ─────────────────────────────────────────────────────────────
class _SocialButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const _SocialButton({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 22, height: 22, child: icon),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── EMAIL FORM ────────────────────────────────────────────────────────────────
class _EmailForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final bool isDark;
  final Color textDark;
  final Color brandPink;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;

  const _EmailForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.isDark,
    required this.textDark,
    required this.brandPink,
    required this.onTogglePassword,
    required this.onLogin,
    required this.onForgotPassword,
  });

  InputDecoration _fieldDeco(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: isDark ? Colors.white54 : Colors.black45,
        fontSize: 14,
      ),
      prefixIcon: Icon(
        icon,
        size: 20,
        color: isDark ? Colors.white38 : Colors.black38,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF7F7F7),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFF68D9A), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.white : textDark,
            ),
            decoration: _fieldDeco('Email address', Icons.mail_outline),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!v.contains('@') || !v.contains('.')) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.white : textDark,
            ),
            decoration: _fieldDeco(
              'Password',
              Icons.lock_outline,
              suffix: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
                onPressed: onTogglePassword,
              ),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Please enter your password';
              }
              if (v.length < 6) return 'At least 6 characters required';
              return null;
            },
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onForgotPassword,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  fontSize: 13,
                  color: brandPink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isLoading ? null : onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C2C2C),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── APPLE ICON ────────────────────────────────────────────────────────────────
class _AppleIcon extends StatelessWidget {
  final Color color;
  const _AppleIcon({required this.color});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _ApplePainter(color: color));
}

class _ApplePainter extends CustomPainter {
  final Color color;
  _ApplePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final body = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          Rect.fromCenter(
            center: Offset(cx, cy + size.height * 0.06),
            width: size.width * 0.72,
            height: size.height * 0.78,
          ),
          topLeft: const Radius.circular(6),
          topRight: const Radius.circular(6),
          bottomLeft: const Radius.circular(10),
          bottomRight: const Radius.circular(10),
        ),
      );
    canvas.drawPath(body, paint);
    final leaf = Path()
      ..moveTo(cx + size.width * 0.02, cy - size.height * 0.32)
      ..quadraticBezierTo(
        cx + size.width * 0.28,
        cy - size.height * 0.55,
        cx + size.width * 0.18,
        cy - size.height * 0.48,
      )
      ..quadraticBezierTo(
        cx + size.width * 0.02,
        cy - size.height * 0.42,
        cx + size.width * 0.02,
        cy - size.height * 0.32,
      );
    canvas.drawPath(leaf, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── GOOGLE ICON ───────────────────────────────────────────────────────────────
class _GoogleColorIcon extends StatelessWidget {
  const _GoogleColorIcon();

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _GooglePainter());
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.44;
    final strokeW = size.width * 0.19;
    final colors = [
      const Color(0xFF4285F4),
      const Color(0xFF34A853),
      const Color(0xFFFBBC05),
      const Color(0xFFEA4335),
    ];
    final rect = Rect.fromCenter(
      center: Offset(cx, cy),
      width: r * 2,
      height: r * 2,
    );
    for (int i = 0; i < 4; i++) {
      canvas.drawArc(
        rect,
        -math.pi / 2 + i * math.pi / 2,
        math.pi / 2 - 0.08,
        false,
        Paint()
          ..color = colors[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeW
          ..strokeCap = StrokeCap.butt,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
