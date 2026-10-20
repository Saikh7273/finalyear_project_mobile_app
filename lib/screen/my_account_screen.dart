import 'package:flutter/material.dart';
import 'package:present_group2/menu/theme.dart';

// ── MY ACCOUNT SCREEN ─────────────────────────────────────────────────
// A read-only view of the account details. Each row shows a
// "Coming soon" message on tap for now — hook up real editing later by
// replacing _showComingSoon(context) with whatever edit flow you build.
class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon')),
    );
  }

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

              // ── Top bar ─────────────────────────────────────────
              Row(
                children: [
                  _RoundIconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'My Account',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: kTextDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // ── Avatar + name, centered ──────────────────────────
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      padding: const EdgeInsets.all(3.5),
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
                          'lib/image/pich.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: kPeach,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.person_rounded,
                              color: kTextDark,
                              size: 38,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Khon Pich',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: kTextDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    GestureDetector(
                      onTap: () => _showComingSoon(context),
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: kPeach,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit_rounded, size: 13, color: kTextDark),
                            SizedBox(width: 6),
                            Text(
                              'Edit profile picture',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: kTextDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),

              // ── Personal info ─────────────────────────────────────
              const _SectionLabel('Personal information'),
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
                    _InfoRow(
                      icon: Icons.badge_outlined,
                      label: 'Full name',
                      value: 'Khon Pich',
                      onTap: () => _showComingSoon(context),
                    ),
                    const _RowDivider(),
                    _InfoRow(
                      icon: Icons.mail_outline_rounded,
                      label: 'Email',
                      value: 'khon_pich@mail.com',
                      onTap: () => _showComingSoon(context),
                    ),
                    const _RowDivider(),
                    _InfoRow(
                      icon: Icons.phone_outlined,
                      label: 'Phone number',
                      value: '088 517 0070',
                      onTap: () => _showComingSoon(context),
                    ),
                    const _RowDivider(),
                    _InfoRow(
                      icon: Icons.cake_outlined,
                      label: 'Date of birth',
                      value: 'Not set',
                      onTap: () => _showComingSoon(context),
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // ── Account ────────────────────────────────────────────
              const _SectionLabel('Account'),
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
                    _InfoRow(
                      icon: Icons.lock_outline_rounded,
                      label: 'Password',
                      value: '••••••••',
                      onTap: () => _showComingSoon(context),
                    ),
                    const _RowDivider(),
                    _InfoRow(
                      icon: Icons.event_available_outlined,
                      label: 'Member since',
                      value: 'Jan 2022',
                      onTap: null,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
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

// ── Section label above each card group ──────────────────────────────
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

// ── Thin divider between info rows ──────────────────────────────────────
class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 62),
      child: Divider(height: 1, color: kBg, thickness: 1),
    );
  }
}

// ── Info row — icon, label + value, optional chevron if tappable ────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool isLast;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(fontSize: 11.5, color: kTextGrey),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kTextDark,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onTap != null)
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