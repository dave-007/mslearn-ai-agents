---
description: Generate a complete pytest test suite for a specific exercise, including smoke tests, unit tests with mocks, and integration test stubs.
---

Read the solution file (or starter code if no solution exists) for exercise `${input:exerciseDir:Exercise directory name (e.g., 02-build-ai-agent)}`.

Generate a complete test suite in `Labfiles/${input:exerciseDir}/Python/tests/` with:

1. **conftest.py** — shared fixtures for mock credentials, mock clients, and exercise paths
2. **test_smoke.py** — verify files exist, syntax is valid, .env has required vars, requirements.txt is complete
3. **test_unit.py** — mock Azure SDK clients and test agent creation, tool config, conversation flow, error handling, and cleanup
4. **test_integration.py** — stubs marked with `@pytest.mark.integration` for live Azure testing

Verify all test files compile. Run the smoke and unit tests and report results.
