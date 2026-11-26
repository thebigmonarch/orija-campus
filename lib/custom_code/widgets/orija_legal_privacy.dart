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

import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';

/// New page -- the "Legal & Privacy" settings row previously had no onTap
/// and no page to link to at all. Draft starter copy, scoped to what this
/// app actually does (listings/orders, vendor payouts via Paystack,
/// community features, chat, push notifications, account deletion tied to
/// request_my_account_deletion) -- NOT final legal text; replace before
/// real launch review.
class OrijaLegalPrivacy extends StatefulWidget {
  const OrijaLegalPrivacy({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaLegalPrivacy> createState() => _OrijaLegalPrivacyState();
}

class _OrijaLegalPrivacyState extends State<OrijaLegalPrivacy>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _section(String title, String body, FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(body,
              style: TextStyle(
                  color: theme.secondaryText, fontSize: 13, height: 1.5)),
        ],
      ),
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
        title: Text('Legal & Privacy',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.primary,
          unselectedLabelColor: theme.secondaryText,
          indicatorColor: theme.primary,
          tabs: const [
            Tab(text: 'Terms of Service'),
            Tab(text: 'Privacy Policy'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    children: [
                      _section(
                          'About These Terms',
                          'These Terms of Service apply to the Orija mobile application and services '
                              '("Orija", "the App"). Orija is published on Google Play under the developer '
                              'account Monarchy Org and is operated by Orija HQ Limited, a company based in '
                              'Ikeja, Lagos, Nigeria. References to "we", "us", or "our" below mean Orija HQ '
                              'Limited.',
                          theme),
                      _section(
                          '1. What Orija Is',
                          'Orija is a marketplace connecting buyers and vendors across Nigeria. '
                              'Vendors list products and services on their own storefronts; buyers browse, '
                              'message vendors, and place orders. Orija facilitates the connection and '
                              'payment but is not the seller of record for vendor listings.',
                          theme),
                      _section(
                          '2. Accounts',
                          'You must provide accurate information when creating an account and are '
                              'responsible for activity on it. You must be old enough to enter a binding '
                              'contract under Nigerian law to use Orija.',
                          theme),
                      _section(
                          '3. Buying & Selling',
                          'Vendors are responsible for the accuracy of their listings, the quality and '
                              'legality of what they sell, and fulfilling orders as described. Buyers are '
                              'responsible for providing correct delivery details and paying for orders they '
                              'place. Orija may remove listings or suspend accounts that violate these terms '
                              'or applicable law.',
                          theme),
                      _section(
                          '4. Payments & Payouts',
                          'Payments are processed through Paystack. Vendor payouts are sent to the bank '
                              'account the vendor provides during storefront setup. Orija deducts applicable '
                              'commission before payout, as shown in the vendor\'s own dashboard.',
                          theme),
                      _section(
                          '5. Store Plans',
                          'Vendors may choose a paid plan for additional storefront features. Plans '
                              'renew on the cycle shown at checkout and can be cancelled at any time from '
                              'the vendor\'s own Settings; access continues until the end of the paid period.',
                          theme),
                      _section(
                          '6. Community & Content',
                          'Communities, posts, chat messages, and reviews you post are your own content. '
                              'Don\'t post anything illegal, harassing, or infringing on someone else\'s '
                              'rights. Orija can remove content or restrict accounts that break this rule.',
                          theme),
                      _section(
                          '7. Account Deletion',
                          'You can permanently delete your account at any time from Settings. This '
                              'anonymizes your personal information, deactivates any storefronts you own, '
                              'and cancels active plans. This action cannot be undone.',
                          theme),
                      _section(
                          '8. Changes',
                          'Orija may update these terms as the app grows. Continuing to use Orija after '
                              'an update means you accept the revised terms.',
                          theme),
                    ],
                  ),
                  ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    children: [
                      _section(
                          'About This Policy',
                          'This Privacy Policy applies to the Orija mobile application and services '
                              '("Orija", "the App"), published on Google Play under the developer account '
                              'Monarchy Org and operated by Orija HQ Limited, a company based in Ikeja, Lagos, '
                              'Nigeria. References to "we", "us", or "our" in this policy mean Orija HQ '
                              'Limited. This policy describes what information we collect through the App and '
                              'how we use it.',
                          theme),
                      _section(
                          '1. What We Collect',
                          'Account details (name, email, phone, date of birth), profile info (avatar, '
                              'city/state), storefront and listing data if you sell, order and payment '
                              'records, messages you send in chat and communities, and device info (push '
                              'notification token, app version) needed to deliver the app\'s features.',
                          theme),
                      _section(
                          '2. How We Use It',
                          'To run the marketplace: matching buyers and vendors, processing orders and '
                              'payouts, sending order and account notifications, showing you relevant '
                              'listings and communities, and keeping the platform safe (fraud checks, abuse '
                              'reports, blocked-user enforcement).',
                          theme),
                      _section(
                          '3. Who We Share It With',
                          'Paystack (payments and vendor payouts), Firebase (push notifications), and '
                              'delivery partners for orders that need dispatch. We don\'t sell your personal '
                              'data.',
                          theme),
                      _section(
                          '4. Your Choices',
                          'You can review and edit most of your profile from Settings, control which '
                              'notification categories you receive (including quiet hours), manage who you\'ve '
                              'blocked, and sign out of other devices. You can request permanent account '
                              'deletion at any time.',
                          theme),
                      _section(
                          '5. Data Retention',
                          'We keep your data while your account is active. If you delete your account, '
                              'personal identifiers are anonymized immediately; records tied to completed '
                              'orders may be retained as required for tax, accounting, or dispute records.',
                          theme),
                      _section(
                          '6. Security',
                          'We use industry-standard measures (encrypted connections, access controls, '
                              'row-level data isolation) to protect your data. No system is perfectly secure, '
                              'and we\'ll notify affected users if a serious breach occurs.',
                          theme),
                      _section(
                          '7. Contact',
                          'Questions about this policy or your data: reach us via Help Center in Settings, '
                              'or support@orija.ng. Orija HQ Limited, Ikeja, Lagos, Nigeria.',
                          theme),
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
