## 2026-10-15 - Background Disk I/O Optimization
**Learning:** Found a background loop doing a full directory sync `cp -a` every 60 seconds. This is inefficient as it overwrites identical files repeatedly.
**Action:** Use `cp -au` (update flag) for periodic file syncs in bash scripts to avoid unnecessary disk I/O when files haven't changed.

## 2026-10-15 - jq Optimization in Bash Scripts
**Learning:** Found multiple separate `jq` invocations to extract values from a JSON config file. This creates unnecessary process spawning overhead, which can slow down script initialization, especially on resource-constrained devices like Raspberry Pis running Home Assistant. Using `empty` as a fallback inside string concatenation in `jq` aborts the entire string output.
**Action:** Consolidate multiple `jq` extractions into a single invocation using `eval` and string concatenation: `eval "$(jq -r '"VAR=\(.key // "" | @sh) " + ...' file.json)"`. Always use `// ""` instead of `// empty` when concatenating strings to prevent unexpected blank outputs.
