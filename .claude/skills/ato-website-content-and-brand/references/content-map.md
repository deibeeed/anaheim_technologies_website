# Content map — every on-page string and where it lives

Verified 2026-07-07 against the website repo. All copy is hardcoded English
string literals in Dart widgets (or in `web/index.html` for the shell). There is
no CMS and no live l10n. Line anchors are stable-ish but re-grep the phrase if a
number looks off.

## `/` — home (`lib/features/home/screen/home_screen_content.dart`)

| Copy | Anchor |
|------|--------|
| Hero: "We turn ideas into shipped products — web, mobile, cloud, and hardware…" | `:22` |
| Tagline "Ideas -\nDelivered" (Plavsky, rendered twice: expanded `:34`, compact `:46`) | `:34`, `:46` |
| "Our services" / "Contact us" buttons | `:68`, `:90` |
| Service selector buttons: "Branding" `:313`, "Product Design, Development and Prototyping" `:340`, "Virtual Teams" `:367` | `:292-373` |
| Service blurb `switch` (state 0 branding / 1 product / 2 virtual teams) | `:130-137` |
| "Are you ready to co-create with us?" | `:154` |
| "We are excited to work with you!" | `:167` |
| "Talk to us today" booking button → `https://bit.ly/CallATO` | `:179`,`:195` |
| "CURRENTLY BUILDING" eyebrow | `:207` |
| "Loooans" (Plavsky) | `:216` |
| "The first product on our fintech stack. Now in closed beta.\nWe dogfood every stack we recommend." | `:226` |
| Footer: "ATO" wordmark (Mechsuit) + Facebook/LinkedIn SVG links | `:243-280` |

The service selector state is driven by `ServiceSelectCubit` (0=branding,
1=pdd, 2=vt). The blurb text is a separate `switch` on the same state.

## `/services` (`lib/features/services/screen/services_screen.dart`)

Four narrative locals, then fed to `MasterDetailScreen`:

| Narrative local | Anchor |
|-----------------|--------|
| `pddNarrative` — "Imagine an idea sitting in a notes app…" | `:21-26` |
| `prototypingNarrative` — "Some products can't live entirely on a screen…" (mentions GlacierGrid, YC-backed IoT, LoRaWAN) | `:28-33` |
| `virtualTeamsNarrative` — "Building a team is hard…" | `:35-40` |
| `brandingNarrative` — "Your brand is the first thing customers see…" | `:42-45` |
| `titleList` = Branding / Product design and development / Prototyping / Virtual teams | `:52-57`, `:73-78` |

Note the compact (`!Constants.isExpandedScreen`) and expanded branches build the
same content two different ways (`:47-67` vs `:69-110`) — edit both if you
restructure.

## `/projects` (`lib/features/projects/screen/projects_screen.dart`)

Three index-aligned lists on `MasterDetailScreen` — item `i` in each describes
the same case study:

| List | Content | Anchor |
|------|---------|--------|
| `titleList` | `'BPV Loan Monitoring'`, `'[PROTOTYPE] HLP Systems'` | `:22-24` |
| `narrativeList` | BPV description (Baybay Property Ventures Corp, loan/lot monitoring); HLP description (collections/remittances, "Integrity, Accountability and Security") | `:26-40` |
| `detailList` | `[0]` stacked screenshots `assets/images/pic1..3.png`; `[1]` `assets/svg/3d-model.svg` tinted green | `:42-77` |

Known copy typos present in source (leave unless doing a deliberate copy pass):
"andhow" (`:32`), "application andhow we can help" — verbatim in the narrative.

## `/us` — about (`lib/features/about_us/screen/about_us_screen.dart`)

| Copy | Anchor |
|------|--------|
| Bio `Text.rich`: "Anaheim Technologies is a specialist product studio — small by design, senior by default…" (13+ yrs, ex-GlacierGrid, Loooans, "even this website is written in Flutter") | `:29-41` |
| Inline "Talk to us today!" link → `/contact` | `:47-55` |
| Tech-logo `Wrap` — 14 SVGs from `assets/svg/` | `:68-82` |

The 14 logos, in order: flutter, dart, firebase, gcp (full), golang, java
(full), kotlin, nodejs, python, swift, typescript, cpp, gcp_iot_core,
lorawan (dark). Rendered at `height: 56`.

## `/contact` (`lib/features/contact_us/screen/contact_us_screen.dart`)

Booking button + name/email/message form. Copy lives here; the form's
write-to-Firestore behaviour is documented in
**ato-website-inquiries-and-integration**, not here.

## `/privacy` (`lib/features/privacy/screen/privacy_screen.dart`)

Short Data-Privacy-Act-of-2012 (Philippines) notice.

## Shell / SEO copy (`web/index.html`)

| Copy | Anchor |
|------|--------|
| `<meta name="description">` — "Anaheim Technologies is a specialist product studio…" | `:22` |
| Open Graph title/description/url/image | `:25-29` |
| Twitter card title/description/url/image | `:32-36` |
| `<title>` "Anaheim Technologies — Ideas, Delivered" | `:47` |
| Splash markup "ATO" / pulse / "Ideas — Delivered" | `:106-110` |

If you rebrand the tagline or company blurb, update the on-page Dart copy **and**
these meta/OG/Twitter tags so shares and search results match.
