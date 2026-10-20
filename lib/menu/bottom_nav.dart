import 'package:flutter/material.dart';
import 'package:present_group2/menu/theme.dart';

// ── Shared bottom nav ────────────────────────────────────────────────
// Used by MainScreen, OlderScreen, SearchScreen, and ProfileScreen — put
// this at lib/menu/bottom_nav.dart and import it from all four instead
// of each screen declaring its own bottom bar. Any future style change
// then only needs to happen here, once, and every screen stays in sync.
//
// currentIndex: which tab is active (0 Home, 1 Search, 2 Bag, 3 Profile)
// onTap: called with the tapped index — each screen keeps its own
//   navigation logic (Home might clear the stack, Bag might push vs
//   replace, etc.), this widget only renders and reports taps.
// bagCount: shown as a small pink number badge on the Bag icon when > 0.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int bagCount;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.bagCount = 0,
  });

  static const _icons = [
    Icons.home_rounded,
    Icons.search_rounded,
    Icons.shopping_bag_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [
          BoxShadow(
            color: kShadow,
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_icons.length, (i) {
              final selected = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: selected ? 20 : 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: selected
                        ? const LinearGradient(
                            colors: [kGreen, kGreenDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: kGreen.withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : null,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        _icons[i],
                        color: selected ? Colors.white : kTextGrey,
                        size: 22,
                      ),
                      if (i == 2 && bagCount > 0)
                        Positioned(
                          right: -7,
                          top: -7,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            decoration: BoxDecoration(
                              color: kBadgePink,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                            child: Text(
                              '$bagCount',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}