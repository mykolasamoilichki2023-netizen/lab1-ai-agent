# Usage

## Agent commands

- Run `/lab-init` to initialize the project and run its complete check.
- Run `/check` to verify the generated project.

## Local checks

From the repository root, run:

```text
npm ci
npm run build
npm test
node dist/hello.js
```

For the platform-specific CI script, use `scripts\ci.bat` on Windows or `bash scripts/ci.sh` on Linux and macOS.
