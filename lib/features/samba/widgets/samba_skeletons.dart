import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/core/widgets/skeleton_loading.dart';

// ─────────────────────────────────────────────────────
//  Beranda / Home Dashboard Skeleton
// ─────────────────────────────────────────────────────

/// Skeleton for the Samba Beranda (dashboard) tab.
/// Mimics: title row, 4 stat cards (2x2), and a "Transaksi Terakhir" card.
class BerandaSkeleton extends StatelessWidget {
  const BerandaSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title row skeleton ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonLine(width: 80, height: 12),
                    SizedBox(height: 8),
                    SkeletonLine(width: 180, height: 22),
                  ],
                ),
                const SkeletonBox(width: 130, height: 40, borderRadius: 10),
              ],
            ),
            const SizedBox(height: 20),

            // ── Stat cards row 1 ──
            Row(
              children: const [
                Expanded(child: _StatCardSkeleton()),
                SizedBox(width: 16),
                Expanded(child: _StatCardSkeleton()),
              ],
            ),
            const SizedBox(height: 16),

            // ── Stat cards row 2 ──
            Row(
              children: const [
                Expanded(child: _StatCardSkeleton()),
                SizedBox(width: 16),
                Expanded(child: _StatCardSkeleton()),
              ],
            ),
            const SizedBox(height: 24),

            // ── Latest transaction card skeleton ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonLine(width: 160, height: 18),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const SkeletonBox(
                        width: 56,
                        height: 56,
                        borderRadius: 16,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SkeletonLine(height: 16),
                            SizedBox(height: 8),
                            SkeletonLine(width: 140, height: 14),
                            SizedBox(height: 8),
                            SkeletonLine(width: 100, height: 12),
                          ],
                        ),
                      ),
                    ],
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

class _StatCardSkeleton extends StatelessWidget {
  const _StatCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const SkeletonBox(width: 48, height: 48, borderRadius: 14),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonLine(width: 60, height: 13),
                SizedBox(height: 10),
                SkeletonLine(width: 40, height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  Rekening List Skeleton
// ─────────────────────────────────────────────────────

/// Skeleton for the list inside the Rekening tab.
/// Mimics: search bar area + list of rekening items.
class RekeningListSkeleton extends StatelessWidget {
  final int itemCount;

  const RekeningListSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Column(
        children: List.generate(itemCount, (index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Row(
                  children: [
                    const SkeletonBox(width: 48, height: 48, borderRadius: 8),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SkeletonLine(height: 14),
                          SizedBox(height: 8),
                          SkeletonLine(width: 120, height: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (index < itemCount - 1)
                const Divider(
                  color: AppTheme.inputBorder,
                  height: 1,
                  thickness: 1,
                ),
            ],
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  Transaksi List Skeleton
// ─────────────────────────────────────────────────────

/// Skeleton for the list inside the Transaksi tab.
/// Mimics: search bar area + list of transaction items.
class TransaksiListSkeleton extends StatelessWidget {
  final int itemCount;

  const TransaksiListSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Column(
        children: List.generate(itemCount, (index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Row(
                  children: [
                    const SkeletonBox(width: 48, height: 48, borderRadius: 8),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SkeletonLine(height: 14),
                          const SizedBox(height: 6),
                          const SkeletonLine(width: 160, height: 14),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              SkeletonLine(width: 80, height: 11),
                              SkeletonBox(
                                width: 90,
                                height: 24,
                                borderRadius: 6,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (index < itemCount - 1)
                const Divider(
                  color: AppTheme.inputBorder,
                  height: 1,
                  thickness: 1,
                ),
            ],
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  Profile Form Skeleton
// ─────────────────────────────────────────────────────

/// Skeleton for the Samba profile form screen.
/// Mimics: avatar circle, title, subtitle, form card with fields.
class ProfileFormSkeleton extends StatelessWidget {
  const ProfileFormSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title row ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonLine(width: 40, height: 12),
                    SizedBox(height: 8),
                    SkeletonLine(width: 80, height: 22),
                  ],
                ),
                const SkeletonBox(width: 40, height: 40, borderRadius: 10),
              ],
            ),
            const SizedBox(height: 32),

            // ── Avatar circle ──
            const Center(child: SkeletonCircle(size: 100)),
            const SizedBox(height: 32),

            // ── Section title ──
            const SkeletonLine(width: 150, height: 18),
            const SizedBox(height: 8),
            const SkeletonLine(width: 280, height: 14),
            const SizedBox(height: 20),

            // ── Form card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row of 2 fields
                  Row(
                    children: [
                      Expanded(child: _buildFieldSkeleton()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildFieldSkeleton()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Full-width field
                  _buildFieldSkeleton(),
                  const SizedBox(height: 20),
                  // Full-width field
                  _buildFieldSkeleton(),
                  const SizedBox(height: 20),
                  // Row of 2 fields
                  Row(
                    children: [
                      Expanded(child: _buildFieldSkeleton()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildFieldSkeleton()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Full-width field
                  _buildFieldSkeleton(),
                  const SizedBox(height: 24),
                  // Button skeleton
                  const SkeletonBox(width: 120, height: 46, borderRadius: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildFieldSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SkeletonLine(width: 100, height: 13),
        SizedBox(height: 8),
        SkeletonBox(width: double.infinity, height: 44, borderRadius: 8),
      ],
    );
  }
}
