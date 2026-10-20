## 2026-10-15 - Background Disk I/O Optimization
**Learning:** Found a background loop doing a full directory sync `cp -a` every 60 seconds. This is inefficient as it overwrites identical files repeatedly.
**Action:** Use `cp -au` (update flag) for periodic file syncs in bash scripts to avoid unnecessary disk I/O when files haven't changed.

## 2026-10-16 - Reducing Process Spawning Overhead with `jq`
**Learning:** Shell scripts in this HA add-on project parsed `options.json` using multiple `jq` invocations. This incurs significant process spawning overhead, which is detrimental to edge devices. Note: `// empty` will abort string concatenations in `jq`; always use `// ""` instead.
**Action:** Consolidate multiple `jq` extractions into a single `eval` invocation in bash scripts using string concatenation (`eval "$(jq -r '"VAR=" + (.key // "" | @sh) ...' file.json)"`) to significantly reduce process creation overhead.
