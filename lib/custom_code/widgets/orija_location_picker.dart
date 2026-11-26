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

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// What the picker currently holds. Names are Terminal Africa's own, so they
/// match exactly what delivery quotes are asked for.
class OrijaLocationValue {
  const OrijaLocationValue({
    this.stateName,
    this.stateCode,
    this.city,
    this.address,
  });

  final String? stateName;
  final String? stateCode;
  final String? city;
  final String? address;

  bool get hasStateAndCity =>
      (stateName ?? '').isNotEmpty && (city ?? '').isNotEmpty;
}

/// Country (Nigeria) -> state -> city, then an optional street address.
///
/// State and city are cascading dropdowns fed live by Terminal Africa's geo
/// data, the same source the checkout address sheet uses, so a seller's
/// location and a buyer's delivery address always speak the same names.
/// The street line is typed by hand.
///
/// Every change is reported through [onChanged]. Not backed by app state:
/// the parent owns the value.
class OrijaLocationPicker extends StatefulWidget {
  const OrijaLocationPicker({
    super.key,
    this.width,
    this.height,
    this.initialState,
    this.initialCity,
    this.initialAddress,
    this.showStreet,
    this.onChanged,
  });

  final double? width;
  final double? height;

  /// State to preselect, by name (matched loosely: "Lagos State" == "Lagos").
  final String? initialState;
  final String? initialCity;
  final String? initialAddress;

  /// Show the street-address search + field. Defaults to true.
  final bool? showStreet;

  /// Dart-only callback: not a FlutterFlow parameter.
  final ValueChanged<OrijaLocationValue>? onChanged;

  @override
  State<OrijaLocationPicker> createState() => _OrijaLocationPickerState();
}

class _OrijaLocationPickerState extends State<OrijaLocationPicker> {
  static const _country = 'NG';

  final _street = TextEditingController();

  List<Map<String, String>> _states = [];
  List<String> _cities = [];
  String? _stateCode;
  String? _city;

  bool _loadingStates = true;
  bool _loadingCities = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _street.text = widget.initialAddress ?? '';
    _loadStates();
  }

  @override
  void dispose() {
    _street.dispose();
    super.dispose();
  }

  String _norm(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z]'), '')
      .replaceAll(RegExp(r'state$'), '');

  String? get _stateName {
    for (final s in _states) {
      if (s['isoCode'] == _stateCode) return s['name'];
    }
    return null;
  }

  void _emit() {
    widget.onChanged?.call(OrijaLocationValue(
      stateName: _stateName,
      stateCode: _stateCode,
      city: _city,
      address: _street.text.trim(),
    ));
  }

  Future<void> _loadStates() async {
    setState(() {
      _loadingStates = true;
      _error = null;
    });
    final res = await GetStateterminalafricaCall.call(countryCode: _country);
    if (!mounted) return;

    final names =
        GetStateterminalafricaCall.name(res.jsonBody) ?? const <String>[];
    final codes =
        GetStateterminalafricaCall.isoCode(res.jsonBody) ?? const <String>[];
    final list = <Map<String, String>>[
      for (var i = 0; i < names.length && i < codes.length; i++)
        {'name': names[i], 'isoCode': codes[i]},
    ]..sort((a, b) => a['name']!.compareTo(b['name']!));

    if (!res.succeeded || list.isEmpty) {
      setState(() {
        _loadingStates = false;
        _error = 'Could not load states. Tap to retry.';
      });
      return;
    }

    String? preset;
    final wanted = _norm(widget.initialState ?? '');
    if (wanted.isNotEmpty) {
      for (final s in list) {
        final n = _norm(s['name']!);
        if (n == wanted || n.contains(wanted) || wanted.contains(n)) {
          preset = s['isoCode'];
          break;
        }
      }
    }

    setState(() {
      _states = list;
      _loadingStates = false;
      _stateCode = preset;
    });
    if (preset != null) {
      await _loadCities(preset, presetCity: widget.initialCity);
    }
    _emit();
  }

  Future<void> _loadCities(String stateCode, {String? presetCity}) async {
    setState(() {
      _loadingCities = true;
      _cities = [];
      _city = null;
      _error = null;
    });
    final res = await GetCityterminalafricaCall.call(
      countryCode: _country,
      stateCode: stateCode,
    );
    if (!mounted) return;

    final names =
        GetCityterminalafricaCall.name(res.jsonBody) ?? const <String>[];
    final cities = List<String>.from(names)..sort();

    String? preset;
    if ((presetCity ?? '').isNotEmpty) {
      for (final c in cities) {
        if (c.toLowerCase() == presetCity!.toLowerCase()) {
          preset = c;
          break;
        }
      }
    }

    setState(() {
      _loadingCities = false;
      _cities = cities;
      _city = preset;
      if (!res.succeeded || cities.isEmpty) {
        _error = 'No cities found for this state.';
      }
    });
  }

  InputDecoration _dec(FlutterFlowTheme theme, String label) {
    OutlineInputBorder b(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c),
        );
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: theme.secondaryText, fontSize: 13),
      filled: true,
      fillColor: theme.secondaryBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: b(theme.alternate),
      focusedBorder: b(theme.secondary),
      border: b(theme.alternate),
    );
  }

  Widget _status(FlutterFlowTheme theme, String text, {bool spinner = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.alternate),
      ),
      child: Row(children: [
        if (spinner) ...[
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: theme.secondary),
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Text(text,
              style: TextStyle(color: theme.secondaryText, fontSize: 13)),
        ),
      ]),
    );
  }

  /// Street address as a real search box, backed by Google's Places API
  /// (New) -- the one Places endpoint that answers direct browser calls with
  /// CORS headers, so this works on web as well as iOS/Android without a
  /// native platform picker. Falls back to plain typing with no error shown
  /// if the API call fails (wrong/disabled key, offline, etc.) -- the field
  /// is a normal TextField underneath, so nothing is lost by trying.
  Widget _streetSearchField(
    FlutterFlowTheme theme,
    TextEditingController controller, {
    required ValueChanged<String> onPicked,
  }) {
    return _StreetSearchField(
      theme: theme,
      controller: controller,
      onPicked: onPicked,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final showStreet = widget.showStreet ?? true;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _status(theme, 'Nigeria'),
        const SizedBox(height: 10),
        if (_loadingStates)
          _status(theme, 'Loading states…', spinner: true)
        else if (_states.isEmpty)
          GestureDetector(
            onTap: _loadStates,
            child: _status(theme, _error ?? 'Could not load states.'),
          )
        else
          DropdownButtonFormField<String>(
            key: ValueKey('state-$_stateCode'),
            initialValue: _stateCode,
            isExpanded: true,
            dropdownColor: theme.secondaryBackground,
            style: TextStyle(color: theme.primaryText, fontSize: 14),
            decoration: _dec(theme, 'State'),
            items: [
              for (final s in _states)
                DropdownMenuItem(value: s['isoCode'], child: Text(s['name']!)),
            ],
            onChanged: (v) async {
              if (v == null) return;
              setState(() => _stateCode = v);
              await _loadCities(v);
              _emit();
            },
          ),
        const SizedBox(height: 10),
        if (_stateCode == null)
          _status(theme, 'Choose a state first')
        else if (_loadingCities)
          _status(theme, 'Loading cities…', spinner: true)
        else
          DropdownButtonFormField<String>(
            key: ValueKey('city-$_stateCode-$_city'),
            initialValue: _city,
            isExpanded: true,
            dropdownColor: theme.secondaryBackground,
            style: TextStyle(color: theme.primaryText, fontSize: 14),
            decoration: _dec(theme, 'City / area'),
            items: [
              for (final c in _cities)
                DropdownMenuItem(value: c, child: Text(c)),
            ],
            onChanged: (v) {
              setState(() => _city = v);
              _emit();
            },
          ),
        if (_error != null && _states.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(_error!, style: TextStyle(color: theme.error, fontSize: 11.5)),
        ],
        if (showStreet) ...[
          const SizedBox(height: 10),
          _streetSearchField(theme, _street, onPicked: (_) => _emit()),
        ],
      ],
    );
  }
}

class _StreetSuggestion {
  const _StreetSuggestion(this.placeId, this.text);
  final String placeId;
  final String text;
}

class _StreetSearchField extends StatefulWidget {
  const _StreetSearchField({
    required this.theme,
    required this.controller,
    required this.onPicked,
  });

  final FlutterFlowTheme theme;
  final TextEditingController controller;
  final ValueChanged<String> onPicked;

  @override
  State<_StreetSearchField> createState() => _StreetSearchFieldState();
}

class _StreetSearchFieldState extends State<_StreetSearchField> {
  static const _iosKey = 'AIzaSyAXzJ05IP_j7zho9RxvppCHk0GgSQ1mj4g';
  static const _androidKey = 'AIzaSyCC9i1gWMNw8bkhDiE2VGMHWQTwD0wGkDM';
  static const _webKey = 'AIzaSyB-GO6pS515nha7e9l-Q6xIF7bVF1qHkEA';

  Timer? _debounce;
  String? _sessionToken;
  List<_StreetSuggestion> _suggestions = [];
  bool _searching = false;
  final _layerLink = LayerLink();
  OverlayEntry? _overlay;

  String get _apiKey {
    if (kIsWeb) return _webKey;
    if (Platform.isIOS) return _iosKey;
    return _androidKey;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _hideOverlay();
    super.dispose();
  }

  void _onChanged(String value) {
    widget.onPicked
        .call(''); // typing manually clears any prior pick's side-effects
    _debounce?.cancel();
    if (value.trim().length < 4) {
      _suggestions = [];
      _hideOverlay();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () => _search(value));
  }

  Future<void> _search(String input) async {
    _sessionToken ??= '${DateTime.now().microsecondsSinceEpoch}';
    setState(() => _searching = true);
    try {
      final res = await http.post(
        Uri.parse('https://places.googleapis.com/v1/places:autocomplete'),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': _apiKey,
        },
        body: jsonEncode({
          'input': input,
          'sessionToken': _sessionToken,
          'includedRegionCodes': ['ng'],
          'languageCode': 'en',
        }),
      );
      if (!mounted) return;
      if (res.statusCode != 200) {
        setState(() {
          _searching = false;
          _suggestions = [];
        });
        _hideOverlay();
        return;
      }
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final preds = (data['suggestions'] as List?) ?? const [];
      setState(() {
        _searching = false;
        _suggestions = [
          for (final p in preds)
            if (p['placePrediction'] != null)
              _StreetSuggestion(
                '${p['placePrediction']['placeId']}',
                '${p['placePrediction']['text']?['text'] ?? ''}',
              ),
        ];
      });
      _showOverlay();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _searching = false;
        _suggestions = [];
      });
      _hideOverlay();
    }
  }

  /// Terminal Africa (and most carrier APIs) cap an address line at 45
  /// characters. Google's prediction text and formattedAddress are full
  /// descriptions (street, area, city, state, country) that routinely run
  /// well past that, so anything from this picker gets clamped before it
  /// reaches the field.
  static const _maxLine1 = 45;
  String _clamp(String s) =>
      s.length > _maxLine1 ? s.substring(0, _maxLine1) : s;

  Future<void> _select(_StreetSuggestion s) async {
    _hideOverlay();
    widget.controller.text = _clamp(s.text);
    widget.controller.selection =
        TextSelection.collapsed(offset: widget.controller.text.length);
    setState(() => _suggestions = []);
    FocusScope.of(context).unfocus();
    try {
      final res = await http.get(
        Uri.parse('https://places.googleapis.com/v1/places/${s.placeId}'),
        headers: {
          'X-Goog-Api-Key': _apiKey,
          'X-Goog-FieldMask': 'formattedAddress,addressComponents',
        },
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final components = (data['addressComponents'] as List?) ?? const [];
        String? componentText(String type) {
          for (final c in components) {
            final types = (c['types'] as List?) ?? const [];
            if (types.contains(type)) {
              return (c['longText'] ?? c['shortText']) as String?;
            }
          }
          return null;
        }

        // A street number + route (e.g. "12 Allen Avenue") is what "line 1"
        // actually means and is reliably short -- the full formattedAddress
        // duplicates the city/state this picker already collects separately
        // via its own dropdowns, which is exactly what pushed it past 45.
        final streetLine = [
          componentText('street_number'),
          componentText('route')
        ].where((p) => p != null && p.trim().isNotEmpty).join(' ');
        final formatted = data['formattedAddress'] as String?;
        final best = streetLine.isNotEmpty
            ? streetLine
            : (formatted?.isNotEmpty == true ? formatted! : null);
        if (best != null) {
          widget.controller.text = _clamp(best);
        }
      }
    } catch (_) {
      // The prediction text alone is still a usable address.
    } finally {
      _sessionToken = null;
      widget.onPicked.call(widget.controller.text);
    }
  }

  void _showOverlay() {
    _hideOverlay();
    if (_suggestions.isEmpty) return;
    final theme = widget.theme;
    final box = context.findRenderObject() as RenderBox?;
    final width = box?.size.width ?? 300;
    _overlay = OverlayEntry(
      builder: (ctx) => Positioned(
        width: width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, (box?.size.height ?? 48) + 4),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            color: theme.secondaryBackground,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _suggestions.length,
                itemBuilder: (_, i) {
                  final s = _suggestions[i];
                  return ListTile(
                    dense: true,
                    leading: Icon(Icons.place_outlined,
                        size: 18, color: theme.secondaryText),
                    title: Text(s.text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(color: theme.primaryText, fontSize: 13)),
                    onTap: () => _select(s),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlay!);
  }

  void _hideOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: widget.controller,
        onChanged: _onChanged,
        textCapitalization: TextCapitalization.words,
        maxLength: 45,
        style: TextStyle(color: theme.primaryText, fontSize: 14),
        decoration: InputDecoration(
          labelText: 'Street address',
          hintText: 'Search for the address, or type it in',
          counterText: '',
          labelStyle: TextStyle(color: theme.secondaryText, fontSize: 13),
          hintStyle: TextStyle(color: theme.secondaryText, fontSize: 12.5),
          filled: true,
          fillColor: theme.secondaryBackground,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          suffixIcon: _searching
              ? Padding(
                  padding: const EdgeInsets.all(14),
                  child: SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: theme.secondary),
                  ),
                )
              : Icon(Icons.search, color: theme.secondaryText, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.alternate),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.alternate),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.secondary),
          ),
        ),
      ),
    );
  }
}
