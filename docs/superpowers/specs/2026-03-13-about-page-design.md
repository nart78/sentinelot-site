# About Page Design Spec
**Date:** 2026-03-13
**Project:** sentinelot.com
**File to create:** `about.html`

## Typography Convention

All dashes in copy use ` -- ` (space, double hyphen, space). Renders as literal ` -- ` in the browser. Never use em dashes (`&mdash;` or `—`) anywhere.

## Context

sentinelot.com is a GitHub Pages site (deploys from `gh-pages` branch). Each page is a self-contained `.html` file with all CSS in a `<style>` block -- no shared stylesheet. Inter font. CSS variables:

```css
--bg: #f3f3f3;
--bg-card: #e8e8e8;
--white: #ffffff;
--black: #151515;
--black-7: rgba(0,0,0,0.48);
--accent: #0ea5e9;
--accent-hover: #38bdf8;
--navy: #141821;
--navy-light: #1a1f2e;
--navy-mid: #242a3a;
--font: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
```

Body background: `var(--bg)` (#f3f3f3, light gray). Nav/hero/footer/CTA section use dark navy.

## Head Boilerplate

Copy the full `<head>` block from `index.html`, then replace only these three tags:

```html
<title>About | Sentinel OT</title>
<meta name="description" content="Sentinel OT produces passive ICS intelligence for system integrators and OT cybersecurity firms. Firmware-validated CVEs, confirmed operators, decision-maker contacts.">
<meta http-equiv="Content-Security-Policy" content="default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src https://fonts.gstatic.com; img-src 'self' data:; frame-ancestors 'none';">
```

Keep charset, viewport, favicon, apple-touch-icon, referrer, and Google Fonts links unchanged. Do NOT copy the Organization JSON-LD schema block.

## Goals

- Build credibility with system integrators and OT cybersecurity firms
- Establish that Sentinel OT genuinely understands the OT/ICS world
- Signal legitimacy as a serious, focused intelligence operation
- Reveal nothing about the underlying methodology or tooling

## Design Approach

Intelligence firm positioning. Authoritative, sparse, analyst-grade tone. No sales language. No founder focus.

## CSS Reference

All CSS goes in a single `<style>` block. Copy nav and footer CSS verbatim from `index.html`. New classes needed for this page:

```css
/* Nav: inner pages use higher opacity (no parallax scroll effect) */
.nav { background: rgba(20,24,33,0.95); backdrop-filter: blur(16px); }

/* Page header strip */
.page-header {
  background: var(--navy);
  padding: calc(80px + 64px) 32px 64px; /* top accounts for 64px fixed nav */
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

/* Content sections */
.about-section {
  padding: 80px 0;
}
.about-section-inner {
  max-width: 720px;
  margin: 0 auto;
  padding: 0 32px;
}
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

/* Bullet items with accent dot */
.bullet-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
  margin-top: 8px;
}
.bullet-item {
  display: flex;
  gap: 16px;
  align-items: flex-start;
}
.bullet-dot {
  width: 6px;
  height: 6px;
  background: var(--accent);
  border-radius: 50%;
  flex-shrink: 0;
  margin-top: 10px;
}
.bullet-item strong { color: var(--black); }
.bullet-item span { color: var(--black-7); font-size: 1.6rem; line-height: 1.6; }

/* Sector grid */
.sector-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 8px;
  margin-top: 24px;
}
.sector-tile {
  background: var(--navy);
  color: rgba(255,255,255,0.85);
  padding: 16px 20px;
  border-radius: 8px;
  font-size: 1.5rem;
  font-weight: 500;
}

/* CTA section */
.cta-section {
  background: var(--navy);
  padding: 80px 32px;
  text-align: center;
}
.cta-section .section-eyebrow { color: var(--accent); }
.cta-section h2 {
  font-size: 2.8rem;
  font-weight: 700;
  color: #ffffff;
  margin-bottom: 12px;
  letter-spacing: -0.02em;
}
.cta-section p {
  font-size: 1.6rem;
  color: rgba(255,255,255,0.55);
  margin-bottom: 32px;
}
.cta-buttons {
  display: flex;
  gap: 12px;
  justify-content: center;
  flex-wrap: wrap;
}
.btn-primary {
  display: inline-flex;
  align-items: center;
  padding: 12px 28px;
  background: var(--accent);
  color: #ffffff;
  border-radius: 8px;
  font-size: 1.5rem;
  font-weight: 500;
  text-decoration: none;
  transition: background 0.2s;
}
.btn-primary:hover { background: var(--accent-hover); }
.btn-outline {
  display: inline-flex;
  align-items: center;
  padding: 12px 28px;
  border: 1px solid rgba(255,255,255,0.2);
  color: #ffffff;
  border-radius: 8px;
  font-size: 1.5rem;
  font-weight: 500;
  text-decoration: none;
  transition: border-color 0.2s, background 0.2s;
}
.btn-outline:hover { border-color: rgba(255,255,255,0.4); background: rgba(255,255,255,0.05); }

/* Responsive */
@media (max-width: 768px) {
  .page-header h1 { font-size: 2.8rem; }
  .sector-grid { grid-template-columns: 1fr; }
  .cta-buttons { flex-direction: column; align-items: center; }
}
```

## Page Structure

### Nav
Copy nav HTML from `index.html` verbatim. The `.nav-links` div contains only the CTA button -- no "About" link yet.

### Page Header
```html
<div class="page-header">
  <div class="container">
    <div class="page-header-eyebrow">01</div>
    <h1>About Sentinel OT</h1>
    <p class="page-header-sub">Passive ICS intelligence for critical infrastructure sectors.</p>
  </div>
</div>
```

### Section 02 -- Mission
```html
<section class="about-section">
  <div class="about-section-inner">
    <div class="section-eyebrow">02 -- Mission</div>
    <p>Critical infrastructure runs on aging control systems. Many operators don't know what's exposed or what's at risk. Sentinel OT finds them -- before the wrong people do.</p>
    <p>We produce qualified intelligence packages for system integrators, OT cybersecurity firms, and industrial security providers. Our work is passive, sourced entirely from public signals, and fully documented.</p>
  </div>
</section>
```

### Section 03 -- What We Produce
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

### Section 04 -- Sectors
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

### Section 05 -- Global Coverage
```html
<section class="about-section" style="background: var(--bg-card);">
  <div class="about-section-inner">
    <div class="section-eyebrow">05 -- Coverage</div>
    <p>Sentinel OT operates globally. Our reconnaissance is not constrained by geography -- critical infrastructure exposure does not respect borders. We deliver intelligence on operators and facilities across every major region.</p>
  </div>
</section>
```

### Section 06 -- CTA
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

### Footer
Copy footer HTML and CSS from `index.html` verbatim, including the LinkedIn icon (`icons/linkedin.png`, 20px, opacity 0.5, full opacity on hover via `.footer-linkedin:hover img`).

## Deployment

Batch both the new page and the index.html updates into one commit:

```bash
# 1. Build about.html (this spec)
# 2. Update index.html nav and footer (see below)
# 3. Commit and push together
git add about.html index.html
git commit -m "Add About page, update nav and footer links"
git push origin main && git push origin main:gh-pages
```

### index.html changes (apply before committing):

**Nav** -- add inside `.nav-links` before the CTA button:
```html
<a href="/about.html">About</a>
```

**Footer Resources column** -- change:
```html
<a href="#contact">About Sentinel OT</a>
```
to:
```html
<a href="/about.html">About Sentinel OT</a>
```
