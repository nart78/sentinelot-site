# Sentinel OT Website -- Design Reference

Use this reference to design new pages that match the existing site's visual language.

## Tech Stack

- Static HTML, inline `<style>` per page (no external CSS files, no build step)
- Fonts loaded from Google Fonts
- No JavaScript framework -- vanilla JS only for interactions
- Deployed via GitHub Pages

## Fonts

```css
font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;  /* body/headings */
font-family: 'JetBrains Mono', ui-monospace, SFMono-Regular, Menlo, monospace;                /* labels, data, eyebrows */
```

Load via:
```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
```

## Color Tokens

```css
:root {
  /* Backgrounds (dark) */
  --navy-950: #0b0e14;    /* footer, deepest dark */
  --navy-900: #0f131b;    /* secondary dark sections */
  --navy-850: #141821;    /* primary dark bg (body default) */

  /* Borders */
  --line: rgba(255,255,255,0.08);         /* default border */
  --line-strong: rgba(255,255,255,0.14);  /* emphasized border */
  --line-faint: rgba(255,255,255,0.04);   /* dashed separators */

  /* Text (on dark) */
  --text-hi: #f4f6fa;     /* headings, primary text */
  --text-mid: #c9d0db;    /* body paragraphs */
  --text-lo: #8892a3;     /* secondary labels */
  --text-dim: #5b6473;    /* tertiary, timestamps */

  /* Accent */
  --accent: #0ea5e9;                       /* sky-500, primary brand color */
  --accent-soft: rgba(14,165,233,0.18);    /* accent backgrounds, glows */

  /* Semantic */
  --red: #c0392b;  /* severity, danger (used on homepage) */
}
```

### Light sections (white bg)
- Background: `#ffffff`
- Heading text: `#151515`
- Body text: `rgba(0,0,0,0.64)`
- Strong/bold text: `#151515`
- Accent stays `--accent: #0ea5e9`

## Typography Scale

### Headings
| Element | Size | Weight | Letter-spacing | Line-height | Notes |
|---------|------|--------|----------------|-------------|-------|
| Hero h1 | 66px | 500 | -0.028em | 1.02 | Mobile: 36px |
| Section h2 (dark) | 40-44px | 500 | -0.025em | 1.08-1.1 | Mobile: 28-30px |
| Section h2 (light) | 44px | 500 | -0.025em | 1.08 | Mobile: 30px |
| Card h3 | 20px | 500 | -0.01em | 1.3 | |

### Body
| Context | Size | Weight | Line-height | Color |
|---------|------|--------|-------------|-------|
| Hero subtitle | 17px | 400 | 1.55 | --text-mid |
| Section lead | 19px | 400 | 1.55 | --text-mid |
| Body (dark bg) | 17px | 400 | 1.65 | --text-mid |
| Body (light bg) | 17px | 400 | 1.65 | rgba(0,0,0,0.64) |
| Card body | 15px | 400 | 1.6 | --text-mid or --text-lo |

### Labels & Eyebrows
| Type | Font | Size | Weight | Letter-spacing | Transform |
|------|------|------|--------|----------------|-----------|
| Eyebrow | JetBrains Mono | 11px | 400 | 0.14em | uppercase |
| Tick label | JetBrains Mono | 10px | 400 | 0.18em | uppercase |
| Section caps | JetBrains Mono | ~0.65em of parent | 500 | 0.02em | uppercase |

Eyebrows are always `--accent` color on dark bg, or `--accent` on light bg.

## Spacing & Layout

- Max content width: `1080px` (centered with `margin: 0 auto`)
- Section padding: `96px 56px` (vertical horizontal)
- Mobile section padding: `64px 22px`
- Nav padding: `29px 56px`
- Mobile nav padding: `16px 20px`

## Component Patterns

### Navigation
```
Fixed top bar, semi-transparent with blur:
  background: rgba(11,14,20,0.7)
  backdrop-filter: blur(8px)
  border-bottom: 1px solid var(--line)

Left: Logo image (SENTINEL-banner-with-shield.png, height: 42px)
Right: text links + primary CTA button
Mobile: hamburger toggle, links stack vertically
```

### Buttons
```css
/* Primary (accent bg, dark text) */
.btn-primary {
  background: var(--accent);
  color: #03131f;
  font-weight: 600;
  font-size: 14px;
  padding: 14px 22px;
  border-radius: 2px;  /* NOTE: sharp corners, not rounded */
}

/* Ghost (transparent, border) */
.btn-ghost {
  background: transparent;
  color: var(--text-hi);
  border: 1px solid var(--line-strong);
  border-radius: 2px;
}

/* Text link with arrow */
.btn-text {
  background: transparent;
  color: var(--text-mid);
  padding: 14px 0;
}

/* Arrow pattern: span with class "arrow", content "→", slides right on hover */
```

### Section Eyebrow Pattern
Every section starts with:
1. A mono eyebrow label in accent color (e.g., "THE PROBLEM", "HOW IT WORKS")
2. Then a large h2 heading
3. Then optional lead paragraph

On dark bg, the eyebrow is rendered as a `<span class="caps">` inside the h2.
On about page, it's a separate `<div class="section-eyebrow">`.

### Cards / Grid Items

**Dark cards (beliefs grid, barrier grid):**
```
Grid with 2px gap, border around the whole grid.
Individual cards: background: var(--navy-900) or var(--navy-850)
Padding: 28-36px
No individual borders or border-radius -- the gap between cards IS the border.
```

**Incident cards (homepage):**
```
Dark bg (--navy-850), 1px solid var(--line-strong) border, border-radius: 3px
Hover: border turns accent, box-shadow with accent glow
Contains: sector icon, location label (mono, accent), date (mono, dim), headline, tag line
Click opens modal
```

### Data/Findings Panel (proof section)
```
Dark panel with border, internal rows in monospace
Header: flex with label + severity badge
Rows: 2-column grid (88px label | value), dashed bottom borders
Footer: 3-column severity indicators (red badges)
Color coding: .danger = --red, .warn = --accent
```

### Section Separator Bar
```html
<div class="sep-rule">
  <span class="tick">SECTION LABEL</span>
  <span class="mid"></span>  <!-- 1px line fills space -->
  <span class="right">
    <span class="tick">META 1</span>
    <span class="tick">META 2</span>
  </span>
</div>
```
This creates a horizontal bar with label left, line in middle, meta-labels right. Used between hero and problem section.

### Contact Form
```
2-column grid layout
Labels: mono, 10px, uppercase, dim color
Inputs: dark bg (--navy-850), 1px border (--line-strong), 15px Inter text
Focus: border turns accent
Submit row: note text left, primary button right
```

### Footer
```
4-column grid: brand (2fr) | col | col | col (each 1fr)
Background: --navy-950 (darkest)
Bottom bar: copyright left, links right, 1px border-top
Text: rgba(255,255,255, 0.25-0.55)
Mobile: stacks to single column
```

## Section Background Pattern

The site alternates section backgrounds:
1. **Dark (--navy-850):** Hero, beliefs
2. **Navy (--navy-900):** Funding gap, "what we don't do", locations. Has border-top/bottom.
3. **White (#ffffff):** Problem section, pipeline, "what we do". Text colors flip to dark.
4. **Deepest (--navy-950):** Footer, CTA bands

Borders between sections: `1px solid var(--line)` or `var(--line-strong)`.

## Responsive Breakpoints

```css
@media (max-width: 1100px) { /* tablet: reduce grid columns, gap */ }
@media (max-width: 720px)  { /* mobile: single column, smaller type, hamburger nav */ }
```

Mobile changes:
- Headings drop ~35-40% in size
- Grids collapse to 1 or 2 columns
- Horizontal padding goes from 56px to 22px
- CTAs stack vertically, full-width
- Nav links hidden behind hamburger

## Key Visual Elements

- **Aurora gradient:** Animated background in hero (two layers of repeating-linear-gradient with blur, low opacity)
- **Crosshair grid:** SVG pattern overlay (120px repeat, faint cross marks)
- **Pulsing dots:** SVG circles on the US map with per-dot randomized animation timing
- **Redacted text:** `background: rgba(255,255,255,0.08); color: transparent` for blacked-out IP addresses
- **Live indicator:** Green/accent dot with pulse animation + "LIVE" label in mono

## Existing Nav Links

Current navigation:
- About (about.html)
- Sample Report (sample-report.pdf, opens in new tab)
- Get in touch (primary CTA button, scrolls to #contact or links to /#contact)

## Live Site Structure

The live site has two pages (plus legal):

```
sentinelot-site/
  index.html          -- Homepage (the main page)
  about.html          -- About page
  privacy.html        -- Privacy policy
  terms.html          -- Terms of service
  sample-report.pdf   -- Downloadable sample report
  SENTINEL-banner-with-shield.png  -- Logo (used in nav + footer)
  us-map-dots.png     -- US map for hero panel
  usa.jpg             -- US map for about page
  favicon.ico
  apple-touch-icon.png
```

### Homepage sections (top to bottom):
1. Nav bar (semi-transparent, blur, fixed on about page)
2. Hero: large headline left, interactive map panel right, aurora gradient bg
3. Section separator bar (mono labels, horizontal rule)
4. "The Problem" section (WHITE bg) -- two-column text + 3 incident cards with click-to-open modals
5. "The Funding Gap" section (navy-900 bg) -- 4-column barrier grid
6. Proof strip (dark bg with scan-line texture) -- redacted assessment excerpt + findings panel
7. "How It Works" pipeline (WHITE bg) -- 4 numbered stages with connected line
8. Contact form (navy-900 bg) -- 2-column layout with form
9. Footer (navy-950 bg) -- 4-column grid

### About page sections (top to bottom):
1. Nav bar (fixed)
2. Page header (centered headline + subtitle, dark bg)
3. "What We Do" section (WHITE bg) -- single-column prose
4. "Before We Engage" section (navy-900 bg) -- list with red X markers
5. "Principles" section (navy-850 bg) -- 2x2 beliefs card grid
6. "Locations" section (navy-900 bg) -- 2-column: text left, globe image right
7. CTA band (navy-950 bg) -- centered headline + two buttons
8. Footer (navy-950 bg)

## Design Notes for New Pages

- Follow the index.html/about.html design language. Both use the same tokens, type scale, and component patterns.
- The site uses `border-radius: 2px` everywhere (sharp, not rounded).
- All CSS is inline in `<style>` tags. No external stylesheet.
- No CSS framework. Everything is hand-written.
- Global `letter-spacing: -0.005em` on body.
- Global `-webkit-font-smoothing: antialiased`.
- Sections alternate between dark bg variants and white bg. White sections flip all text colors to dark.
- The about page uses a fixed nav (`position: fixed`) with padding-top on the first section to compensate. The homepage nav is not fixed.
