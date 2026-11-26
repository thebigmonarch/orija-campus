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
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';

/// Opens a new timed (no-video) bid auction -- storefront-backed or
/// standalone. Standalone sellers (no active storefront) are charged a flat
/// listing fee from their Orija wallet and must be identity-verified first;
/// `open_bid` enforces both server-side, this is just the matching UI gate.
class OrijaCreateBidListing extends StatefulWidget {
  const OrijaCreateBidListing({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaCreateBidListing> createState() => _OrijaCreateBidListingState();
}

class _OrijaCreateBidListingState extends State<OrijaCreateBidListing> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _startingPrice = TextEditingController();
  final _reservePrice = TextEditingController();
  String _condition = 'new';
  List<String> _photos = [];
  bool _uploadingPhoto = false;
  bool _submitting = false;
  String? _error;
  int _targetDays = 1;
  bool _scheduleForLater = false;
  DateTime? _opensAt;
  num _commissionPct = 10;
  bool _feeAcknowledged = false;

  @override
  void initState() {
    super.initState();
    _loadCommissionPct();
  }

  Future<void> _loadCommissionPct() async {
    try {
      final row = await Supabase.instance.client
          .from('platform_config')
          .select('value')
          .eq('key', 'timed_bid_comm')
          .maybeSingle();
      final v = row?['value'];
      final parsed = v is num ? v : num.tryParse('$v');
      if (parsed != null && mounted) setState(() => _commissionPct = parsed);
    } catch (_) {}
  }

  static const _dayFees = {1: 0, 3: 1000, 7: 2000};

  DateTime get _startBase {
    final now = DateTime.now();
    if (_scheduleForLater && _opensAt != null) return _opensAt!;
    return DateTime(now.year, now.month, now.day, now.hour, now.minute);
  }

  Map<int, DateTime> get _closingOptions {
    final base = _startBase;
    return {
      for (final d in _dayFees.keys) d: base.add(Duration(days: d)),
    };
  }

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final initial = _opensAt ?? now.add(const Duration(hours: 1));
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(now) ? now : initial,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      helpText: 'Choose your start date',
    );
    if (pickedDate == null) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
      helpText: 'Choose your start time',
    );
    if (pickedTime == null) return;
    var combined = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
        pickedTime.hour, pickedTime.minute);
    if (combined.isBefore(now)) combined = now.add(const Duration(minutes: 5));
    setState(() {
      _opensAt = combined;
      _scheduleForLater = true;
    });
  }

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  static const _weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  String _formatDate(DateTime d) =>
      '${_weekdays[d.weekday - 1]}, ${_months[d.month - 1]} ${d.day}';

  Future<void> _pickClosingDate() async {
    final options = _closingOptions;
    final picked = await showDatePicker(
      context: context,
      initialDate: options[_targetDays]!,
      firstDate: options[1]!,
      lastDate: options[7]!,
      selectableDayPredicate: (day) => options.values.any((d) =>
          d.year == day.year && d.month == day.month && d.day == day.day),
      helpText: 'Choose your closing date',
    );
    if (picked == null) return;
    final match = options.entries.firstWhere(
      (e) =>
          e.value.year == picked.year &&
          e.value.month == picked.month &&
          e.value.day == picked.day,
      orElse: () => options.entries.first,
    );
    setState(() => _targetDays = match.key);
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _startingPrice.dispose();
    _reservePrice.dispose();
    super.dispose();
  }

  Future<void> _addPhotos() async {
    if (_photos.length >= 4 || _uploadingPhoto) return;
    setState(() => _error = null);
    try {
      final selected = await selectMedia(
        mediaSource: MediaSource.photoGallery,
        multiImage: true,
        imageQuality: 85,
      );
      if (selected == null || selected.isEmpty) return;
      setState(() => _uploadingPhoto = true);
      final room = 4 - _photos.length;
      for (final file in selected.take(room)) {
        try {
          final res = await pickUploadCloudinaryMedia(
            [
              FFUploadedFile(
                name: file.originalFilename.isNotEmpty
                    ? file.originalFilename
                    : 'bid_item.jpg',
                bytes: file.bytes,
              )
            ],
            null,
            false,
            'listing',
            1600,
            85,
            0,
          );
          final urls =
              List<String>.from((res as Map)['mediaUrls'] as List? ?? []);
          if (urls.isEmpty) continue;
          if (!mounted) return;
          setState(() => _photos = [..._photos, urls.first]);
        } catch (_) {
          if (mounted) {
            setState(() => _error = 'One of your photos failed to upload.');
          }
        }
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not open your photos.');
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  void _removePhoto(int index) {
    final next = [..._photos]..removeAt(index);
    setState(() => _photos = next);
  }

  double? _num(String s) => double.tryParse(s.trim());

  // Sellers no longer think about this -- a flat 5% of the starting price
  // (rounded to the nearest ₦50, floor ₦100) is applied automatically.
  double _autoIncrement(double startingPrice) {
    if (startingPrice <= 0) return 100;
    final rounded = ((startingPrice * 0.05) / 50).round() * 50;
    return rounded < 100 ? 100 : rounded.toDouble();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final title = _title.text.trim();
    final startingPrice = _num(_startingPrice.text);
    final reservePrice =
        _reservePrice.text.trim().isEmpty ? null : _num(_reservePrice.text);

    if (title.isEmpty) {
      setState(() => _error = 'Give your item a title.');
      return;
    }
    if (_photos.isEmpty) {
      setState(() => _error = 'Add at least one photo.');
      return;
    }
    if (startingPrice == null || startingPrice < 0) {
      setState(() => _error = 'Enter a valid starting price (0 or more).');
      return;
    }
    if (_reservePrice.text.trim().isNotEmpty && reservePrice == null) {
      setState(
          () => _error = 'Enter a valid reserve price, or leave it blank.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      final res = await Supabase.instance.client.rpc('open_bid', params: {
        'p_listing_id': null,
        'p_item_title': title,
        'p_item_photos': _photos,
        'p_item_description': _description.text.trim(),
        'p_item_condition': _condition,
        'p_starting_price': startingPrice,
        'p_bid_increment': _autoIncrement(startingPrice),
        'p_reserve_price': reservePrice,
        'p_target_days': _targetDays,
        'p_opens_at': (_scheduleForLater && _opensAt != null)
            ? _opensAt!.toUtc().toIso8601String()
            : null,
      });

      if (res is Map && res['success'] == true) {
        final sessionId = res['session_id'] as String?;
        if (!mounted) return;
        if (sessionId != null) {
          context.pushReplacementNamed('bidDetailPage',
              queryParameters: {'sessionId': sessionId});
        } else {
          context.pop();
        }
      } else {
        setState(() => _error = (res is Map ? res['error'] as String? : null) ??
            'Could not open this bid. Try again.');
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 8 (Pattern D bulk pass). Mobile body
    // below is untouched; this gate is unreachable on a real phone.
    if (OrijaDesktopShell.isDesktop(context)) {
      return OrijaDesktopShell(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: _mobileBody(context),
          ),
        ),
      );
    }
    return _mobileBody(context);
  }

  Widget _mobileBody(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.primaryText),
        title: Text('Open a Bid',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            Text('Photos', style: _label(theme)),
            const SizedBox(height: 8),
            SizedBox(
              height: 86,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _photos.length + (_photos.length < 4 ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  if (i >= _photos.length) {
                    return InkWell(
                      onTap: _addPhotos,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          color: theme.secondaryBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.alternate),
                        ),
                        alignment: Alignment.center,
                        child: _uploadingPhoto
                            ? SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.2, color: theme.primary))
                            : Icon(Icons.add_a_photo_outlined,
                                color: theme.secondaryText, size: 24),
                      ),
                    );
                  }
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(_photos[i],
                            width: 86, height: 86, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 3,
                        right: 3,
                        child: InkWell(
                          onTap: () => _removePhoto(i),
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                                color: Colors.black54, shape: BoxShape.circle),
                            child: const Icon(Icons.close_rounded,
                                color: Colors.white, size: 14),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text('Item title', style: _label(theme)),
            const SizedBox(height: 6),
            _field(theme, _title, hint: 'e.g. Ankara Fabric Bundle'),
            const SizedBox(height: 16),
            Text('Description', style: _label(theme)),
            const SizedBox(height: 6),
            _field(theme, _description,
                hint: 'Tell bidders about it', maxLines: 3),
            const SizedBox(height: 16),
            Text('Condition', style: _label(theme)),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final c in const ['new', 'used', 'refurbished'])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c[0].toUpperCase() + c.substring(1)),
                      selected: _condition == c,
                      onSelected: (_) => setState(() => _condition = c),
                      selectedColor: theme.primary,
                      labelStyle: TextStyle(
                          color: _condition == c
                              ? Colors.white
                              : theme.primaryText,
                          fontSize: 12.5),
                      backgroundColor: theme.secondaryBackground,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Starting price (₦)', style: _label(theme)),
            const SizedBox(height: 6),
            _field(theme, _startingPrice,
                hint: '5,000', keyboardType: TextInputType.number),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline_rounded,
                    size: 14, color: theme.secondaryText),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                      'Starting low -- even from ₦0 -- draws more bidders in and often ends with a higher final price than starting high.',
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Reserve price (optional)', style: _label(theme)),
            const SizedBox(height: 6),
            _field(theme, _reservePrice,
                hint: 'Lowest you will accept',
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            Text('Start', style: _label(theme)),
            const SizedBox(height: 8),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('Start now'),
                  selected: !_scheduleForLater,
                  onSelected: (_) => setState(() => _scheduleForLater = false),
                  selectedColor: theme.primary,
                  labelStyle: TextStyle(
                      color:
                          !_scheduleForLater ? Colors.white : theme.primaryText,
                      fontSize: 12.5),
                  backgroundColor: theme.secondaryBackground,
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Schedule for later'),
                  selected: _scheduleForLater,
                  onSelected: (_) => _pickStartDate(),
                  selectedColor: theme.primary,
                  labelStyle: TextStyle(
                      color:
                          _scheduleForLater ? Colors.white : theme.primaryText,
                      fontSize: 12.5),
                  backgroundColor: theme.secondaryBackground,
                ),
              ],
            ),
            if (_scheduleForLater && _opensAt != null) ...[
              const SizedBox(height: 10),
              InkWell(
                onTap: _pickStartDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.alternate),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.schedule_rounded,
                          size: 17, color: theme.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                            'Opens ${_formatDate(_opensAt!)} at ${TimeOfDay.fromDateTime(_opensAt!).format(context)}',
                            style: TextStyle(
                                color: theme.primaryText,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600)),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          size: 18, color: theme.secondaryText),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text('Closing date', style: _label(theme)),
            const SizedBox(height: 6),
            InkWell(
              onTap: _pickClosingDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.alternate),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 17, color: theme.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                          'Closes ${_formatDate(_closingOptions[_targetDays]!)}',
                          style: TextStyle(
                              color: theme.primaryText,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600)),
                    ),
                    Text(
                        _dayFees[_targetDays] == 0
                            ? 'Free'
                            : '+₦${_dayFees[_targetDays]}',
                        style: TextStyle(
                            color: _dayFees[_targetDays] == 0
                                ? theme.secondaryText
                                : theme.primary,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(width: 6),
                    Icon(Icons.chevron_right_rounded,
                        size: 18, color: theme.secondaryText),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
                'Tap to choose 1 day (free), 3 days (+₦1,000) or 7 days (+₦2,000). The fee is charged from your wallet when you open the bid.',
                style: TextStyle(color: theme.secondaryText, fontSize: 11.5)),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => setState(() => _feeAcknowledged = !_feeAcknowledged),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color:
                          _feeAcknowledged ? theme.primary : theme.alternate),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _feeAcknowledged,
                      onChanged: (v) =>
                          setState(() => _feeAcknowledged = v ?? false),
                      activeColor: theme.primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                          "I understand Orija keeps a small ${_commissionPct.toStringAsFixed(_commissionPct % 1 == 0 ? 0 : 1)}% fee only when this item actually sells -- nothing is charged for bids that don't win, and there's no cost just to list.",
                          style: TextStyle(
                              color: theme.primaryText,
                              fontSize: 12,
                              height: 1.35)),
                    ),
                  ],
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 14),
              Text(_error!,
                  style: const TextStyle(color: Colors.red, fontSize: 12.5)),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: (_submitting || !_feeAcknowledged) ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.2, color: Colors.white))
                    : const Text('Open Bid',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _label(FlutterFlowTheme theme) => TextStyle(
      color: theme.primaryText, fontSize: 13, fontWeight: FontWeight.w600);

  Widget _field(FlutterFlowTheme theme, TextEditingController controller,
      {String? hint, int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(color: theme.primaryText, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: theme.secondaryText, fontSize: 13),
        filled: true,
        fillColor: theme.secondaryBackground,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.alternate),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.alternate),
        ),
      ),
    );
  }
}
