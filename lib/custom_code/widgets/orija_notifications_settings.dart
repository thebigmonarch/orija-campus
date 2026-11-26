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

/// Replacement for the generated `notifications_settings` page. Self-fetches
/// notification_preferences directly instead of depending on the old
/// `notification` DataStruct page param. Same seven category toggles as
/// before (still saved via the existing UpdatenotificationpreferencesCall --
/// backend untouched), plus Quiet Hours, which the data model and that API
/// call already fully supported (pQuietHoursEnabled/pQuietStartTime/
/// pQuietEndTime) but no UI anywhere ever exposed.
class OrijaNotificationsSettings extends StatefulWidget {
  const OrijaNotificationsSettings({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaNotificationsSettings> createState() =>
      _OrijaNotificationsSettingsState();
}

class _OrijaNotificationsSettingsState
    extends State<OrijaNotificationsSettings> {
  bool _loading = true;
  bool _saving = false;

  bool _ordersPayments = true;
  bool _liveTrade = true;
  bool _bidActivity = true;
  bool _social = true;
  bool _community = true;
  bool _dispatch = true;
  bool _platform = true;

  bool _showPreviews = true;
  bool _quietHours = false;
  TimeOfDay _quietStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietEnd = const TimeOfDay(hour: 7, minute: 0);

  @override
  void initState() {
    super.initState();
    _load();
  }

  TimeOfDay _parseTime(String? raw, TimeOfDay fallback) {
    if (raw == null || raw.isEmpty) return fallback;
    final parts = raw.split(':');
    if (parts.length < 2) return fallback;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return fallback;
    return TimeOfDay(hour: h, minute: m);
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';

  Future<void> _load() async {
    try {
      final row = await Supabase.instance.client
          .from('notification_preferences')
          .select()
          .eq('user_id', currentUserUid)
          .maybeSingle();
      if (!mounted) return;
      setState(() {
        _ordersPayments = row?['orders_payments_enabled'] ?? true;
        _liveTrade = row?['live_trade_enabled'] ?? true;
        _bidActivity = row?['bid_activity_enabled'] ?? true;
        _social = row?['social_enabled'] ?? true;
        _community = row?['community_enabled'] ?? true;
        _dispatch = row?['dispatch_enabled'] ?? true;
        _platform = row?['platform_enabled'] ?? true;
        _showPreviews = row?['show_previews'] ?? true;
        _quietHours = row?['quiet_hours_enabled'] ?? false;
        _quietStart =
            _parseTime(row?['quiet_start_time'] as String?, _quietStart);
        _quietEnd = _parseTime(row?['quiet_end_time'] as String?, _quietEnd);
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await UpdatenotificationpreferencesCall.call(
        pUserId: currentUserUid,
        pBidActivityEnabled: _bidActivity,
        pCommunityEnabled: _community,
        pDispatchEnabled: _dispatch,
        pLiveTradeEnabled: _liveTrade,
        pOrdersPaymentsEnabled: _ordersPayments,
        pPlatformEnabled: _platform,
        pSocialEnabled: _social,
        pQuietHoursEnabled: _quietHours,
        pQuietStartTime: _formatTime(_quietStart),
        pQuietEndTime: _formatTime(_quietEnd),
      );
    } catch (_) {
      // Best-effort; the toggle already reflects the user's choice locally.
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _quietStart : _quietEnd,
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _quietStart = picked;
      } else {
        _quietEnd = picked;
      }
    });
    _save();
  }

  Widget _toggleRow(FlutterFlowTheme theme,
      {required String title,
      required String subtitle,
      required bool value,
      required ValueChanged<bool> onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: TextStyle(color: theme.primaryText, fontSize: 14)),
                Text(subtitle,
                    style:
                        TextStyle(color: theme.secondaryText, fontSize: 11.5)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: theme.primary,
            onChanged: (v) {
              onChanged(v);
              _save();
            },
          ),
        ],
      ),
    );
  }

  Widget _card(FlutterFlowTheme theme, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.alternate),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        automaticallyImplyLeading: false,
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Notifications',
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            if (_saving) ...[
              const SizedBox(width: 10),
              SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: theme.secondary)),
            ],
          ],
        ),
      ),
      body: SafeArea(
        child: _loading
            ? Center(child: CircularProgressIndicator(color: theme.primary))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('Categories',
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 12)),
                  const SizedBox(height: 8),
                  _card(theme,
                      child: Column(
                        children: [
                          _toggleRow(theme,
                              title: 'Orders & Payments',
                              subtitle: 'Order status, payment confirmations',
                              value: _ordersPayments,
                              onChanged: (v) =>
                                  setState(() => _ordersPayments = v)),
                          Divider(color: theme.alternate, height: 1),
                          _toggleRow(theme,
                              title: 'Live Trade',
                              subtitle: 'Bids, live sessions, outbid alerts',
                              value: _liveTrade,
                              onChanged: (v) => setState(() => _liveTrade = v)),
                          Divider(color: theme.alternate, height: 1),
                          _toggleRow(theme,
                              title: 'Bid Activity',
                              subtitle: 'Activity on auctions you\'re watching',
                              value: _bidActivity,
                              onChanged: (v) =>
                                  setState(() => _bidActivity = v)),
                          Divider(color: theme.alternate, height: 1),
                          _toggleRow(theme,
                              title: 'Social',
                              subtitle: 'Messages, likes, comments',
                              value: _social,
                              onChanged: (v) => setState(() => _social = v)),
                          Divider(color: theme.alternate, height: 1),
                          _toggleRow(theme,
                              title: 'Community',
                              subtitle:
                                  'New posts and vendors in your communities',
                              value: _community,
                              onChanged: (v) => setState(() => _community = v)),
                          Divider(color: theme.alternate, height: 1),
                          _toggleRow(theme,
                              title: 'Dispatch',
                              subtitle: 'Delivery and rider updates',
                              value: _dispatch,
                              onChanged: (v) => setState(() => _dispatch = v)),
                          Divider(color: theme.alternate, height: 1),
                          _toggleRow(theme,
                              title: 'Platform',
                              subtitle: 'Announcements and account notices',
                              value: _platform,
                              onChanged: (v) => setState(() => _platform = v)),
                        ],
                      )),
                  const SizedBox(height: 20),
                  Text('Privacy',
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 12)),
                  const SizedBox(height: 8),
                  _card(theme,
                      child: _toggleRow(theme,
                          title: 'Show message text on lock screen',
                          subtitle:
                              'When off, chat, order and payment alerts say "Open Orija to see the details" instead of showing the text or amounts',
                          value: _showPreviews, onChanged: (v) {
                        setState(() => _showPreviews = v);
                        Supabase.instance.client.rpc('set_notification_privacy',
                            params: {
                              'p_show_previews': v
                            }).then((_) {}, onError: (_) {});
                      })),
                  const SizedBox(height: 20),
                  Text('Quiet Hours',
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 12)),
                  const SizedBox(height: 8),
                  _card(theme,
                      child: Column(
                        children: [
                          _toggleRow(theme,
                              title: 'Quiet Hours',
                              subtitle:
                                  'Hold non-urgent notifications during this window (Lagos time). Orders and payments still come through.',
                              value: _quietHours,
                              onChanged: (v) =>
                                  setState(() => _quietHours = v)),
                          if (_quietHours) ...[
                            Divider(color: theme.alternate, height: 1),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => _pickTime(true),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('From',
                                              style: TextStyle(
                                                  color: theme.secondaryText,
                                                  fontSize: 11.5)),
                                          Text(_quietStart.format(context),
                                              style: TextStyle(
                                                  color: theme.primaryText,
                                                  fontSize: 15)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => _pickTime(false),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('To',
                                              style: TextStyle(
                                                  color: theme.secondaryText,
                                                  fontSize: 11.5)),
                                          Text(_quietEnd.format(context),
                                              style: TextStyle(
                                                  color: theme.primaryText,
                                                  fontSize: 15)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      )),
                ],
              ),
      ),
    );
  }
}
