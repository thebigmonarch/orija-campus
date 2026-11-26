# orija-campus

Web home of **Orija Campus** at `campus.orija.app`.

## Share links

Every share from the app is a short link that opens the item in the right app,
with a proper preview (title, text, photo) in WhatsApp, Instagram and X:

| Link | Item |
| --- | --- |
| `/go/s/<store slug>` | Store |
| `/go/l/<listing id>` | Listing |
| `/go/p/<post id>` | Post |
| `/go/h/<hostel id>` | Hostel |
| `/go/b/<session id>` | Bid |

`api/go.js` asks the database (`link_target`) whether the item belongs to
Orija Campus or the main Orija market, then forwards to
`campus.orija.app/...` or `orija.app/...`. Add `?from=main` to a link shared
from the main app: the item opens there when its store sells outside campus.
Asks, hostels, room requests and campus bids always open in Orija Campus.

## The campus web app

Put the Flutter web build (`build/web`, or FlutterFlow's web export) in the
repo root. `vercel.json` serves `index.html` for app routes and leaves
`/go/...` to the router.

## Settings (optional)

Environment variables in Vercel, all with working defaults:
`SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, `CAMPUS_URL`, `MAIN_URL`.
