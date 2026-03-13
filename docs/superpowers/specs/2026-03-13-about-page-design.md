# About Page Design Spec
**Date:** 2026-03-13
**Project:** sentinelot.com
**File to create:** `about.html`

## Context

sentinelot.com is a GitHub Pages site (deploys from `gh-pages` branch). Dark navy design using Inter font, `--navy: #141821`, `--accent: #0ea5e9`. All styles are inline in `index.html` -- `about.html` will follow the same pattern.

## Goals

- Build credibility with system integrators and OT cybersecurity firms
- Establish that Sentinel OT genuinely understands the OT/ICS world
- Signal legitimacy as a serious, focused intelligence operation
- Reveal nothing about the underlying methodology or tooling

## Design Approach

Intelligence firm positioning. Authoritative, sparse, analyst-grade tone. No sales language. No founder focus -- company-forward throughout.

## Page Structure

### Nav
Same fixed nav as `index.html`: logo left, "Get in touch" CTA right (links to `/#contact`).

### 01 — Page Header
Dark navy hero strip (not full-screen). Headline: "About Sentinel OT". Subline: "Passive ICS intelligence for critical infrastructure sectors."

### 02 — Mission
Two paragraphs:

> Critical infrastructure runs on aging control systems. Many operators don't know what's exposed or what's at risk. Sentinel OT finds them -- before the wrong people do.

> We produce qualified intelligence packages for system integrators, OT cybersecurity firms, and industrial security providers. Our work is passive, sourced entirely from public signals, and fully documented.

### 03 — What We Produce
Section header: "Each intelligence package includes:"

Three bullet points:
- **Firmware-validated CVE list** -- confirmed vulnerabilities with CVSS scores and remediation paths, cross-referenced against actual device firmware
- **Confirmed operator identity** -- attributed to a named facility or organization, not an anonymous IP block
- **Decision-maker contact information** -- the people responsible for OT infrastructure, not just a general company listing

### 04 — Sectors
Section intro: "We focus exclusively on high-value critical infrastructure:"

Five sector tiles in a grid:
- Oil & Gas
- Water & Wastewater
- Power & Utilities
- Manufacturing
- Building Automation

### 05 — Global Coverage
Single paragraph:

> Sentinel OT operates globally. Our reconnaissance is not constrained by geography -- critical infrastructure exposure does not respect borders. We deliver intelligence on operators and facilities across every major region.

### 06 — CTA
Heading: "Ready to work with qualified intelligence?"
Body: "Use the contact form on the homepage or connect with us on LinkedIn."
Two buttons: "Get in touch" (links to `/#contact`) and "LinkedIn" (links to `https://www.linkedin.com/company/sentinelot`, opens in new tab).

### Footer
Identical to `index.html` footer (including the LinkedIn icon added today).

## Styling Notes

- Match `index.html` exactly: same CSS variables, same font, same nav/footer
- Copy all required CSS into a `<style>` block in `about.html` -- no shared stylesheet
- Section labels styled as small uppercase accent text (like `--accent` color), numbered 01-06
- Bullet points use accent-colored dots, not default list markers
- Sector tiles: dark card grid (`--navy` background, light text)
- No em dashes anywhere -- use double hyphens in source, rendered as " -- "

## Deployment

Same as all site pages:
```bash
git add about.html
git commit -m "Add About page"
git push origin main && git push origin main:gh-pages
```

Also add "About" link to the nav and footer in `index.html` once the page is live.
