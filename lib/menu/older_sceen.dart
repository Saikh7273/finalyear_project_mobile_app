import 'package:flutter/material.dart';
import 'package:present_group2/menu/theme.dart';
import 'package:present_group2/menu/bottom_nav.dart';
import 'package:present_group2/screen/main_screen.dart';
import 'package:present_group2/screen/qr_payment_screen.dart';
import 'package:present_group2/menu/research_screen.dart';
import 'package:present_group2/menu/profile_screen.dart';

// ── Model ─────────────────────────────────────────────────────────────
class BagItem {
  final String store;
  final String name;
  final String size;
  final double price;
  final String imagePath;
  int quantity;
  bool selected;
  BagItem({
    required this.store,
    required this.name,
    required this.size,
    required this.price,
    required this.imagePath,
    this.quantity = 1,
    this.selected = true,
  });
}

// ── Bag (shared across screens) ────────────────────────────────────────
// Call Bag.instance.add(...) from anywhere (e.g. a "buy" button on a
// product card) and this screen will automatically show it — including
// whatever image path that product already used.
class Bag extends ChangeNotifier {
  Bag._internal();
  static final Bag instance = Bag._internal();

  final List<BagItem> _items = [];
  List<BagItem> get items => List.unmodifiable(_items);

  bool get allSelected => _items.isNotEmpty && _items.every((e) => e.selected);

  int get itemCount => _items.fold(0, (sum, e) => sum + e.quantity);

  double get total => _items
      .where((e) => e.selected)
      .fold(0.0, (sum, e) => sum + e.price * e.quantity);

  /// Adds a product to the bag. If a product with the same name is
  /// already in the bag, its quantity is increased instead of adding
  /// a duplicate row.
  void add({
    required String name,
    required double price,
    required String imagePath,
    String store = 'Angkor Fashion',
    String size = 'One Size',
  }) {
    final index = _items.indexWhere((e) => e.name == name);
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(
        BagItem(
          store: store,
          name: name,
          size: size,
          price: price,
          imagePath: imagePath,
        ),
      );
    }
    notifyListeners();
  }

  void toggleSelected(int index, bool value) {
    _items[index].selected = value;
    notifyListeners();
  }

  void toggleAll(bool value) {
    for (final item in _items) {
      item.selected = value;
    }
    notifyListeners();
  }

  void increment(int index) {
    _items[index].quantity += 1;
    notifyListeners();
  }

  void decrement(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity -= 1;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  /// Finalizes an order: removes the currently-selected items from the
  /// bag (the ones being purchased) and returns how many there were.
  /// Call this right before showing the order-success screen.
  int checkoutSelected() {
    final purchasedCount = _items.where((e) => e.selected).length;
    _items.removeWhere((e) => e.selected);
    notifyListeners();
    return purchasedCount;
  }
}

// ── Order history (shared across screens) ───────────────────────────────
// A snapshot of what was purchased in one checkout — kept even after
// the items are removed from the Bag, so "My Orders" has something to
// show.
class Order {
  final DateTime date;
  final double total;
  final List<BagItem> items;
  Order({required this.date, required this.total, required this.items});
}

class OrderHistory extends ChangeNotifier {
  OrderHistory._internal();
  static final OrderHistory instance = OrderHistory._internal();

  final List<Order> _orders = [];

  /// Most recent order first.
  List<Order> get orders => List.unmodifiable(_orders.reversed);

  void addOrder({required List<BagItem> items, required double total}) {
    // Copy each item so later Bag changes can't affect this saved order.
    final snapshot = items
        .map((e) => BagItem(
              store: e.store,
              name: e.name,
              size: e.size,
              price: e.price,
              imagePath: e.imagePath,
              quantity: e.quantity,
            ))
        .toList();
    _orders.add(Order(date: DateTime.now(), total: total, items: snapshot));
    notifyListeners();
  }
}

// ── BAG SCREEN ───────────────────────────────────────────────────────
class OlderScreen extends StatefulWidget {
  const OlderScreen({super.key});

  @override
  State<OlderScreen> createState() => _OlderScreenState();
}

class _OlderScreenState extends State<OlderScreen> {
  int _navIndex = 2; // Bag tab active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Bag.instance,
          builder: (context, _) {
            final items = Bag.instance.items;

            // Group items by store, preserving first-seen order.
            final storeOrder = <String>[];
            for (final item in items) {
              if (!storeOrder.contains(item.store)) storeOrder.add(item.store);
            }

            return Column(
              children: [
                // ── Top bar ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'My Bag',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: kTextDark,
                              letterSpacing: -0.4,
                            ),
                          ),
                          if (items.isNotEmpty)
                            Text(
                              '${Bag.instance.itemCount} item${Bag.instance.itemCount == 1 ? '' : 's'}',
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: kTextGrey,
                              ),
                            ),
                        ],
                      ),
                      _RoundIconButton(
                        icon: Icons.favorite_border_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                // ── Item list ───────────────────────────────────
                Expanded(
                  child: items.isEmpty
                      ? _EmptyBagState(
                          onStartShopping: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const MainScreen()),
                            (route) => false,
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          children: [
                            for (final store in storeOrder) ...[
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [kGreen, kGreenDark],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.storefront_rounded,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    store,
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      color: kTextDark,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              for (final item in items.where(
                                (e) => e.store == store,
                              ))
                                _BagItemTile(
                                  item: item,
                                  onSelectedChanged: (v) => Bag.instance
                                      .toggleSelected(
                                        items.indexOf(item),
                                        v ?? false,
                                      ),
                                  onIncrement: () => Bag.instance.increment(
                                    items.indexOf(item),
                                  ),
                                  onDecrement: () => Bag.instance.decrement(
                                    items.indexOf(item),
                                  ),
                                ),
                            ],
                            const SizedBox(height: 16),
                          ],
                        ),
                ),

                // ── Bottom summary + checkout ────────────────────
                // Only shown when there's something in the bag — the
                // empty state already has its own "Start Shopping" CTA,
                // so this bar would be redundant (and confusing, since
                // Checkout would just be permanently disabled).
                if (items.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: kShadow,
                          blurRadius: 20,
                          offset: const Offset(0, -6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Bag.instance
                                  .toggleAll(!Bag.instance.allSelected),
                              child: Row(
                                children: [
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: Bag.instance.allSelected
                                          ? const LinearGradient(
                                              colors: [kGreen, kGreenDark],
                                            )
                                          : null,
                                      color: Bag.instance.allSelected
                                          ? null
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: Bag.instance.allSelected
                                            ? Colors.transparent
                                            : kTextGrey,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Bag.instance.allSelected
                                        ? const Icon(Icons.check_rounded,
                                            size: 15, color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Select all',
                                    style: TextStyle(
                                      color: kTextDark,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: kTextGrey,
                                  ),
                                ),
                                Text(
                                  '\$${Bag.instance.total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: kTextDark,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: _CheckoutButton(
                            enabled: Bag.instance.items.any((e) => e.selected),
                            onPressed: () {
                              final total = Bag.instance.total;
                              // Snapshot the selected items — the QR
                              // screen finalizes the order (removes
                              // them from the Bag + saves to
                              // OrderHistory) only once payment is
                              // confirmed, not before.
                              final purchasedItems =
                                  items.where((e) => e.selected).toList();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => QrPaymentScreen(
                                    total: total,
                                    purchasedItems: purchasedItems,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
     bottomNavigationBar: AnimatedBuilder(
        animation: Bag.instance,
        builder: (context, _) {
          return AppBottomNav(
            currentIndex: _navIndex,
            bagCount: Bag.instance.itemCount,
            onTap: (i) {
              setState(() => _navIndex = i);
              if (i == 0) {
                // Home — clear the whole stack and go to MainScreen,
                // instead of just popping one screen back.
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                  (route) => false,
                );
              } else if (i == 1) {
                // Replace instead of push, so switching tabs doesn't
                // keep growing the navigation stack.
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              } else if (i == 3) {
                // Replace instead of push, so switching between Bag and
                // Profile doesn't keep growing the navigation stack.
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              }
              // i == 2 (Bag) — already here, nothing to do.
            },
          );
        },
      ),
    );
  }
}

// ── Small round icon button (favorite) ─────────────────────────────────
class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
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

// ── Gradient checkout button, disabled state included ──────────────────
class _CheckoutButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;
  const _CheckoutButton({required this.enabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: enabled
            ? const LinearGradient(
                colors: [kGreen, kGreenDark],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: enabled ? null : kTextGrey.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: kGreen.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: enabled ? onPressed : null,
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Checkout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.5,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Empty bag state — gradient icon badge + heading + subtext + CTA ────
class _EmptyBagState extends StatelessWidget {
  final VoidCallback onStartShopping;
  const _EmptyBagState({required this.onStartShopping});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kGreen.withValues(alpha: 0.15), kPeach],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text('🛍️', style: TextStyle(fontSize: 48)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your bag is empty',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: kTextDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Looking for ideas? Find something\nyou love and it\'ll show up here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: kTextGrey, height: 1.5),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: _CheckoutButtonLabel(
                label: 'Start Shopping',
                onTap: onStartShopping,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Generic gradient CTA button, reused for "Start Shopping" ───────────
class _CheckoutButtonLabel extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _CheckoutButtonLabel({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Bag item row ─────────────────────────────────────────────────────
class _BagItemTile extends StatelessWidget {
  final BagItem item;
  final ValueChanged<bool?> onSelectedChanged;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _BagItemTile({
    required this.item,
    required this.onSelectedChanged,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kShadow,
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Selection circle — gradient fill when selected.
          GestureDetector(
            onTap: () => onSelectedChanged(!item.selected),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: item.selected
                    ? const LinearGradient(colors: [kGreen, kGreenDark])
                    : null,
                color: item.selected ? null : Colors.transparent,
                border: Border.all(
                  color: item.selected ? Colors.transparent : kTextGrey,
                  width: 1.5,
                ),
              ),
              child: item.selected
                  ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),

          // Thumbnail — same image the product used on the home screen.
          // errorBuilder keeps a fixed size even if the image is missing,
          // so it can never overflow the row.
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              item.imagePath,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 64,
                height: 64,
                color: kBg,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  size: 20,
                  color: kTextGrey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Name / size / price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: kTextDark,
                    fontSize: 14.5,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: kBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.size,
                    style: const TextStyle(color: kTextGrey, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: kGreenDark,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          // Quantity stepper — pill-shaped container.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: kBg,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StepperButton(icon: Icons.remove, onTap: onDecrement),
                SizedBox(
                  width: 24,
                  child: Text(
                    '${item.quantity}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: kTextDark,
                      fontSize: 13,
                    ),
                  ),
                ),
                _StepperButton(icon: Icons.add, onTap: onIncrement),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: kShadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 14, color: kTextDark),
      ),
    );
  }
}