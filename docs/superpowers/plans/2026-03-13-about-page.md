# About Page Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build `about.html` for sentinelot.com and update `index.html` nav/footer links, deploying as a single commit to both `main` and `gh-pages`.

**Architecture:** Single self-contained HTML file with all CSS inline. Matches existing site design (Inter font, dark navy/light gray palette, same nav and footer as index.html). No JavaScript needed.

**Tech Stack:** HTML, CSS, GitHub Pages. No build tool, no test framework.

**Spec:** `docs/superpowers/specs/2026-03-13-about-page-design.md`

---

## Chunk 1: Build about.html and update index.html

### Task 1: Create about.html shell

**Files:**
- Create: `about.html`

- [ ] **Step 1: Copy index.html `<head>` block as the starting point**

Start the file with the full document wrapper, then paste the head contents:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <!-- paste index.html head contents here, then apply the replacements below -->
</head>
<body>
```

Copy everything between `<head>` and `</head>` from `index.html` into the head block. Then replace exactly these three tags:

Replace title:
```html
<title>About | Sentinel OT</title>
```

Replace meta description:
```html
<meta name="description" content="Sentinel OT produces passive ICS intelligence for system integrators and OT cybersecurity firms. Firmware-validated CVEs, confirmed operators, decision-maker contacts.">
```

Replace CSP (remove `connect-src https://formspree.io`):
```html
<meta http-equiv="Content-Security-Policy" content="default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src https://fonts.gstatic.com; img-src 'self' data:; frame-ancestors 'none';">
```

Delete the Organization JSON-LD `<script type="application/ld+json">` block entirely. Keep all other tags (charset, viewport, favicon, apple-touch-icon, referrer, Google Fonts links) unchanged.

- [ ] **Step 2: Add CSS to the `<style>` block**

The `<style>` block already exists (copied from index.html in Step 1). It contains the `:root { }` variables block and all base styles -- keep all of that. Also keep the `.nav`, `.nav-inner`, `.nav-left`, `.nav-links`, `.nav-cta`, `.container`, `.footer-*`, `.footer-linkedin` CSS exactly as copied from index.html.

Now **add** the following about-page-specific classes at the end of the `<style>` block:

```css
/* ─── ABOUT PAGE ─── */

/* Override nav opacity for inner pages (no parallax scroll) */
.nav { background: rgba(20,24,33,0.95); backdrop-filter: blur(16px); -webkit-backdrop-filter: blur(16px); }

.page-header {
  background: var(--navy);
  padding: calc(80px + 64px) 32px 64px;
  text-align: center;
}
.page-header-eyebrow {
  font-size: 1.1rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.12em;
  color: var(--accent);
  margin-bottom: 16px;
}
.page-header h1 {
  font-size: 4rem;
  font-weight: 700;
  color: #ffffff;
  margin-bottom: 12px;
  letter-spacing: -0.03em;
}
.page-header-sub {
  font-size: 1.8rem;
  color: rgba(255,255,255,0.55);
}
.about-section { padding: 80px 0; }
.about-section-inner { max-width: 720px; margin: 0 auto; padding: 0 32px; }
.section-eyebrow {
  font-size: 1.1rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--accent);
  margin-bottom: 24px;
}
.about-section p {
  font-size: 1.7rem;
  color: var(--black-7);
  line-height: 1.7;
  margin-bottom: 16px;
}
.bullet-list { display: flex; flex-direction: column; gap: 20px; margin-top: 8px; }
.bullet-item { display: flex; gap: 16px; align-items: flex-start; }
.bullet-dot { width: 6px; height: 6px; background: var(--accent); border-radius: 50%; flex-shrink: 0; margin-top: 10px; }
.bullet-item strong { color: var(--black); }
.bullet-item span { color: var(--black-7); font-size: 1.6rem; line-height: 1.6; }
.sector-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-top: 24px; }
.sector-tile { background: var(--navy); color: rgba(255,255,255,0.85); padding: 16px 20px; border-radius: 8px; font-size: 1.5rem; font-weight: 500; }
.cta-section { background: var(--navy); padding: 80px 32px; text-align: center; }
.cta-section .section-eyebrow { color: var(--accent); }
.cta-section h2 { font-size: 2.8rem; font-weight: 700; color: #ffffff; margin-bottom: 12px; letter-spacing: -0.02em; }
.cta-section p { font-size: 1.6rem; color: rgba(255,255,255,0.55); margin-bottom: 32px; }
.cta-buttons { display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; }
.btn-primary { display: inline-flex; align-items: center; padding: 12px 28px; background: var(--accent); color: #ffffff; border-radius: 8px; font-size: 1.5rem; font-weight: 500; text-decoration: none; transition: background 0.2s; }
.btn-primary:hover { background: var(--accent-hover); }
.btn-outline { display: inline-flex; align-items: center; padding: 12px 28px; border: 1px solid rgba(255,255,255,0.2); color: #ffffff; border-radius: 8px; font-size: 1.5rem; font-weight: 500; text-decoration: none; transition: border-color 0.2s, background 0.2s; }
.btn-outline:hover { border-color: rgba(255,255,255,0.4); background: rgba(255,255,255,0.05); }

@media (max-width: 768px) {
  .page-header h1 { font-size: 2.8rem; }
  .sector-grid { grid-template-columns: 1fr; }
  .cta-buttons { flex-direction: column; align-items: center; }
  .about-section-inner { padding: 0 20px; }
}
```

- [ ] **Step 3: Add nav HTML**

Copy the nav HTML from `index.html` verbatim (from `<!-- NAV -->` to the closing `</nav>`). The `.nav-links` div should contain only the "Get in touch" CTA button -- no "About" link:

```html
<nav class="nav">
  <div class="nav-inner">
    <a href="/" class="nav-left">
      <img src="SENTINEL-banner-with-shield.png" alt="Sentinel OT">
    </a>
    <div class="nav-links">
      <a href="/#contact" class="nav-cta">Get in touch</a>
    </div>
  </div>
</nav>
```

- [ ] **Step 4: Add page header**

```html
<div class="page-header">
  <div class="container">
    <div class="page-header-eyebrow">01</div>
    <h1>About Sentinel OT</h1>
    <p class="page-header-sub">Passive ICS intelligence for critical infrastructure sectors.</p>
  </div>
</div>
```

- [ ] **Step 5: Add Mission section**

```html
<section class="about-section">
  <div class="about-section-inner">
    <div class="section-eyebrow">02 -- Mission</div>
    <p>Critical infrastructure runs on aging control systems. Many operators don't know what's exposed or what's at risk. Sentinel OT finds them -- before the wrong people do.</p>
    <p>We produce qualified intelligence packages for system integrators, OT cybersecurity firms, and industrial security providers. Our work is passive, sourced entirely from public signals, and fully documented.</p>
  </div>
</section>
```

- [ ] **Step 6: Add What We Produce section**

```html
<section class="about-section" style="background: var(--bg-card);">
  <div class="about-section-inner">
    <div class="section-eyebrow">03 -- What We Produce</div>
    <p>Each intelligence package includes:</p>
    <div class="bullet-list">
      <div class="bullet-item">
        <div class="bullet-dot"></div>
        <span><strong>Firmware-validated CVE list</strong> -- confirmed vulnerabilities with CVSS scores and remediation paths, cross-referenced against actual device firmware</span>
      </div>
      <div class="bullet-item">
        <div class="bullet-dot"></div>
        <span><strong>Confirmed operator identity</strong> -- attributed to a named facility or organization, not an anonymous IP block</span>
      </div>
      <div class="bullet-item">
        <div class="bullet-dot"></div>
        <span><strong>Decision-maker contact information</strong> -- the people responsible for OT infrastructure, not just a general company listing</span>
      </div>
    </div>
  </div>
</section>
```

- [ ] **Step 7: Add Sectors section**

Note: This section uses `.container` (max-width 1200px) instead of `.about-section-inner` (max-width 720px) to give the sector grid more room. `.container` is already defined in the copied CSS from index.html.

```html
<section class="about-section">
  <div class="container">
    <div class="section-eyebrow">04 -- Sectors</div>
    <p style="color: var(--black-7); font-size: 1.6rem; margin-bottom: 0;">We focus exclusively on high-value critical infrastructure:</p>
    <div class="sector-grid">
      <div class="sector-tile">Oil &amp; Gas</div>
      <div class="sector-tile">Water &amp; Wastewater</div>
      <div class="sector-tile">Power &amp; Utilities</div>
      <div class="sector-tile">Medical Devices</div>
    </div>
  </div>
</section>
```

- [ ] **Step 8: Add Global Coverage section**

```html
<section class="about-section" style="background: var(--bg-card);">
  <div class="about-section-inner">
    <div class="section-eyebrow">05 -- Coverage</div>
    <p>Sentinel OT operates globally. Our reconnaissance is not constrained by geography -- critical infrastructure exposure does not respect borders. We deliver intelligence on operators and facilities across every major region.</p>
  </div>
</section>
```

- [ ] **Step 9: Add CTA section**

```html
<div class="cta-section">
  <div class="section-eyebrow">06 -- Work With Us</div>
  <h2>Ready to work with qualified intelligence?</h2>
  <p>Use the contact form on the homepage or connect with us on LinkedIn.</p>
  <div class="cta-buttons">
    <a href="/#contact" class="btn-primary">Get in touch</a>
    <a href="https://www.linkedin.com/company/sentinelot" target="_blank" rel="noopener" class="btn-outline">LinkedIn</a>
  </div>
</div>
```

- [ ] **Step 10: Add footer**

Copy the entire footer HTML and all related CSS from `index.html` verbatim. This includes:
- All HTML from `<!-- FOOTER -->` to `</footer>`
- All `.footer-grid`, `.footer-brand`, `.footer-col`, `.footer-bottom`, `.footer-linkedin` CSS rules (already present from the Step 1 copy -- verify they are there)
- The LinkedIn icon: `icons/linkedin.png`, 20px, opacity 0.5, full opacity on `.footer-linkedin:hover img`

Close the `</body>` and `</html>` tags after the footer.

- [ ] **Step 11: Visual check**

Open `about.html` via a local server (not `file://` -- the `/#contact` links won't resolve). Use VS Code Live Server or `python3 -m http.server 8080` from the `sentinelot-site` directory, then open `http://localhost:8080/about.html`.

Verify:
- Nav: fixed at top, dark navy, logo on left, "Get in touch" button on right
- Page header: dark navy strip, "01" label, large "About Sentinel OT" headline, muted subline
- Section 02: light gray bg, "02 -- MISSION" label, two paragraphs
- Section 03: card bg, "03 -- WHAT WE PRODUCE" label, three bullet items with blue dots
- Section 04: light gray bg, "04 -- SECTORS" label, 2-column grid of 4 dark navy tiles
- Section 05: card bg, "05 -- COVERAGE" label, one paragraph
- Section 06: dark navy bg, "06 -- WORK WITH US" label, two buttons side by side
- Footer: identical to homepage footer, LinkedIn icon visible in footer-bottom
- Nav: does NOT contain an "About" link (only "Get in touch" CTA -- no self-referential link)

---

### Task 2: Verify page on mobile

- [ ] **Step 1: Resize browser to 375px wide**

Verify:
- Sector grid collapses to 1 column
- CTA buttons stack vertically
- No horizontal scroll
- Nav shows only the CTA button

---

### Task 3: Update index.html

**Files:**
- Modify: `index.html`

- [ ] **Step 1: Add About link to nav**

In `index.html`, find the `.nav-links` div and add the About link before the CTA button:

```html
<div class="nav-links">
  <a href="/about.html">About</a>
  <a href="#contact" class="nav-cta">Get in touch</a>
</div>
```

- [ ] **Step 2: Update footer Resources link**

Find this line in the footer Resources column:
```html
<a href="#contact">About Sentinel OT</a>
```

Change to:
```html
<a href="/about.html">About Sentinel OT</a>
```

---

### Task 4: Commit and deploy

- [ ] **Step 1: Commit both files together**

```bash
git add about.html index.html
git commit -m "Add About page, update nav and footer links"
```

Expected output: 2 files changed.

- [ ] **Step 2: Push to both branches**

```bash
git push origin main && git push origin main:gh-pages
```

Expected: Both pushes succeed with no errors.

- [ ] **Step 3: Verify live**

Wait 1-2 minutes for GitHub Pages to deploy, then verify:
- `https://sentinelot.com/about.html` loads the About page correctly
- Homepage nav shows "About" link
- Footer "About Sentinel OT" navigates to `/about.html`
- About page footer and nav render correctly on desktop and mobile
