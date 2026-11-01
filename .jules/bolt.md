## 2026-10-15 - Background Disk I/O Optimization
**Learning:** Found a background loop doing a full directory sync `cp -a` every 60 seconds. This is inefficient as it overwrites identical files repeatedly.
**Action:** Use `cp -au` (update flag) for periodic file syncs in bash scripts to avoid unnecessary disk I/O when files haven't changed.
## 2026-11-01 - Secure jq Eval Batching
**Learning:** When using `eval` with `jq` and `@sh` to batch variable assignment, piping values through `tostring` (e.g., `\(.key // "" | tostring | @sh)`) is essential. It prevents arbitrary command execution edge-cases if a user injects an unexpected JSON array where a string was expected, which `@sh` would otherwise expand into unquoted commands.
**Action:** Always pipe values to `tostring` before `@sh` when batch-assigning JSON data to bash variables via `eval`.
