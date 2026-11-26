import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'market_head_dashboard_page_model.dart';
export 'market_head_dashboard_page_model.dart';

/// Build the Market Head Dashboard for Orija — a Nigerian social commerce
/// platform.
///
/// Brand colour: #FE6601 (orange). Background: dark (#1A1A1A) with card
/// surfaces at #2D2D2D.
///
/// This screen is the command centre for a market head who manages a physical
/// Nigerian
/// marketplace (e.g. The Arena Market, Oshodi). It is only visible to users
/// whose account
/// is the head_user_id of a market-type community.
///
/// ─────────────────────────────────────────────────────────────────
/// DATA  (all from one API call)
/// ─────────────────────────────────────────────────────────────────
/// Backend Call → Supabase RPC: market_head_get_dashboard(p_head_user_id:
/// currentUserID)
///
/// Response shape:
///   market     { id, name, slug, cover_url, state, city, address,
/// is_verified }
///   head       { id, name, avatar_url, phone }
///   stats      { total_vendors, pending_count, verified_vendors,
/// unverified_vendors,
///                pending_cac_docs, monthly_commission, total_pending_payout,
/// total_earned }
///   pending_approvals [ { storefront_id, name, logo_url, category, state,
/// city, joined_at,
///                          owner{name, phone, email},
/// cac_document{document_url, reg_number} } ]
///   commission_summary { current_month, last_month, pending_payout,
/// total_paid, total_earned }
///   commission_breakdown [ { storefront_name, storefront_logo,
/// subscription_tier,
///                            commission_amt, period_label, status } ]
///   recently_approved  [ { storefront_id, name, logo_url, approved_at,
/// owner_name } ]
///
/// ─────────────────────────────────────────────────────────────────
/// LAYOUT
/// ─────────────────────────────────────────────────────────────────
///
/// HEADER (sticky, dark background)
///   Left:   avatar_url + "Market Head" label in orange pill badge
///   Centre: market.name in bold white
///   Right:  bell icon (notifications)
///
/// MARKET HERO CARD (full-width, rounded corners)
///   Background: market.cover_url image with dark overlay
///   Over image:
///     • market.name  (large bold white)
///     • city, state  (small grey)
///     • "Verified Market ✓" green badge if market.is_verified = true
///     • address line in small grey beneath
///
/// ─────────────────────────────────────────────────────────────────
/// STATS ROW  (horizontal scroll, 2 rows × 3 cards on desktop)
/// ─────────────────────────────────────────────────────────────────
/// 6 stat cards in #FE6601-accented style:
///   1. Total Vendors      → stats.total_vendors
///   2. Pending Approvals  → stats.pending_count          (red badge if > 0)
///   3. CAC Docs Pending   → stats.pending_cac_docs       (amber badge if >
/// 0)
///   4. Verified Vendors   → stats.verified_vendors
///   5. Monthly Earnings   → ₦ stats.monthly_commission    (formatted)
///   6. Pending Payout     → ₦ stats.total_pending_payout
///
/// ─────────────────────────────────────────────────────────────────
/// TAB STRIP  (4 tabs, underline style, orange active indicator)
/// ─────────────────────────────────────────────────────────────────
///
/// TAB 1 — APPROVALS (badge = stats.pending_count)
///   Show when pending_approvals.length > 0, otherwise show empty state:
///     illustration + "No pending approvals — you're all caught up 🎉"
///
///   Each approval card:
///     ┌─────────────────────────────────────────────────────────┐
///     │ [logo]  Store Name              Category pill           │
///     │         Owner: John Doe · 📞 08012345678               │
///     │         Joined: 3 days ago · Lagos, Alimosho           │
///     │                                                         │
///     │  CAC DOCUMENT:                                          │
///     │  [📄 View Document]  Reg No: RC1234567                 │
///     │                                                         │
///     │  [✓ Approve]        [✗ Reject]                         │
///     └─────────────────────────────────────────────────────────┘
///
///   Approve → bottom sheet with optional "Note" field →
///     RPC: market_head_review_storefront(p_head_user_id, storefront_id,
/// 'approve', note)
///
///   Reject → bottom sheet with required "Reason" field →
///     RPC: market_head_review_storefront(p_head_user_id, storefront_id,
/// 'reject', reason)
///
///   On success: remove card from list, update pending badge count.
///
///
/// TAB 2 — MY MARKET
///   Search bar (debounced, 400ms) + filter pill row:
///     Status: [All] [Verified] [Unverified]
///
///   Data: RPC market_head_get_market_storefronts(p_head_user_id, status,
/// search, 25, offset)
///   Paginate with "Load more" at bottom.
///
///   Each storefront row:
///     ┌──────────────────────────────────────────────────────────┐
///     │ [logo]  Store Name              [✓ Verified] or [Unverified] │
///     │         Category · City         ⭐ avg_rating  📦 orders │
///     │         Owner name · Tier badge                          │
///     │                                            [⋮ Actions]  │
///     └──────────────────────────────────────────────────────────┘
///
///   [⋮ Actions] kebab opens bottom sheet with:
///     • View Store Profile (navigate to storefront detail)
///     • Remove from Market → confirm dialog + reason field →
///         RPC: market_head_remove_storefront(p_head_user_id, storefront_id,
/// reason)
///
///   Remove triggers: success toast, list refreshes, verified badge removed.
///
///
/// TAB 3 — COMMISSION
///   Top summary card (orange gradient):
///     ₦ commission_summary.current_month    → "This month"
///     ₦ commission_summary.last_month       → "Last month"
///     ₦ commission_summary.pending_payout   → "Pending payout" (amber)
///     ₦ commission_summary.total_earned     → "All time"
///
///   Period selector (pill tabs): This Month | Last Month | All Time
///     Changes filter params on
/// market_head_get_commission_history(p_head_user_id, null, month, year, 25,
/// offset)
///
///   Commission breakdown list:
///     Each row: logo + store name | subscription tier badge | ₦
/// commission_amt | period | status pill
///     Status: "Pending" (amber) | "Paid ✓" (green)
///
///   Empty state: "No commission records yet. Earnings appear here when
/// vendors subscribe."
///
///   Info banner (collapsible): "Orija pays out commissions monthly. Contact
/// support for payout queries."
///
///
/// TAB 4 — MARKET INFO
///   Editable market profile card:
///     • Cover image (tap to change)
///     • Market name (read-only — contact Orija to change)
///     • State, City, Address line
///     • Description (editable textarea)
///     • Coordinates: lat, lng (read-only)
///     • Verified badge status
///
///   Currently read-only — future phase will allow head to update cover +
/// description.
///
/// ─────────────────────────────────────────────────────────────────
/// GLOBAL BEHAVIOUR
/// ─────────────────────────────────────────────────────────────────
/// - Loading state: shimmer cards for stats row and tab content
/// - Error state: "Something went wrong. Pull to refresh." with retry button
/// - All monetary values formatted as ₦X,XXX (e.g. ₦15,000)
/// - All dates formatted as relative ("2 days ago") with tooltip showing full
/// date
/// - Destructive actions (Remove, Reject) require a confirmation step — never
/// one-tap
/// - The screen is NOT accessible from the main nav — accessed via a "Market
/// Head" banner
///   on the home/profile page for users who have the role, or via deep link
///   /market-head/[community_slug]
///
/// Use Tailwind CSS or FlutterFlow's built-in styling. Responsive across
/// mobile and tablet.
class MarketHeadDashboardPageWidget extends StatefulWidget {
  const MarketHeadDashboardPageWidget({
    super.key,
    required this.communityID,
  });

  final String? communityID;

  static String routeName = 'MarketHeadDashboardPage';
  static String routePath = 'marketHeadDashboardPage';

  @override
  State<MarketHeadDashboardPageWidget> createState() =>
      _MarketHeadDashboardPageWidgetState();
}

class _MarketHeadDashboardPageWidgetState
    extends State<MarketHeadDashboardPageWidget> {
  late MarketHeadDashboardPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MarketHeadDashboardPageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiCallResponse>(
      future: MarketHeadDashboardPageCall.call(
        pUserId: currentUserUid,
        communityID: widget.communityID,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: SpinKitChasingDots(
                  color: FlutterFlowTheme.of(context).primary,
                  size: 50.0,
                ),
              ),
            ),
          );
        }
        final marketHeadDashboardPageMarketHeadDashboardPageResponse =
            snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: SafeArea(
              top: true,
              child: Container(
                child: custom_widgets.OrijaMarketHeadDashboard(
                  communityId: widget.communityID,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
