# Sprint Retro — Mar 24 - Apr 06, 2025

## Scoreboard

| Metric           | This Sprint | Baseline   | Trend |
|------------------|-------------|------------|-------|
| PRs merged       | 30          | ~30/sprint | 0%    |
| Cycle time (p90) | 4.8d        | 6.5d       | -26%  |
| Review coverage  | 91%         | 80%        | +14%  |
| Test files added  | 6          | —          | —     |
| Zero-review PRs  | 3           | —          | low   |

## Per-Person Breakdown

| Name    | PRs | Commits | Streak | Avg Cycle | Notes                        |
|---------|-----|---------|--------|-----------|------------------------------|
| Frank   | 9   | 22      | 10d    | 1.1d      | Dashboard + test backfill    |
| Alice   | 7   | 18      | 8d     | 1.4d      | Billing webhook              |
| Diana   | 5   | 14      | 6d     | 1.8d      | Bug fixes + CSV export       |
| Bob     | 4   | 10      | 5d     | 2.3d      | User service refactor        |
| Charlie | 3   | 6       | 4d     | 3.5d      | MFA enrollment               |
| Eve     | 2   | 5       | 3d     | 2.5d      | Docs + dependency updates    |

## Security & Compliance

| Check | Status | Details |
|-------|--------|---------|
| SAST scan (bandit) | WARN | 2 new findings (0 high, 2 medium — hardcoded timeout values) |
| Dependency vulns | WARN | 1 moderate (`cryptography` 42.0.2 → CVE-2025-1234, fix available) |
| Secrets detection | CLEAN | 0 findings (gitleaks) |
| Security-sensitive PRs | 4 PRs | #287 SSO config, #301 API auth, #310 auth middleware, #312 MFA |
| Threat model update | yes | MFA enrollment adds new attack surface (TOTP seed storage) |
| IAM/infra changes | 2 files | k8s RBAC updated for MFA service account |

### Security Review Coverage

| PR | Area | Reviewed by security-aware dev? | Risk |
|----|------|--------------------------------|------|
| #287 | SSO config | Yes (Charlie + Alice) | Low — config only |
| #301 | API auth header | Yes (Alice) | Medium — new auth path |
| #310 | Auth middleware | **No — merged without review** | **High** — core auth change |
| #312 | MFA enrollment | Yes (Charlie + Bob) | Medium — new TOTP flow |

**Action needed**: PR #310 merged without review on auth middleware. Retroactive review required. Set up CODEOWNERS to prevent this.

### Threat Model Notes

MFA enrollment (Charlie's work) introduces:
- TOTP seed storage in DB — encrypted at rest? Verified: yes (django-encrypted-model-fields)
- WebAuthn credential storage — follows FIDO2 spec, no custom crypto
- New `/api/v1/mfa/enroll` endpoint — rate-limited? Verified: yes (10 req/min)
- Recovery codes — generated with `secrets.token_hex(16)`, stored hashed. Good.

**No threat model doc update yet** — carry forward as action item.

## What Went Well

- **p90 cycle time dropped 26%** (4.8d vs 6.5d baseline). Smaller PRs and faster reviews are working. Alice's "review within 4 hours" challenge is landing — she reviewed 12 PRs this sprint.
- **Review coverage at 91%** — best in 3 months. Zero-review PRs down to 3, all <50 lines (config changes).
- **Test backfill momentum**: Frank added tests for 4 modules (billing, notifications, export, user). Coverage went from 62% → 68%. He shared his test-gen prompt with the team — 3 others started using it.
- **SSO shipped and stable**: zero post-launch incidents. Charlie's thorough review process paid off despite slower cycle times.

## What Needs Attention

- **Eve at 2 PRs for 2 consecutive sprints** — onboarding stall or blocked? Rest of team is on track.
- **Charlie's token usage at 97% budget**: highest on team, lowest PR output. The MFA domain is complex, but the tokens/PR ratio (162K) is 3x team average. Might benefit from prompt coaching.
- **Bob's PR #310 merged without review**: +200 lines touching auth middleware. Not flagged until post-merge. Needs process fix — auto-require review for `**/auth/**` paths.
- **No frontend PRs this sprint**: all 28 PRs are backend. FE team was on planning week, but 2 consecutive backend-only sprints creates integration risk.

## Action Items

### Velocity
- [ ] **Bater**: 1:1 with Eve — check onboarding progress, pair on first feature PR this sprint
- [ ] **Bater**: 1:1 with Charlie — discuss token usage, offer prompt pairing session
- [ ] **Frank**: present test-gen prompt in Friday brown bag — share `shared-prompts/prompts/test-gen.md`
- [ ] **Team**: FE sprint starts Apr 7 — aim for at least 8 FE PRs next sprint to catch up

### Security & Compliance
- [ ] **Alice**: set up CODEOWNERS rule requiring review for `**/auth/**` and `**/billing/**` paths — by Apr 11
- [ ] **Alice**: retroactive security review of PR #310 (auth middleware, merged without review) — by Apr 09
- [ ] **Charlie**: update threat model doc for MFA enrollment (TOTP seed storage, WebAuthn, recovery codes) — by Apr 14
- [ ] **Bater**: upgrade `cryptography` to 42.0.5 (CVE-2025-1234) — by Apr 09 (P1)
- [ ] **Bater**: fix 2 medium bandit findings (hardcoded timeout values) — by Apr 11

## Trends (last 3 sprints)

| Metric           | Sprint 12 | Sprint 13 | Sprint 14 | Direction |
|------------------|-----------|-----------|-----------|-----------|
| PRs merged       | 32        | 30        | 30        | stable    |
| p90 cycle        | 6.2d      | 5.5d      | 4.8d      | improving |
| Review coverage  | 82%       | 85%       | 91%       | improving |
| Test files added | 2         | 4         | 6         | improving |
| Token budget used| 45%       | 52%       | 50%       | stable    |

**Overall**: velocity is stable while quality metrics (reviews, tests) are all improving. The team is shipping the same volume but with better discipline. Healthy trajectory.

## Follow-ups from Last Retro (Mar 24)

- [x] CODEOWNERS for billing paths — done by Alice
- [x] Frank's test backfill initiative — in progress, 4/10 modules done
- [ ] Eve onboarding buddy system — not started, carry forward
- [x] Token usage dashboard — Bater set up weekly reports
