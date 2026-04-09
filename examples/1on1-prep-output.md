# 1-on-1 Prep — Charlie — 2025-04-07

## 6-Month Summary

| Metric           | Charlie | Team Avg |
|------------------|---------|----------|
| PRs merged       | 35      | 52       |
| Median cycle     | 3.2d    | 2.1d     |
| p90 cycle        | 8.1d    | 5.2d     |
| Zero-review %    | 6%      | 13%      |
| Reviews given    | 15      | 34       |
| Tokens/week avg  | 220K    | 185K     |

## Weekly Activity (last 12 weeks)

```
W03 (Jan 13) PRs: 1  ██░░░░░░░░░░░░░░░░░░  API schema design
W04 (Jan 20) PRs: 2  ████░░░░░░░░░░░░░░░░  Auth service scaffold
W05 (Jan 27) PRs: 0  ░░░░░░░░░░░░░░░░░░░░  — planning week —
W06 (Feb 03) PRs: 3  ██████░░░░░░░░░░░░░░  SSO provider integration
W07 (Feb 10) PRs: 4  ████████░░░░░░░░░░░░  SSO callback handlers    ← peak
W08 (Feb 17) PRs: 2  ████░░░░░░░░░░░░░░░░  Token refresh flow
W09 (Feb 24) PRs: 1  ██░░░░░░░░░░░░░░░░░░  Blocked on security review
W10 (Mar 03) PRs: 3  ██████░░░░░░░░░░░░░░  SSO testing + fixes
W11 (Mar 10) PRs: 4  ████████░░░░░░░░░░░░  SSO launch prep
W12 (Mar 17) PRs: 2  ████░░░░░░░░░░░░░░░░  Post-launch fixes
W13 (Mar 24) PRs: 3  ██████░░░░░░░░░░░░░░  MFA enrollment flow
W14 (Mar 31) PRs: 3  ██████░░░░░░░░░░░░░░  MFA + token usage spike
```

## Key Contributions

### SSO Integration (18 PRs, 51%)
- Built entire SAML + OIDC flow from scratch
- 3 review rounds on core auth PR (#245) — thorough but slow
- Security review blocker on #287 (12.3d cycle)

### MFA Enrollment (8 PRs, 23%)
- Rolling out TOTP + WebAuthn support
- Clean architecture, reusing SSO session patterns

### Bug Fixes (5 PRs, 14%)
- Token expiry edge cases, session cleanup

### Other (4 PRs, 12%)
- Docs, deps, test infrastructure

## Token Usage Pattern

```
W11  ████████░░░░░  120K  (SSO launch — focused, efficient)
W12  █████████░░░░  180K  (post-launch debugging)
W13  ██████████████████  350K  (MFA exploration — heavy research)
W14  ████████████████████  485K  (MFA + prompt iteration)
```

Token/PR ratio rising: 120K → 162K/PR. Worth checking if MFA complexity is driving this or if prompt strategy needs help.

## Talking Points

### Strengths to Recognize
- **Owns the hardest domain**: SSO/MFA is the highest-complexity work on the team. Charlie shipped it end-to-end.
- **Lowest zero-review rate** (6%): most disciplined about getting reviews, even when it slows cycle time
- **Architecture quality**: MFA reuses SSO patterns cleanly — other devs have complimented the code structure

### Areas to Discuss
- **Cycle time is longest on team** (3.2d median vs 2.1d team avg). ~60% of the gap is review wait time, not coding time. Two options:
  - Break PRs smaller (Charlie's avg PR is +480 lines vs team avg +280)
  - Identify a dedicated reviewer for auth PRs (Alice has reviewed 70% of them)
- **Token usage spiking** (485K this week, 97% of budget). Is the MFA domain just harder, or is there a prompt strategy that could help? Offer to pair on a prompt session.
- **Review contributions low** (15 given vs 34 team avg). May be bandwidth — SSO ate most of Q1. Now that it's shipped, can Charlie pick up more reviews in Q2?

### Growth Questions
- "SSO is shipped — what do you want to work on next? More auth depth or branch out?"
- "I noticed your token usage jumped in W13-14. What were you using Claude for? Any prompts worth sharing with the team?"
- "Would it help to have a dedicated reviewer for auth PRs so you're not waiting 3+ days?"

## Follow-ups from Last Session (Mar 10)

- [x] SSO launch date confirmed — shipped W11
- [ ] Charlie wanted to present SSO architecture to the team — schedule a brown bag?
- [ ] Discuss Q2 goals: auth depth vs new domain
