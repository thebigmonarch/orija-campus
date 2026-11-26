// Orija share-link router.
//
//   /go/s/<store slug or id>   store
//   /go/l/<listing id>         listing
//   /go/p/<post id>            post
//   /go/h/<hostel id>          hostel
//   /go/b/<live session id>    bid
//
// Looks the item up with the public link_target database function, which
// decides whether it belongs to Orija Campus or the main Orija market, then
// returns a small page with the item's preview (title, text, photo) for
// WhatsApp, Instagram, X and others, and forwards the visitor to the right app.
//
// ?from=main  The link was shared from the main app: open the item there when
//             the store allows it (sells outside campus). Asks, hostels, room
//             requests and campus bids always open in Orija Campus.

const SUPABASE_URL = process.env.SUPABASE_URL || 'https://dgwvnxdxushgfvuzrvdr.supabase.co';
// A publishable key: safe in client code, it only reaches public data.
const SUPABASE_KEY = process.env.SUPABASE_PUBLISHABLE_KEY || 'sb_publishable_MtgpzEyZ3g8L-HtSO1B7jQ_piLwB0yR';

const APPS = {
  campus: process.env.CAMPUS_URL || 'https://campus.orija.app',
  main: process.env.MAIN_URL || 'https://orija.app',
};

const KINDS = { s: 'store', l: 'listing', p: 'post', h: 'hostel', b: 'bid' };

// The page each kind opens in the app. Both apps use the same page addresses.
function appPath(t) {
  const q = (o) =>
    '?' + Object.entries(o).filter(([, v]) => v !== undefined && v !== null && v !== '')
      .map(([k, v]) => `${k}=${encodeURIComponent(v)}`).join('&');
  switch (t.kind) {
    case 'store': return '/storefrontPage' + q({ storefontslug: t.slug });
    case 'listing': return '/listingdetailPage' + q({ listingId: t.id, storefrontId: t.storefront_id });
    case 'post': return '/viewPost' + q({ postID: t.id, postType: 'post', storeID: t.storefront_id || '' });
    case 'hostel': return '/hostel' + q({ hostelId: t.id });
    case 'bid': return '/bid-detail' + q({ sessionId: t.id });
    default: return '/';
  }
}

const esc = (s) => String(s ?? '')
  .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
  .replace(/"/g, '&quot;').replace(/'/g, '&#39;');

function page({ title, description, image, url, target, appName }) {
  const t = esc(title), d = esc(description), u = esc(url), dest = esc(target);
  const img = image ? esc(image) : '';
  return `<!doctype html>
<html lang="en"><head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>${t}</title>
<meta name="description" content="${d}" />
<meta property="og:type" content="website" />
<meta property="og:site_name" content="${esc(appName)}" />
<meta property="og:title" content="${t}" />
<meta property="og:description" content="${d}" />
<meta property="og:url" content="${u}" />
${img ? `<meta property="og:image" content="${img}" />` : ''}
<meta name="twitter:card" content="${img ? 'summary_large_image' : 'summary'}" />
<meta name="twitter:title" content="${t}" />
<meta name="twitter:description" content="${d}" />
${img ? `<meta name="twitter:image" content="${img}" />` : ''}
<meta http-equiv="refresh" content="0; url=${dest}" />
<link rel="canonical" href="${dest}" />
<style>
  body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,sans-serif;background:#FFF5EE;color:#14181B;
       display:flex;min-height:100vh;align-items:center;justify-content:center;padding:24px;box-sizing:border-box}
  .c{max-width:360px;text-align:center}
  img{width:100%;max-height:220px;object-fit:cover;border-radius:16px;margin-bottom:16px}
  h1{font-size:18px;margin:0 0 6px} p{font-size:14px;color:#57636C;margin:0 0 18px}
  a{display:inline-block;background:#86370E;color:#FFF5EE;text-decoration:none;padding:12px 22px;border-radius:24px;font-weight:600}
</style>
</head><body>
<div class="c">
  ${img ? `<img src="${img}" alt="" />` : ''}
  <h1>${t}</h1>
  <p>Opening in ${esc(appName)}…</p>
  <a href="${dest}">Open ${esc(appName)}</a>
</div>
<script>location.replace(${JSON.stringify(target)});</script>
</body></html>`;
}

async function lookup(kind, key) {
  const res = await fetch(`${SUPABASE_URL}/rest/v1/rpc/link_target`, {
    method: 'POST',
    headers: { apikey: SUPABASE_KEY, Authorization: `Bearer ${SUPABASE_KEY}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ p_kind: kind, p_key: key }),
  });
  if (!res.ok) throw new Error(`link_target ${res.status}`);
  return res.json();
}

module.exports = async (req, res) => {
  const url = new URL(req.url, `https://${req.headers.host || 'campus.orija.app'}`);
  // Vercel rewrites /go/<letter>/<key> to /api/go?path=<letter>/<key>.
  const [letter, ...rest] = (url.searchParams.get('path') || '').split('/').filter(Boolean);
  const key = decodeURIComponent(rest.join('/'));
  const kind = KINDS[letter];
  const fromMain = url.searchParams.get('from') === 'main';
  const self = `${url.origin}/go/${letter || ''}/${encodeURIComponent(key)}`;

  res.setHeader('Content-Type', 'text/html; charset=utf-8');

  if (!kind || !key) {
    res.setHeader('Cache-Control', 'public, s-maxage=3600');
    res.statusCode = 404;
    return res.end(page({ title: 'Orija Campus', description: 'Buy, sell and find rooms at your school.',
      url: self, target: APPS.campus, appName: 'Orija Campus' }));
  }

  let t;
  try {
    t = await lookup(kind, key);
  } catch (_) {
    // Database unreachable: still send people somewhere useful, and don't cache it.
    res.setHeader('Cache-Control', 'no-store');
    return res.end(page({ title: 'Orija', description: 'Open Orija to see this.', url: self,
      target: APPS.campus, appName: 'Orija Campus' }));
  }

  if (!t || !t.found) {
    res.setHeader('Cache-Control', 'public, s-maxage=300');
    res.statusCode = 404;
    return res.end(page({ title: 'This is no longer available', description: 'It may have been removed or sold.',
      url: self, target: APPS.campus, appName: 'Orija Campus' }));
  }

  const app = fromMain && t.open_in_main ? 'main' : t.app;
  const appName = app === 'campus' ? 'Orija Campus' : 'Orija';
  // Pass the sharer's referral code on to the app.
  const ref = url.searchParams.get('ref');
  let target = APPS[app] + appPath(t);
  if (ref) target += (target.includes('?') ? '&' : '?') + 'ref=' + encodeURIComponent(ref);
  res.setHeader('Cache-Control', 'public, s-maxage=300, stale-while-revalidate=3600');
  return res.end(page({
    title: t.title || appName,
    description: t.description || '',
    image: t.image,
    url: self,
    target,
    appName,
  }));
};
