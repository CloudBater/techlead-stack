# Project Health Check — 2025-04-07

## Summary

| Area               | Status | Details                                        |
|--------------------|--------|------------------------------------------------|
| Repository         | OK     | 0 uncommitted, 3 stale branches                |
| Dependencies (BE)  | WARN   | 5 outdated, 1 vulnerability (moderate)         |
| Dependencies (FE)  | OK     | 2 outdated, 0 audit issues                     |
| Lint (BE)          | PASS   | 0 issues (ruff)                                |
| Lint (FE)          | WARN   | 4 warnings (unused imports)                    |
| Type Check         | PASS   | 0 errors (tsc --noEmit)                        |
| Tests (BE)         | 142    | coverage: 68%                                  |
| Tests (FE)         | 87     | coverage: 71%                                  |
| CI/CD              | PASS   | last 5 builds green                            |
| Secrets            | CLEAN  | 0 findings                                     |

## Details

### Stale Branches (merged but not deleted)

| Branch                   | Merged    | Author  |
|--------------------------|-----------|---------|
| feature/old-billing-v1   | 2025-01-15| Bob     |
| fix/session-timeout      | 2025-02-20| Charlie |
| chore/deps-update-feb    | 2025-02-28| Diana   |

### Outdated Dependencies (BE — top 5)

| Package          | Current | Latest  | Breaking? |
|------------------|---------|---------|-----------|
| django           | 5.0.4   | 5.1.2   | Minor     |
| celery           | 5.3.6   | 5.4.0   | Minor     |
| boto3            | 1.34.50 | 1.34.85 | Patch     |
| pydantic         | 2.6.1   | 2.7.0   | Minor     |
| cryptography     | 42.0.2  | 42.0.5  | Patch — **security fix** |

### Vulnerability

| Package       | Severity | CVE            | Fix Available |
|---------------|----------|----------------|---------------|
| cryptography  | Moderate | CVE-2025-1234  | Yes (42.0.5)  |

### FE Lint Warnings

```
src/components/Dashboard.tsx:12 — 'useCallback' is defined but never used
src/components/UserList.tsx:5 — 'formatDate' is defined but never used
src/utils/api.ts:88 — 'LegacyEndpoint' is defined but never used
src/hooks/useAuth.ts:3 — 'AuthContext' is defined but never used
```

### 7-Day Activity

| Contributor | Commits |
|-------------|---------|
| Frank       | 22      |
| Alice       | 18      |
| Diana       | 14      |
| Bob         | 10      |
| Charlie     | 6       |
| Eve         | 5       |

### CI/CD — Last 5 Builds

| Status | Workflow       | Branch    | Time  |
|--------|---------------|-----------|-------|
| PASS   | test-and-lint | main      | 4m12s |
| PASS   | test-and-lint | main      | 3m58s |
| PASS   | deploy-staging| staging   | 6m30s |
| PASS   | test-and-lint | main      | 4m05s |
| PASS   | deploy-prod   | main      | 7m15s |

## Action Items

- [ ] **P1**: Upgrade `cryptography` to 42.0.5 (security fix) — assign to Diana
- [ ] **P2**: Clean up 3 stale branches — assign to branch authors
- [ ] **P3**: Fix 4 FE lint warnings (unused imports) — assign to Eve (good onboarding task)
- [ ] **P3**: Review `django` 5.0→5.1 changelog for upgrade path — assign to Bob
