import 'package:flutter/material.dart';
import 'package:present_group2/menu/theme.dart';
import 'package:present_group2/screen/main_screen.dart';
import 'package:present_group2/screen/order_history_screen.dart';

//Older success screen, kept for reference. The new one is in order_success_screen_v2.dart
class OrderSuccessScreen extends StatefulWidget {
  final double total;
  final int itemCount;
  const OrderSuccessScreen({
    super.key,
    required this.total,
    required this.itemCount,
  });

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Icon: scales/bounces in with a slight overshoot (elasticOut), and
  // fades in quickly at the very start of the timeline.
  late final Animation<double> _iconScale = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
  );
  late final Animation<double> _iconFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
  );

  // Title/subtitle: fade + slide up, starting once the icon is mostly done.
  late final Animation<double> _textFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.25, 0.55, curve: Curves.easeOut),
  );
  late final Animation<Offset> _textSlide = Tween(
    begin: const Offset(0, 0.15),
    end: Offset.zero,
  ).animate(_textFade);

  // Summary card: fade + slide up, starting a bit after the text.
  late final Animation<double> _cardFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
  );
  late final Animation<Offset> _cardSlide = Tween(
    begin: const Offset(0, 0.15),
    end: Offset.zero,
  ).animate(_cardFade);

  // Buttons: fade + slide up last, so the eye lands on them after
  // everything else has settled.
  late final Animation<double> _buttonsFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
  );
  late final Animation<Offset> _buttonsSlide = Tween(
    begin: const Offset(0, 0.15),
    end: Offset.zero,
  ).animate(_buttonsFade);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          // ── Decorative background blobs, same touch as the
          // login/register screens ─────────────────────────────
          Positioned(
            top: -90,
            right: -70,
            child: _Blob(size: 240, color: kGreen.withValues(alpha: 0.14)),
          ),
          Positioned(
            top: 80,
            left: -100,
            child: _Blob(size: 200, color: kBadgePink.withValues(alpha: 0.10)),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // ── Success icon — bounces in with a slight
                  // overshoot instead of just appearing ───────────
                  FadeTransition(
                    opacity: _iconFade,
                    child: ScaleTransition(
                      scale: _iconScale,
                      child: Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [kGreen, kGreenDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: kGreen.withValues(alpha: 0.35),
                              blurRadius: 26,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 54,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Title + subtitle ──────────────────────────────
                  FadeTransition(
                    opacity: _textFade,
                    child: SlideTransition(
                      position: _textSlide,
                      child: Column(
                        children: [
                          const Text(
                            'Order Placed!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: kTextDark,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Your order has been placed successfully.\nYou\'ll get a notification once it ships.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: kTextGrey,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // ── Order summary card ────────────────────────────
                  FadeTransition(
                    opacity: _cardFade,
                    child: SlideTransition(
                      position: _cardSlide,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: kShadow,
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _SummaryRow(
                              icon: Icons.inventory_2_rounded,
                              label: 'Items',
                              value: '${widget.itemCount}',
                            ),
                            const SizedBox(height: 14),
                            const Divider(height: 1, color: kBg),
                            const SizedBox(height: 14),
                            _SummaryRow(
                              icon: Icons.payments_rounded,
                              label: 'Total paid',
                              value: '\$${widget.total.toStringAsFixed(2)}',
                              bold: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // ── Buttons ────────────────────────────────────────
                  FadeTransition(
                    opacity: _buttonsFade,
                    child: SlideTransition(
                      position: _buttonsSlide,
                      child: Column(
                        children: [
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
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: kGreen.withValues(alpha: 0.35),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    // Clear the whole stack and return to Home.
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const MainScreen()),
                                      (route) => false,
                                    );
                                  },
                                  child: const Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Continue Shopping',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.5,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(Icons.arrow_forward_rounded,
                                            color: Colors.white, size: 18),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                // The order that was just placed shows up
                                // first, since OrderHistory.orders lists
                                // most-recent-first.
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const OrderHistoryScreen()),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: kTextDark,
                                side: const BorderSide(color: kTextGrey, width: 1),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'View Order',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
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

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool bold;
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: kGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 16, color: kGreenDark),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(color: kTextGrey, fontSize: 13.5),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            color: kTextDark,
            fontSize: bold ? 18 : 13.5,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}