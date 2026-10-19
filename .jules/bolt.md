## 2024-05-19 - JQ String Concatenation Issue on Edge Devices
**Learning:** When consolidating multiple `jq` extractions into a single `eval` invocation for shell scripts (a key optimization to reduce process overhead on edge devices like Raspberry Pis), using the fallback `// empty` causes the entire `jq` string concatenation to abort if the key is missing, resulting in empty output. The correct fallback for string concatenation is `// ""`.
**Action:** Always use `// ""` instead of `// empty` when using string concatenation in `jq` to generate shell assignments.

## 2024-05-19 - JQ String Concatenation Issue on Edge Devices
**Learning:** When consolidating multiple `jq` extractions into a single `eval` invocation for shell scripts (a key optimization to reduce process overhead on edge devices like Raspberry Pis), using the fallback `// empty` causes the entire `jq` string concatenation to abort if the key is missing, resulting in empty output. The correct fallback for string concatenation is `// ""`.
**Action:** Always use `// ""` instead of `// empty` when using string concatenation in `jq` to generate shell assignments.
