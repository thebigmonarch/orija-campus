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

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// Phase 2 of the bags/chat rework: the missing "My Orders / My Bags" page
/// (see workspace plan — item 1, "Foundational"). Two role-based views:
///
///  - Buying: bags the current user has in progress (draft/sent/
///    vendor_confirmed, not yet an order) plus their full order history.
///  - Selling: only shown when the current user owns a storefront — bags
///    sent to them for review, plus orders placed against their storefront.
///
/// Data source is a direct client-side query against `v_bag_items` (grouped
/// by bag_id, using its own window-aggregate columns rather than re-summing)
/// and `v_order_full`, both scoped correctly by the RLS on their underlying
/// tables now that both views run with `security_invoker` — no bags/orders-
/// shaped API existed prior to this (`GetmythreadsCall` only returns thread
/// previews), so this is a new query rather than a wrapped existing call.
class OrijaMyOrders extends StatefulWidget {
  const OrijaMyOrders({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaMyOrders> createState() => _OrijaMyOrdersState();
}

class _OrijaMyOrdersState extends State<OrijaMyOrders> {
  bool _isLoading = true;
  String? _myStorefrontId;
  int _tab = 0; // 0 = Buying, 1 = Selling (Selling only exists for vendors)

  List<VBagItemsRow> _buyerBags = [];
  List<VOrderFullRow> _buyerOrders = [];
  List<VBagItemsRow> _vendorBags = [];
  List<VOrderFullRow> _vendorOrders = [];

  // Desktop Shell rollout, Phase 5 (Pattern C). Selected order shown in
  // the right-hand detail pane on desktop; always null on mobile.
  // pending_payment orders still push to checkout on desktop too -- that's
  // a focused task (Pattern D), not a detail view.
  String? _selectedOrderId;

  bool get _isVendor => _myStorefrontId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    final storefronts = await StorefrontsTable().queryRows(
      queryFn: (q) => q.eqOrNull('owner_id', currentUserUid).limit(1),
    );
    final storefrontId = storefronts.isNotEmpty ? storefronts.first.id : null;

    final buyerBags = await VBagItemsTable().queryRows(
      queryFn: (q) => q
          .eqOrNull('buyer_id', currentUserUid)
          .inFilter('bag_status', ['draft', 'sent', 'vendor_confirmed']).order(
              'created_at',
              ascending: false),
    );
    final buyerOrders = await VOrderFullTable().queryRows(
      queryFn: (q) => q
          .eqOrNull('buyer_id', currentUserUid)
          .order('created_at', ascending: false),
    );

    List<VBagItemsRow> vendorBags = [];
    List<VOrderFullRow> vendorOrders = [];
    if (storefrontId != null) {
      vendorBags = await VBagItemsTable().queryRows(
        queryFn: (q) => q
            .eqOrNull('storefront_id', storefrontId)
            .order('created_at', ascending: false),
      );
      vendorOrders = await VOrderFullTable().queryRows(
        queryFn: (q) => q
            .eqOrNull('vendor_id', currentUserUid)
            .order('created_at', ascending: false),
      );
    }

    if (!mounted) return;
    setState(() {
      _myStorefrontId = storefrontId;
      _buyerBags = buyerBags;
      _buyerOrders = buyerOrders;
      _vendorBags = vendorBags;
      _vendorOrders = vendorOrders;
      _isLoading = false;
    });
  }

  /// `v_bag_items` returns one row per item; group down to one row per bag
  /// (keeping the first item's row, whose window-aggregate columns —
  /// bag_subtotal / bag_total_items / etc. — already describe the bag as a
  /// whole) for a bag-summary card.
  List<VBagItemsRow> _oneRowPerBag(List<VBagItemsRow> rows) {
    final seen = <String>{};
    final out = <VBagItemsRow>[];
    for (final row in rows) {
      final id = row.bagId;
      if (id == null || !seen.add(id)) continue;
      out.add(row);
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 5 (Pattern C browse/detail split).
    // Mobile body below is untouched; this gate is unreachable on a real
    // phone.
    if (OrijaDesktopShell.isDesktop(context)) {
      final theme = FlutterFlowTheme.of(context);
      return OrijaDesktopShell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: 380, child: _mobileBody(context)),
            VerticalDivider(width: 1, color: theme.alternate),
            Expanded(
              child: _selectedOrderId == null
                  ? Center(
                      child: Text(
                        'Select an order to see details',
                        style: theme.bodyMedium.override(
                          color: theme.secondaryText,
                        ),
                      ),
                    )
                  : OrijaOrderDetails(orderId: _selectedOrderId),
            ),
          ],
        ),
      );
    }
    return _mobileBody(context);
  }

  Widget _mobileBody(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final showingVendorTab = _tab == 1 && _isVendor;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('My Orders',
            style: TextStyle(
                color: theme.primaryText, fontWeight: FontWeight.w600)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: theme.primary))
          : Column(
              children: [
                if (_isVendor) _roleTabs(theme),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _load,
                    color: theme.primary,
                    child: showingVendorTab
                        ? _sellingView(theme)
                        : _buyingView(theme),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _roleTabs(FlutterFlowTheme theme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.alternate),
      ),
      child: Row(
        children: [
          _roleTab(theme, label: 'Buying', index: 0),
          _roleTab(theme, label: 'Selling', index: 1),
        ],
      ),
    );
  }

  Widget _roleTab(FlutterFlowTheme theme,
      {required String label, required int index}) {
    final selected = _tab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? theme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : theme.secondaryText,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buyingView(FlutterFlowTheme theme) {
    final bags = _oneRowPerBag(_buyerBags);
    if (bags.isEmpty && _buyerOrders.isEmpty) {
      return _emptyState(
        theme,
        icon: Icons.shopping_bag_outlined,
        title: 'Nothing here yet',
        subtitle:
            'Bags you send to vendors and orders you place will show up here.',
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (bags.isNotEmpty) ...[
          _sectionHeader(theme, 'Active Bags'),
          ...bags.map((row) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _bagCard(row, theme, isVendorView: false),
              )),
          const SizedBox(height: 12),
        ],
        if (_buyerOrders.isNotEmpty) ...[
          _sectionHeader(theme, 'Orders'),
          ..._buyerOrders.map((row) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _orderCard(row, theme),
              )),
        ],
      ],
    );
  }

  Widget _sellingView(FlutterFlowTheme theme) {
    final bags = _oneRowPerBag(_vendorBags);
    if (bags.isEmpty && _vendorOrders.isEmpty) {
      return _emptyState(
        theme,
        icon: Icons.storefront_outlined,
        title: 'Nothing to review yet',
        subtitle:
            'Bags buyers send you and orders against your storefront will show up here.',
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (bags.isNotEmpty) ...[
          _sectionHeader(theme, 'Bags to Review'),
          ...bags.map((row) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _bagCard(row, theme, isVendorView: true),
              )),
          const SizedBox(height: 12),
        ],
        if (_vendorOrders.isNotEmpty) ...[
          _sectionHeader(theme, 'Orders'),
          ..._vendorOrders.map((row) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _orderCard(row, theme),
              )),
        ],
      ],
    );
  }

  Widget _sectionHeader(FlutterFlowTheme theme, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: TextStyle(
            color: theme.secondaryText,
            fontWeight: FontWeight.w700,
            fontSize: 13),
      ),
    );
  }

  Widget _emptyState(FlutterFlowTheme theme,
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return ListView(
      // ListView (not Center) so RefreshIndicator's pull-to-refresh still works
      // on an otherwise-empty screen.
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 80),
          child: Column(
            children: [
              Icon(icon, size: 56, color: theme.secondaryText),
              const SizedBox(height: 12),
              Text(title,
                  style: TextStyle(
                      color: theme.primaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 16)),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.secondaryText, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ({String label, Color color}) _bagStatusMeta(
      FlutterFlowTheme theme, String? status) {
    switch (status) {
      case 'draft':
        return (label: 'Draft — not sent', color: theme.secondaryText);
      case 'sent':
        return (label: 'Awaiting vendor', color: theme.secondary);
      case 'vendor_confirmed':
        return (label: 'Reviewed — ready to order', color: theme.primary);
      default:
        return (label: status ?? '', color: theme.secondaryText);
    }
  }

  Widget _bagCard(VBagItemsRow row, FlutterFlowTheme theme,
      {required bool isVendorView}) {
    final statusMeta = _bagStatusMeta(theme, row.bagStatus);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.pushNamed(
        isVendorView ? 'OrijaVendorBagPage' : 'OrijaBuyerBagPage',
        queryParameters:
            {'bagId': serializeParam(row.bagId, ParamType.String)}.withoutNulls,
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.alternate),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: (row.listingImage ?? '').isNotEmpty
                  ? Image.network(row.listingImage!,
                      width: 52, height: 52, fit: BoxFit.cover)
                  : Container(
                      width: 52,
                      height: 52,
                      color: theme.alternate,
                      child: Icon(Icons.shopping_bag_outlined,
                          color: theme.secondaryText),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isVendorView
                        ? (row.storefrontName ?? 'Bag')
                        : '${row.bagTotalItems ?? 0} item${(row.bagTotalItems ?? 0) == 1 ? '' : 's'}',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    statusMeta.label,
                    style: TextStyle(
                        color: statusMeta.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Text(
              '₦${(row.bagSubtotal ?? 0).toStringAsFixed(2)}',
              style: TextStyle(
                  color: theme.primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: theme.secondaryText, size: 20),
          ],
        ),
      ),
    );
  }

  void _openOrder(VOrderFullRow row) {
    if (row.orderStatus == 'pending_payment') {
      context.pushNamed(
        OrijaCheckoutPageWidget.routeName,
        queryParameters: {
          'orderId': serializeParam(row.orderId, ParamType.String),
        }.withoutNulls,
      );
      return;
    }
    // Desktop Shell rollout, Phase 5: desktop selects into the split pane
    // instead of pushing a route; mobile is unchanged below.
    if (OrijaDesktopShell.isDesktop(context)) {
      setState(() => _selectedOrderId = row.orderId);
      return;
    }
    context.pushNamed(
      OrderDetailsPageWidget.routeName,
      queryParameters: {
        'orderId': serializeParam(row.orderId, ParamType.String)
      }.withoutNulls,
    );
  }

  Widget _orderCard(VOrderFullRow row, FlutterFlowTheme theme) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _openOrder(row),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.alternate),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: (row.firstItemImage ?? '').isNotEmpty
                  ? Image.network(row.firstItemImage!,
                      width: 52, height: 52, fit: BoxFit.cover)
                  : Container(
                      width: 52,
                      height: 52,
                      color: theme.alternate,
                      child: Icon(Icons.receipt_long_outlined,
                          color: theme.secondaryText),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row.orderRef ?? 'Order',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    row.statusLabel ?? (row.orderStatus ?? ''),
                    style: TextStyle(
                        color: theme.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Text(
              '₦${(row.total ?? 0).toStringAsFixed(2)}',
              style: TextStyle(
                  color: theme.primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: theme.secondaryText, size: 20),
          ],
        ),
      ),
    );
  }
}
