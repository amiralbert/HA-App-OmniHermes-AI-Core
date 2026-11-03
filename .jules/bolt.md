## 2026-10-15 - Background Disk I/O Optimization
**Learning:** Found a background loop doing a full directory sync `cp -a` every 60 seconds. This is inefficient as it overwrites identical files repeatedly.
**Action:** Use `cp -au` (update flag) for periodic file syncs in bash scripts to avoid unnecessary disk I/O when files haven't changed.

## 2026-10-16 - `jq` Process Spawning Overhead
**Learning:** Shell scripts frequently spawn multiple individual `jq` processes to parse a single JSON configuration file (e.g., Home Assistant add-on options). This process spawning overhead is significant, particularly on resource-constrained edge devices.
**Action:** Consolidate multiple `jq` extractions into a single invocation using `eval` and string concatenation: `eval "$(jq -r '"VAR=\(.key // "" | tostring | @sh) " + ...' file.json)"`.
