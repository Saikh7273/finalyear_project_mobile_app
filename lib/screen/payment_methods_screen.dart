import 'package:flutter/material.dart';
import 'package:present_group2/menu/theme.dart';

// ── Model ─────────────────────────────────────────────────────────────
class PaymentCard {
  final String brand; // 'Visa', 'Mastercard', etc.
  final String holderName;
  final String last4;
  final String expiry; // 'MM/YY'
  bool isDefault;
  PaymentCard({
    required this.brand,
    required this.holderName,
    required this.last4,
    required this.expiry,
    this.isDefault = false,
  });
}

// ── PAYMENT METHODS SCREEN ─────────────────────────────────────────────
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  // 👉 Sample cards — replace with real data whenever you wire up a
  // backend. Add more PaymentCard(...) entries the same way to show
  // additional saved cards.
  final List<PaymentCard> _cards = [
    PaymentCard(
      brand: 'Visa',
      holderName: 'Khon Pich',
      last4: '4242',
      expiry: '08/27',
      isDefault: true,
    ),
    PaymentCard(
      brand: 'Mastercard',
      holderName: 'Khon Pich',
      last4: '8890',
      expiry: '02/26',
    ),
  ];

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon')),
    );
  }

  void _setDefault(int index) {
    setState(() {
      for (var i = 0; i < _cards.length; i++) {
        _cards[i].isDefault = i == index;
      }
    });
  }

  void _removeCard(int index) {
    setState(() {
      final wasDefault = _cards[index].isDefault;
      _cards.removeAt(index);
      if (wasDefault && _cards.isNotEmpty) _cards.first.isDefault = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: _cards.isEmpty
            ? _EmptyState(onAdd: _showComingSoon)
            : ListView(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
                children: [
                  // ── Top bar ─────────────────────────────────────
                  Row(
                    children: [
                      _RoundIconButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Payment Methods',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: kTextDark,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_cards.length} saved card${_cards.length == 1 ? '' : 's'}',
                              style: const TextStyle(fontSize: 12.5, color: kTextGrey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  for (var i = 0; i < _cards.length; i++) ...[
                    _PaymentCardTile(
                      card: _cards[i],
                      onSetDefault: () => _setDefault(i),
                      onRemove: () => _removeCard(i),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Add card — dashed outline "slot" the same size
                  // as a real card, instead of a plain button, so it
                  // reads as another card in the stack ──────────────
                  _AddCardTile(onTap: _showComingSoon),
                ],
              ),
      ),
    );
  }
}

// ── Empty state ──────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
          child: Row(
            children: [
              _RoundIconButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(width: 14),
              const Text(
                'Payment Methods',
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
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(color: kPeach, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const Icon(Icons.credit_card_outlined, size: 40, color: kTextDark),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No cards saved yet',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: kTextDark),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Add a card to check out faster next time.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: kTextGrey),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(width: double.infinity, child: _AddCardTile(onTap: onAdd)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Card tile — chip icon, brand logo mark, cardholder name, expiry ─────
class _PaymentCardTile extends StatelessWidget {
  final PaymentCard card;
  final VoidCallback onSetDefault;
  final VoidCallback onRemove;
  const _PaymentCardTile({
    required this.card,
    required this.onSetDefault,
    required this.onRemove,
  });

  List<Color> get _gradientColors {
    switch (card.brand) {
      case 'Mastercard':
        return [const Color(0xFF2E2E3E), const Color(0xFF15161F)];
      default:
        return [kGreen, kGreenDark];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _gradientColors.first.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Faint decorative circle, purely for texture — real cards
          // are never a flat, empty rectangle.
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Chip + brand mark ─────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ChipIcon(),
                  _BrandMark(brand: card.brand),
                ],
              ),
              const SizedBox(height: 18),

              // ── Card number ────────────────────────────────────
              Text(
                '••••  ••••  ••••  ${card.last4}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),

              const Spacer(),

              // ── Cardholder + expiry ────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CARD HOLDER',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.65),
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          card.holderName.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXPIRES',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        card.expiry,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // ── Default badge, top-left ─────────────────────────────
          if (card.isDefault)
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded, size: 12, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Default',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Options menu, top-right ─────────────────────────────
          Positioned(
            right: 0,
            top: 0,
            child: PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 18),
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              onSelected: (value) {
                if (value == 'default') onSetDefault();
                if (value == 'remove') onRemove();
              },
              itemBuilder: (context) => [
                if (!card.isDefault)
                  const PopupMenuItem(
                    value: 'default',
                    child: Text('Set as default'),
                  ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Text('Remove card'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card chip icon — small gold rounded rectangle with contact lines,
// like a real card's EMV chip. ──────────────────────────────────────
class _ChipIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 28,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8D48A), Color(0xFFC9A94A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          3,
          (i) => Container(
            height: 1.4,
            color: const Color(0xFF8A6E20).withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}

// ── Brand logo mark — a simple Visa wordmark or Mastercard circles,
// drawn directly instead of relying on an image asset. ────────────────
class _BrandMark extends StatelessWidget {
  final String brand;
  const _BrandMark({required this.brand});

  @override
  Widget build(BuildContext context) {
    if (brand == 'Mastercard') {
      return SizedBox(
        width: 44,
        height: 28,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFFEB5757),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5A623).withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Default: Visa-style italic wordmark.
    return const Text(
      'VISA',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.italic,
        letterSpacing: 1,
      ),
    );
  }
}

// ── "Add new card" tile — dashed outline the same shape as a real
// card, instead of a plain solid button. ──────────────────────────────
class _AddCardTile extends StatelessWidget {
  final VoidCallback onTap;
  const _AddCardTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(radius: 22),
        child: Container(
          height: 90,
          width: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(color: kPeach, shape: BoxShape.circle),
                child: const Icon(Icons.add_rounded, color: kTextDark, size: 20),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add New Card',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: kTextDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final double radius;
  _DashedBorderPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kTextGrey.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    const dashWidth = 6.0;
    const dashSpace = 5.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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