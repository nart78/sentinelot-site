# Sentinel OT Website Copy Redesign

**Date:** 2026-03-13
**Status:** Approved for implementation

## Problem

The current sentinelot.com homepage exposes the full methodology: passive Shodan scanning, CVE validation against NVD, operator attribution via EPA databases, LinkedIn contact research. Any competitor with Claude can replicate this in a weekend. The copy functions as a recipe, not a sales page.

## Goal

Reposition the site around "intelligence as a service" -- vague about methodology, clear about coverage and outcomes. The site should communicate what Sentinel OT covers and what buyers get, without explaining how it's built. The visual design stays exactly the same. Only copy changes.

## Scope

- Single-page site (index.html only)
- No structural or CSS changes
- Copy surgery only: rewrite, remove, or replace specific sections
- Contact form: replace modal with inline form

---

## Section-by-Section Changes

### Hero

**Current:**
- Badge: "Passive ICS Intelligence"
- H1: "Qualified vulnerability leads. Without the guesswork."
- Description: "Sentinel OT delivers firmware-validated intelligence packages for OT professionals. Confirmed operators, validated CVEs, and decision-maker contacts. Ready for your sales team."
- Trust line: "100% passive sources. No active scanning. Ever."

**New:**
- Badge: "OT Intelligence"
- H1: "Intelligence for critical infrastructure."
- Description: "Sentinel OT monitors critical infrastructure sectors and delivers actionable intelligence to the organizations that need it."
- Trust line: **Remove entirely**

**Rationale:** Current hero names specific deliverables (CVEs, operator contacts) and methodology signals (passive sources, no active scanning). New copy states what we are and what we do without explaining how.

---

### Section 2: Coverage

**Current heading:** "Every lead is a qualified intelligence package"
**Current content:** 5 feature cards -- Firmware-Validated CVEs, Confirmed Operators, Decision-Maker Contacts, Full Project Scope, Risk Assessment. Each card describes methodology in detail.

**New heading:** "Intelligence across critical infrastructure."
**New content:** 4 sector cards in a 2x2 grid. Each card has: sector label (uppercase, accent color), subtitle, one-sentence outcome description.

| Sector label | Subtitle | Description |
|---|---|---|
| Oil & Gas | Pipeline & Refinery | Exposure intelligence for upstream, midstream, and downstream operations. |
| Water & Wastewater | Treatment & Distribution | Risk intelligence for municipal water systems and treatment infrastructure. |
| Power & Utilities | Generation & Transmission | Operational intelligence across generation, substation, and distribution assets. |
| Medical Devices | Connected Healthcare | Vulnerability intelligence for networked medical devices and clinical systems. |

**Tagline below grid:** "Delivered as decision-ready intelligence reports."

**Rationale:** Communicates coverage breadth and buyer-relevant outcomes without naming any tools, databases, or collection methods.

---

### Section 3: "How we build a lead"

**Action: Remove entirely.**

This section (5 steps: Passive Discovery, CVE Validation, Operator Attribution, Contact Research, Intelligence Package) is the highest-risk content on the page. It is a step-by-step replication guide. No buyer benefit justifies keeping it.

---

### Section 4: Buyer types

**Current heading:** "Leads your sales team can close"
**Current content:** 6 buyer type cards -- System Integrators, OT Cybersecurity, Security Assessors, Hardware Distributors, Managed Security, Electrical Contractors.

**Action: Remove the section. Replace with a single supporting line** placed above the contact CTA:

> "Used by security firms, insurers, system integrators, and risk consultants across North America."

**Rationale:** The current list excludes insurance underwriters (a new target buyer) and locks the positioning into a narrow B2B sales tool framing. A single line is sufficient social proof without over-specifying the audience.

---

### Section 5: CTA / Contact

**Current:** "See a real lead." -- modal-triggered form offering a sample vulnerability report.

**New heading:** "Get in touch."
**New supporting copy:** "Tell us what you're working on."
**New form:** Inline (not modal). Fields: Name, Company, Email, Message. Submit button: "Send."

**Action:** Remove the modal entirely. Remove the sample lead offer. Replace with a simple inline contact form using the same Formspree endpoint.

**Rationale:** "See a real lead" gives away that Sentinel OT produces specific lead packages. "Get in touch" is neutral and works for any buyer type including insurers and consultants.

---

## What Does Not Change

- All CSS and visual styles
- Navigation (logo, links, CTA button)
- Footer
- Brand voice (professional, precise, no em dashes)
- Formspree endpoint
- Meta title, description, schema markup (update separately if needed)
- Privacy and terms pages

---

## Meta / Schema (Recommended follow-up, not in scope)

The current meta description and schema markup also reference "vulnerability leads," "CVEs," and "SCADA." These should be updated to match the new positioning in a follow-up pass. Not blocking for this implementation.
