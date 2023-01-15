# React scaffold script

Bash script to create React components (or component pages) with a single command.

# Usage

```bash
  $ ./react_scaffold.sh [flags] <ComponentOne> <ComponentTwo> ...
```

# Flags

| Flag | Description | Values | Default |
| ---- | ----------- | ------ | ------- |
| -h, --help | Show help | - | - |
| -c, --component | Create a component instead of a component page | - | component |
| -p, --page | Create a component page instead of a normal component | - | component |
| -s, --styles | Select styles file | css, scss, sass, styled | styled |
| -l, --language | Select language | js, ts | ts |

# Examples

```bash
  $ ./react_scaffold.sh -p -s sass -l js ComponentOne ComponentTwo
```