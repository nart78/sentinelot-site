# Sentinel OT Website — Architecture

## What This Site Is

The public corporate website for Sentinel OT. Its purpose is brand presence and inbound pipeline. Target audiences are OT security buyers, industrial operators, OT integrators, and cyber insurance underwriters.

The site is marketing and credibility infrastructure. It does not host the product, a portal, or any customer-facing tools.

---

## Deployment Model

**Repo:** `nart78/sentinelot-site` (GitHub)
**Hosting:** GitHub Pages
**Domain:** `sentinelot.com`
**Branch strategy:** Content lives on `main`. GitHub Pages serves from `gh-pages`.

**Every deploy must push to both branches:**

```bash
git push origin main && git push origin main:gh-pages
```

Pushing to `main` only will not update the live site. Pushing to `gh-pages` only will lose the commit on `main`. Both pushes are required, every time.

---

## Page Inventory

| File | Purpose |
|------|---------|
| `index.html` | Homepage. Primary entry point. Brand positioning, value proposition, contact. |
| `about.html` | Company background, methodology overview, team positioning. |
| `privacy.html` | Privacy policy. Required for credibility with enterprise and regulated buyers. |
| `terms.html` | Terms of service / terms of use. |

All pages are static HTML/CSS/JS. No backend, no build step, no framework.

---

## Content Strategy

The site's primary organic content vehicle is a LinkedIn article series. Four articles are drafted, each targeting a specific audience segment:

| Article | Target Audience |
|---------|----------------|
| 1 | Intelligence gap audience (security teams unaware of OT exposure) |
| 2 | OT integrators (system integrators who deploy and maintain OT) |
| 3 | Cyber insurance underwriters (quantifying OT risk for policy pricing) |
| 4 | Industrial operators (plant managers, operations directors) |

Article source files: `docs/linkedin-articles/` (four `.md` files).

LinkedIn articles link back to sentinelot.com and build topical authority for passive OT intelligence as a category.

---

## Brand Asset Inventory

| File | Use |
|------|-----|
| `SENTINEL-banner-with-shield.png` | Primary banner. Used in reports, email headers, cover pages. |
| `SENTINEL-banner-no-shield.png` | Alternate banner (no shield graphic). |
| `logo.png` | Square/icon logo. Favicons, nav, social profiles. |

Brand assets are also used by Iris (report writer) and Argus. The report PDF template (`sentinel-premium`) references `SENTINEL-banner-with-shield.png` from `~/argus/reports/`. Do not rename or move these files without updating those references.

---

## docs/ Folder Structure

```
docs/
  architecture.md              <- this file
  linkedin-articles/
    article-1-*.md             <- Intelligence gap audience
    article-2-*.md             <- OT integrators
    article-3-*.md             <- Underwriters
    article-4-*.md             <- Operators
  superpowers/
    plans/                     <- Feature and page planning documents
    specs/                     <- Technical specs for planned features
```

The `superpowers/` subfolder contains planning docs for future site features. Check there before starting any new feature work.

---

## OPSEC Rules for All Site Content

These rules apply to every page, article, and document published under the sentinelot.com domain or the nart78/sentinelot-site repo.

**Never mention:**
- Shodan
- Censys
- GreyNoise
- Any specific third-party reconnaissance platform or data provider by name

**Use instead:**
- "Proprietary passive reconnaissance"
- "Passive intelligence techniques"
- "Public signal analysis"
- "Open-source intelligence"

Rationale: naming specific tools exposes methodology, creates competitive risk, and may complicate customer relationships. The positioning is Sentinel OT's own intelligence capability, not a resale of third-party data.

This rule also applies to the LinkedIn articles, any press or media content, and any other material that references the sentinelot.com site or Sentinel OT's methodology.
