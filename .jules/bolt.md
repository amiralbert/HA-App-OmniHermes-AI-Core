## 2026-10-15 - Background Disk I/O Optimization
**Learning:** Found a background loop doing a full directory sync `cp -a` every 60 seconds. This is inefficient as it overwrites identical files repeatedly.
**Action:** Use `cp -au` (update flag) for periodic file syncs in bash scripts to avoid unnecessary disk I/O when files haven't changed.

## 2026-10-15 - jq Optimization in Bash Scripts
**Learning:** Found multiple `jq` calls parsing the same `options.json` file in sequence, which introduces significant process spawning overhead on edge devices like Raspberry Pis running Home Assistant.
**Action:** Consolidate multiple `jq` extractions into a single invocation using `eval` and jq's `@sh` for secure shell string formatting. Also, ensure fallback values in jq string concatenations use `// ""` rather than `// empty` to prevent aborting the entire concatenation.
