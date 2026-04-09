---
title: Django Test Generator
author: Frank
date: 2025-03-28
tags: [testing, django, pytest]
---

## When to Use

When you need to write tests for a Django view, serializer, or service function. Works best for CRUD operations and API endpoints. For complex business logic, write the test structure by hand and use this to fill in the assertions.

## The Prompt

```
Write pytest tests for the following Django module. Follow these rules:

1. Use pytest + pytest-django, not unittest.TestCase
2. Use factory_boy for model instances (assume factories exist in tests/factories.py)
3. Use `api_client` fixture (already configured with DRF's APIClient)
4. One test function per behavior, not per method
5. Name tests: test_{action}_{condition}_{expected_result}
6. Cover: happy path, permission denied, not found, validation error
7. For ViewSets: test list, create, retrieve, update, destroy separately
8. Assert response status AND response body — don't just check 200
9. Use freezegun for time-dependent logic
10. No mocking the database — use TransactionTestCase if needed

Module to test:
{paste the module code here}

Existing factories (for reference):
{paste relevant factories or say "generate new ones"}
```

## Example

**Input**: `apps/billing/views.py` — InvoiceViewSet with list, create, retrieve

**Output**: 12 test functions covering:
- `test_list_invoices_returns_only_own_org` (permission scoping)
- `test_list_invoices_empty_returns_200` (edge case)
- `test_create_invoice_valid_data_returns_201` (happy path)
- `test_create_invoice_missing_amount_returns_400` (validation)
- `test_create_invoice_unauthenticated_returns_401` (auth)
- `test_retrieve_invoice_other_org_returns_404` (permission)
- ... etc

## Notes

- If the module imports `celery` tasks, the prompt will try to test async behavior. Add "mock celery tasks with `@pytest.mark.django_db`" to the prompt if you want sync-only tests.
- Doesn't handle file upload views well — add specific instructions for `SimpleUploadedFile` usage.
- Frank found that adding "Existing factories" context reduces hallucinated field names by ~80%.

## Iterations

- **v1** (Mar 15): Basic prompt, tests were too shallow (only checked status codes)
- **v2** (Mar 22): Added rule 8 ("assert body, not just status") — quality jumped
- **v3** (Mar 28): Added factory_boy context — stopped generating wrong field names
