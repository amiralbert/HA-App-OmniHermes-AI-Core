## 2026-10-15 - Background Disk I/O Optimization
**Learning:** Found a background loop doing a full directory sync `cp -a` every 60 seconds. This is inefficient as it overwrites identical files repeatedly.
**Action:** Use `cp -au` (update flag) for periodic file syncs in bash scripts to avoid unnecessary disk I/O when files haven't changed.

## 2026-10-16 - jq string concatenation empty fallback
**Learning:** When using `eval "$(jq -r '... "VAR=\(.key // empty | @sh) " + ...' file.json)"`, if `empty` is hit, the entire string concatenation is silently aborted, returning nothing to `eval`.
**Action:** Always use `// ""` instead of `// empty` when relying on `jq` string concatenation for shell variable assignment.
