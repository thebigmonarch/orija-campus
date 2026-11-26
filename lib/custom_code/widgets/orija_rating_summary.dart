// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/material.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Replaces storefront_page's plain "Rating" header stat tile. Adds a
/// dropdown chevron that expands the four-dimension breakdown -- data
/// that already exists on storefronts_with_review_summary
/// (avg_product_accuracy / avg_communication / avg_packaging /
/// avg_value_for_money), so this is a display concern only, no migration.
/// Self-contained: resolves its own row by slug rather than depending on
/// page state the rest of storefront_page doesn't expose.
class OrijaRatingSummary extends StatefulWidget {
  const OrijaRatingSummary({
    super.key,
    this.width,
    this.height,
    required this.storefrontSlug,
  });

  final double? width;
  final double? height;
  final String? storefrontSlug;

  @override
  State<OrijaRatingSummary> createState() => _OrijaRatingSummaryState();
}

class _OrijaRatingSummaryState extends State<OrijaRatingSummary> {
  bool _expanded = false;
  Map<String, dynamic>? _row;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final slug = widget.storefrontSlug ?? '';
    if (slug.isEmpty) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final row = await Supabase.instance.client
          .from('storefronts_with_review_summary')
          .select(
              'avg_rating, total_reviews, avg_product_accuracy, avg_communication, avg_packaging, avg_value_for_money, storefront_type')
          .eq('slug', slug)
          .maybeSingle();
      if (!mounted) return;
      setState(() {
        _row = row;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _dimensionRow(String label, double? value, FlutterFlowTheme theme) {
    final v = value ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: TextStyle(color: theme.secondaryText, fontSize: 12.5)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (v / 5).clamp(0, 1),
                minHeight: 6,
                backgroundColor: theme.alternate,
                valueColor: AlwaysStoppedAnimation(theme.secondary),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 28,
            child: Text(v.toStringAsFixed(1),
                textAlign: TextAlign.right,
                style: TextStyle(color: theme.primaryText, fontSize: 12.5)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final avg = (_row?['avg_rating'] as num?)?.toDouble();
    final total = (_row?['total_reviews'] as num?)?.toInt() ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Rating',
            style: TextStyle(color: theme.secondaryText, fontSize: 12)),
        const SizedBox(height: 2),
        InkWell(
          onTap: _loading || total == 0
              ? null
              : () => setState(() => _expanded = !_expanded),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, size: 16, color: theme.secondary),
              const SizedBox(width: 3),
              Text(
                avg == null ? '—' : avg.toStringAsFixed(1),
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              if (total > 0) ...[
                const SizedBox(width: 2),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: theme.secondaryText,
                ),
              ],
            ],
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: 10),
          Container(
            width: 240,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.alternate),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Rating breakdown',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                _dimensionRow(
                    _row?['storefront_type'] == 'agent'
                        ? 'Room matched listing'
                        : 'Product Accuracy',
                    (_row?['avg_product_accuracy'] as num?)?.toDouble(),
                    theme),
                _dimensionRow('Communication',
                    (_row?['avg_communication'] as num?)?.toDouble(), theme),
                _dimensionRow(
                    _row?['storefront_type'] == 'agent'
                        ? 'On time'
                        : 'Packaging',
                    (_row?['avg_packaging'] as num?)?.toDouble(),
                    theme),
                _dimensionRow('Value for Money',
                    (_row?['avg_value_for_money'] as num?)?.toDouble(), theme),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
