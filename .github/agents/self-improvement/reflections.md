# Reflections

Short post-task lessons that may become reusable later.

## Format

```
DATE: YYYY-MM-DD
AGENT: sentinel-*
CONTEXT: short task context
REFLECTION: what could have gone better
LESSON: better next move next time
```

DATE: 2026-04-11
AGENT: sentinel-orchestrator
CONTEXT: final always-on tracking acceptance and deployment pass with live Railway verification
REFLECTION: Production proof stalled on Windows shell quoting and missing direct auth before the pass switched to dedicated live QA accounts plus temp scripts for schema and endpoint verification.
LESSON: For SENTINEL production proof passes, prefer dedicated live QA accounts, self-cleaning temp scripts, and read-only schema checks first; only use QA-account password rotation when no safer token path is available, and relock those QA accounts immediately after verification.
