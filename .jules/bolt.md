## 2026-10-15 - Background Disk I/O Optimization
**Learning:** Found a background loop doing a full directory sync `cp -a` every 60 seconds. This is inefficient as it overwrites identical files repeatedly.
**Action:** Use `cp -au` (update flag) for periodic file syncs in bash scripts to avoid unnecessary disk I/O when files haven't changed.

## 2026-10-15 - Process Spawning Overhead on Edge Devices
**Learning:** Found initialization scripts spawning multiple `jq` processes sequentially (10 in one script, 7 in another) to parse JSON configuration. On edge devices like Raspberry Pis (where HA add-ons often run), process creation overhead is non-trivial and impacts container startup time.
**Action:** Consolidate multiple `jq` extractions into a single invocation using `eval` and string concatenation: `eval "$(jq -r '"VAR=\(.key // "" | @sh) " + ...' file.json)"`. Remember to always use `// ""` instead of `// empty` in these concatenations to prevent string building abortion.
