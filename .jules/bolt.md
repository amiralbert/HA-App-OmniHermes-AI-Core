## 2026-10-15 - Background Disk I/O Optimization
**Learning:** Found a background loop doing a full directory sync `cp -a` every 60 seconds. This is inefficient as it overwrites identical files repeatedly.
**Action:** Use `cp -au` (update flag) for periodic file syncs in bash scripts to avoid unnecessary disk I/O when files haven't changed.

## 2024-10-24 - Process Spawning Overhead Reduction
**Learning:** Found multiple individual `jq` calls parsing a JSON configuration file in bash scripts. This creates unnecessary process spawning overhead, especially on edge devices. Additionally, when consolidating `jq` extractions using string concatenation and `eval`, fallback values must use `// ""` instead of `// empty` because `empty` will cause the entire string concatenation to abort and yield nothing.
**Action:** Consolidate multiple `jq` extractions into a single invocation using `eval` and string concatenation to reduce process spawning overhead.
