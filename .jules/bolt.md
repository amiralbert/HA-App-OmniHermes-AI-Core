## 2026-10-15 - Background Disk I/O Optimization
**Learning:** Found a background loop doing a full directory sync `cp -a` every 60 seconds. This is inefficient as it overwrites identical files repeatedly.
**Action:** Use `cp -au` (update flag) for periodic file syncs in bash scripts to avoid unnecessary disk I/O when files haven't changed.

## 2026-10-15 - jq Optimization in Bash Scripts
**Learning:** Found multiple sequential `jq` calls to parse an options file, which spawns a new process for each call. This can be slow, especially on edge devices running Home Assistant.
**Action:** Consolidate multiple `jq` extractions into a single invocation using `eval` and string concatenation: `eval "$(jq -r '"VAR=\(.key // "" | @sh) " + ...' file.json)"`.
