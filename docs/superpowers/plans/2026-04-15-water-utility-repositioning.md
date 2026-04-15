# Water Utility Repositioning Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Pivot the public website to focus exclusively on US water utilities, delivering a find/fund/fix/monitor value proposition under the "IT/OT security partner" positioning, with a fabricated sample report and a methodology page for credibility.

**Architecture:** Rewrite the existing self-contained HTML files (index.html, about.html) and add one new page (methodology.html). The site uses inline CSS and inline JavaScript per file with no build step or test framework. Content safety is enforced by grep-based guardrail scripts run before every commit. A composite sample report PDF is produced via the Iris pipeline and shipped into the repo as a static asset.

**Tech Stack:** Static HTML, inline CSS, inline vanilla JavaScript, Formspree for contact form, GitHub Pages deployment from the `gh-pages` branch. Sample report produced via the existing `pdf-export` skill with the `sentinel-premium` theme.

**Spec:** [docs/superpowers/specs/2026-04-15-water-utility-repositioning-design.md](../specs/2026-04-15-water-utility-repositioning-design.md)

---

## Important Context for the Implementer

You are modifying a live marketing site that represents a real business. Every piece of copy matters. Follow these rules without exception:

1. **Do not invent copy from scratch.** The spec contains the exact headlines, subheads, and paragraphs for every section. Use the spec text verbatim unless the task explicitly says "expand into full paragraphs" and gives you guardrails.
2. **Inline CSS, inline JS.** The site has no build pipeline. Each HTML file carries its own `<style>` block and any needed `<script>` tags. Do not extract CSS to external files. Do not introduce a bundler.
3. **Self-contained pages.** Each HTML file duplicates the base CSS variables and nav styles. This is intentional. Do not try to DRY it.
4. **No em dashes in body copy.** The rule is enforced by a guardrail script. Use periods, commas, or restructure sentences. Em dashes are permitted only in headings, tables, or code blocks if grammar requires.
5. **No forbidden words.** Never write "Shodan", "Censys", "SOAP", "Soap Engineering", "Outer Eye", or "memo" anywhere in any HTML file, comment, alt text, or meta tag. The guardrail script enforces this.
6. **OPSEC comes first.** If a task conflicts with the OPSEC checklist in the spec, stop and escalate to the user.
7. **Commit frequently.** Every task ends in a commit. Do not batch.
8. **Deployment requires double push.** The site deploys from `gh-pages`, not `main`. Every push goes to both branches.

---

## File Structure

**Files created by this plan:**
- `scripts/opsec-check.sh` - Grep-based guardrail script
- `scripts/link-check.sh` - Internal link validation script
- `methodology.html` - New page, long-form technical detail
- `sample-report.pdf` - Fabricated composite vulnerability report (generated out of repo, copied in)
- `docs/superpowers/plans/2026-04-15-water-utility-repositioning.md` - This plan (already exists)

**Files modified by this plan:**
- `index.html` - Full body rewrite, CSS additions, schema.org update
- `about.html` - Full body rewrite, nav update

**Files unchanged:**
- `privacy.html`, `terms.html`, `CNAME`, static assets (logo PNGs, favicon, icons), existing `docs/*`, existing `pitch/*`

---

## Phase 0: Guardrails

This phase produces the content safety scripts that every subsequent task uses to gate commits. Build the guardrails first so every edit afterward is verified automatically.

### Task 1: Create the OPSEC check script

**Files:**
- Create: `scripts/opsec-check.sh`

- [ ] **Step 1: Create the scripts directory**

```bash
cd /home/ubuntu/sentinelot-site && mkdir -p scripts
```

- [ ] **Step 2: Write the OPSEC check script**

Create `scripts/opsec-check.sh` with this exact content:

```bash
#!/usr/bin/env bash
# OPSEC guardrail for sentinelot-site. Run before every commit.
# Exits non-zero if any forbidden content is present in HTML files.

set -u

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

FAIL=0

FORBIDDEN_WORDS=(
  "Shodan"
  "shodan"
  "Censys"
  "censys"
  "SOAP"
  "Soap Engineering"
  "soap engineering"
  "Outer Eye"
  "outer eye"
  "memo"
  "Memo"
)

HTML_FILES=(index.html about.html methodology.html privacy.html terms.html)

echo "== OPSEC check =="
for f in "${HTML_FILES[@]}"; do
  if [ ! -f "$f" ]; then
    continue
  fi
  for word in "${FORBIDDEN_WORDS[@]}"; do
    if grep -Fn -- "$word" "$f" > /dev/null; then
      echo "FAIL: '$word' found in $f"
      grep -Fn -- "$word" "$f"
      FAIL=1
    fi
  done
done

echo ""
echo "== Em dash check =="
for f in "${HTML_FILES[@]}"; do
  if [ ! -f "$f" ]; then
    continue
  fi
  if grep -n $'\xe2\x80\x94' "$f" > /dev/null; then
    echo "FAIL: em dash found in $f"
    grep -n $'\xe2\x80\x94' "$f"
    FAIL=1
  fi
done

echo ""
if [ $FAIL -eq 0 ]; then
  echo "OK: no forbidden content found"
  exit 0
else
  echo "FAIL: OPSEC check found issues"
  exit 1
fi
```

- [ ] **Step 3: Make it executable and run it against the current repo**

```bash
chmod +x scripts/opsec-check.sh && ./scripts/opsec-check.sh
```

Expected: Likely FAIL on the current files. Note which files and which words fail. Record them for reference but do NOT fix the existing files in this task. The whole point of Phase 2 is to rewrite them, so failures will resolve naturally.

- [ ] **Step 4: Commit the script**

```bash
git add scripts/opsec-check.sh
git commit -m "$(cat <<'EOF'
Add OPSEC guardrail script

Grep-based check for forbidden words (Shodan, Censys, SOAP, Outer
Eye, memo) and em dashes in HTML files. Run before every commit to
prevent regressions.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

### Task 2: Create the link check script

**Files:**
- Create: `scripts/link-check.sh`

- [ ] **Step 1: Write the script**

Create `scripts/link-check.sh` with this exact content:

```bash
#!/usr/bin/env bash
# Internal link check for sentinelot-site.
# Extracts href values from HTML files and verifies each local target exists.

set -u

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

FAIL=0
HTML_FILES=(index.html about.html methodology.html privacy.html terms.html)

echo "== Link check =="
for f in "${HTML_FILES[@]}"; do
  if [ ! -f "$f" ]; then
    continue
  fi
  # Extract href values
  while IFS= read -r href; do
    # Skip external, anchor-only, mailto, tel, and javascript
    case "$href" in
      http*|mailto:*|tel:*|javascript:*|\#*|"")
        continue
        ;;
    esac
    # Strip leading slash and fragment
    target="${href#/}"
    target="${target%%#*}"
    if [ -z "$target" ]; then
      continue
    fi
    if [ ! -e "$target" ]; then
      echo "FAIL: $f references missing $target"
      FAIL=1
    fi
  done < <(grep -oE 'href="[^"]*"' "$f" | sed -E 's/href="([^"]*)"/\1/')
done

if [ $FAIL -eq 0 ]; then
  echo "OK: all internal links resolve"
  exit 0
else
  echo "FAIL: link check found broken links"
  exit 1
fi
```

- [ ] **Step 2: Make executable and run it**

```bash
chmod +x scripts/link-check.sh && ./scripts/link-check.sh
```

Expected: May flag links to files that will exist after Phase 2 through 4 (methodology.html, sample-report.pdf). Any failures now get resolved naturally as files are created.

- [ ] **Step 3: Commit**

```bash
git add scripts/link-check.sh
git commit -m "$(cat <<'EOF'
Add internal link check script

Verifies that all local href targets in HTML files resolve to
existing files in the repo. External links, mailto, and fragments
are skipped.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

## Phase 1: Sample Report Production

The homepage and the methodology page both link to `sample-report.pdf`. This PDF must exist before those pages can pass link-check. Phase 1 produces it.

### Task 3: Draft the composite sample report markdown

**Files:**
- Create: `~/sentinelot-sample-report/sample-report.md` (outside the website repo, not committed)

The sample report is a fabricated composite built from pieces of real Iris reports. It must read as a legitimate vulnerability report to a controls engineer or OT security consultant. Use the Iris three-pass verification protocol described in `~/iris/CLAUDE.md`. Use only real, verifiable CVEs with CVSS scores that match NVD.

- [ ] **Step 1: Create the working directory**

```bash
mkdir -p ~/sentinelot-sample-report
```

- [ ] **Step 2: Write the markdown source using this brief**

The fabricated operator and assessment profile:

| Field | Value |
|---|---|
| Operator | "Cedar Ridge Regional Water Authority" (fictional) |
| Facility | "Cedar Ridge Water Treatment Plant" (fictional) |
| Location | "A midwestern US community" (no city, no state, no coordinates) |
| Population served | Approximately 28,500 (fabricated, no link to any real utility) |
| Document classification | Confidential |
| Assessment date | Use the current date |

**Technical profile to include:**

- Two internet-exposed programmable logic controllers on a Verizon Business cellular netblock (use only IPs from RFC 5737 documentation ranges: `198.51.100.10` and `198.51.100.11`)
- Both PLCs are Rockwell Automation CompactLogix 1769-L18ER, one hardware revision A, one hardware revision B
- Internal private IPs reported via CIP identity response: `192.168.1.30` and `192.168.1.3` (these stay in asset inventory only, per Iris severity rules, not in findings)
- Microhard Systems cellular gateway as network edge
- MAC addresses use the real Rockwell OUI `00:0F:92` with fabricated suffixes (for example, `00:0F:92:4D:A1:7C`)
- Fabricated serial numbers in plausible Rockwell hex format

**Exposed services to document in asset inventory:**

- 21/tcp FTP (embedded, Rockwell OUI in MAC, cleartext login prompt exposed)
- 22/tcp SSH (Dropbear 2020.81)
- 23/tcp Telnet (BusyBox telnetd, UserDevice login prompt, cleartext)
- 53/tcp DNS (open resolver, available for amplification)
- 80/tcp HTTP (lighttpd, redirects to HTTPS)
- 443/tcp HTTPS (lighttpd, Microhard Systems SSL cert organization field, basic auth realm "UserDevice")
- 602/tcp HTTP (XetaWave industrial radio management UI, no auth challenge) on Device B only
- 44818/tcp EtherNet/IP (full CIP identity, no authentication)
- 44818/udp EtherNet/IP (duplicate identity on UDP)

**CVEs to document as findings (all real, verify against NVD):**

1. **CVE-2021-22681** (CVSS 9.8, authentication bypass, CISA KEV, CWE-522) - affects both devices. This is the critical finding. Remediation deadline already passed.
2. **CVE-2022-1161** (CVSS 9.8, code injection via Logix Designer, CWE-20) - affects both devices. Attacker can alter compiled PLC code while source appears unchanged.
3. **CVE-2019-10952** (CVSS 7.5 NVD base, remote code execution via web server, CWE-787) - affects both devices. Uses the exposed HTTPS interface.

Additional informational findings (not counted as CVEs):
- XetaWave radio management interface exposed without authentication challenge
- DNS open resolver configuration on a SCADA gateway
- Cleartext authentication services (FTP, Telnet) on internet-facing control equipment

**Attribution section:**

Fabricate a plausible attribution story using only the categories real Iris reports use:

- CIP protocol identity response matches Rockwell CompactLogix 1769-L18ER
- MAC OUI confirms Rockwell Automation (IEEE registered)
- Microhard Systems SSL certificate on management interface
- XetaWave service on port 602 (Microhard brand for SCADA telemetry)
- Certificate Transparency logs show Microhard Systems Inc. issuer organization
- Public water authority records "confirm Cedar Ridge Regional Water Authority operates the cited treatment plant serving approximately 28,500 residents"

Attribution confidence: CONFIRMED (invent a score in the 90-95 range).

**Required sections** (follow `~/iris/CLAUDE.md` "Vulnerability Report" structure exactly):

1. Cover Page (use the standard Iris HTML div pattern from the Belle Glade report as a template)
2. Executive Summary (1 page max, business risk in plain terms, top three findings)
3. Methodology Disclaimer (the mandatory passive disclaimer from `~/iris/CLAUDE.md`)
4. Operator Attribution
5. Asset Inventory (Device A, Device B, exposed services tables, network architecture note)
6. Vulnerability Findings (each CVE with the Iris table format: CVE, CVSS, CWE, affected devices, affected product, CISA KEV status, confidence, description, risk context, remediation)
7. Risk Matrix (likelihood vs impact for each finding)
8. Recommended Actions (prioritized remediation roadmap, quick wins first, phased by Immediate / Next Maintenance Window / Next Capital Cycle / Risk Accept)
9. Standards References (IEC 62443, NIST SP 800-82 Rev 3, CISA CPG 2.0)
10. Appendix (raw technical data, methodology notes, data sources, credit usage section deliberately omitted per memory rule)

**Remediation framework:** Every finding must use the 3-part structure from `~/iris/CLAUDE.md`: compensating control first, full remediation next, if-patch-not-feasible fallback.

**Language rules:**

- No em dashes anywhere
- Never use "Shodan", "Censys", "Outer Eye", or "memo"
- Refer to the reconnaissance method as "passive intelligence gathering from aggregated public sources" and nothing more specific
- Never mention Soap Engineering or any delivery partner

- [ ] **Step 3: Run the Iris three-pass verification protocol on the draft**

Pass 1: Draft complete.
Pass 2: Gap review. Every claim sourced, every cost estimate backed. Would a controls engineer challenge any assertion?
Pass 3: Fact verification. Every CVE verified against NVD. Every CVSS score cross-referenced. Every CWE category correct. Flag any unverifiable claim.

- [ ] **Step 4: Save the file**

```bash
ls -la ~/sentinelot-sample-report/sample-report.md
```

Expected: file exists and is at least 12KB of content.

No commit yet. This file lives outside the website repo.

---

### Task 4: Export the sample report to PDF

**Files:**
- Create: `~/sentinelot-sample-report/sample-report.pdf`

- [ ] **Step 1: Run the pdf-export skill with sentinel-premium theme**

```bash
python3 /home/ubuntu/.openclaw/skills/pdf-export/scripts/pdf_export.py \
  --input ~/sentinelot-sample-report/sample-report.md \
  --theme sentinel-premium \
  --output ~/sentinelot-sample-report/sample-report.pdf
```

Expected: PDF is produced with no WeasyPrint errors. Cover page renders with logo, badge, title, and cover table. No blank pages.

- [ ] **Step 2: Open and visually inspect the PDF**

Verify:
- Cover page shows the Sentinel OT banner logo (not broken)
- Cover page classification badge is present
- Cover table has four rows (Document, Date, Prepared by, Classification)
- No blank pages
- No em dashes anywhere in the rendered text
- No forbidden words anywhere in the rendered text
- CVE tables render correctly
- Executive summary is on its own page

If any of the above fails, fix the markdown and re-run Step 1.

No commit yet.

---

### Task 5: Place the PDF in the website repo

**Files:**
- Create: `sentinelot-site/sample-report.pdf`

- [ ] **Step 1: Copy the PDF into the repo**

```bash
cp ~/sentinelot-sample-report/sample-report.pdf /home/ubuntu/sentinelot-site/sample-report.pdf
```

- [ ] **Step 2: Verify size and format**

```bash
ls -la /home/ubuntu/sentinelot-site/sample-report.pdf
file /home/ubuntu/sentinelot-site/sample-report.pdf
```

Expected: File exists, non-zero size, `file` reports it as `PDF document`.

- [ ] **Step 3: Commit the PDF**

```bash
cd /home/ubuntu/sentinelot-site
git add sample-report.pdf
git commit -m "$(cat <<'EOF'
Add fabricated composite sample vulnerability report

Self-contained sample of Sentinel OT's vulnerability report format,
built as a composite of real Iris reports with a fabricated operator
(Cedar Ridge Regional Water Authority). Uses RFC 5737 documentation
IPs, real CVEs, and real Rockwell CompactLogix hardware details.
Links from homepage and methodology pages.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

## Phase 2: Homepage Rewrite

This is the largest phase. The homepage is rewritten section by section. Each task makes a focused edit, runs the guardrail scripts, and commits. Do not batch edits across tasks.

**Before starting this phase**, read [index.html](/home/ubuntu/sentinelot-site/index.html) lines 1472 to 1633 once to confirm the current body structure. Do not read the entire file.

### Task 6: Update page title, meta description, and schema.org Organization block

**Files:**
- Modify: `index.html` lines 8-9, 17-49

- [ ] **Step 1: Replace the title and meta description**

Find the current lines 8-9:

```html
  <title>Sentinel OT | Passive OT Intelligence for Critical Infrastructure</title>
  <meta name="description" content="Qualified vulnerability leads for ICS system integrators, OT cybersecurity firms, and industrial automation distributors. Firmware-validated CVEs, confirmed operators, decision-maker contacts.">
```

Replace with:

```html
  <title>Sentinel OT | The IT/OT Security Partner for US Water Utilities</title>
  <meta name="description" content="Sentinel OT is the single accountable IT/OT security partner for US water utilities. Passive vulnerability intelligence, grant funding support, remediation delivery, and ongoing CVE monitoring under one contract.">
```

- [ ] **Step 2: Replace the schema.org Organization block**

Find the current block at lines 17-49 (the `<script type="application/ld+json">` containing the Organization) and replace its JSON body with:

```json
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "Sentinel OT",
  "url": "https://sentinelot.com",
  "logo": "https://sentinelot.com/logo.png",
  "description": "The single accountable IT/OT security partner for US water utilities. Passive vulnerability intelligence, grant funding support, remediation delivery, and ongoing CVE monitoring under one contract.",
  "foundingDate": "2025",
  "foundingLocation": {
    "@type": "Place",
    "address": {
      "@type": "PostalAddress",
      "addressLocality": "Calgary",
      "addressRegion": "AB",
      "addressCountry": "CA"
    }
  },
  "location": [
    {
      "@type": "Place",
      "name": "Calgary Corporate Office",
      "address": {
        "@type": "PostalAddress",
        "addressLocality": "Calgary",
        "addressRegion": "AB",
        "addressCountry": "CA"
      }
    },
    {
      "@type": "Place",
      "name": "Houston Delivery Operations",
      "address": {
        "@type": "PostalAddress",
        "addressLocality": "Houston",
        "addressRegion": "TX",
        "addressCountry": "US"
      }
    }
  ],
  "areaServed": "United States",
  "knowsAbout": [
    "Water utility cybersecurity",
    "Industrial control systems security",
    "PLC vulnerability assessment",
    "Passive OT reconnaissance",
    "AWIA compliance",
    "SLCGP grant support",
    "IEC 62443",
    "NIST SP 800-82"
  ],
  "sameAs": [
    "https://sentinelot.com/about.html",
    "https://www.linkedin.com/company/sentinelot"
  ]
}
```

- [ ] **Step 3: Run the OPSEC check**

```bash
cd /home/ubuntu/sentinelot-site && ./scripts/opsec-check.sh
```

Expected: index.html still fails on leftover body copy from pre-pivot. That is fine for now. Meta and schema changes must not introduce new failures.

- [ ] **Step 4: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Rewrite homepage title, meta description, and schema.org

Repositions the homepage for the water utility focus and IT/OT
security partner brand. Adds Houston as a schema.org location entry
for US delivery operations while keeping Calgary as the corporate
founding location.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

### Task 7: Update homepage navigation

**Files:**
- Modify: `index.html` lines 1475-1484

- [ ] **Step 1: Replace the nav block**

Find the current nav:

```html
  <nav class="nav">
    <div class="nav-inner">
      <a href="/" class="nav-left">
        <img src="SENTINEL-banner-with-shield.png" alt="Sentinel OT">
      </a>
      <div class="nav-links">
        <a href="#contact" class="nav-cta">Get in touch</a>
      </div>
    </div>
  </nav>
```

Replace with:

```html
  <nav class="nav">
    <div class="nav-inner">
      <a href="/" class="nav-left">
        <img src="SENTINEL-banner-with-shield.png" alt="Sentinel OT">
      </a>
      <div class="nav-links">
        <a href="/methodology.html">Methodology</a>
        <a href="/about.html">About</a>
        <a href="/sample-report.pdf" target="_blank" rel="noopener">Sample Report</a>
        <a href="#contact" class="nav-cta">Get in touch</a>
      </div>
    </div>
  </nav>
```

- [ ] **Step 2: Run link check**

```bash
./scripts/link-check.sh
```

Expected: `sample-report.pdf` resolves (added in Phase 1). `methodology.html` does NOT yet exist and will fail. This is known and acceptable for now. `about.html` exists.

- [ ] **Step 3: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Add Methodology, About, and Sample Report links to homepage nav

Methodology link targets a page created in Phase 3. Link-check will
fail on it until that phase lands.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

### Task 8: Add new CSS classes for pivot sections

All new section styles go in a single CSS block appended to the existing `<style>` tag. This keeps pivot-specific CSS identifiable and easy to remove if the direction changes.

**Files:**
- Modify: `index.html` - append CSS block before the closing `</style>` tag around line 1470

- [ ] **Step 1: Locate the end of the current `<style>` block**

Find the line `</style>` inside the `<head>` (currently around line 1470). Insert the new CSS immediately before it.

- [ ] **Step 2: Insert the new CSS block**

Insert exactly this block (a single cohesive addition, not split across tasks):

```css
    /* ─── WATER PIVOT (2026-04) ─── */
    .quiet-problem {
      max-width: 760px;
      margin: 0 auto;
    }

    .quiet-problem p {
      font-size: 1.6rem;
      line-height: 1.7;
      color: var(--black-9);
      margin-bottom: 18px;
    }

    .quiet-problem p:last-child { margin-bottom: 0; }

    .proof-block {
      background: var(--navy);
      border-radius: 16px;
      padding: 40px;
      max-width: 820px;
      margin: 0 auto;
      color: rgba(255,255,255,0.88);
      box-shadow: 0 4px 24px rgba(0,0,0,0.06);
    }

    .proof-label {
      font-size: 1.15rem;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.08em;
      color: #38bdf8;
      margin-bottom: 16px;
    }

    .proof-text {
      font-size: 1.7rem;
      line-height: 1.55;
      color: rgba(255,255,255,0.92);
      margin-bottom: 20px;
    }

    .proof-close {
      font-size: 1.4rem;
      color: rgba(255,255,255,0.6);
      font-style: italic;
      margin-bottom: 24px;
    }

    .proof-link {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      color: #38bdf8;
      text-decoration: none;
      font-size: 1.4rem;
      font-weight: 500;
      border-bottom: 1px solid rgba(56,189,248,0.4);
      padding-bottom: 2px;
    }

    .proof-link:hover {
      color: #ffffff;
      border-bottom-color: #ffffff;
    }

    .pipeline-stages {
      display: flex;
      flex-direction: column;
      gap: 48px;
    }

    .stage {
      display: grid;
      grid-template-columns: 80px 1fr;
      gap: 32px;
      align-items: start;
      padding-bottom: 48px;
      border-bottom: 1px solid var(--border);
    }

    .stage:last-child {
      border-bottom: none;
      padding-bottom: 0;
    }

    .stage-num {
      font-size: 5.2rem;
      font-weight: 700;
      color: var(--accent);
      letter-spacing: -0.04em;
      line-height: 0.9;
    }

    .stage-body h3 {
      font-size: 2.6rem;
      font-weight: 600;
      letter-spacing: -0.02em;
      color: var(--black);
      margin-bottom: 14px;
    }

    .stage-body p {
      font-size: 1.55rem;
      line-height: 1.65;
      color: var(--black-9);
      margin-bottom: 12px;
    }

    .stage-body p:last-child { margin-bottom: 0; }

    .grant-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 32px;
      font-size: 1.4rem;
    }

    .grant-table th,
    .grant-table td {
      text-align: left;
      padding: 14px 18px;
      border-bottom: 1px solid var(--border);
    }

    .grant-table th {
      background: var(--bg-card);
      font-weight: 600;
      color: var(--black);
      text-transform: uppercase;
      font-size: 1.15rem;
      letter-spacing: 0.06em;
    }

    .grant-table td {
      color: var(--black-9);
    }

    .grant-table tbody tr:hover {
      background: var(--accent-light);
    }

    .awia-callout {
      background: #fff8e1;
      border: 1px solid #f2c94c;
      border-left: 4px solid #f2994a;
      border-radius: 10px;
      padding: 22px 26px;
      margin-top: 36px;
      font-size: 1.5rem;
      color: var(--black-9);
      line-height: 1.55;
    }

    .awia-callout strong {
      color: var(--black);
      font-weight: 600;
    }

    .do-not-list {
      list-style: none;
      padding: 0;
      margin: 24px 0 0;
      display: grid;
      grid-template-columns: 1fr;
      gap: 14px;
      max-width: 680px;
    }

    .do-not-list li {
      display: flex;
      align-items: flex-start;
      gap: 14px;
      font-size: 1.55rem;
      line-height: 1.5;
      color: var(--black-9);
      padding: 14px 18px;
      background: var(--white);
      border: 1px solid var(--border);
      border-radius: 10px;
    }

    .do-not-list li::before {
      content: "✕";
      flex-shrink: 0;
      width: 26px;
      height: 26px;
      background: var(--danger-light);
      color: var(--danger);
      border-radius: 6px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 700;
      font-size: 1.3rem;
    }

    .do-not-footer {
      margin-top: 24px;
      font-size: 1.5rem;
      color: var(--black-7);
      max-width: 680px;
      line-height: 1.6;
    }

    .engagement-timeline {
      display: flex;
      flex-direction: column;
      gap: 0;
      max-width: 760px;
    }

    .tl-item {
      display: grid;
      grid-template-columns: 180px 1fr;
      gap: 24px;
      padding: 18px 0;
      border-bottom: 1px solid var(--border);
      align-items: start;
    }

    .tl-item:last-child { border-bottom: none; }

    .tl-when {
      font-size: 1.25rem;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.06em;
      color: var(--accent);
    }

    .tl-what {
      font-size: 1.5rem;
      color: var(--black-9);
      line-height: 1.55;
    }

    .pricing-block {
      margin-top: 32px;
      padding: 24px 28px;
      background: var(--bg-card);
      border-radius: 12px;
      font-size: 1.5rem;
      line-height: 1.6;
      color: var(--black-9);
      max-width: 760px;
    }

    .pricing-block strong { color: var(--black); font-weight: 600; }

    .faq-list {
      display: flex;
      flex-direction: column;
      gap: 20px;
      max-width: 820px;
    }

    .faq-item {
      background: var(--white);
      border: 1px solid var(--border);
      border-radius: 12px;
      padding: 24px 28px;
    }

    .faq-q {
      font-size: 1.7rem;
      font-weight: 600;
      color: var(--black);
      margin-bottom: 12px;
      letter-spacing: -0.01em;
    }

    .faq-a {
      font-size: 1.5rem;
      line-height: 1.65;
      color: var(--black-9);
    }

    /* Responsive overrides for pivot sections */
    @media (max-width: 768px) {
      .stage { grid-template-columns: 1fr; gap: 12px; }
      .stage-num { font-size: 4rem; }
      .tl-item { grid-template-columns: 1fr; gap: 6px; }
      .proof-block { padding: 28px 22px; }
      .grant-table { font-size: 1.3rem; }
      .grant-table th, .grant-table td { padding: 10px 12px; }
    }
```

- [ ] **Step 3: Run OPSEC check (should not fail on the CSS addition)**

```bash
./scripts/opsec-check.sh
```

Expected: Still fails on pre-pivot copy. CSS block adds no new failures.

- [ ] **Step 4: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Add CSS classes for water utility pivot sections

Adds styling for the pipeline, proof strip, grant table, AWIA
callout, do-not list, engagement timeline, pricing block, and FAQ
sections. All new classes grouped under a single "WATER PIVOT"
comment block so they can be identified and removed if needed.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

### Task 9: Rewrite the hero section

**Files:**
- Modify: `index.html` lines 1486-1503 (the `<div class="hero-shader-wrap">` block)

- [ ] **Step 1: Replace the hero block**

Find the current hero block:

```html
  <!-- HERO -->
  <div class="hero-shader-wrap">
    <canvas id="shader-canvas"></canvas>
  <div class="container">
    <div class="hero">
      <div class="hero-content">
        <div class="hero-badge">OT Intelligence as a Service</div>
        <h1>Intelligence for critical<br><span class="muted">infrastructure.</span></h1>
        <p class="hero-desc">Sentinel OT monitors critical infrastructure sectors and delivers actionable intelligence to the organizations that need it.</p>
        <div class="hero-actions">
          <a href="#contact" class="btn-primary">Get in touch</a>
        </div>
      </div>


    </div>
  </div>
  </div><!-- /hero-shader-wrap -->
```

Replace with:

```html
  <!-- HERO -->
  <div class="hero-shader-wrap">
    <canvas id="shader-canvas"></canvas>
  <div class="container">
    <div class="hero">
      <div class="hero-content">
        <div class="hero-badge">Passive IT/OT Intelligence for Municipal Water Systems</div>
        <h1>The IT/OT security partner<br><span class="muted">for US water utilities.</span></h1>
        <p class="hero-desc">We find what is exposed. We help you secure the grant funding to fix it. We deliver the remediation. We monitor it after. One accountable partner. One invoice. Zero network access.</p>
        <div class="hero-actions">
          <a href="#contact" class="btn-primary">Get in touch</a>
          <a href="/methodology.html" class="btn-text">Read the methodology →</a>
        </div>
      </div>
    </div>
  </div>
  </div><!-- /hero-shader-wrap -->
```

- [ ] **Step 2: Run OPSEC check**

```bash
./scripts/opsec-check.sh
```

Expected: One fewer failure now that the old OT Intelligence hero copy is gone.

- [ ] **Step 3: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Rewrite hero section for water utility positioning

New headline "The IT/OT security partner for US water utilities"
with the find/fund/fix/monitor value proposition in the subhead.
Adds a Read the methodology secondary link.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

### Task 10: Replace the coverage grid with "The quiet problem" section

**Files:**
- Modify: `index.html` lines 1505-1542 (the current `<!-- COVERAGE -->` block)

- [ ] **Step 1: Delete the entire current coverage block**

Find and remove the block that starts with `<!-- COVERAGE -->` and ends with the closing `</div>` of its container. This block contains the 4-card coverage grid (Oil & Gas, Water & Wastewater, Power & Utilities, Medical Devices). Delete it entirely.

- [ ] **Step 2: Insert the quiet problem section in its place**

```html
  <!-- QUIET PROBLEM -->
  <div class="container">
    <div class="section">
      <div class="section-label">The Quiet Problem</div>
      <h2>Most small and mid-sized water utilities do not know what they do not know.</h2>

      <div class="quiet-problem">
        <p>The America's Water Infrastructure Act requires every community water system serving more than 3,300 people to complete a Risk and Resilience Assessment and an Emergency Response Plan on a recurring cycle. The next recertification deadline for systems serving 3,301 to 49,999 people is June 30, 2026. Almost no OT security shop helps utilities of that size prepare for it.</p>

        <p>The CISA Known Exploited Vulnerabilities catalog contains dozens of CVEs that affect the exact controllers small water utilities commonly operate. Rockwell CompactLogix. Schneider Modicon. Siemens S7. Each with a federal remediation deadline that passes quietly and is rarely tracked by anyone local.</p>

        <p>Aliquippa, Pennsylvania (November 2023). Oldsmar, Florida (February 2021). Muleshoe, Texas (January 2024). Three real municipal water systems compromised through exactly the class of internet-facing control equipment we find in this work. None of them were hypothetical. All of them were preventable.</p>

        <p>State and federal grant dollars to pay for the fix already exist. Most of them go unclaimed in the communities that need them most, because nobody on staff has the time to identify, apply for, or manage the paperwork that moves the money.</p>
      </div>
    </div>
  </div>
```

- [ ] **Step 3: Run OPSEC check**

```bash
./scripts/opsec-check.sh
```

Expected: No em dash failures from the new copy. Fewer forbidden-word failures overall.

- [ ] **Step 4: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Replace coverage grid with the quiet problem section

Removes the four-sector coverage grid and replaces it with
analytical framing: AWIA deadline, CISA KEV catalog, real named
precedents (Aliquippa, Oldsmar, Muleshoe), and unclaimed grant
dollars. Sets the tone for a non-technical municipal reader.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

### Task 11: Add the proof strip section

**Files:**
- Modify: `index.html` - insert after the quiet problem block, before the next section

- [ ] **Step 1: Insert the proof block**

After the closing `</div>` of the Quiet Problem container, insert:

```html
  <!-- PROOF STRIP -->
  <div class="container">
    <div class="section" style="padding-top:20px;">
      <div class="proof-block">
        <div class="proof-label">From a recent assessment</div>
        <div class="proof-text">A 30,000-resident water utility operating two internet-exposed Rockwell CompactLogix PLCs. One critical authentication bypass vulnerability on the CISA Known Exploited Vulnerabilities catalog with a federal remediation deadline already overdue. No VPN. No firewall. No network segmentation.</div>
        <div class="proof-close">This is not unusual. It is typical.</div>
        <a href="/sample-report.pdf" class="proof-link" target="_blank" rel="noopener">Read the full sample report →</a>
      </div>
    </div>
  </div>
```

- [ ] **Step 2: Run link check**

```bash
./scripts/link-check.sh
```

Expected: `sample-report.pdf` resolves. `methodology.html` still fails (known).

- [ ] **Step 3: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Add proof strip section linking to sample report

Composite finding written in plain English for a non-technical
reader, with a link to the fabricated sample vulnerability report
PDF produced in Phase 1.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

### Task 12: Replace the "Who it's for" section with the four-stage pipeline

**Files:**
- Modify: `index.html` lines 1545-1566 (the current `<!-- WHO IT'S FOR -->` block)

- [ ] **Step 1: Delete the entire current who-its-for block**

Find and remove the block that starts with `<!-- WHO IT'S FOR -->` and contains the three-column comparison grid. Delete it entirely.

- [ ] **Step 2: Insert the four-stage pipeline section**

```html
  <!-- FOUR-STAGE PIPELINE -->
  <div class="container">
    <div class="section">
      <div class="section-label">How It Works</div>
      <h2>One partner. Four stages. Start to finish.</h2>
      <p class="section-desc">Every engagement runs on the same four-stage model, designed to take a community from unknown exposure to a funded, validated, monitored outcome.</p>

      <div class="pipeline-stages">

        <div class="stage">
          <div class="stage-num">01</div>
          <div class="stage-body">
            <h3>Find.</h3>
            <p>We identify externally observable exposure on your IT and OT infrastructure using passive intelligence gathered from aggregated public sources. No packets are sent to your systems. No network access is required. No authentication is attempted on any device.</p>
            <p>You receive a formal vulnerability report documenting every finding with CVSS scores, CWE categories, CISA Known Exploited Vulnerabilities status, affected firmware versions, and remediation guidance. Every finding is verified against the National Vulnerability Database before it appears in the report. The methodology references IEC 62443 and NIST SP 800-82 Revision 3. Typical turnaround is one week.</p>
          </div>
        </div>

        <div class="stage">
          <div class="stage-num">02</div>
          <div class="stage-body">
            <h3>Fund.</h3>
            <p>Most small and mid-sized utilities do not have the bandwidth to chase the grant dollars that would pay for remediation. We do. We identify which state and federal programs your utility qualifies for, prepare the application language, document the scope of work in a form that procurement officers and grant administrators can actually use, and align the package with AWIA Risk and Resilience Assessment requirements where applicable.</p>
            <p>State programs we currently work with include SECURE (New York), the Florida state cybersecurity grant, dedicated SRF cyber set-asides in Massachusetts, SLCGP allocations in Texas and beyond, and WQAA cyber requirements in New Jersey.</p>
          </div>
        </div>

        <div class="stage">
          <div class="stage-num">03</div>
          <div class="stage-body">
            <h3>Fix.</h3>
            <p>Finding the exposure is the first half of the work. The second half is closing it. Our vetted delivery team executes the remediation under a single contract with Sentinel OT as the prime. Network segmentation using IEC 62443 zones and conduits. Firmware updates on controllers that can be patched. Hardware replacement for end-of-life equipment. Compensating controls for anything that cannot be patched within the current capital cycle.</p>
            <p>Every remediation step is documented so the utility has the evidence trail for AWIA recertification and any future audit. You have one point of contact, one contract, and one invoice.</p>
          </div>
        </div>

        <div class="stage">
          <div class="stage-num">04</div>
          <div class="stage-body">
            <h3>Monitor.</h3>
            <p>The platform inventory we build during the Find phase becomes the watchlist for our Zero Day Notification Service. When a new vulnerability is disclosed against any of the hardware, firmware, or software you run, we match it against your inventory and send you an alert before it makes the news. Ongoing, scoped, and specific to your environment.</p>
            <p>ZDNS is offered as a subscription that begins after the initial engagement completes. You learn about a new threat from us, not from a headline.</p>
          </div>
        </div>

      </div>
    </div>
  </div>
```

- [ ] **Step 3: Run OPSEC check**

```bash
./scripts/opsec-check.sh
```

Expected: No new failures from this task.

- [ ] **Step 4: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Replace who-its-for with four-stage pipeline section

Full explainer for Find, Fund, Fix, and Monitor. Each stage is a
150-200 word block, not a card grid, so the value prop has the
real estate it needs. References IEC 62443 and NIST SP 800-82 by
name. SOAP stays invisible under "our vetted delivery team".

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

### Task 13: Add the grant funding landscape section

**Files:**
- Modify: `index.html` - insert after the pipeline section

- [ ] **Step 1: Insert the grant funding block**

After the closing `</div>` of the pipeline container, add:

```html
  <!-- GRANT FUNDING LANDSCAPE -->
  <div class="container">
    <div class="section">
      <div class="section-label">Grant Funding</div>
      <h2>The money is already there. Most utilities never see it.</h2>
      <p class="section-desc">Federal SLCGP funds, state cybersecurity grants, and water-sector State Revolving Fund set-asides collectively allocate hundreds of millions of dollars every year to cybersecurity work in small and mid-sized water utilities. Most of it is left on the table in the communities that need it most.</p>

      <table class="grant-table">
        <thead>
          <tr>
            <th>State</th>
            <th>Program</th>
            <th>Approximate Funding</th>
            <th>Local Match</th>
            <th>Application Window</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>New York</td>
            <td>SECURE Grant Program</td>
            <td>State-funded, multiple rounds</td>
            <td>Varies by program tier</td>
            <td>Rolling</td>
          </tr>
          <tr>
            <td>Florida</td>
            <td>State Cybersecurity Grant</td>
            <td>$15 million annual pool</td>
            <td>None required</td>
            <td>Annual cycle</td>
          </tr>
          <tr>
            <td>Massachusetts</td>
            <td>SRF Cybersecurity Set-Aside</td>
            <td>Dedicated water-sector carve-out</td>
            <td>Varies by award</td>
            <td>Annual cycle</td>
          </tr>
          <tr>
            <td>Texas</td>
            <td>SLCGP (State and Local Cybersecurity Grant Program)</td>
            <td>Largest state allocation in the program</td>
            <td>Required, tiered by year</td>
            <td>FY2026 open</td>
          </tr>
          <tr>
            <td>New Jersey</td>
            <td>WQAA Cybersecurity Requirements</td>
            <td>Mandatory compliance funding</td>
            <td>Varies</td>
            <td>Rolling, tied to WQAA deadlines</td>
          </tr>
          <tr>
            <td>All states</td>
            <td>SLCGP (federal allocation through state admin)</td>
            <td>Federal pass-through, varies</td>
            <td>Tiered, reduces over program life</td>
            <td>State-administered</td>
          </tr>
        </tbody>
      </table>

      <div class="awia-callout">
        <strong>AWIA deadline, clearly.</strong> America's Water Infrastructure Act Risk and Resilience Assessment recertification is due June 30, 2026 for community water systems serving 3,301 to 49,999 people. If that describes your utility, you have a federal deadline and a short runway. We can help you get in front of it.
      </div>
    </div>
  </div>
```

- [ ] **Step 2: Run OPSEC check**

```bash
./scripts/opsec-check.sh
```

Expected: No new failures.

- [ ] **Step 3: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Add grant funding landscape section with state table and AWIA callout

Publishes the state-by-state grant programs we reference when
helping utilities secure funding. AWIA deadline (June 30, 2026) is
called out in a distinct visual block.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

### Task 14: Add the "What we do not do" section

**Files:**
- Modify: `index.html` - insert after the grant section

- [ ] **Step 1: Insert the block**

```html
  <!-- WHAT WE DO NOT DO -->
  <div class="container">
    <div class="section">
      <div class="section-label">Boundaries</div>
      <h2>What we do not do.</h2>

      <ul class="do-not-list">
        <li>We do not scan your internal network.</li>
        <li>We do not send packets to your infrastructure.</li>
        <li>We do not attempt authentication on any system.</li>
        <li>We do not execute exploits.</li>
        <li>We do not require credentials, VPN access, or any form of inside access.</li>
      </ul>

      <p class="do-not-footer">Every finding in every report we produce is observable from the public internet. Our work is defensive, legal, and passive. We reference IEC 62443 and NIST SP 800-82 Revision 3 on every engagement.</p>
    </div>
  </div>
```

- [ ] **Step 2: Run OPSEC check**

```bash
./scripts/opsec-check.sh
```

Expected: No new failures.

- [ ] **Step 3: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Add "What we do not do" boundaries section

Credibility insurance for city attorneys and procurement officers.
Five explicit statements of what Sentinel OT does not touch,
followed by the passive-is-legal footer referencing IEC 62443 and
NIST SP 800-82.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

### Task 15: Add the "What an engagement looks like" section

**Files:**
- Modify: `index.html` - insert after the boundaries section

- [ ] **Step 1: Insert the block**

```html
  <!-- ENGAGEMENT TIMELINE -->
  <div class="container">
    <div class="section">
      <div class="section-label">Timeline</div>
      <h2>What a Sentinel OT engagement looks like.</h2>
      <p class="section-desc">Every engagement follows the same basic shape, whether the utility serves 4,000 residents or 40,000.</p>

      <div class="engagement-timeline">
        <div class="tl-item">
          <div class="tl-when">Week 0</div>
          <div class="tl-what">Vulnerability report delivered. The conversation begins with evidence on the table, not a sales pitch.</div>
        </div>
        <div class="tl-item">
          <div class="tl-when">Week 1 to 2</div>
          <div class="tl-what">Scoping call. We walk the utility leadership through the findings, answer questions, and confirm which systems fall inside the engagement.</div>
        </div>
        <div class="tl-item">
          <div class="tl-when">Week 2 to 4</div>
          <div class="tl-what">Full external assessment. A deeper passive assessment of the full fleet. Per-station exposure profiles, CVE risk register ranked by exploitability, phased remediation scope, cost estimates suitable for grant applications.</div>
        </div>
        <div class="tl-item">
          <div class="tl-when">Week 4 to 6</div>
          <div class="tl-what">Grant application support. We prepare the scope-of-work language, align the package with AWIA requirements, and deliver the application artifacts your finance or clerk's office needs.</div>
        </div>
        <div class="tl-item">
          <div class="tl-when">Month 2 and onward</div>
          <div class="tl-what">Remediation execution. Our vetted delivery team performs the segmentation, firmware updates, hardware replacement, and compensating control work under Sentinel OT as the prime contractor.</div>
        </div>
        <div class="tl-item">
          <div class="tl-when">Month 4 and onward</div>
          <div class="tl-what">Zero Day Notification Service. Ongoing CVE alerts matched against your confirmed inventory. You learn about a new threat from us, not from a headline.</div>
        </div>
      </div>

      <div class="pricing-block">
        <strong>Pricing, plainly.</strong> The full external assessment is $15,000 to $25,000 and is typically below competitive bidding thresholds, which makes it a direct award in most jurisdictions. Remediation costs depend on scope and are almost always funded by grant dollars identified and secured during the Fund stage. ZDNS is a subscription priced after the engagement closes.
      </div>
    </div>
  </div>
```

- [ ] **Step 2: Run OPSEC check**

```bash
./scripts/opsec-check.sh
```

- [ ] **Step 3: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Add engagement timeline and pricing transparency section

Six-step timeline from vulnerability report delivery to ongoing
ZDNS, plus a pricing block stating $15-25K for the full assessment
and noting that remediation is typically grant-funded.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

### Task 16: Add the FAQ section

**Files:**
- Modify: `index.html` - insert after the engagement timeline

- [ ] **Step 1: Insert the FAQ block**

```html
  <!-- FAQ -->
  <div class="container">
    <div class="section">
      <div class="section-label">Questions We Expect</div>
      <h2>Before you reply.</h2>
      <p class="section-desc">The eight questions most mayors and city attorneys ask us before they agree to a conversation.</p>

      <div class="faq-list">

        <div class="faq-item">
          <div class="faq-q">Do you need access to our network?</div>
          <div class="faq-a">No. We never touch your network. Every finding is observable from the public internet. We do not send packets to your infrastructure, we do not attempt authentication, and we do not require VPN access or credentials. If the work requires any of that, it is not us doing it.</div>
        </div>

        <div class="faq-item">
          <div class="faq-q">Is what you do legal?</div>
          <div class="faq-a">Yes. We use only publicly available information. The Computer Fraud and Abuse Act applies to unauthorized access to a protected computer. We never access your systems, so there is no access to authorize. The same passive intelligence methodology is used by CISA, commercial threat intelligence firms, and academic researchers. Our work is defensive and legal by design.</div>
        </div>

        <div class="faq-item">
          <div class="faq-q">We already have an IT provider. Why do we need you?</div>
          <div class="faq-a">Most IT providers focus on office systems, not control systems. The PLCs, cellular gateways, and SCADA equipment that run your water treatment plant live on a different network and speak different protocols. They are rarely patched, rarely inventoried, and almost never visible to a general IT team. We cover that gap.</div>
        </div>

        <div class="faq-item">
          <div class="faq-q">How is this different from a penetration test?</div>
          <div class="faq-a">A penetration test sends live attack traffic at your systems from inside or outside your network. It requires authorization, contracts, and usually downtime. We send nothing. Our findings are observed from the public internet using passive intelligence techniques. No authorization required, no disruption risk, and the findings are ready in days instead of months.</div>
        </div>

        <div class="faq-item">
          <div class="faq-q">Will this help us comply with AWIA?</div>
          <div class="faq-a">Yes. The America's Water Infrastructure Act requires community water systems serving more than 3,300 people to assess cybersecurity risks and certify a Risk and Resilience Assessment. Our vulnerability reports document external exposure in a form that supports the RRA. Recertification for systems serving 3,301 to 49,999 people is due June 30, 2026. We can help you get in front of it.</div>
        </div>

        <div class="faq-item">
          <div class="faq-q">Can grant dollars actually pay for this?</div>
          <div class="faq-a">Yes. Federal State and Local Cybersecurity Grant Program funds, state cybersecurity grants, and water-sector SRF set-asides all cover OT security assessments and remediation. We help you identify which programs your utility qualifies for, prepare the application language, and document the scope of work. The assessment fee is typically below competitive bidding thresholds in most jurisdictions, which makes it a direct award and a clean procurement path.</div>
        </div>

        <div class="faq-item">
          <div class="faq-q">Who does the actual remediation work?</div>
          <div class="faq-a">Our vetted delivery team. Network segmentation, firmware updates, controller replacement, and compensating controls are executed by experienced OT engineers working under Sentinel OT's accountability. You have one point of contact, one contract, and one invoice. We are the prime.</div>
        </div>

        <div class="faq-item">
          <div class="faq-q">What happens if you find something that needs to be fixed immediately?</div>
          <div class="faq-a">We tell you in the report, with a specific recommendation for a compensating control you can implement the same day. Full remediation follows your utility's capital and maintenance cycle. If a finding triggers a mandatory disclosure under CIRCIA or a state breach law, we flag it and walk you through the next step. We do not sit on information that affects public safety.</div>
        </div>

      </div>
    </div>
  </div>
```

- [ ] **Step 2: Run OPSEC check**

```bash
./scripts/opsec-check.sh
```

- [ ] **Step 3: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Add FAQ section with eight pre-reply questions

Questions a mayor or city attorney would ask before responding,
with verbatim answers from the approved design spec. Covers
network access, legality, IT provider overlap, pen-test
distinction, AWIA, grant funding, delivery team, and urgent-fix
handling.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

### Task 17: Update the contact section

**Files:**
- Modify: `index.html` lines ~1568-1599 (the current `<!-- CONTACT -->` block)

- [ ] **Step 1: Replace the contact block**

Find the `<!-- CONTACT -->` block and replace its contents with:

```html
  <!-- CONTACT -->
  <div class="container" id="contact">
    <div class="cta-section">
      <h2>Get in touch.</h2>
      <p>If you received a vulnerability report from Sentinel OT, this is the fastest way to reply. If you are exploring whether your utility is a fit, we will come back to you within one business day.</p>
      <div id="contactFormWrap" style="max-width:480px;margin:32px auto 0;text-align:left;">
        <form id="contactForm" action="https://formspree.io/f/mzdakpwg" method="POST">
          <div class="form-group">
            <label for="cf-name">Name</label>
            <input type="text" id="cf-name" name="name" required placeholder="Your name">
          </div>
          <div class="form-group">
            <label for="cf-email">Email</label>
            <input type="email" id="cf-email" name="email" required placeholder="you@yourcity.gov">
          </div>
          <div class="form-group">
            <label for="cf-company">Utility or Organization</label>
            <input type="text" id="cf-company" name="company" required placeholder="Name of your water utility or city">
          </div>
          <div class="form-group">
            <label>Are you replying to a Sentinel OT report?</label>
            <label style="display:inline-flex;align-items:center;gap:8px;font-size:1.35rem;font-weight:400;margin-right:20px;margin-top:4px;">
              <input type="radio" name="replying_to_report" value="yes" style="width:auto;"> Yes
            </label>
            <label style="display:inline-flex;align-items:center;gap:8px;font-size:1.35rem;font-weight:400;margin-top:4px;">
              <input type="radio" name="replying_to_report" value="no" style="width:auto;"> No
            </label>
          </div>
          <div class="form-group">
            <label for="cf-message">Message</label>
            <textarea id="cf-message" name="message" placeholder="Tell us what prompted your outreach"></textarea>
          </div>
          <button type="submit" class="form-submit">Send</button>
        </form>
      </div>
      <div id="contactSuccess" class="form-success" style="display:none">
        <h3>Message sent</h3>
        <p>We'll be in touch shortly.</p>
      </div>
    </div>
  </div>
```

- [ ] **Step 2: Run OPSEC check**

```bash
./scripts/opsec-check.sh
```

- [ ] **Step 3: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Update contact section copy and add report-reply radio field

New subhead explicitly addressing both report recipients and cold
inbound. Adds a "replying to a Sentinel OT report?" yes/no radio
so the inbox can be triaged. Formspree endpoint preserved.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

### Task 18: Update the footer

**Files:**
- Modify: `index.html` lines ~1601-1632 (the current `<footer>` block)

- [ ] **Step 1: Replace the footer block**

Find the `<footer>` block and replace with:

```html
  <!-- FOOTER -->
  <footer>
    <div class="container">
      <div class="footer-grid">
        <div class="footer-brand">
          <img src="SENTINEL-banner-with-shield.png" alt="Sentinel OT">
          <p>The single accountable IT/OT security partner for US water utilities.</p>
        </div>
        <div class="footer-col">
          <h4>Sentinel OT</h4>
          <a href="/methodology.html">Methodology</a>
          <a href="/about.html">About</a>
          <a href="/sample-report.pdf" target="_blank" rel="noopener">Sample Report</a>
        </div>
        <div class="footer-col">
          <h4>Get in touch</h4>
          <a href="#contact">Contact form</a>
        </div>
        <div class="footer-col">
          <h4>Legal</h4>
          <a href="/privacy.html">Privacy Policy</a>
          <a href="/terms.html">Terms of Service</a>
        </div>
      </div>
      <div class="footer-bottom">
        <p>&copy; 2026 Sentinel OT. All rights reserved.</p>
        <p>Public and passive sources only. Findings are for defensive modernization.</p>
        <a href="https://www.linkedin.com/company/sentinelot" target="_blank" rel="noopener" class="footer-linkedin" aria-label="Sentinel OT on LinkedIn">
          <img src="icons/linkedin.png" alt="LinkedIn" style="width:20px;height:20px;opacity:0.5;transition:opacity 0.2s;vertical-align:middle">
        </a>
      </div>
    </div>
  </footer>
```

- [ ] **Step 2: Run OPSEC check and link check**

```bash
./scripts/opsec-check.sh && ./scripts/link-check.sh
```

Expected: OPSEC clean for index.html. Link check still failing on methodology.html (will resolve in Phase 3).

- [ ] **Step 3: Commit**

```bash
git add index.html
git commit -m "$(cat <<'EOF'
Rewrite footer for water utility positioning

New tagline, new footer-col structure with Methodology, About,
Sample Report, and contact links. LinkedIn link preserved. Legal
links preserved.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

## Phase 3: Methodology Page

### Task 19: Create methodology.html scaffold

**Files:**
- Create: `methodology.html`

- [ ] **Step 1: Copy about.html as a starting template**

```bash
cp /home/ubuntu/sentinelot-site/about.html /home/ubuntu/sentinelot-site/methodology.html
```

The scaffold now has the shared CSS variables, nav structure, and general layout. You will replace the body and update the head.

- [ ] **Step 2: Update the head block in methodology.html**

Open `methodology.html` and replace:
- `<title>` with `<title>Methodology | Sentinel OT</title>`
- The meta description with: `<meta name="description" content="How Sentinel OT identifies IT and OT exposure through passive intelligence. Methodology, verification chain, standards referenced, and the legal basis for passive assessment.">`

- [ ] **Step 3: Replace the nav block to match the new pattern**

Find the existing `<nav class="nav">` block in methodology.html and replace it with:

```html
  <nav class="nav">
    <div class="nav-inner">
      <a href="/" class="nav-left">
        <img src="SENTINEL-banner-with-shield.png" alt="Sentinel OT">
      </a>
      <div class="nav-links">
        <a href="/methodology.html">Methodology</a>
        <a href="/about.html">About</a>
        <a href="/sample-report.pdf" target="_blank" rel="noopener">Sample Report</a>
        <a href="/#contact" class="nav-cta">Get in touch</a>
      </div>
    </div>
  </nav>
```

- [ ] **Step 4: Commit the scaffold**

```bash
git add methodology.html
git commit -m "$(cat <<'EOF'
Scaffold methodology.html from about.html template

Head block updated with new title and description. Nav matches the
new pattern with Methodology, About, Sample Report, and Get in
touch links. Body content still placeholder from about.html and
will be replaced in the next task.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

### Task 20: Replace methodology.html body with full content

**Files:**
- Modify: `methodology.html` body section

- [ ] **Step 1: Replace everything between `<body>` and `</body>` (keeping the nav block) with this content**

After the `</nav>` closing tag, insert:

```html
  <!-- HERO (solid navy, no shader) -->
  <div style="background:var(--navy);padding:140px 0 80px;">
    <div class="container">
      <div style="max-width:760px;">
        <div class="hero-badge" style="display:inline-block;padding:6px 14px;background:#1a2940;border:1px solid #234060;border-radius:100px;font-size:1.2rem;font-weight:600;color:#38bdf8;letter-spacing:0.04em;text-transform:uppercase;margin-bottom:24px;">Methodology</div>
        <h1 style="font-size:clamp(4rem,5.5vw,6.4rem);font-weight:600;line-height:1.08;letter-spacing:-0.04em;color:#ffffff;margin-bottom:24px;">Passive intelligence, in detail.</h1>
        <p style="font-size:1.8rem;line-height:1.6;color:#cbd5e1;max-width:620px;">How Sentinel OT identifies IT and OT exposure without sending a single packet to your infrastructure.</p>
      </div>
    </div>
  </div>

  <!-- WHAT IS PASSIVE INTELLIGENCE -->
  <div class="container">
    <div class="section">
      <div class="section-label">Foundation</div>
      <h2>What passive intelligence is.</h2>

      <div style="max-width:760px;">
        <p style="font-size:1.6rem;line-height:1.7;color:var(--black-9);margin-bottom:18px;">The public internet is indexed continuously by multiple independent data providers. Industrial control systems, cellular gateways, and management interfaces that are directly reachable from the internet respond to ordinary network requests with information about themselves. That information is aggregated, catalogued, and searchable.</p>

        <p style="font-size:1.6rem;line-height:1.7;color:var(--black-9);margin-bottom:18px;">Sentinel OT uses that aggregated public intelligence to identify externally observable exposure, correlate it to specific operators using authoritative public records, and validate every finding against authoritative vulnerability databases.</p>

        <p style="font-size:1.6rem;line-height:1.7;color:var(--black-9);margin-bottom:18px;">We rely on aggregated public intelligence sources and do not operate a scanner of our own against client infrastructure. We do not send packets. We do not attempt authentication. We do not require credentials of any kind. The method is entirely observational.</p>
      </div>
    </div>
  </div>

  <!-- WHAT WE OBSERVE -->
  <div class="container">
    <div class="section" style="padding-top:20px;">
      <div class="section-label">Scope</div>
      <h2>What we observe.</h2>
      <p class="section-desc">The externally observable surface area we cover on every engagement.</p>

      <ul style="list-style:none;padding:0;margin:0;max-width:760px;display:flex;flex-direction:column;gap:12px;">
        <li style="font-size:1.5rem;color:var(--black-9);line-height:1.55;padding:14px 18px;background:var(--white);border:1px solid var(--border);border-radius:10px;">Internet-facing programmable logic controllers from Allen-Bradley, Schneider Electric, Siemens, and other major industrial vendors</li>
        <li style="font-size:1.5rem;color:var(--black-9);line-height:1.55;padding:14px 18px;background:var(--white);border:1px solid var(--border);border-radius:10px;">Cellular SCADA gateways from Microhard Systems, Sierra Wireless, Digi International, and other telemetry equipment vendors</li>
        <li style="font-size:1.5rem;color:var(--black-9);line-height:1.55;padding:14px 18px;background:var(--white);border:1px solid var(--border);border-radius:10px;">SCADA radio management interfaces and industrial telemetry systems</li>
        <li style="font-size:1.5rem;color:var(--black-9);line-height:1.55;padding:14px 18px;background:var(--white);border:1px solid var(--border);border-radius:10px;">Exposed administrative services on control equipment (FTP, Telnet, SSH, HTTP, HTTPS)</li>
        <li style="font-size:1.5rem;color:var(--black-9);line-height:1.55;padding:14px 18px;background:var(--white);border:1px solid var(--border);border-radius:10px;">Misconfigured DNS resolvers and mail services on infrastructure hosts</li>
        <li style="font-size:1.5rem;color:var(--black-9);line-height:1.55;padding:14px 18px;background:var(--white);border:1px solid var(--border);border-radius:10px;">Industrial protocol identity responses (EtherNet/IP, Modbus TCP, DNP3, BACnet)</li>
        <li style="font-size:1.5rem;color:var(--black-9);line-height:1.55;padding:14px 18px;background:var(--white);border:1px solid var(--border);border-radius:10px;">SSL and TLS certificate transparency logs</li>
        <li style="font-size:1.5rem;color:var(--black-9);line-height:1.55;padding:14px 18px;background:var(--white);border:1px solid var(--border);border-radius:10px;">Public business records, EPA ECHO, and CISA advisories for operator attribution</li>
      </ul>
    </div>
  </div>

  <!-- VALIDATION CHAIN -->
  <div class="container">
    <div class="section" style="padding-top:20px;">
      <div class="section-label">Verification</div>
      <h2>Every finding is independently verified.</h2>

      <div style="max-width:760px;">
        <p style="font-size:1.6rem;line-height:1.7;color:var(--black-9);margin-bottom:18px;"><strong style="color:var(--black);">Vulnerability data</strong> is verified against the National Vulnerability Database and the CISA Known Exploited Vulnerabilities catalog. CVSS scores are cross-referenced. CWE categories are confirmed.</p>

        <p style="font-size:1.6rem;line-height:1.7;color:var(--black-9);margin-bottom:18px;"><strong style="color:var(--black);">Operator attribution</strong> is verified against authoritative public records: EPA ECHO for water systems, PHMSA for pipeline operators, state procurement records, SSL certificate organization fields, and Certificate Transparency logs.</p>

        <p style="font-size:1.6rem;line-height:1.7;color:var(--black-9);margin-bottom:18px;"><strong style="color:var(--black);">Hardware identity</strong> is verified against vendor documentation, IEEE-registered Organizationally Unique Identifier records, and industrial protocol self-identification responses.</p>

        <p style="font-size:1.6rem;line-height:1.7;color:var(--black-9);margin-bottom:0;">If we cannot verify a finding against an independent source, it does not appear in the report.</p>
      </div>
    </div>
  </div>

  <!-- STANDARDS REFERENCED -->
  <div class="container">
    <div class="section" style="padding-top:20px;">
      <div class="section-label">Standards</div>
      <h2>Standards referenced.</h2>
      <p class="section-desc">Every engagement maps findings and remediation to recognized industry and federal standards.</p>

      <table style="width:100%;max-width:860px;border-collapse:collapse;margin-top:8px;font-size:1.4rem;">
        <thead>
          <tr>
            <th style="text-align:left;padding:14px 18px;border-bottom:1px solid var(--border);background:var(--bg-card);font-weight:600;color:var(--black);text-transform:uppercase;font-size:1.15rem;letter-spacing:0.06em;">Standard</th>
            <th style="text-align:left;padding:14px 18px;border-bottom:1px solid var(--border);background:var(--bg-card);font-weight:600;color:var(--black);text-transform:uppercase;font-size:1.15rem;letter-spacing:0.06em;">What it covers</th>
          </tr>
        </thead>
        <tbody>
          <tr><td style="padding:14px 18px;border-bottom:1px solid var(--border);color:var(--black-9);"><strong style="color:var(--black);">IEC 62443</strong></td><td style="padding:14px 18px;border-bottom:1px solid var(--border);color:var(--black-9);">Industrial automation and control systems security. Zones and conduits framework, compensating controls. International reference standard for OT security.</td></tr>
          <tr><td style="padding:14px 18px;border-bottom:1px solid var(--border);color:var(--black-9);"><strong style="color:var(--black);">NIST SP 800-82 Rev 3</strong></td><td style="padding:14px 18px;border-bottom:1px solid var(--border);color:var(--black-9);">Industrial Control Systems Security Guide. The US federal reference document for OT risk assessment.</td></tr>
          <tr><td style="padding:14px 18px;border-bottom:1px solid var(--border);color:var(--black-9);"><strong style="color:var(--black);">CISA Cybersecurity Performance Goals 2.0</strong></td><td style="padding:14px 18px;border-bottom:1px solid var(--border);color:var(--black-9);">Cross-sector cybersecurity baseline recommended for all critical infrastructure.</td></tr>
          <tr><td style="padding:14px 18px;border-bottom:1px solid var(--border);color:var(--black-9);"><strong style="color:var(--black);">America's Water Infrastructure Act</strong></td><td style="padding:14px 18px;border-bottom:1px solid var(--border);color:var(--black-9);">Federal statute requiring community water systems to complete Risk and Resilience Assessments and Emergency Response Plans.</td></tr>
          <tr><td style="padding:14px 18px;border-bottom:1px solid var(--border);color:var(--black-9);"><strong style="color:var(--black);">EPA Water Sector Cybersecurity Guidance</strong></td><td style="padding:14px 18px;color:var(--black-9);">Non-binding reference used in AWIA enforcement and compliance context.</td></tr>
        </tbody>
      </table>
    </div>
  </div>

  <!-- WHAT WE DO NOT DO -->
  <div class="container">
    <div class="section" style="padding-top:20px;">
      <div class="section-label">Boundaries</div>
      <h2>What we do not do.</h2>

      <ul style="list-style:none;padding:0;margin:24px 0 0;display:grid;grid-template-columns:1fr;gap:14px;max-width:680px;">
        <li style="display:flex;align-items:flex-start;gap:14px;font-size:1.55rem;line-height:1.5;color:var(--black-9);padding:14px 18px;background:var(--white);border:1px solid var(--border);border-radius:10px;"><span style="flex-shrink:0;width:26px;height:26px;background:var(--danger-light);color:var(--danger);border-radius:6px;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:1.3rem;">✕</span>We do not scan your internal network.</li>
        <li style="display:flex;align-items:flex-start;gap:14px;font-size:1.55rem;line-height:1.5;color:var(--black-9);padding:14px 18px;background:var(--white);border:1px solid var(--border);border-radius:10px;"><span style="flex-shrink:0;width:26px;height:26px;background:var(--danger-light);color:var(--danger);border-radius:6px;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:1.3rem;">✕</span>We do not send packets to your infrastructure.</li>
        <li style="display:flex;align-items:flex-start;gap:14px;font-size:1.55rem;line-height:1.5;color:var(--black-9);padding:14px 18px;background:var(--white);border:1px solid var(--border);border-radius:10px;"><span style="flex-shrink:0;width:26px;height:26px;background:var(--danger-light);color:var(--danger);border-radius:6px;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:1.3rem;">✕</span>We do not attempt authentication on any system.</li>
        <li style="display:flex;align-items:flex-start;gap:14px;font-size:1.55rem;line-height:1.5;color:var(--black-9);padding:14px 18px;background:var(--white);border:1px solid var(--border);border-radius:10px;"><span style="flex-shrink:0;width:26px;height:26px;background:var(--danger-light);color:var(--danger);border-radius:6px;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:1.3rem;">✕</span>We do not execute exploits.</li>
        <li style="display:flex;align-items:flex-start;gap:14px;font-size:1.55rem;line-height:1.5;color:var(--black-9);padding:14px 18px;background:var(--white);border:1px solid var(--border);border-radius:10px;"><span style="flex-shrink:0;width:26px;height:26px;background:var(--danger-light);color:var(--danger);border-radius:6px;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:1.3rem;">✕</span>We do not require credentials, VPN access, or any form of inside access.</li>
      </ul>

      <p style="margin-top:24px;font-size:1.5rem;color:var(--black-9);max-width:760px;line-height:1.65;">Our findings describe the externally observable attack surface of your infrastructure. They do not describe your internal network, your operator training, your physical security posture, your change management procedures, or your emergency response plan. Those assessments require an authorized internal engagement by a different kind of provider. We are explicit about what we can and cannot see, in every report we produce.</p>
    </div>
  </div>

  <!-- LEGAL BASIS -->
  <div class="container">
    <div class="section" style="padding-top:20px;">
      <div class="section-label">Legal</div>
      <h2>Why this work does not require your authorization.</h2>

      <div style="max-width:760px;">
        <p style="font-size:1.6rem;line-height:1.7;color:var(--black-9);margin-bottom:18px;">The Computer Fraud and Abuse Act, codified at 18 U.S.C. section 1030, prohibits unauthorized access to a protected computer. Sentinel OT never accesses any client system. The information we use is already public, aggregated by third parties, and available to any researcher, defender, or adversary. Observing what is publicly visible is not access.</p>

        <p style="font-size:1.6rem;line-height:1.7;color:var(--black-9);margin-bottom:0;">This is the same legal footing used by CISA, United States Computer Emergency Readiness Team, academic security research teams, and commercial threat intelligence firms. The work is defensive by design, passive by construction, and legal by default.</p>
      </div>
    </div>
  </div>

  <!-- CTA -->
  <div class="container">
    <div class="cta-section">
      <h2>Start with evidence.</h2>
      <p>Read the sample report, or send us a note.</p>
      <div style="display:flex;gap:16px;justify-content:center;flex-wrap:wrap;margin-top:24px;">
        <a href="/sample-report.pdf" class="btn-primary" target="_blank" rel="noopener">Read sample report</a>
        <a href="/#contact" class="btn-primary" style="background:transparent;border:1px solid var(--border);color:var(--black);">Get in touch</a>
      </div>
    </div>
  </div>

  <!-- FOOTER -->
  <footer>
    <div class="container">
      <div class="footer-grid">
        <div class="footer-brand">
          <img src="SENTINEL-banner-with-shield.png" alt="Sentinel OT">
          <p>The single accountable IT/OT security partner for US water utilities.</p>
        </div>
        <div class="footer-col">
          <h4>Sentinel OT</h4>
          <a href="/methodology.html">Methodology</a>
          <a href="/about.html">About</a>
          <a href="/sample-report.pdf" target="_blank" rel="noopener">Sample Report</a>
        </div>
        <div class="footer-col">
          <h4>Get in touch</h4>
          <a href="/#contact">Contact form</a>
        </div>
        <div class="footer-col">
          <h4>Legal</h4>
          <a href="/privacy.html">Privacy Policy</a>
          <a href="/terms.html">Terms of Service</a>
        </div>
      </div>
      <div class="footer-bottom">
        <p>&copy; 2026 Sentinel OT. All rights reserved.</p>
        <p>Public and passive sources only. Findings are for defensive modernization.</p>
      </div>
    </div>
  </footer>
```

Remove any leftover body content from the about.html scaffold that is not in the block above.

- [ ] **Step 2: Run OPSEC check**

```bash
./scripts/opsec-check.sh
```

Expected: No failures on methodology.html.

- [ ] **Step 3: Run link check**

```bash
./scripts/link-check.sh
```

Expected: All links resolve. index.html link to methodology.html now passes.

- [ ] **Step 4: Commit**

```bash
git add methodology.html
git commit -m "$(cat <<'EOF'
Fill methodology.html with full content

Seven sections: hero, what passive intelligence is, what we
observe, validation chain, standards referenced, what we do not
do, and legal basis. Closes with a CTA linking to sample report
and the homepage contact anchor. Uses existing site CSS variables
and inline styles for section-specific layout.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

## Phase 4: About Page Rewrite

### Task 21: Rewrite the about page

**Files:**
- Modify: `about.html`

- [ ] **Step 1: Update head block**

Replace the `<title>` and meta description in about.html with:

```html
  <title>About | Sentinel OT</title>
  <meta name="description" content="Sentinel OT is the single accountable IT/OT security partner for US water utilities. Headquartered in Calgary, Alberta with US delivery operations in Houston, TX.">
```

- [ ] **Step 2: Update nav block**

Find the nav block in about.html and replace with the same pattern used on methodology.html:

```html
  <nav class="nav">
    <div class="nav-inner">
      <a href="/" class="nav-left">
        <img src="SENTINEL-banner-with-shield.png" alt="Sentinel OT">
      </a>
      <div class="nav-links">
        <a href="/methodology.html">Methodology</a>
        <a href="/about.html">About</a>
        <a href="/sample-report.pdf" target="_blank" rel="noopener">Sample Report</a>
        <a href="/#contact" class="nav-cta">Get in touch</a>
      </div>
    </div>
  </nav>
```

- [ ] **Step 3: Replace everything between `</nav>` and `</body>` with this body content**

```html
  <!-- HERO -->
  <div style="background:var(--navy);padding:140px 0 80px;">
    <div class="container">
      <div style="max-width:820px;">
        <div style="display:inline-block;padding:6px 14px;background:#1a2940;border:1px solid #234060;border-radius:100px;font-size:1.2rem;font-weight:600;color:#38bdf8;letter-spacing:0.04em;text-transform:uppercase;margin-bottom:24px;">About Sentinel OT</div>
        <h1 style="font-size:clamp(3.4rem,4.8vw,5.6rem);font-weight:600;line-height:1.1;letter-spacing:-0.03em;color:#ffffff;margin-bottom:24px;">Sentinel OT is the single accountable IT/OT security partner for US water utilities.</h1>
        <p style="font-size:1.8rem;line-height:1.6;color:#cbd5e1;max-width:680px;">We find what is exposed. We help you fund the fix. We deliver the remediation. We monitor it after. One contract. One invoice. One point of contact.</p>
      </div>
    </div>
  </div>

  <!-- WHAT WE DO -->
  <div class="container">
    <div class="section">
      <div class="section-label">What We Do</div>
      <h2>End to end, under one name.</h2>
      <div style="max-width:760px;">
        <p style="font-size:1.6rem;line-height:1.7;color:var(--black-9);">Sentinel OT identifies externally observable IT and OT exposure in US water utility infrastructure, helps the affected community secure the state and federal grant funding to remediate it, and delivers the remediation under a single contract. Our work begins with a formal vulnerability report and ends with a validated, monitored system. Every finding we publish is observable from the public internet, verified against authoritative sources, and documented to the standards a municipal procurement officer can take to counsel.</p>
      </div>
    </div>
  </div>

  <!-- WHAT WE DO NOT DO -->
  <div class="container">
    <div class="section" style="padding-top:20px;">
      <div class="section-label">Boundaries</div>
      <h2>What we do not do.</h2>
      <ul style="list-style:none;padding:0;margin:24px 0 0;display:grid;grid-template-columns:1fr;gap:14px;max-width:680px;">
        <li style="display:flex;align-items:flex-start;gap:14px;font-size:1.55rem;line-height:1.5;color:var(--black-9);padding:14px 18px;background:var(--white);border:1px solid var(--border);border-radius:10px;"><span style="flex-shrink:0;width:26px;height:26px;background:var(--danger-light);color:var(--danger);border-radius:6px;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:1.3rem;">✕</span>We do not scan your internal network.</li>
        <li style="display:flex;align-items:flex-start;gap:14px;font-size:1.55rem;line-height:1.5;color:var(--black-9);padding:14px 18px;background:var(--white);border:1px solid var(--border);border-radius:10px;"><span style="flex-shrink:0;width:26px;height:26px;background:var(--danger-light);color:var(--danger);border-radius:6px;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:1.3rem;">✕</span>We do not send packets to your infrastructure.</li>
        <li style="display:flex;align-items:flex-start;gap:14px;font-size:1.55rem;line-height:1.5;color:var(--black-9);padding:14px 18px;background:var(--white);border:1px solid var(--border);border-radius:10px;"><span style="flex-shrink:0;width:26px;height:26px;background:var(--danger-light);color:var(--danger);border-radius:6px;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:1.3rem;">✕</span>We do not attempt authentication on any system.</li>
        <li style="display:flex;align-items:flex-start;gap:14px;font-size:1.55rem;line-height:1.5;color:var(--black-9);padding:14px 18px;background:var(--white);border:1px solid var(--border);border-radius:10px;"><span style="flex-shrink:0;width:26px;height:26px;background:var(--danger-light);color:var(--danger);border-radius:6px;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:1.3rem;">✕</span>We do not execute exploits.</li>
        <li style="display:flex;align-items:flex-start;gap:14px;font-size:1.55rem;line-height:1.5;color:var(--black-9);padding:14px 18px;background:var(--white);border:1px solid var(--border);border-radius:10px;"><span style="flex-shrink:0;width:26px;height:26px;background:var(--danger-light);color:var(--danger);border-radius:6px;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:1.3rem;">✕</span>We do not require credentials, VPN access, or any form of inside access.</li>
      </ul>
    </div>
  </div>

  <!-- WHAT WE BELIEVE -->
  <div class="container">
    <div class="section" style="padding-top:20px;">
      <div class="section-label">Principles</div>
      <h2>What we believe.</h2>
      <div style="max-width:760px;display:flex;flex-direction:column;gap:28px;margin-top:32px;">
        <div>
          <h3 style="font-size:2rem;font-weight:600;color:var(--black);letter-spacing:-0.01em;margin-bottom:8px;">Public infrastructure deserves private-sector rigor.</h3>
          <p style="font-size:1.5rem;color:var(--black-9);line-height:1.6;">Small and mid-sized water utilities serve communities that cannot absorb a treatment plant failure. The work we do for them is the work large enterprises pay six figures for.</p>
        </div>
        <div>
          <h3 style="font-size:2rem;font-weight:600;color:var(--black);letter-spacing:-0.01em;margin-bottom:8px;">Passive by construction.</h3>
          <p style="font-size:1.5rem;color:var(--black-9);line-height:1.6;">The only safe way to assess a control system from the outside is to not touch it. Every method we use is legal by design, not legal by permission.</p>
        </div>
        <div>
          <h3 style="font-size:2rem;font-weight:600;color:var(--black);letter-spacing:-0.01em;margin-bottom:8px;">Grant dollars are part of the job.</h3>
          <p style="font-size:1.5rem;color:var(--black-9);line-height:1.6;">Finding the exposure is the first half. Funding the fix is the second half. A shop that only does one of those is not actually solving the problem.</p>
        </div>
        <div>
          <h3 style="font-size:2rem;font-weight:600;color:var(--black);letter-spacing:-0.01em;margin-bottom:8px;">One accountable partner.</h3>
          <p style="font-size:1.5rem;color:var(--black-9);line-height:1.6;">Municipal buyers do not have time to coordinate three vendors. We are the prime, the single point of contact, and the single invoice. Everything else happens behind that interface.</p>
        </div>
      </div>
    </div>
  </div>

  <!-- WHERE WE WORK -->
  <div class="container">
    <div class="section" style="padding-top:20px;">
      <div class="section-label">Where We Work</div>
      <h2>Calgary and Houston. Work across the United States.</h2>
      <div style="max-width:760px;">
        <p style="font-size:1.6rem;line-height:1.7;color:var(--black-9);">Sentinel OT is headquartered in Calgary, Alberta with US delivery operations in Houston, TX, and serves water utilities across the United States. Our engagement model is designed for US federal and state grant compliance, including AWIA, SLCGP, and state water-sector cybersecurity programs.</p>
      </div>
    </div>
  </div>

  <!-- CTA -->
  <div class="container">
    <div class="cta-section">
      <h2>Get in touch.</h2>
      <p>Tell us what you're working on and we will respond within one business day.</p>
      <a href="/#contact" class="btn-primary">Go to contact form</a>
    </div>
  </div>

  <!-- FOOTER -->
  <footer>
    <div class="container">
      <div class="footer-grid">
        <div class="footer-brand">
          <img src="SENTINEL-banner-with-shield.png" alt="Sentinel OT">
          <p>The single accountable IT/OT security partner for US water utilities.</p>
        </div>
        <div class="footer-col">
          <h4>Sentinel OT</h4>
          <a href="/methodology.html">Methodology</a>
          <a href="/about.html">About</a>
          <a href="/sample-report.pdf" target="_blank" rel="noopener">Sample Report</a>
        </div>
        <div class="footer-col">
          <h4>Get in touch</h4>
          <a href="/#contact">Contact form</a>
        </div>
        <div class="footer-col">
          <h4>Legal</h4>
          <a href="/privacy.html">Privacy Policy</a>
          <a href="/terms.html">Terms of Service</a>
        </div>
      </div>
      <div class="footer-bottom">
        <p>&copy; 2026 Sentinel OT. All rights reserved.</p>
        <p>Public and passive sources only. Findings are for defensive modernization.</p>
      </div>
    </div>
  </footer>
```

- [ ] **Step 4: Run OPSEC check and link check**

```bash
./scripts/opsec-check.sh && ./scripts/link-check.sh
```

Expected: Both pass. All files clean.

- [ ] **Step 5: Commit**

```bash
git add about.html
git commit -m "$(cat <<'EOF'
Rewrite about page for water utility positioning

New hero, what we do paragraph, what we do not do list, four
principles (public infrastructure, passive by construction, grant
dollars, one accountable partner), and a where-we-work block that
names Calgary as headquarters and Houston as US delivery
operations. No team section.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

## Phase 5: Final Verification and Deployment

### Task 22: Full site verification

**Files:** None modified.

- [ ] **Step 1: Run OPSEC check across all files**

```bash
cd /home/ubuntu/sentinelot-site && ./scripts/opsec-check.sh
```

Expected: `OK: no forbidden content found`

If any failure, fix the offending file, commit the fix as its own commit, and re-run.

- [ ] **Step 2: Run link check across all files**

```bash
./scripts/link-check.sh
```

Expected: `OK: all internal links resolve`

If any failure, fix the offending link, commit the fix, and re-run.

- [ ] **Step 3: Verify schema.org JSON parses**

```bash
python3 -c "import json,re,sys; html=open('index.html').read(); m=re.search(r'<script type=\"application/ld\\+json\">(.*?)</script>', html, re.DOTALL); assert m, 'no schema found'; data=json.loads(m.group(1)); print('schema.org OK. Organization type:', data.get('@type')); print('locations:', [loc.get('name') for loc in data.get('location',[])])"
```

Expected: `schema.org OK. Organization type: Organization` followed by the two location names.

- [ ] **Step 4: Verify all required homepage sections are present**

```bash
for phrase in \
  "The IT/OT security partner for US water utilities" \
  "The quiet problem\|Most small and mid-sized" \
  "From a recent assessment" \
  "One partner. Four stages" \
  "The money is already there" \
  "What we do not do" \
  "What a Sentinel OT engagement looks like" \
  "Before you reply" \
  "replying_to_report"; do
  if grep -q "$phrase" index.html; then
    echo "OK: $phrase"
  else
    echo "MISSING: $phrase"
  fi
done
```

Expected: Every line prints `OK:`. If any prints `MISSING:`, go back to the relevant phase task.

- [ ] **Step 5: Verify methodology and about pages have their key sections**

```bash
for phrase in "Passive intelligence, in detail" "What passive intelligence is" "What we observe" "Every finding is independently verified" "Why this work does not require your authorization"; do
  if grep -q "$phrase" methodology.html; then
    echo "methodology OK: $phrase"
  else
    echo "methodology MISSING: $phrase"
  fi
done

for phrase in "Sentinel OT is the single accountable" "End to end, under one name" "What we believe" "Calgary and Houston"; do
  if grep -q "$phrase" about.html; then
    echo "about OK: $phrase"
  else
    echo "about MISSING: $phrase"
  fi
done
```

Expected: All `OK:` lines.

- [ ] **Step 6: Smoke test in a browser (manual)**

Open each page in a browser from the file system:

```bash
echo "Open these URLs in a browser:"
echo "  file:///home/ubuntu/sentinelot-site/index.html"
echo "  file:///home/ubuntu/sentinelot-site/methodology.html"
echo "  file:///home/ubuntu/sentinelot-site/about.html"
```

Manual checklist:
- [ ] Homepage hero renders with shader background
- [ ] Nav shows four links: Methodology, About, Sample Report, Get in touch
- [ ] All nine homepage sections visible when scrolling
- [ ] Grant table renders with headers and six rows
- [ ] AWIA callout block is visually distinct (yellow background, left border)
- [ ] FAQ items render as individual cards
- [ ] Contact form shows the "Are you replying to a Sentinel OT report?" radio
- [ ] Methodology page renders all seven content sections
- [ ] About page renders all five content sections
- [ ] Sample Report link opens the PDF in a new tab on all three pages
- [ ] Mobile layout does not break below 768px (use browser dev tools)

- [ ] **Step 7: No commit required for verification. Report results to user.**

Write a short summary of the verification results to the session so the user can review before deployment.

---

### Task 23: Deploy to gh-pages

**Files:** None modified. This is a git operation only.

- [ ] **Step 1: Confirm main branch is clean and up to date**

```bash
cd /home/ubuntu/sentinelot-site && git status && git log --oneline -15
```

Expected: Clean working tree, recent commits reflect all phase work.

- [ ] **Step 2: Push to main**

```bash
git push origin main
```

Expected: Successful push.

- [ ] **Step 3: Push main to gh-pages**

```bash
git push origin main:gh-pages
```

Expected: Successful push. This is what actually deploys the site per the repo CLAUDE.md.

- [ ] **Step 4: Verify deployment**

Wait approximately 60 seconds for GitHub Pages to rebuild, then open `https://sentinelot.com/` in a browser and confirm:
- Homepage loads with new hero and content
- Methodology page loads at `https://sentinelot.com/methodology.html`
- About page loads with rewritten content
- Sample report PDF loads at `https://sentinelot.com/sample-report.pdf`

- [ ] **Step 5: Report deployment status to user**

---

## Plan Self-Review

Before handing off, verify the following against the spec at [docs/superpowers/specs/2026-04-15-water-utility-repositioning-design.md](../specs/2026-04-15-water-utility-repositioning-design.md):

**Spec coverage:**
- Sitemap: covered in Tasks 19 (methodology), 21 (about), Phase 2 (homepage)
- Homepage hero: Task 9
- Quiet problem section: Task 10
- Proof strip: Task 11
- Four-stage pipeline: Task 12
- Grant funding landscape: Task 13
- What we do not do: Task 14
- Engagement timeline: Task 15
- FAQ: Task 16
- Contact section: Task 17
- Footer: Task 18
- Methodology page: Tasks 19-20
- About page rewrite: Task 21
- Sample report PDF: Tasks 3-5
- schema.org update: Task 6
- OPSEC guardrails: Tasks 1-2, verified in Task 22

**Placeholder scan:** No `TBD`, `TODO`, "add appropriate error handling", or similar. All copy is verbatim from the spec or directly expanded from it.

**Type consistency:** No typed signatures to verify (HTML project). CSS class names used in content tasks (`.proof-block`, `.stage`, `.grant-table`, `.awia-callout`, `.do-not-list`, `.engagement-timeline`, `.tl-item`, `.pricing-block`, `.faq-list`, `.faq-item`) are all defined in Task 8.

**Scope check:** Single focused implementation plan. Sample report is a prerequisite for homepage link validation and is produced in Phase 1 before the homepage rewrite.
