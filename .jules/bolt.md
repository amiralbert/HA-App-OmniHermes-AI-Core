## 2026-10-15 - Background Disk I/O Optimization
**Learning:** Found a background loop doing a full directory sync `cp -a` every 60 seconds. This is inefficient as it overwrites identical files repeatedly.
**Action:** Use `cp -au` (update flag) for periodic file syncs in bash scripts to avoid unnecessary disk I/O when files haven't changed.

## 2026-10-18 - Bash Subprocess Spawning Optimization
**Learning:** In bash scripts parsing JSON config files (like Home Assistant add-on options), spawning `jq` repeatedly for each field (e.g. `VAR1=$(jq ...)`, `VAR2=$(jq ...)`) adds significant execution time due to process creation overhead, particularly on lower-power edge devices.
**Action:** Use a single `jq` execution with string concatenation and `eval` to assign multiple bash variables at once: `eval "$(jq -r '"VAR1=\(.key1 // "" | @sh) " + "VAR2=\(.key2 // "" | @sh)"' file.json)"`.
