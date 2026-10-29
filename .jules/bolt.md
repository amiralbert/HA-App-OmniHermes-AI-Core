## 2026-10-15 - Background Disk I/O Optimization
**Learning:** Found a background loop doing a full directory sync `cp -a` every 60 seconds. This is inefficient as it overwrites identical files repeatedly.
**Action:** Use `cp -au` (update flag) for periodic file syncs in bash scripts to avoid unnecessary disk I/O when files haven't changed.

## 2026-10-16 - Subprocess Spawning Overhead Optimization
**Learning:** Shell scripts loading add-on configuration typically spawn multiple `jq` processes (one for each config key). In low-resource edge devices (like Home Assistant on Raspberry Pi), this creates unnecessary process spawning overhead that slows down startup times.
**Action:** Consolidate multiple `jq` extractions into a single invocation using `eval` and string concatenation (e.g., `eval "$(jq -r '"VAR=\(.key // "" | @sh) " + ...' file.json)"`) to reduce process spawn overhead. Ensure `// ""` is used instead of `// empty` in the jq script to prevent string concatenation abortion.
