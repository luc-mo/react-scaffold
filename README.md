# React scaffold script

Bash script to create React components (or component pages) with a single command.

# Usage

- Add executable permissions to the script
```bash
  $ chmod +x react_scaffold.sh
```

- Run the script
```bash
  $ ./react_scaffold.sh [flags] <ComponentOne> <ComponentTwo> ...
```

# Flags

| Flag | Description | Values | Default |
| ---- | ----------- | ------ | ------- |
| -h, --help | Show help | - | - |
| -c, --component | Create a component instead of a component page | - | component |
| -p, --page | Create a component page instead of a normal component | - | component |
| -s, --styles | Select styles file | css, scss, sass, styled, stitches | styled |
| -l, --language | Select language | js, ts | ts |

# Examples

```bash
  $ ./react_scaffold.sh -p -s sass -l js ComponentOne ComponentTwo
```

# Notes

- It is recomended to remove the extension of the script file (`react_scaffold.sh -> react_scaffold`) and move it to
  `/usr/bin`, `/usr/local/bin` or any other directory in your PATH variable to access it from anywhere in your system.

- By default, the script will create a component in the first `components` or `pages` directory it finds recursively
  from the current location. The option to select a specific directory will be added in the future.