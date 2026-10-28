import 'package:flutter/material.dart';

import '../../../../core/theme/app_metrics.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// A compact, labeled metric with a stable numeric baseline.
class TripStatCard extends StatelessWidget {
  const TripStatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    super.key,
  });

  final String label;
  final String value;
  final String unit;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: theme.colorScheme.onSurfaceVariant,
              size: AppMetrics.smallIconSize,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              label,
              style: AppTypography.eyebrow.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.xs,
              children: [
                Text(value, style: theme.textTheme.headlineMedium),
                if (unit.isNotEmpty)
                  Text(
                    unit,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
