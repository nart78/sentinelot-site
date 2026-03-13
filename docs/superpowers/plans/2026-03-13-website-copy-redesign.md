# Sentinel OT Website Copy Redesign Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rewrite sentinelot.com copy to obscure methodology, broaden buyer positioning, and replace the sample-lead modal with a simple "Get in touch" inline form.

**Architecture:** Single file edit -- `index.html` only. No CSS changes. No new files except inline form styles (added to existing `<style>` block if needed). All changes are find-and-replace on specific HTML blocks.

**Tech Stack:** Static HTML, Formspree (existing endpoint `https://formspree.io/f/mzdakpwg`), GitHub Pages.

---

## Chunk 1: Navigation, Hero, and Section 2

### Task 1: Update navigation

**Files:**
- Modify: `index.html:1481-1486`

> **Note:** Tasks 1 and 2 introduce `href="#contact"` anchors. The `id="contact"` element is added in Chunk 2 Task 6. Do NOT deploy to GitHub Pages until Chunk 2 Task 6 is complete, or the nav/hero CTAs will have broken anchors.

- [ ] **Step 1: Remove the "How It Works" and "For Buyers" nav links, update CTA**

Note: the `<div class="nav-links">` wrapper is NOT included in the replacement strings below -- it stays in place. Only the inner `<a>` tags change.

Replace:
```html
        <a href="#how-it-works">How It Works</a>
        <a href="#buyers">For Buyers</a>
        <a href="/guides/scada-lead-intelligence-2026">Guide</a>
        <a href="#" onclick="openContactForm();return false" class="nav-cta">Request Sample</a>
```
With:
```html
        <a href="/guides/scada-lead-intelligence-2026">Guide</a>
        <a href="#contact" class="nav-cta">Get in touch</a>
```

- [ ] **Step 2: Verify**

Run:
```bash
grep -n "how-it-works\|For Buyers\|Request Sample\|openContactForm" ~/sentinelot-site/index.html | head -5
```
Expected: no matches on lines 1481-1486. The only remaining `how-it-works` and `openContactForm` references should be elsewhere in the file (will be cleaned up in later tasks).

- [ ] **Step 3: Commit**

```bash
cd ~/sentinelot-site && git add index.html && git commit -m "feat: update nav -- remove methodology links, replace CTA"
```

---

### Task 2: Update hero copy

**Files:**
- Modify: `index.html:1496-1503`

- [ ] **Step 1: Replace hero badge, H1, description, CTAs, and trust line**

Replace:
```html
        <div class="hero-badge">Passive ICS Intelligence</div>
        <h1>Qualified vulnerability leads.<br><span class="muted">Without the guesswork.</span></h1>
        <p class="hero-desc">Sentinel OT delivers firmware-validated intelligence packages for OT professionals. Confirmed operators, validated CVEs, and decision-maker contacts. Ready for your sales team.</p>
        <div class="hero-actions">
          <a href="#" onclick="openContactForm();return false" class="btn-primary">Request a Sample Lead</a>
          <a href="#how-it-works" class="btn-text">See how it works &darr;</a>
        </div>
        <p class="hero-trust">100% passive sources &middot; No active scanning &middot; Ever.</p>
```
With:
```html
        <div class="hero-badge">OT Intelligence</div>
        <h1>Intelligence for critical<br><span class="muted">infrastructure.</span></h1>
        <p class="hero-desc">Sentinel OT monitors critical infrastructure sectors and delivers actionable intelligence to the organizations that need it.</p>
        <div class="hero-actions">
          <a href="#contact" class="btn-primary">Get in touch</a>
        </div>
```

- [ ] **Step 2: Verify**

Run:
```bash
grep -n "Passive ICS\|firmware-validated\|hero-trust\|how-it-works\|Request a Sample Lead" ~/sentinelot-site/index.html | head -5
```
Expected: no matches in the hero block (lines ~1496-1503).

- [ ] **Step 3: Commit**

```bash
cd ~/sentinelot-site && git add index.html && git commit -m "feat: rewrite hero -- OT Intelligence badge, new headline and description"
```

---

### Task 3: Replace Section 2 (features) with coverage grid

**Files:**
- Modify: `index.html:1572-1779`

The entire FEATURES block (from `<!-- FEATURES -->` comment through its closing `</div></div>` at line 1779) is replaced with a 4-card coverage grid.

- [ ] **Step 1: Replace the entire features section**

This is a large block replacement. Use the Edit tool with the exact opening anchor and exact closing anchor shown below. The block spans from the `<!-- FEATURES -->` comment through the first divider line before `<!-- METHODOLOGY -->`.

Replace everything from:
```html
  <!-- FEATURES -->
  <div class="container">
    <div class="section">
      <div class="section-label">What We Deliver</div>
      <h2>Every lead is a qualified<br>intelligence package</h2>
      <p class="section-desc">We don't hand you a list of IP addresses. Every lead is a researched, validated, ready-to-pitch report with everything your sales team needs.</p>
```
through the closing:
```html
    </div>
  </div>

  <div class="container"><div class="divider"></div></div>

  <!-- METHODOLOGY -->
```
With:
```html
  <!-- COVERAGE -->
  <div class="container">
    <div class="section">
      <div class="section-label">Coverage</div>
      <h2>Intelligence across critical infrastructure.</h2>

      <div style="display:grid;grid-template-columns:repeat(2,1fr);gap:24px;margin-top:40px;">

        <div style="background:var(--accent-light);border:1px solid rgba(14,165,233,0.15);border-radius:12px;padding:28px;">
          <div style="font-size:1.1rem;font-weight:600;text-transform:uppercase;letter-spacing:0.08em;color:var(--accent);margin-bottom:10px;">Oil &amp; Gas</div>
          <div style="font-size:1.8rem;font-weight:600;color:var(--black);margin-bottom:10px;letter-spacing:-0.02em;">Pipeline &amp; Refinery</div>
          <div style="font-size:1.5rem;color:var(--black-7);">Exposure intelligence for upstream, midstream, and downstream operations.</div>
        </div>

        <div style="background:var(--accent-light);border:1px solid rgba(14,165,233,0.15);border-radius:12px;padding:28px;">
          <div style="font-size:1.1rem;font-weight:600;text-transform:uppercase;letter-spacing:0.08em;color:var(--accent);margin-bottom:10px;">Water &amp; Wastewater</div>
          <div style="font-size:1.8rem;font-weight:600;color:var(--black);margin-bottom:10px;letter-spacing:-0.02em;">Treatment &amp; Distribution</div>
          <div style="font-size:1.5rem;color:var(--black-7);">Risk intelligence for municipal water systems and treatment infrastructure.</div>
        </div>

        <div style="background:var(--accent-light);border:1px solid rgba(14,165,233,0.15);border-radius:12px;padding:28px;">
          <div style="font-size:1.1rem;font-weight:600;text-transform:uppercase;letter-spacing:0.08em;color:var(--accent);margin-bottom:10px;">Power &amp; Utilities</div>
          <div style="font-size:1.8rem;font-weight:600;color:var(--black);margin-bottom:10px;letter-spacing:-0.02em;">Generation &amp; Transmission</div>
          <div style="font-size:1.5rem;color:var(--black-7);">Operational intelligence across generation, substation, and distribution assets.</div>
        </div>

        <div style="background:var(--accent-light);border:1px solid rgba(14,165,233,0.15);border-radius:12px;padding:28px;">
          <div style="font-size:1.1rem;font-weight:600;text-transform:uppercase;letter-spacing:0.08em;color:var(--accent);margin-bottom:10px;">Medical Devices</div>
          <div style="font-size:1.8rem;font-weight:600;color:var(--black);margin-bottom:10px;letter-spacing:-0.02em;">Connected Healthcare</div>
          <div style="font-size:1.5rem;color:var(--black-7);">Vulnerability intelligence for networked medical devices and clinical systems.</div>
        </div>

      </div>

      <p style="margin-top:28px;font-size:1.5rem;color:var(--black-7);">Delivered as decision-ready intelligence reports.</p>

    </div>
  </div>

  <div class="container"><div class="divider"></div></div>

  <!-- METHODOLOGY -->
```

- [ ] **Step 2: Verify**

Run:
```bash
grep -n "intelligence package\|Firmware-Validated\|Confirmed Operators\|Decision-Maker Contacts\|Full Project Scope\|Risk Assessment\|feature-row" ~/sentinelot-site/index.html
```
Expected: no matches (all feature rows removed).

Run:
```bash
grep -n "Intelligence across critical infrastructure\|Oil.*Gas\|Water.*Wastewater\|Power.*Utilities\|Medical Devices" ~/sentinelot-site/index.html
```
Expected: 5 matches (heading + 4 sector labels).

- [ ] **Step 3: Commit**

```bash
cd ~/sentinelot-site && git add index.html && git commit -m "feat: replace features section with 4-sector coverage grid"
```

---

## Chunk 2: Remove Methodology, Replace Buyers, Update CTA, Clean Up

### Task 4: Remove the methodology section

**Files:**
- Modify: `index.html` (methodology block)

- [ ] **Step 1: Remove the entire methodology section including its preceding divider**

The find string must start at the divider line immediately before `<!-- METHODOLOGY -->` (line 1781) to avoid leaving an orphaned `<div class="divider">` in the page.

Replace:
```html
  <div class="container"><div class="divider"></div></div>

  <!-- METHODOLOGY -->
  <div class="container" id="how-it-works">
    <div class="section">
      <div class="section-label">Methodology</div>
      <h2>How we build a lead</h2>
      <p class="section-desc">Five steps from raw signal to ready-to-pitch intelligence. All passive. All verified.</p>

      <div class="method-grid">
        <div class="method-step">
          <div class="method-num">1</div>
          <h3>Passive Discovery</h3>
          <p>Sentinel passive reconnaissance across 6 ICS protocols to identify exposed devices. No active scanning.</p>
        </div>
        <div class="method-step">
          <div class="method-num">2</div>
          <h3>CVE Validation</h3>
          <p>Each firmware version matched against NVD data with version-range checking.</p>
        </div>
        <div class="method-step">
          <div class="method-num">3</div>
          <h3>Operator Attribution</h3>
          <p>Cross-reference GPS, property records, EPA databases, and state filings.</p>
        </div>
        <div class="method-step">
          <div class="method-num">4</div>
          <h3>Contact Research</h3>
          <p>LinkedIn and public directory research to identify the decision maker.</p>
        </div>
        <div class="method-step">
          <div class="method-num">5</div>
          <h3>Intelligence Package</h3>
          <p>Branded PDF report with full inventory, CVEs, risk assessment, and contacts.</p>
        </div>
      </div>
    </div>
  </div>

  <div class="container"><div class="divider"></div></div>
```
With: *(nothing -- delete entirely)*

- [ ] **Step 2: Verify**

Run:
```bash
grep -n "how-it-works\|Passive Discovery\|CVE Validation\|Operator Attribution\|Contact Research\|Intelligence Package\|method-grid" ~/sentinelot-site/index.html
```
Expected: no matches.

- [ ] **Step 3: Commit**

```bash
cd ~/sentinelot-site && git add index.html && git commit -m "feat: remove methodology section"
```

---

### Task 5: Replace buyers section with single line

**Files:**
- Modify: `index.html` (buyers block)

- [ ] **Step 1: Replace the entire buyers section with a single paragraph**

Replace everything from:
```html
  <!-- BUYERS -->
  <div class="container" id="buyers">
    <div class="section">
      <div class="section-label">Who We Serve</div>
      <h2>Leads your sales team can close</h2>
      <p class="section-desc">Confirmed operator. Validated vulnerabilities. Decision-maker contact. Every lead is a ready-to-pitch package, not raw data your team has to research.</p>

      <div class="buyer-grid">
        <div class="buyer-card">
          <div class="buyer-icon">&#9881;</div>
          <h3>System Integrators</h3>
          <p>Migration project leads</p>
        </div>
        <div class="buyer-card">
          <div class="buyer-icon">&#128737;</div>
          <h3>OT Cybersecurity</h3>
          <p>Monitoring platform leads</p>
        </div>
        <div class="buyer-card">
          <div class="buyer-icon">&#128269;</div>
          <h3>Security Assessors</h3>
          <p>Assessment engagement leads</p>
        </div>
        <div class="buyer-card">
          <div class="buyer-icon">&#128230;</div>
          <h3>Hardware Distributors</h3>
          <p>Equipment replacement leads</p>
        </div>
        <div class="buyer-card">
          <div class="buyer-icon">&#128225;</div>
          <h3>Managed Security</h3>
          <p>OT monitoring contracts</p>
        </div>
        <div class="buyer-card">
          <div class="buyer-icon">&#9889;</div>
          <h3>Electrical Contractors</h3>
          <p>Field installation leads</p>
        </div>
      </div>
    </div>
  </div>
```
With:
```html
  <!-- WHO WE SERVE -->
  <div class="container">
    <div class="section" style="text-align:center;padding:32px 0;">
      <p style="font-size:1.6rem;color:var(--black-7);">Used by security firms, insurers, system integrators, and risk consultants across North America.</p>
    </div>
  </div>
```

- [ ] **Step 2: Verify**

Run:
```bash
grep -n "buyer-grid\|buyer-card\|Leads your sales team\|System Integrators\|OT Cybersecurity\|id=\"buyers\"" ~/sentinelot-site/index.html
```
Expected: no matches.

Run:
```bash
grep -n "Used by security firms" ~/sentinelot-site/index.html
```
Expected: 1 match.

- [ ] **Step 3: Commit**

```bash
cd ~/sentinelot-site && git add index.html && git commit -m "feat: replace buyers section with single positioning line"
```

---

### Task 6: Replace CTA section and modal with inline contact form

**Files:**
- Modify: `index.html` (cta-section + modal blocks)

This task replaces the `cta-section` div and the entire modal HTML with a new inline form section.

- [ ] **Step 1: Replace cta-section and modal with inline contact form**

Replace everything from:
```html
  <!-- CTA -->
  <div class="container">
    <div class="cta-section">
      <h2>See a real lead.</h2>
      <p>Request a free sample vulnerability report. A real lead with validated CVEs, confirmed operator, and decision-maker contact.</p>
      <a href="#" onclick="openContactForm();return false" class="btn-primary">Request a Sample Lead</a>
    </div>
  </div>

  <!-- CONTACT MODAL -->
  <div class="modal-overlay" id="contactModal">
    <div class="modal">
      <button class="modal-close" onclick="closeContactForm()">&times;</button>
      <div id="contactFormWrap">
        <h2>Request a Sample Lead</h2>
        <p>Get a free sample vulnerability report. A real lead with validated CVEs, confirmed operator, and decision-maker contact.</p>
        <form id="contactForm" action="https://formspree.io/f/mzdakpwg" method="POST">
          <div class="form-group">
            <label for="cf-name">Name</label>
            <input type="text" id="cf-name" name="name" required placeholder="Your name">
          </div>
          <div class="form-group">
            <label for="cf-email">Email</label>
            <input type="email" id="cf-email" name="email" required placeholder="you@company.com">
          </div>
          <div class="form-group">
            <label for="cf-company">Company</label>
            <input type="text" id="cf-company" name="company" required placeholder="Your company name">
          </div>
          <div class="form-group">
            <label for="cf-role">Company Type</label>
            <select id="cf-role" name="company_type">
              <option value="">Select company type</option>
              <option value="System Integrator">System Integrator</option>
              <option value="OT Cybersecurity">OT Cybersecurity</option>
              <option value="Security Assessor">Security Assessor</option>
              <option value="Hardware Distributor">Hardware Distributor</option>
              <option value="Managed Security Provider">Managed Security Provider</option>
              <option value="Other">Other</option>
            </select>
          </div>
          <div class="form-group">
            <label for="cf-message">Message (optional)</label>
            <textarea id="cf-message" name="message" placeholder="Tell us about your business or what you're looking for"></textarea>
          </div>
          <button type="submit" class="form-submit">Send Request</button>
        </form>
      </div>
      <div id="contactSuccess" class="form-success" style="display:none">
        <h3>Request sent</h3>
        <p>We'll get back to you within 24 hours with a sample lead package.</p>
      </div>
    </div>
  </div>
```
With:
```html
  <!-- CONTACT -->
  <div class="container" id="contact">
    <div class="cta-section">
      <h2>Get in touch.</h2>
      <p>Tell us what you're working on.</p>
      <div id="contactFormWrap" style="max-width:480px;margin:32px auto 0;text-align:left;">
        <form id="contactForm" action="https://formspree.io/f/mzdakpwg" method="POST">
          <div class="form-group">
            <label for="cf-name">Name</label>
            <input type="text" id="cf-name" name="name" required placeholder="Your name">
          </div>
          <div class="form-group">
            <label for="cf-email">Email</label>
            <input type="email" id="cf-email" name="email" required placeholder="you@company.com">
          </div>
          <div class="form-group">
            <label for="cf-company">Company</label>
            <input type="text" id="cf-company" name="company" required placeholder="Your company name">
          </div>
          <div class="form-group">
            <label for="cf-message">Message</label>
            <textarea id="cf-message" name="message" placeholder="Tell us what you're working on"></textarea>
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

- [ ] **Step 2: Verify**

Run:
```bash
grep -n "contactModal\|modal-overlay\|modal-close\|Company Type\|cf-role\|See a real lead\|Request a Sample" ~/sentinelot-site/index.html
```
Expected: zero matches (all modal markup removed).

Run:
```bash
grep -n "cta-section" ~/sentinelot-site/index.html | grep -v "^\S*:\s*[\.#]"
```
Expected: 1 match -- the new `<div class="cta-section">` in the inline form section. (CSS lines also contain `cta-section` but are filtered out by the grep.)

Run:
```bash
grep -n "id=\"contact\"\|Get in touch\|contactFormWrap\|contactSuccess" ~/sentinelot-site/index.html
```
Expected: all 4 match in the new inline form section.

- [ ] **Step 3: Commit**

```bash
cd ~/sentinelot-site && git add index.html && git commit -m "feat: replace modal with inline contact form"
```

---

### Task 7: Update footer and remove modal JavaScript

**Files:**
- Modify: `index.html` (footer + script block)

- [ ] **Step 1: Update footer copy and links**

Replace:
```html
          <p>Passive ICS intelligence for system integrators, OT cybersecurity firms, and industrial security providers.</p>
```
With:
```html
          <p>OT intelligence for critical infrastructure sectors across North America.</p>
```

Replace the Product footer column:
```html
        <div class="footer-col">
          <h4>Product</h4>
          <a href="#how-it-works">How It Works</a>
          <a href="#buyers">For Buyers</a>
          <a href="#" onclick="openContactForm();return false">Request a Sample</a>
        </div>
```
With:
```html
        <div class="footer-col">
          <h4>Intelligence</h4>
          <a href="/guides/scada-lead-intelligence-2026">Intelligence Guide</a>
          <a href="#contact">Get in touch</a>
        </div>
```

Replace the Resources footer column's Contact Us link:
```html
          <a href="#" onclick="openContactForm();return false">Contact Us</a>
```
With:
```html
          <a href="#contact">Contact Us</a>
```

- [ ] **Step 2: Remove the modal JavaScript block**

Replace the entire second script block:
```html
  <script>
  function openContactForm() {
    document.getElementById('contactModal').classList.add('active');
    document.body.style.overflow = 'hidden';
  }

  function closeContactForm() {
    document.getElementById('contactModal').classList.remove('active');
    document.body.style.overflow = '';
  }

  document.getElementById('contactModal').addEventListener('click', function(e) {
    if (e.target === this) closeContactForm();
  });

  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closeContactForm();
  });

  if (window.location.search.indexOf('contact') !== -1) openContactForm();

  document.getElementById('contactForm').addEventListener('submit', function(e) {
    e.preventDefault();
    var form = this;
    var data = new FormData(form);
    fetch(form.action, {
      method: 'POST',
      body: data,
      headers: { 'Accept': 'application/json' }
    }).then(function(response) {
      if (response.ok) {
        document.getElementById('contactFormWrap').style.display = 'none';
        document.getElementById('contactSuccess').style.display = 'block';
        form.reset();
      }
    });
  });
  </script>
```
With:
```html
  <script>
  if (window.location.search.indexOf('contact') !== -1) document.getElementById('contact').scrollIntoView();

  document.getElementById('contactForm').addEventListener('submit', function(e) {
    e.preventDefault();
    var form = this;
    var data = new FormData(form);
    fetch(form.action, {
      method: 'POST',
      body: data,
      headers: { 'Accept': 'application/json' }
    }).then(function(response) {
      if (response.ok) {
        document.getElementById('contactFormWrap').style.display = 'none';
        document.getElementById('contactSuccess').style.display = 'block';
        form.reset();
      }
    });
  });
  </script>
```

- [ ] **Step 3: Verify no remaining openContactForm or modal references**

Run:
```bash
grep -n "openContactForm\|closeContactForm\|contactModal\|modal-overlay\|how-it-works\|id=\"buyers\"" ~/sentinelot-site/index.html
```
Expected: zero matches.

- [ ] **Step 4: Commit**

```bash
cd ~/sentinelot-site && git add index.html && git commit -m "feat: update footer, remove modal JS"
```

---

### Task 8: Deploy

- [ ] **Step 1: Push to both branches**

```bash
cd ~/sentinelot-site && git push origin main && git push origin main:gh-pages
```
Expected: both pushes succeed.

- [ ] **Step 2: Verify deployment**

Wait 30-60 seconds for GitHub Pages to rebuild, then run:
```bash
curl -s https://sentinelot.com | grep -c "Intelligence for critical"
```
Expected: `1`

Run:
```bash
curl -s https://sentinelot.com | grep -c "openContactForm\|how-it-works\|firmware-validated"
```
Expected: `0`

---

## Notes (Out of Scope -- Follow-up Recommended)

The following sections also contain methodology reveals not addressed in the spec. Consider a follow-up pass:

1. **Comparison section** (lines ~1822-1889): The "Sentinel OT" column lists firmware-validated CVEs, multi-signal attribution, 6 ICS protocols, 15 vendors. Same problem as the removed sections.
2. **Stats bar** (lines ~1935-1953): "31,000+ ICS devices scanned" and "100% Passive. No scanning. Ever." reveal methodology.
3. **Meta/schema** (already flagged in spec as recommended follow-up).
