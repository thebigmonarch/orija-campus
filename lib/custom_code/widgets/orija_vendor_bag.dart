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

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/material.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Hand-authored, fully self-contained replacement for the generated
/// `vendorBag` screen. The main redesign: the old always-visible
/// availability-switch + free-text "Final Price" field + separate "Change"
/// button (deferred save, per item) is replaced with three explicit
/// actions — Accept / Decline / Counter — each of which saves immediately
/// via the existing `VendorconfirmitemCall` (no new backend needed, just a
/// clearer interaction shape). Because each decision now saves the instant
/// it's made, the old risk of tapping "Approve availability" while an
/// item-level edit sat unsaved no longer exists.
///
/// Same running-total (from `v_bag_items`'s own computed fields), real
/// empty state, and functional "Close Bag" (a direct `bags` table update —
/// see the doc comment on `OrijaBuyerBag`, the sibling widget, for exactly
/// what that does and doesn't guarantee; no dedicated cancel RPC exists in
/// this project).
class OrijaVendorBag extends StatefulWidget {
  const OrijaVendorBag(
      {super.key, this.width, this.height, required this.bagId});

  final double? width;
  final double? height;

  final String? bagId;

  @override
  State<OrijaVendorBag> createState() => _OrijaVendorBagState();
}

class _OrijaVendorBagState extends State<OrijaVendorBag> {
  List<VBagItemsRow> _items = [];
  bool _isLoading = true;
  bool _isApproving = false;
  bool _isClosing = false;

  // itemId currently showing its inline Decline-reason or Counter-price
  // field, at most one at a time to keep the list from turning into a wall
  // of open text fields.
  String? _expandedItemId;
  String? _expandedMode; // 'decline' | 'counter'
  final _inlineController = TextEditingController();
  bool _isSavingItem = false;

  String get _bid => widget.bagId ?? '';
  bool get _hasBag => _bid.isNotEmpty;

  VBagItemsRow? get _first => _items.isNotEmpty ? _items.first : null;
  double get _subtotal => _first?.bagSubtotal ?? 0;
  int get _totalItems => _first?.bagTotalItems ?? _items.length;
  int get _availableItems => _first?.bagAvailableItems ?? 0;
  int get _unavailableItems => _first?.bagUnavailableItems ?? 0;

  @override
  void initState() {
    super.initState();
    if (_hasBag) _loadItems();
  }

  @override
  void dispose() {
    _inlineController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    final rows = await VBagItemsTable().queryRows(
      queryFn: (q) => q.eqOrNull('bag_id', _bid).order('created_at'),
    );
    if (!mounted) return;
    setState(() {
      _items = rows;
      _isLoading = false;
    });
  }

  void _openInline(String itemId, String mode, {String initial = ''}) {
    setState(() {
      _expandedItemId = itemId;
      _expandedMode = mode;
      _inlineController.text = initial;
    });
  }

  void _closeInline() {
    setState(() {
      _expandedItemId = null;
      _expandedMode = null;
      _inlineController.clear();
    });
  }

  Future<void> _accept(VBagItemsRow row) => _confirmItem(
        row,
        isAvailable: true,
        price: row.buyerOfferPrice ?? row.unitPrice,
        note: null,
      );

  Future<void> _confirmDecline(VBagItemsRow row) => _confirmItem(
        row,
        isAvailable: false,
        price: null,
        note: _inlineController.text.trim().isEmpty
            ? null
            : _inlineController.text.trim(),
      );

  Future<void> _confirmCounter(VBagItemsRow row) {
    final parsed = double.tryParse(_inlineController.text.trim());
    if (parsed == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid price.')),
      );
      return Future.value();
    }
    return _confirmItem(row, isAvailable: true, price: parsed, note: null);
  }

  Future<void> _confirmItem(
    VBagItemsRow row, {
    required bool isAvailable,
    required double? price,
    required String? note,
  }) async {
    setState(() => _isSavingItem = true);
    try {
      await VendorconfirmitemCall.call(
        itemID: row.itemId,
        isAvailable: isAvailable,
        vConfrimedPrice: price,
        vendorId: currentUserUid,
        vendorNote: note ?? '',
      );
      _closeInline();
      await _loadItems();
    } finally {
      if (mounted) setState(() => _isSavingItem = false);
    }
  }

  Future<void> _approveBag() async {
    setState(() => _isApproving = true);
    try {
      final result = await VendorconfirmbagCall.call(
          bagId: _bid, vendorId: currentUserUid);
      final ok = VendorconfirmbagCall.success(result.jsonBody ?? '') ?? false;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok
              ? 'Bag approved.'
              : 'Failed. Please try again in a few minutes.'),
          backgroundColor: ok
              ? FlutterFlowTheme.of(context).secondary
              : FlutterFlowTheme.of(context).error,
        ),
      );
      if (ok) Navigator.of(context).maybePop();
    } finally {
      if (mounted) setState(() => _isApproving = false);
    }
  }

  Future<void> _confirmCloseBag() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Close this bag?'),
        content: const Text(
            'This marks the bag as cancelled and ends the negotiation.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Keep bag')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Close bag',
                style: TextStyle(color: FlutterFlowTheme.of(context).error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _isClosing = true);
    try {
      // A raw client-side table write here always silently affected zero
      // rows -- vendors have no RLS UPDATE grant on bags, only read -- so
      // this showed "Bag closed." regardless of whether anything actually
      // changed. vendor_cancel_bag does the real authorized update server
      // side and tells us honestly whether it worked.
      final result = await Supabase.instance.client.rpc('vendor_cancel_bag',
          params: {'p_vendor_id': currentUserUid, 'p_bag_id': _bid});
      final ok = result is Map && result['success'] == true;
      if (!mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Bag closed.')));
        Navigator.of(context).maybePop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                (result is Map ? result['message'] : null)?.toString() ??
                    "Couldn't close the bag."),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Couldn't close the bag — you may not have permission to do this directly.",
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isClosing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    if (!_hasBag) {
      return Scaffold(
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: theme.secondaryBackground,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: Center(
            child: Text('No bag selected.',
                style: TextStyle(color: theme.secondaryText))),
      );
    }

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Review Bag',
            style: TextStyle(
                color: theme.primaryText, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            tooltip: 'Close bag',
            icon: Icon(Icons.close_rounded, color: theme.error),
            onPressed: _isClosing ? null : _confirmCloseBag,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: theme.primary))
          : _items.isEmpty
              ? _emptyState(theme)
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          ..._items.map((row) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _itemCard(row, theme),
                              )),
                          _summaryCard(theme),
                        ],
                      ),
                    ),
                    _actionBar(theme),
                  ],
                ),
    );
  }

  Widget _emptyState(FlutterFlowTheme theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_bag_outlined,
              size: 56, color: theme.secondaryText),
          const SizedBox(height: 12),
          Text('No items in this bag',
              style: TextStyle(
                  color: theme.primaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
        ],
      ),
    );
  }

  Widget _itemCard(VBagItemsRow row, FlutterFlowTheme theme) {
    final itemId = row.itemId ?? '';
    final isProposal = row.offerStatus == 'proposed';
    final decided = row.vendorReviewedAt != null;
    final accepted = decided && row.isAvailable == true;
    final declined = decided && row.isAvailable == false;
    final isExpanded = _expandedItemId == itemId;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: declined
              ? theme.error.withValues(alpha: 0.5)
              : accepted
                  ? theme.secondary.withValues(alpha: 0.5)
                  : theme.alternate,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child:
                    (row.listingImage != null && row.listingImage!.isNotEmpty)
                        ? Image.network(row.listingImage!,
                            width: 72, height: 72, fit: BoxFit.cover)
                        : Container(
                            width: 72,
                            height: 72,
                            color: theme.alternate,
                            child: Icon(Icons.image_outlined,
                                color: theme.secondaryText),
                          ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row.listingTitle ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: theme.primaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Qty ${row.quantity ?? 1} · ${isProposal ? 'Buyer proposed' : 'Listed at'} ₦${(row.buyerOfferPrice ?? row.unitPrice ?? 0).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: isProposal ? theme.primary : theme.secondaryText,
                        fontSize: 12.5,
                        fontWeight:
                            isProposal ? FontWeight.w700 : FontWeight.normal,
                      ),
                    ),
                    if (isProposal && !decided)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('Price proposal',
                              style: TextStyle(
                                  color: theme.primary,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    if ((row.buyerItemNote?.isNotEmpty ?? false))
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '"${row.buyerItemNote}"',
                          style: TextStyle(
                              color: theme.secondaryText,
                              fontSize: 11.5,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (!decided || isExpanded) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.secondary,
                      side: BorderSide(color: theme.secondary),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: _isSavingItem ? null : () => _accept(row),
                    child: const Text('Accept'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.error,
                      side: BorderSide(color: theme.error),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: _isSavingItem
                        ? null
                        : () => isExpanded && _expandedMode == 'decline'
                            ? _closeInline()
                            : _openInline(itemId, 'decline'),
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.primary,
                      side: BorderSide(color: theme.primary),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: _isSavingItem
                        ? null
                        : () => isExpanded && _expandedMode == 'counter'
                            ? _closeInline()
                            : _openInline(
                                itemId,
                                'counter',
                                initial:
                                    (row.buyerOfferPrice ?? row.unitPrice ?? 0)
                                        .toStringAsFixed(2),
                              ),
                    child: const Text('Counter'),
                  ),
                ),
              ],
            ),
          ],
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inlineController,
                      autofocus: true,
                      keyboardType: _expandedMode == 'counter'
                          ? const TextInputType.numberWithOptions(decimal: true)
                          : TextInputType.text,
                      style: TextStyle(color: theme.primaryText, fontSize: 13),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: _expandedMode == 'counter'
                            ? 'New price'
                            : 'Reason (optional)',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.check_circle, color: theme.secondary),
                    onPressed: _isSavingItem
                        ? null
                        : () => _expandedMode == 'counter'
                            ? _confirmCounter(row)
                            : _confirmDecline(row),
                  ),
                ],
              ),
            ),
          if (decided && !isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(
                    accepted
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    size: 16,
                    color: accepted ? theme.secondary : theme.error,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    accepted
                        ? (row.vendorConfirmedPrice != row.buyerOfferPrice
                            ? 'Countered at ₦${(row.vendorConfirmedPrice ?? 0).toStringAsFixed(2)}'
                            : 'Accepted')
                        : 'Declined${(row.vendorNote?.isNotEmpty ?? false) ? ': ${row.vendorNote}' : ''}',
                    style: TextStyle(
                      color: accepted ? theme.secondary : theme.error,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(() => _expandedItemId = itemId),
                    child: const Text('Change'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _summaryCard(FlutterFlowTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$_totalItems item${_totalItems == 1 ? '' : 's'} · $_availableItems accepted, $_unavailableItems declined',
            style: TextStyle(color: theme.secondaryText, fontSize: 12.5),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal',
                  style: TextStyle(
                      color: theme.primaryText, fontWeight: FontWeight.w600)),
              Text(
                '₦${_subtotal.toStringAsFixed(2)}',
                style: TextStyle(
                    color: theme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBar(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        border: Border(top: BorderSide(color: theme.alternate)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
          onPressed: _isApproving ? null : _approveBag,
          child: _isApproving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Approve availability',
                  style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
