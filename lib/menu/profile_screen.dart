import 'package:flutter/material.dart';
import 'package:present_group2/menu/theme.dart';
import 'package:present_group2/menu/bottom_nav.dart';
import 'package:present_group2/menu/research_screen.dart'; 
import 'package:present_group2/screen/main_screen.dart';
import 'package:present_group2/menu/older_sceen.dart';
import 'package:present_group2/screen/order_history_screen.dart';
import 'package:present_group2/screen/my_account_screen.dart';
import 'package:present_group2/screen/payment_methods_screen.dart';
import 'package:present_group2/screen/address_screen.dart';
// 👉 Adjust this import/class name if your login screen file or class
// is named differently — this assumes login_scren.dart defines
// `class LoginScreen`.
import 'package:present_group2/screen/login_scren.dart';

// ── PROFILE SCREEN ───────────────────────────────────────────────────
// Shows a quick placeholder message for menu items that don't have a
// screen built yet.
void _showComingSoon(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Coming soon')),
  );
}

// A gentle fade + scale transition instead of the default slide-in —
// feels calmer for a "leaving the app" moment than a normal push.
Route<void> _logoutRoute() {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 450),
    pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.96, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

// Shows a confirmation dialog. Confirming swaps the dialog into a brief
// "Logging out..." loading state, then clears the whole navigation
// stack and animates into the login screen.
void _confirmLogout(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => const _LogoutDialog(),
  );
}

class _LogoutDialog extends StatefulWidget {
  const _LogoutDialog();

  @override
  State<_LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<_LogoutDialog> {
  bool _loggingOut = false;

  Future<void> _handleConfirm() async {
    setState(() => _loggingOut = true);
    // Brief pause so the loading state is actually visible — swap for a
    // real sign-out call (clearing tokens/session, etc.) when you have one.
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    final navigator = Navigator.of(context, rootNavigator: true);
    navigator.pop(); // close the dialog
    navigator.pushAndRemoveUntil(_logoutRoute(), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _loggingOut
                  ? const SizedBox(
                      key: ValueKey('spinner'),
                      width: 64,
                      height: 64,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(
                          color: kBadgePink,
                          strokeWidth: 3,
                        ),
                      ),
                    )
                  : Container(
                      key: const ValueKey('icon'),
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [kBadgePink, kBadgePink.withValues(alpha: 0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: kBadgePink.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
            ),
            const SizedBox(height: 18),
            Text(
              _loggingOut ? 'Logging out...' : 'Log out?',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: kTextDark,
              ),
            ),
            if (!_loggingOut) ...[
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to log out of your account?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: kTextGrey, height: 1.4),
              ),
            ],
            const SizedBox(height: 22),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _loggingOut
                  ? const SizedBox(key: ValueKey('empty'), height: 0)
                  : Row(
                      key: const ValueKey('buttons'),
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: kTextDark,
                              side: const BorderSide(color: kTextGrey),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleConfirm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kBadgePink,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Log out',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _navIndex = 3; // Profile tab active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),

              // ── Top bar — title + subtitle, shadowed round icon
              // buttons instead of bare IconButtons (matches Home) ───
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: kTextDark,
                          letterSpacing: -0.4,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Manage your account',
                        style: TextStyle(fontSize: 12.5, color: kTextGrey),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _RoundIconButton(
                        icon: Icons.mail_outline_rounded,
                        onTap: () {},
                      ),
                      const SizedBox(width: 10),
                      _RoundIconButton(
                        icon: Icons.notifications_none_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Profile header card — gradient ring avatar, name,
              // email, edit shortcut ─────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: kShadow,
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [kGreen, kGreenDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          // Using your actual file: lib/image/pich.jpg
                          'lib/image/pich.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: kPeach,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.person_rounded,
                              color: kTextDark,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Khon Pich',
                            style: TextStyle(
                              fontSize: 17.5,
                              fontWeight: FontWeight.w800,
                              color: kTextDark,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'khon_pich@mail.com',
                            style: TextStyle(fontSize: 12.5, color: kTextGrey),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showComingSoon(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: kPeach,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          size: 16,
                          color: kTextDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ── Stats row ───────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      icon: Icons.shopping_bag_rounded,
                      label: 'My Orders',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.local_offer_rounded,
                      label: 'Promo code',
                      onTap: () => _showComingSoon(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.people_alt_rounded,
                      label: 'Following',
                      onTap: () => _showComingSoon(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),

              // ── General Setting ─────────────────────────────────
              const _SectionLabel('General Setting'),
              const SizedBox(height: 10),
              Container(
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
                child: Column(
                  children: [
                    _MenuTile(
                      icon: Icons.person_outline_rounded,
                      label: 'My account',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyAccountScreen()),
                      ),
                    ),
                    _MenuDivider(),
                    _MenuTile(
                      icon: Icons.credit_card_rounded,
                      label: 'Payment methods',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()),
                      ),
                    ),
                    _MenuDivider(),
                    _MenuTile(
                      icon: Icons.location_on_outlined,
                      label: 'My Address',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddressScreen()),
                      ),
                    ),
                    _MenuDivider(),
                    _MenuTile(
                      icon: Icons.notifications_none_rounded,
                      label: 'Notifications',
                      onTap: () => _showComingSoon(context),
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ── Other ────────────────────────────────────────────
              const _SectionLabel('Other'),
              const SizedBox(height: 10),
              Container(
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
                child: Column(
                  children: [
                    _MenuTile(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: 'Contact preferences',
                      onTap: () => _showComingSoon(context),
                    ),
                    _MenuDivider(),
                    _MenuTile(
                      icon: Icons.description_outlined,
                      label: 'Terms & Conditions',
                      onTap: () => _showComingSoon(context),
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // ── Log out ──────────────────────────────────────────
              // Its own card with a gradient icon circle + shadow
              // (matching the style used on the stat tiles above),
              // instead of the flat tinted circle everywhere else —
              // makes it read as a distinct, deliberate action.
              Container(
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _confirmLogout(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [kBadgePink, kBadgePink.withValues(alpha: 0.75)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: kBadgePink.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.logout_rounded,
                                size: 17,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Log out',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: kBadgePink,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
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
              } else if (i == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const OlderScreen()),
                );
              }
              // i == 3 (Profile) — already here, nothing to do.
            },
          );
        },
      ),
    );
  }
}

// ── Small round icon button (mail / notifications) ─────────────────────
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

// ── Section label used above each card group ────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15.5,
        fontWeight: FontWeight.w800,
        color: kTextDark,
        letterSpacing: -0.2,
      ),
    );
  }
}

// ── Thin divider between menu rows inside a card ────────────────────────
class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 62),
      child: Divider(height: 1, color: kBg, thickness: 1),
    );
  }
}

// ── Stat tile (My Orders / Promo code / Following) ───────────────────
class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _StatTile({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
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
              child: Icon(icon, color: Colors.white, size: 19),
            ),
            const SizedBox(height: 9),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: kTextDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Menu row (used in General Setting / Other sections) ──────────────
class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isLast;
  const _MenuTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        bottom: isLast ? const Radius.circular(18) : Radius.zero,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: kPeach,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 17, color: kTextDark),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kTextDark,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: kTextGrey,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}