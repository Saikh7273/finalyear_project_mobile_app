import 'package:flutter/material.dart';
import 'package:present_group2/menu/theme.dart';

// ── Model ─────────────────────────────────────────────────────────────
class SavedAddress {
  final String label; // 'Home', 'Work', etc.
  final String fullAddress;
  final String phone;
  bool isDefault;
  SavedAddress({
    required this.label,
    required this.fullAddress,
    required this.phone,
    this.isDefault = false,
  });
}

// ── MY ADDRESS SCREEN ─────────────────────────────────────────────────
class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  // 👉 Sample addresses — replace with real data whenever you wire up a
  // backend. Add more SavedAddress(...) entries the same way to show
  // additional saved addresses.
  final List<SavedAddress> _addresses = [
    SavedAddress(
      label: 'Home',
      fullAddress: 'Street 210, Sangkat Boeung Kak I, Toul Kork, Phnom Penh',
      phone: '+855 885 170 070',
      isDefault: true,
    ),
    SavedAddress(
      label: 'Work',
      fullAddress: 'Building 6A, Diamond Island, Chamkarmon, Phnom Penh',
      phone: '+855 98 765 432',
    ),
  ];

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon')),
    );
  }

  void _setDefault(int index) {
    setState(() {
      for (var i = 0; i < _addresses.length; i++) {
        _addresses[i].isDefault = i == index;
      }
    });
  }

  void _removeAddress(int index) {
    setState(() {
      final wasDefault = _addresses[index].isDefault;
      _addresses.removeAt(index);
      if (wasDefault && _addresses.isNotEmpty) _addresses.first.isDefault = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 4),
              child: Row(
                children: [
                  _RoundIconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'My Address',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: kTextDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),

            // ── Address list ────────────────────────────────────
            Expanded(
              child: _addresses.isEmpty
                  ? _EmptyState(onAdd: _showComingSoon)
                  : ListView.separated(
                      padding: const EdgeInsets.all(18),
                      itemCount: _addresses.length,
                      separatorBuilder: (context, i) => const SizedBox(height: 14),
                      itemBuilder: (context, i) => _AddressTile(
                        address: _addresses[i],
                        onSetDefault: () => _setDefault(i),
                        onRemove: () => _removeAddress(i),
                      ),
                    ),
            ),

            // ── Add address button ───────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
              child: SizedBox(
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
                      onTap: _showComingSoon,
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_rounded, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Add New Address',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
    return Center(
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
              child: const Icon(Icons.location_on_outlined, size: 40, color: kTextDark),
            ),
            const SizedBox(height: 20),
            const Text(
              'No addresses saved yet',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: kTextDark),
            ),
            const SizedBox(height: 6),
            const Text(
              'Add an address to check out faster next time.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: kTextGrey),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Address tile — icon, label, address, phone, default badge, menu ─────
class _AddressTile extends StatelessWidget {
  final SavedAddress address;
  final VoidCallback onSetDefault;
  final VoidCallback onRemove;
  const _AddressTile({
    required this.address,
    required this.onSetDefault,
    required this.onRemove,
  });

  IconData get _icon {
    switch (address.label) {
      case 'Work':
        return Icons.work_outline_rounded;
      default:
        return Icons.home_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: kShadow,
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            child: Icon(_icon, color: Colors.white, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      address.label,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: kTextDark,
                      ),
                    ),
                    if (address.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: kGreen.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Default',
                          style: TextStyle(
                            color: kGreenDark,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  address.fullAddress,
                  style: const TextStyle(fontSize: 13, color: kTextGrey, height: 1.4),
                ),
                const SizedBox(height: 4),
                Text(
                  address.phone,
                  style: const TextStyle(fontSize: 12.5, color: kTextGrey),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: kTextGrey, size: 20),
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            onSelected: (value) {
              if (value == 'default') onSetDefault();
              if (value == 'remove') onRemove();
            },
            itemBuilder: (context) => [
              if (!address.isDefault)
                const PopupMenuItem(
                  value: 'default',
                  child: Text('Set as default'),
                ),
              const PopupMenuItem(
                value: 'remove',
                child: Text('Remove address'),
              ),
            ],
          ),
        ],
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