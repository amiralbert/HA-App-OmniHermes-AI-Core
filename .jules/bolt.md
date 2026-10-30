## 2026-10-15 - Background Disk I/O Optimization
**Learning:** Found a background loop doing a full directory sync `cp -a` every 60 seconds. This is inefficient as it overwrites identical files repeatedly.
**Action:** Use `cp -au` (update flag) for periodic file syncs in bash scripts to avoid unnecessary disk I/O when files haven't changed.

## 2026-10-17 - Bash Script Process Spawning Overhead
**Learning:** Identified a pattern in HA add-on entrypoint scripts where multiple sequential `jq` calls were used to extract configuration values, spawning many unnecessary processes.
**Action:** Consolidate multiple `jq` extractions into a single invocation using `eval` and `jq -r '"VAR=\(.key | @sh)"'` to reduce process spawning overhead. When providing fallback values in string concatenations, always use `// ""` instead of `// empty` because `empty` will cause the entire string concatenation to abort and yield nothing.
