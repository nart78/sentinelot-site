# Water utility repositioning design

**Date**: 2026-04-15
**Status**: Draft, pending review
**Author**: Johnny Tran with Claude (brainstorming session)

## Context

Sentinel OT is pivoting its go-to-market to a single revenue path: small and mid-sized US water utilities. The value proposition is an end-to-end service that identifies externally observable IT/OT exposure, helps the utility secure state and federal grant funding to pay for remediation, delivers the remediation under a single contract, and monitors the result afterward. The technical remediation work is executed by a delivery partner (Soap Engineering, Houston TX) whose identity is not disclosed on the public website.

The current website positions Sentinel OT as a broad "OT intelligence as a service" provider covering oil and gas, power, water, and medical sectors. That positioning no longer reflects where revenue is being pursued and does not serve the audience we now care about reaching: city and county managers and mayors whose communities have a water utility and a potential vulnerability report in hand from Sentinel OT.

The primary job of the website is now to serve as a credibility verification layer. When a mayor receives a Sentinel OT vulnerability report and googles the company, the site must convince them in roughly twenty seconds that Sentinel OT is a real, qualified, legally defensible operation that can take them from the problem to a funded, remediated, monitored outcome.

## Goals

1. Reposition the homepage to water utilities as the sole vertical focus.
2. Establish immediate credibility for a non-technical municipal decision-maker.
3. Demonstrate domain authority in OT security, AWIA compliance, and grant funding.
4. Make the value proposition of "find, fund, fix, monitor" impossible to miss.
5. Introduce the "IT/OT security partner" positioning without renaming the company.
6. Protect the identity of the delivery partner (Soap Engineering).
7. Provide defensible language for procurement officers and municipal attorneys.

## Non-goals

1. No redesign of the CSS system, color palette, typography, or shader background.
2. No new animations, illustrations, or custom graphics.
3. No analytics or tracking changes.
4. No Formspree backend changes.
5. No LinkedIn company page updates (separate task).
6. No team page, no staff photos, no bios.
7. No dedicated pages or copy for non-water sectors. Other sectors are removed from the public site entirely.

## Audience

**Primary**: City or county manager, or mayor, of a US community with a water utility that serves approximately 3,300 to 50,000 residents. Non-technical. Cares about grant dollars, regulatory compliance, public safety liability, and press risk. Will pass the site to a city attorney and possibly a public works director before responding.

**Secondary**: City attorney reading the site alongside the mayor to verify the work is legally defensible. Public works director reading the site to understand the technical and procurement fit.

## Triggering context

The user flow is not "mayor discovers Sentinel OT and requests a scan." The flow is:

1. Sentinel OT sends an unsolicited, free vulnerability report to the affected utility.
2. The recipient reads the PDF, googles Sentinel OT, and lands on the website.
3. The website must answer "are these people real and qualified?" in under one minute.
4. The recipient replies to the original email or uses the site contact form.

No scan request, no download gate, no lead magnet. The website is a trust layer, not a lead funnel.

## Brand positioning

**Company name**: Sentinel OT. Unchanged.
**Positioning statement**: "The IT/OT security partner for US water utilities."

The "IT/OT" expansion reflects work that is already true. The Iris vulnerability reports routinely include findings on cellular gateways, exposed administrative services (FTP, Telnet, SSH, HTTP/HTTPS), DNS open resolvers, and SSL certificate exposure in addition to PLC-level findings. The positioning statement brings the visible brand in line with the actual scope of work.

## Sitemap

| Page | URL | Status |
|---|---|---|
| Home | `/` | Rewrite, consolidated |
| Methodology | `/methodology.html` | New |
| About | `/about.html` | Rewrite |
| Sample report | `/sample-report.pdf` | New asset |
| Privacy | `/privacy.html` | No change |
| Terms | `/terms.html` | No change |

**Dropped**: `/water` as a separate page. Folded into the homepage.
**Dropped**: All non-water sector pages and references.

**Navigation**:
```
[LOGO]            Methodology    About    Sample Report    [Get in touch]
```

On mobile, the nav collapses to a hamburger. The existing nav CSS pattern is retained.

## Homepage structure

The homepage is long by design, approximately 2,500 to 3,500 words across nine scroll sections. It carries the full credibility job on its own.

### 1. Hero

- Eyebrow: "Passive IT/OT intelligence for municipal water systems"
- Headline: "The IT/OT security partner for US water utilities."
- Subhead: "We find what is exposed. We help you secure the grant funding to fix it. We deliver the remediation. We monitor it after. One accountable partner. One invoice. Zero network access."
- Primary CTA button: "Get in touch" (anchor to contact section)
- Secondary CTA link: "Read the methodology" (link to `/methodology.html`)
- Background: existing shader canvas, unchanged.

### 2. The quiet problem

- Headline: "Most small and mid-sized water utilities do not know what they do not know."
- Three to four short paragraphs, analytical tone, not sales copy:
  - AWIA Risk and Resilience Assessment recertification is due June 30, 2026 for systems serving 3,301 to 49,999 people.
  - The CISA Known Exploited Vulnerabilities catalog contains vulnerabilities affecting the exact controllers small utilities commonly operate. Remediation deadlines pass quietly.
  - Named precedents: Aliquippa PA (November 2023), Oldsmar FL (February 2021), Muleshoe TX (January 2024). Each is real, each was preventable.
  - State and federal grant dollars that exist and go unclaimed in small and mid-sized communities.

### 3. Proof strip

- Section label: "From a recent assessment"
- A single quote-style block with a composite finding written in plain English:
  - 30,000-resident water utility, two internet-exposed Rockwell CompactLogix PLCs, one critical authentication bypass vulnerability on the CISA KEV catalog with an overdue federal remediation deadline, no VPN, no firewall, no network segmentation.
  - Closing line: "This is not unusual. It is typical."
- Inline link: "Read the full sample report" opening `/sample-report.pdf`.

### 4. The four-stage pipeline

- Headline: "One partner. Four stages. Start to finish."
- Four full explainers, 150 to 250 words each, not a card grid:
  - **Find**: Passive intelligence methodology, what the vulnerability report contains, standards referenced (IEC 62443, NIST SP 800-82 Rev 3), typical turnaround.
  - **Fund**: Grant landscape, active state programs, AWIA alignment, how we prepare the application with the utility.
  - **Fix**: Remediation delivered by "our vetted delivery team." Network segmentation, firmware updates, hardware replacement for EOL controllers, compensating controls. IEC 62443 zones and conduits referenced by name.
  - **Monitor**: Zero Day Notification Service. Ongoing CVE alerts matched against the confirmed platform inventory from the Find phase. Positioned as an optional ongoing subscription.

### 5. Grant funding landscape

- Headline: "The money is already there. Most utilities never see it."
- Short explanatory paragraph covering SLCGP, state programs, SRF set-asides.
- Table. Columns: State, Program, Approximate Funding, Match Requirement, Application Window. Populated from the grant landscape intelligence report at `~/argus/reports/2026-03-31_water-utility-grant-funding-landscape_internal.md`. At minimum, rows for NY SECURE, FL ($15M state program), MA SRF cyber, TX SLCGP, NJ WQAA. Every row must be verifiable against an authoritative source before publication.
- AWIA deadline callout: a distinct visual block stating "AWIA RRA recertification is due June 30, 2026 for systems serving 3,301 to 49,999 people." Not a hero headline, but impossible to miss on scroll.

### 6. What we do not do

- Headline: "What we do not do."
- Five-item list:
  - We do not scan your internal network.
  - We do not send packets to your infrastructure.
  - We do not attempt authentication on any system.
  - We do not execute exploits.
  - We do not require credentials, VPN access, or any form of inside access.
- Closing paragraph: "Every finding in every report we produce is observable from the public internet. Our work is defensive, legal, and passive. We reference IEC 62443 and NIST SP 800-82 Rev 3."

### 7. What an engagement looks like

- Headline: "What a Sentinel OT engagement looks like."
- Timeline presentation:
  - Week 0: Vulnerability report delivered
  - Week 1 to 2: Scoping call
  - Week 2 to 4: Full external assessment
  - Week 4 to 6: Grant application support
  - Month 2 onward: Remediation execution
  - Month 4 onward: ZDNS monitoring
- Pricing transparency block: "The full external assessment is $15,000 to $25,000. Remediation is typically funded by grant dollars and scoped separately. ZDNS is a subscription priced after the engagement."

### 8. FAQ

Eight questions and their approved answers, reproduced verbatim for the implementation plan:

**Do you need access to our network?**
No. We never touch your network. Every finding is observable from the public internet. We do not send packets to your infrastructure, we do not attempt authentication, and we do not require VPN access or credentials. If the work requires any of that, it is not us doing it.

**Is what you do legal?**
Yes. We use only publicly available information. The Computer Fraud and Abuse Act applies to unauthorized access to a protected computer. We never access your systems, so there is no access to authorize. The same passive intelligence methodology is used by CISA, commercial threat intelligence firms, and academic researchers. Our work is defensive and legal by design.

**We already have an IT provider. Why do we need you?**
Most IT providers focus on office systems, not control systems. The PLCs, cellular gateways, and SCADA equipment that run your water treatment plant live on a different network and speak different protocols. They are rarely patched, rarely inventoried, and almost never visible to a general IT team. We cover that gap.

**How is this different from a penetration test?**
A penetration test sends live attack traffic at your systems from inside or outside your network. It requires authorization, contracts, and usually downtime. We send nothing. Our findings are observed from the public internet using passive intelligence techniques. No authorization required, no disruption risk, and the findings are ready in days instead of months.

**Will this help us comply with AWIA?**
Yes. The America's Water Infrastructure Act requires community water systems serving more than 3,300 people to assess cybersecurity risks and certify a Risk and Resilience Assessment. Our vulnerability reports document external exposure in a form that supports the RRA. Recertification for systems serving 3,301 to 49,999 people is due June 30, 2026. We can help you get in front of it.

**Can grant dollars actually pay for this?**
Yes. Federal State and Local Cybersecurity Grant Program funds, state cybersecurity grants, and water-sector SRF set-asides all cover OT security assessments and remediation. We help you identify which programs your utility qualifies for, prepare the application language, and document the scope of work. The assessment fee is typically below competitive bidding thresholds in most jurisdictions, which makes it a direct award and a clean procurement path.

**Who does the actual remediation work?**
Our vetted delivery team. Network segmentation, firmware updates, controller replacement, and compensating controls are executed by experienced OT engineers working under Sentinel OT's accountability. You have one point of contact, one contract, and one invoice. We are the prime.

**What happens if you find something that needs to be fixed immediately?**
We tell you in the report, with a specific recommendation for a compensating control you can implement the same day. Full remediation follows your utility's capital and maintenance cycle. If a finding triggers a mandatory disclosure under CIRCIA or a state breach law, we flag it and walk you through the next step. We do not sit on information that affects public safety.

### 9. Contact

- Headline: "Get in touch."
- Subhead: "If you received a vulnerability report from Sentinel OT, this is the fastest way to reply. If you are exploring whether your utility is a fit, we will come back to you within one business day."
- Existing Formspree form at endpoint `https://formspree.io/f/mzdakpwg` is retained unchanged.
- One new form field: a radio input labeled "Are you replying to a Sentinel OT report?" with values "Yes" and "No". This routes Johnny's inbox and lets him prioritize replies to outbound reports.

### 10. Footer

- Tagline: "The single accountable IT/OT security partner for US water utilities."
- LinkedIn link preserved.
- Legal links preserved (Privacy, Terms).
- Copyright line unchanged.
- Passive-sources disclaimer preserved.

## `/methodology.html` page

New page. Long-form technical detail for a skeptical defender, city attorney, or IT director. Linked from the homepage hero secondary CTA and from the main nav.

### Hero

- Headline: "Passive intelligence, in detail."
- Subhead: "How Sentinel OT identifies IT and OT exposure without sending a single packet to your infrastructure."

### What passive intelligence is

Two to three paragraphs in plain English. Explains that the public internet is indexed continuously by multiple independent data providers, that industrial control systems and gateways reachable from the internet respond to ordinary network requests with self-identifying information, and that the aggregated intelligence is searchable, verifiable, and legal to use.

Exact phrase permitted once: "We rely on aggregated public intelligence sources and do not operate a scanner of our own against client infrastructure."

No tool names. Shodan, Censys, Outer Eye, and all other tooling remain unnamed.

### What we observe

Structured list of observable categories drawn from real Iris report content:

- Internet-facing programmable logic controllers (Allen-Bradley, Schneider, Siemens, and others)
- Cellular SCADA gateways (Microhard, Sierra Wireless, Digi, and others)
- SCADA radio management interfaces
- Exposed administrative services on OT devices (FTP, Telnet, SSH, HTTP, HTTPS)
- Misconfigured DNS resolvers and mail services
- Industrial protocol identity responses (EtherNet/IP, Modbus TCP, DNP3, BACnet)
- SSL certificate transparency logs
- Public business records, EPA ECHO, and CISA advisories for operator attribution

### The validation chain

Headline: "Every finding is independently verified."

Three bullets:
- Vulnerability data is verified against the National Vulnerability Database and CISA Known Exploited Vulnerabilities catalog.
- Operator attribution is verified against authoritative public records (EPA ECHO for water systems, PHMSA for pipelines, state procurement records, SSL certificate organization fields).
- Hardware identity is verified against vendor documentation, OUI registries, and industrial protocol self-identification responses.

Closing line: "If we cannot verify a finding against an independent source, it does not appear in the report."

### Standards referenced

Table. Columns: Standard, What it covers, Why it matters here.

- IEC 62443. Industrial automation security, zones and conduits framework, compensating controls.
- NIST SP 800-82 Rev 3. ICS Security Guide. US federal reference document for OT risk assessment.
- CISA Cybersecurity Performance Goals 2.0. Cross-sector cybersecurity baseline.
- America's Water Infrastructure Act. Federal statute requiring community water systems to complete Risk and Resilience Assessments and Emergency Response Plans.
- EPA Water Sector Cybersecurity Guidance. Non-binding reference used in AWIA context.

### What we do not do

Same five-item list as the homepage, repeated verbatim. Repetition is intentional.

One additional paragraph aimed at the technical reader: "Our findings describe the externally observable attack surface of your infrastructure. They do not describe your internal network, your operator training, your physical security posture, your change management procedures, or your emergency response plan. Those assessments require an authorized internal engagement by a different kind of provider. We are explicit about what we can and cannot see, in every report we produce."

### Legal basis

Headline: "Why this work does not require your authorization."

Two paragraphs.

Paragraph one: The Computer Fraud and Abuse Act (18 U.S.C. § 1030) prohibits unauthorized access to a protected computer. Sentinel OT never accesses any client system. The information used is already public, aggregated by third parties, and available to any researcher, defender, or adversary. Observing what is publicly visible is not access.

Paragraph two: "This is the same legal footing used by CISA, US-CERT, academic security research teams, and commercial threat intelligence firms. The work is defensive by design, passive by construction, and legal by default."

### CTA block

Short. Two buttons: "Read sample report" (link to `/sample-report.pdf`) and "Get in touch" (link to homepage contact anchor).

## `/about.html` page

Short page, approximately 400 to 600 words.

### Hero

- Headline: "Sentinel OT is the single accountable IT/OT security partner for US water utilities."
- Subhead: "We find what is exposed. We help you fund the fix. We deliver the remediation. We monitor it after. One contract. One invoice. One point of contact."

### What we do

Single paragraph, four to five sentences, establishing the scope of work, the start and end of an engagement, and the standards referenced.

### What we do not do

The five-item list, third and final repetition across the site.

### What we believe

Four short principles, each a one-line statement with one sentence of elaboration:

- Public infrastructure deserves private-sector rigor.
- Passive by construction.
- Grant dollars are part of the job.
- One accountable partner.

### Where we work

Exact text: "Sentinel OT is headquartered in Calgary, Alberta with US delivery operations in Houston, TX, and serves water utilities across the United States. Our engagement model is designed for US federal and state grant compliance, including AWIA, SLCGP, and state water-sector cybersecurity programs."

### CTA block

Short. "Get in touch" headline, one sentence under it, Formspree form identical to homepage.

## Sample report PDF

A fabricated composite document in the style of Iris's vulnerability reports. It is built by combining technical elements from multiple real Iris reports (Belle Glade PBCWUD, Burkburnett TX, Los Fresnos TX, Sunbury PA, and others) into a single coherent assessment of a fictional water utility.

### Constraints

- No real operator name, facility name, location, or geolocation. The operator is invented.
- All IP addresses must be drawn from RFC 5737 documentation ranges (192.0.2.0/24, 198.51.100.0/24, 203.0.113.0/24). No real IPs, no real netblocks, no real ISP names that could be traced to an actual operator.
- All MAC addresses use real vendor OUIs (00:0F:92 for Rockwell is permitted) but fabricated suffixes.
- All CVEs must be real and verifiable against NVD. CVSS scores must match NVD exactly. Only cite CVEs that genuinely affect the cited hardware.
- The operator backstory (population served, region, facility type) must be plausible but fictional.
- The report must read, to a controls engineer or OT security consultant, as something a serious shop produced.
- The report must pass the same sentinel-qa three-pass verification protocol that any real Iris report passes.

### Format and theme

Produced as Markdown source, exported to PDF via the existing pdf-export skill using the sentinel-premium theme. Cover page follows the standard Iris pattern (cover image, badge div, h1 title, cover-table). The filename shipped to the website is `sample-report.pdf`.

### Source file storage

The markdown source lives outside the website repo. A suggested path is `~/sentinelot-sample-report/sample-report.md`, or inside `~/iris/reports/` under a `_sample_public` descriptor. Only the rendered PDF ships into the `sentinelot-site` repo.

### Review requirement

The sample report must be reviewed by Johnny before it is published. No automated review passes this check.

## schema.org Organization markup

The existing Organization block in [index.html:17-49](../../index.html#L17-L49) requires updates:

- `name`: unchanged (`Sentinel OT`)
- `url`: unchanged
- `logo`: unchanged
- `description`: rewrite to reflect the water utility focus and IT/OT scope. Proposed: "The single accountable IT/OT security partner for US water utilities. Passive vulnerability intelligence, grant funding support, remediation delivery, and ongoing CVE monitoring under one contract."
- `foundingDate`: unchanged (2025)
- `foundingLocation`: unchanged (Calgary, AB, Canada). Founding city is a factual claim that does not change.
- `knowsAbout`: rewrite. Replace the current array with terms that reflect the new focus: "Water utility cybersecurity", "Industrial control systems security", "PLC vulnerability assessment", "Passive OT reconnaissance", "AWIA compliance", "SLCGP grant support", "IEC 62443", "NIST SP 800-82"
- `address` or `location`: add a new `location` array containing two entries, both with `@type: Place` and `address: PostalAddress`:
  - Calgary, AB, Canada (primary corporate location)
  - Houston, TX, US (delivery operations location)
- `sameAs`: unchanged

## Voice and style rules

Applied across all pages and the sample report:

- No em dashes in body copy. Periods, commas, or restructuring. Em dashes permitted only in headings, tables, and structural elements where grammar allows.
- No use of the word "memo". Use "report".
- No mention of "Shodan" anywhere, including comments, alt text, and meta tags.
- No naming of Soap Engineering or any delivery partner. Use "our vetted delivery team" or "our US delivery operations" where reference is needed.
- No use of "Outer Eye" on the public site. Outer Eye remains an internal and sales-ready-report term only.
- No alarmist language. Specific CVE severity language is fine. Fear phrasing ("cyber attack imminent", "your community is at risk") is not.
- Johnny's voice profile at `~/.claude/projects/-home-ubuntu/memory/johnny-voice.md` governs all copy.

## OPSEC checklist

Every item below must be verified before the updated site is pushed to the `gh-pages` branch:

- No mention of Shodan, Censys, or any commercial intelligence data provider by name
- No mention of Soap Engineering, no mention of any delivery partner by name
- No team names, photos, or biographies published
- No real operator names, IP addresses, facility names, or geolocations anywhere on the site, including the sample report PDF
- Sample report PDF uses only RFC 5737 documentation IP ranges and a fabricated operator name
- Every CVE referenced on the public site is real and verifiable against NVD
- Every standard referenced is named exactly as the standards body names it
- schema.org Organization block is updated with Houston as `location`, not as `foundingLocation` or primary `address`
- schema.org `knowsAbout` array reflects the water-utility focus

## Deployment

Per the repository CLAUDE.md, the site deploys from the `gh-pages` branch, not `main`. Every push must be made to both branches:

```
git push origin main && git push origin main:gh-pages
```

The implementation plan must include the double-push as an explicit step in the deploy sequence.

## Open questions

None at design approval. Any questions that arise during implementation should be logged into `UNKNOWNS.md` in the repo root.

## Future considerations (not part of this spec)

These are noted so they do not contaminate the current work, and so they are easy to pick up later:

- A team page on `/about.html` with Johnny, Simon Raven, and Joel Davies, if the decision is revisited.
- LinkedIn company page pivot to match the website positioning.
- Outbound email template alignment with the new positioning.
- A brief "After the report" one-page handout in PDF form that mayors can forward internally to their city attorney and public works director.
- A state-specific landing page for each of the top priority states (NY, FL, MA, TX, NJ, PA), if outbound volume justifies it.
- An "intake" page for new vulnerability reports that are hand-delivered to a utility by Johnny or a representative.
