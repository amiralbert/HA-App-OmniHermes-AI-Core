## 2026-10-15 - Background Disk I/O Optimization
**Learning:** Found a background loop doing a full directory sync `cp -a` every 60 seconds. This is inefficient as it overwrites identical files repeatedly.
**Action:** Use `cp -au` (update flag) for periodic file syncs in bash scripts to avoid unnecessary disk I/O when files haven't changed.

## 2026-10-16 - Consolidating process spawning overhead
**Learning:** Found multiple consecutive `jq` process calls in shell scripts parsing `/data/options.json`. Spawning many processes sequentially introduces measurable overhead on edge devices like Raspberry Pi.
**Action:** Consolidate multiple `jq` extractions into a single invocation using `eval` and string concatenation, such as `eval "$(jq -r '"VAR=" + (.key // "" | tostring | @sh) ...' file.json)"` to speed up script execution.
