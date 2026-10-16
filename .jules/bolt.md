## 2024-05-24 - Bash JSON Parsing Optimization
**Learning:** In bash startup scripts parsing JSON files (common in HA Add-ons), making a separate `jq` call for each option spawns multiple processes. This can add noticeable startup latency on edge devices like Raspberry Pis.
**Action:** Consolidate multiple `jq` extractions into a single call using `eval "$(jq -r '@sh "VAR1=\(.key1) VAR2=\(.key2)"' file.json)"` to parse everything in one pass, reducing process spawning overhead by over 80%.
