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

import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';

/// Hand-authored replacement for the generated buyerBag screen — running
/// total, is_negotiable-aware offer field, consolidated save bar, real empty
/// state, and a functional Close Bag via a direct bags table update.
class OrijaBuyerBag extends StatefulWidget {
  const OrijaBuyerBag(
      {super.key, this.width, this.height, required this.bagId});

  final double? width;
  final double? height;

  // Nullable to match how page/query params are actually generated
  // (always `String?` regardless of `.withDefault(...)` at the DSL level) —
  // see the equivalent note on OrijaMessageThread for the full reasoning.
  final String? bagId;

  @override
  State<OrijaBuyerBag> createState() => _OrijaBuyerBagState();
}

class _OrijaBuyerBagState extends State<OrijaBuyerBag> {
  final _noteController = TextEditingController();

  List<VBagItemsRow> _items = [];
  bool _isLoading = true;
  bool _isSending = false;
  bool _isClosing = false;
  bool _noteSeeded = false;

  // itemId -> pending (unsaved) quantity/offer. Only populated when a value
  // actually differs from what the server last returned, so the save bar
  // appears exactly when there's something to save, not on every rebuild.
  final Map<String, int> _pendingQty = {};
  final Map<String, double> _pendingOffer = {};

  String get _bid => widget.bagId ?? '';
  bool get _hasBag => _bid.isNotEmpty;
  bool get _hasPendingEdits =>
      _pendingQty.isNotEmpty || _pendingOffer.isNotEmpty;

  VBagItemsRow? get _first => _items.isNotEmpty ? _items.first : null;
  double get _subtotal => _first?.bagSubtotal ?? 0;
  int get _totalItems => _first?.bagTotalItems ?? _items.length;
  int get _availableItems => _first?.bagAvailableItems ?? 0;
  int get _unavailableItems => _first?.bagUnavailableItems ?? 0;
  // Presence of a timestamp is a more reliable signal than guessing at
  // `status` string values the database might use — these two DateTime
  // fields have unambiguous meaning regardless of what `bagStatus` says.
  bool get _isSent => _first?.sentAt != null;
  bool get _vendorResponded => _first?.vendorReviewedAt != null;

  @override
  void initState() {
    super.initState();
    if (_hasBag) _loadItems();
  }

  @override
  void dispose() {
    _noteController.dispose();
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
      if (!_noteSeeded && rows.isNotEmpty) {
        _noteController.text = rows.first.bagBuyerNote ?? '';
        _noteSeeded = true;
      }
    });
  }

  void _setPendingQty(String itemId, int qty, int serverQty) {
    setState(() {
      if (qty == serverQty) {
        _pendingQty.remove(itemId);
      } else {
        _pendingQty[itemId] = qty;
      }
    });
  }

  void _setPendingOffer(String itemId, double offer, double? serverOffer) {
    setState(() {
      if (offer == serverOffer) {
        _pendingOffer.remove(itemId);
      } else {
        _pendingOffer[itemId] = offer;
      }
    });
  }

  Future<void> _saveChanges() async {
    if (!_hasPendingEdits) return;
    final touched = <String>{..._pendingQty.keys, ..._pendingOffer.keys};
    setState(() => _isSending = true);
    try {
      for (final itemId in touched) {
        final row = _items.firstWhere((r) => r.itemId == itemId);
        await UpdatebagitemCall.call(
          buyerId: currentUserUid,
          itemID: itemId,
          quantity: _pendingQty[itemId] ?? row.quantity,
          offerPrice: _pendingOffer[itemId] ?? row.buyerOfferPrice,
        );
      }
      _pendingQty.clear();
      _pendingOffer.clear();
      await _loadItems();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _removeItem(String itemId) async {
    await RemovebagitemCall.call(buyerId: currentUserUid, itemID: itemId);
    _pendingQty.remove(itemId);
    _pendingOffer.remove(itemId);
    await _loadItems();
  }

  /// Answers a vendor counter-offer through the real state machine
  /// (buyer_respond_counter), not a raw item update -- accept the
  /// countered price, keep the item at its original listed price, or
  /// remove the item from the bag. Mirrors the sheet on the message
  /// thread's bag card.
  Future<void> _respondToCounter(VBagItemsRow row, String action) async {
    setState(() => _isSending = true);
    try {
      final res =
          await Supabase.instance.client.rpc('buyer_respond_counter', params: {
        'p_buyer_id': currentUserUid,
        'p_item_id': row.itemId,
        'p_action': action,
      });
      final ok = res is Map && res['success'] == true;
      if (!mounted) return;
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text((res is Map ? res['message'] : null)?.toString() ??
              'Could not respond to the counter-offer.'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ));
        return;
      }
      await _loadItems();
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _sendToVendor() async {
    setState(() => _isSending = true);
    try {
      final result = await SendbagtovendorCall.call(
        bagId: _bid,
        buyerId: currentUserUid,
        buyerNote: _noteController.text,
      );
      final ok = SendbagtovendorCall.success(result.jsonBody ?? '') ?? false;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok
                ? 'Sent to the vendor for review.'
                : 'Failed. Please try again in a few minutes.',
          ),
          backgroundColor: ok
              ? FlutterFlowTheme.of(context).secondary
              : FlutterFlowTheme.of(context).error,
        ),
      );
      if (ok) await _loadItems();
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _confirmCloseBag() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Close this bag?'),
        content: const Text(
          'This marks the bag as cancelled. Items already ordered are not '
          'affected — this only applies to items still being negotiated.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep bag'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Close bag',
              style: TextStyle(color: FlutterFlowTheme.of(context).error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _closeBag();
  }

  Future<void> _closeBag() async {
    setState(() => _isClosing = true);
    try {
      // No dedicated cancel-bag RPC exists anywhere in this project — this
      // is a direct table update against real, existing `bags` columns
      // rather than the RPC pattern every other bag mutation uses. See the
      // class doc comment for exactly what this does and doesn't guarantee.
      await BagsTable().update(
        data: {
          'status': 'cancelled',
          'cancelled_at': DateTime.now().toIso8601String(),
        },
        matchingRows: (rows) => rows.eqOrNull('id', _bid),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bag closed.')),
      );
      Navigator.of(context).maybePop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Couldn't close the bag — you may not have permission to do "
            'this directly. Please try again or contact support.',
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
              style: TextStyle(color: theme.secondaryText)),
        ),
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
        title: Text('My Bag',
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
                          if (_isSent) _statusBanner(theme),
                          ..._items.map((row) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _itemCard(row, theme),
                              )),
                          _noteField(theme),
                          const SizedBox(height: 12),
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
          Text('Your bag is empty',
              style: TextStyle(
                  color: theme.primaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
          const SizedBox(height: 6),
          Text(
            'Items you add from a storefront will show up here.',
            style: TextStyle(color: theme.secondaryText, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _statusBanner(FlutterFlowTheme theme) {
    final label = _vendorResponded
        ? 'Vendor has reviewed this bag — see their response below.'
        : 'Sent to vendor — waiting for their response.';
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.secondary.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(
            _vendorResponded
                ? Icons.mark_email_read_outlined
                : Icons.hourglass_top_outlined,
            size: 18,
            color: theme.secondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: TextStyle(color: theme.primaryText, fontSize: 12.5)),
          ),
        ],
      ),
    );
  }

  Widget _itemCard(VBagItemsRow row, FlutterFlowTheme theme) {
    final itemId = row.itemId ?? '';
    final qty = _pendingQty[itemId] ?? row.quantity ?? 1;
    final offer =
        _pendingOffer[itemId] ?? row.buyerOfferPrice ?? row.unitPrice ?? 0;
    final negotiable = row.isNegotiable ?? false;
    final offerStatus = row.offerStatus;
    final hasVendorDecision = row.vendorReviewedAt != null;
    final proposed = offerStatus == 'proposed';
    final countered = offerStatus == 'countered';
    final offerAccepted = offerStatus == 'accepted';
    final declined = offerStatus == 'declined' ||
        (hasVendorDecision && row.isAvailable == false && offerStatus == null);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.alternate),
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            row.listingTitle ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: theme.primaryText,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline,
                              color: theme.error, size: 20),
                          onPressed: () => _removeItem(itemId),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₦${(row.unitPrice ?? 0).toStringAsFixed(2)} each',
                      style: TextStyle(
                        color: theme.secondaryText,
                        fontSize: 12.5,
                        decoration:
                            negotiable ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (_pendingQty.containsKey(itemId) ||
                        _pendingOffer.containsKey(itemId))
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text('Unsaved changes',
                            style:
                                TextStyle(color: theme.warning, fontSize: 11)),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _qtyStepper(row, qty, theme),
              if (negotiable)
                SizedBox(
                  width: 130,
                  child: TextFormField(
                    initialValue: offer.toStringAsFixed(2),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.right,
                    style: TextStyle(color: theme.primaryText, fontSize: 13),
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Your offer',
                      labelStyle:
                          TextStyle(color: theme.secondaryText, fontSize: 11),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (value) {
                      final parsed = double.tryParse(value);
                      if (parsed != null) {
                        _setPendingOffer(itemId, parsed, row.buyerOfferPrice);
                      }
                    },
                  ),
                ),
            ],
          ),
          if (proposed)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _decisionNote(
                theme: theme,
                color: theme.secondary,
                icon: Icons.hourglass_top_outlined,
                label: 'Your offer is waiting for the vendor to respond.',
              ),
            ),
          if (offerAccepted)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _decisionNote(
                theme: theme,
                color: theme.secondary,
                icon: Icons.check_circle_outline,
                label: 'Vendor accepted your offer.',
              ),
            ),
          if (declined)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _decisionNote(
                theme: theme,
                color: theme.error,
                icon: Icons.block_outlined,
                label: 'Vendor marked this unavailable'
                    '${(row.vendorNote?.isNotEmpty ?? false) ? ': ${row.vendorNote}' : '.'}',
              ),
            ),
          if (countered) ...[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _decisionNote(
                theme: theme,
                color: theme.primary,
                icon: Icons.swap_horiz_rounded,
                label:
                    'Vendor countered: ₦${(row.vendorConfirmedPrice ?? 0).toStringAsFixed(2)}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: theme.secondary,
                          side: BorderSide(color: theme.secondary)),
                      onPressed: _isSending
                          ? null
                          : () => _respondToCounter(row, 'accept'),
                      child: const Text('Accept'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: theme.secondaryText,
                          side: BorderSide(color: theme.alternate)),
                      onPressed: _isSending
                          ? null
                          : () => _respondToCounter(row, 'listed'),
                      child: const Text('Keep listed price'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: theme.error,
                          side: BorderSide(color: theme.error)),
                      onPressed: _isSending
                          ? null
                          : () => _respondToCounter(row, 'remove'),
                      child: const Text('Remove'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _decisionNote({
    required FlutterFlowTheme theme,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
              child: Text(label,
                  style: TextStyle(color: theme.primaryText, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _qtyStepper(VBagItemsRow row, int qty, FlutterFlowTheme theme) {
    final max = row.stockQuantity ?? 99;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.alternate),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 16),
            onPressed: qty > 1
                ? () =>
                    _setPendingQty(row.itemId ?? '', qty - 1, row.quantity ?? 1)
                : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          SizedBox(
            width: 28,
            child: Text('$qty',
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.primaryText)),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16),
            onPressed: qty < max
                ? () =>
                    _setPendingQty(row.itemId ?? '', qty + 1, row.quantity ?? 1)
                : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _noteField(FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: TextFormField(
        controller: _noteController,
        maxLines: 3,
        maxLength: 200,
        style: TextStyle(color: theme.primaryText),
        decoration: InputDecoration(
          labelText: 'Note to vendor (optional)',
          hintText: 'Any special instructions?',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_totalItems item${_totalItems == 1 ? '' : 's'}'
                '${_vendorResponded ? ' · $_availableItems available, $_unavailableItems unavailable' : ''}',
                style: TextStyle(color: theme.secondaryText, fontSize: 12.5),
              ),
            ],
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
          onPressed: _isSending
              ? null
              : (_hasPendingEdits
                  ? _saveChanges
                  : (_isSent ? null : _sendToVendor)),
          child: _isSending
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Text(
                  _hasPendingEdits
                      ? 'Save changes'
                      : (_isSent ? 'Sent to vendor' : 'Send to Vendor'),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }
}
