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
import '/custom_code/widgets/orija_media_field.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Submit CAC registration + proof of address for a storefront's business
/// verification. Writes one row to `business_verifications` with
/// badge='cac'; `reviewer_type` is picked automatically depending on whether
/// the storefront belongs to a market community (market_head) or not
/// (orija_admin) -- see the `on_business_verification` trigger for what each
/// does on approval.
class OrijaStorefrontVerification extends StatefulWidget {
  const OrijaStorefrontVerification({
    super.key,
    this.width,
    this.height,
    required this.storefrontId,
  });

  final double? width;
  final double? height;
  final String? storefrontId;

  @override
  State<OrijaStorefrontVerification> createState() =>
      _OrijaStorefrontVerificationState();
}

class _OrijaStorefrontVerificationState
    extends State<OrijaStorefrontVerification> {
  final _db = Supabase.instance.client;
  final _regNumber = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  String? _error;
  String? _marketCommunityId;
  String? _existingStatus;
  String? _cacUrl;
  String? _addressUrl;

  String get _storeId => widget.storefrontId ?? '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _regNumber.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (_storeId.isEmpty) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final sf = await _db
          .from('storefronts')
          .select('market_community_id')
          .eq('id', _storeId)
          .maybeSingle();
      final existing = await _db
          .from('business_verifications')
          .select('status')
          .eq('storefront_id', _storeId)
          .eq('badge', 'cac')
          .order('submitted_at', ascending: false)
          .limit(1)
          .maybeSingle();
      if (!mounted) return;
      setState(() {
        _marketCommunityId = sf?['market_community_id'] as String?;
        _existingStatus = existing?['status'] as String?;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    if (_saving) return;
    final reg = _regNumber.text.trim();
    if (reg.isEmpty || _cacUrl == null || _addressUrl == null) {
      setState(() {
        _error =
            'Add your registration number and both documents before submitting.';
      });
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final isMarket =
          _marketCommunityId != null && _marketCommunityId!.isNotEmpty;
      await _db.from('business_verifications').insert({
        'storefront_id': _storeId,
        'user_id': currentUserUid,
        'badge': 'cac',
        'reg_number': reg,
        'document_url': _cacUrl,
        'address_document_url': _addressUrl,
        'reviewer_type': isMarket ? 'market_head' : 'orija_admin',
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitted for review.')),
      );
      Navigator.of(context).maybePop();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Could not submit. Try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    if (_loading) {
      return Scaffold(
        backgroundColor: theme.primaryBackground,
        body: Center(child: CircularProgressIndicator(color: theme.secondary)),
      );
    }

    final pending = _existingStatus == 'pending';

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        automaticallyImplyLeading: false,
        elevation: 2,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Business Verification',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Submit your CAC registration and a proof of address for '
                'your business. Approved submissions add a verified badge '
                'to your storefront.',
                style: TextStyle(
                    color: theme.secondaryText, fontSize: 13, height: 1.4),
              ),
              if (pending) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: theme.alternate),
                  ),
                  child: Text(
                    'Your last submission is still pending review.',
                    style:
                        TextStyle(color: theme.secondaryText, fontSize: 12.5),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Text('CAC registration number',
                  style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _regNumber,
                decoration: InputDecoration(
                  hintText: 'e.g. RC1234567',
                  filled: true,
                  fillColor: theme.secondaryBackground,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: theme.alternate),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('CAC certificate',
                  style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              OrijaMediaField(
                shape: 'wide',
                height: 120,
                uploadContext: 'verification_doc',
                label: 'Add your CAC certificate',
                imageUrl: _cacUrl,
                onSave: (url) async {
                  setState(() => _cacUrl = url);
                  return true;
                },
              ),
              const SizedBox(height: 20),
              Text('Proof of address',
                  style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              OrijaMediaField(
                shape: 'wide',
                height: 120,
                uploadContext: 'verification_doc',
                label: 'Add a utility bill or similar proof of address',
                imageUrl: _addressUrl,
                onSave: (url) async {
                  setState(() => _addressUrl = url);
                  return true;
                },
              ),
              if (_error != null) ...[
                const SizedBox(height: 14),
                Text(_error!,
                    style: TextStyle(color: theme.error, fontSize: 12.5)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saving ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.4, color: Colors.white),
                        )
                      : const Text('Submit for review',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
