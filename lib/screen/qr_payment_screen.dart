import 'dart:async';
import 'package:flutter/material.dart';
import 'package:present_group2/menu/theme.dart';
import 'package:present_group2/menu/older_sceen.dart';
import 'package:present_group2/screen/order_success_screen.dart';

// ── QR PAYMENT SCREEN ─────────────────────────────────────────────────
// Shown after tapping "Checkout" on the Bag screen, before the order is
// actually finalized — matches how QR payment (KHQR / bank apps) is the
// dominant checkout method in Cambodia, rather than card entry.
class QrPaymentScreen extends StatefulWidget {
  final double total;
  final List<BagItem> purchasedItems;
  const QrPaymentScreen({
    super.key,
    required this.total,
    required this.purchasedItems,
  });

  @override
  State<QrPaymentScreen> createState() => _QrPaymentScreenState();
}

class _QrPaymentScreenState extends State<QrPaymentScreen> {
  static const _expirySeconds = 5 * 60; // 5 minutes
  int _secondsLeft = _expirySeconds;
  Timer? _timer;
  bool _confirming = false;

  // A fake but realistic-looking payment reference — swap this for a
  // real one from your payment provider once you integrate KHQR/Bakong.
  late final String _orderRef =
      'AF${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _regenerate() {
    setState(() => _secondsLeft = _expirySeconds);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  // Simulates checking with the bank/payment provider, then finalizes
  // the order — this is where real KHQR/Bakong status polling would go.
  Future<void> _confirmPayment() async {
    setState(() => _confirming = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    final purchasedCount = Bag.instance.checkoutSelected();
    OrderHistory.instance.addOrder(
      items: widget.purchasedItems,
      total: widget.total,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderSuccessScreen(
          total: widget.total,
          itemCount: purchasedCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expired = _secondsLeft <= 0;
    // Scales with the actual screen width instead of a fixed guess, so
    // it fills the card properly on any phone size instead of looking
    // small on wider screens or overflowing on narrow ones.
    final qrSize =
        (MediaQuery.of(context).size.width * 0.62).clamp(220.0, 300.0);

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // ── Top bar ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    _RoundIconButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      'Scan to Pay',
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

              const Spacer(),

              // ── QR card ─────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: kShadow,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [kGreen, kGreenDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.storefront_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Angkor Fashion',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: kTextDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ref: $_orderRef',
                      style: const TextStyle(fontSize: 11.5, color: kTextGrey),
                    ),
                    const SizedBox(height: 20),

                    // ── The QR code itself, dimmed + overlaid with a
                    // "Refresh" prompt once it expires ────────────────
                    // Bumped from 200x200 to 260x260 — same styling,
                    // just bigger and easier to scan.
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: expired ? 0.15 : 1,
                          // 👉 ADD YOUR BANK QR IMAGE HERE — put the
                          // file in lib/image/ and update the path
                          // below (this is your real, unchanging QR
                          // code, e.g. an ABA/ACLEDA/Bakong static QR
                          // — the amount/timer around it are just for
                          // display, they don't change what's encoded
                          // in the picture itself).
                          child: Image.asset(
                            'lib/image/bank_qr.jpg',
                            width: qrSize,
                            height: qrSize,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: qrSize,
                              height: qrSize,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: kBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Add your QR image at\nlib/image/bank_qr.png',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 11.5, color: kTextGrey),
                              ),
                            ),
                          ),
                        ),
                        if (expired)
                          GestureDetector(
                            onTap: _regenerate,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.refresh_rounded, color: kGreenDark, size: 32),
                                SizedBox(height: 6),
                                Text(
                                  'QR expired\nTap to refresh',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kGreenDark,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text(
                      '\$${widget.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: kTextDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: expired
                            ? kBadgePink.withValues(alpha: 0.12)
                            : kGreen.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        expired ? 'Expired' : 'Expires in $_formattedTime',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: expired ? kBadgePink : kGreenDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              const Text(
                'Open your banking app (ABA, ACLEDA, Wing, and others)\nand scan this code to complete your payment.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.5, color: kTextGrey, height: 1.5),
              ),

              const Spacer(),

              // ── Confirm button ────────────────────────────────────
              // In a real integration this button wouldn't exist — the
              // app would auto-detect payment by polling the provider.
              // Kept here so you can test/demo the flow without a real
              // backend hooked up yet.
              SizedBox(
                width: double.infinity,
                height: 54,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: expired
                        ? null
                        : const LinearGradient(
                            colors: [kGreen, kGreenDark],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                    color: expired ? kTextGrey.withValues(alpha: 0.4) : null,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: expired
                        ? null
                        : [
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
                      onTap: (expired || _confirming) ? null : _confirmPayment,
                      child: Center(
                        child: _confirming
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.4,
                                ),
                              )
                            : const Text(
                                "I've Completed Payment",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Small round icon button (back) ──────────────────────────────────────
class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: kShadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 19, color: kTextDark),
      ),
    );
  }
}