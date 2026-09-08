# codegraph

Builds a graph of a project's code and serves it to the agent over MCP, instead
of grepping through files for the connections.

## Install

```bash
npm i -g @colbymchenry/codegraph
codegraph --version
```

It installs globally through npm, not Homebrew — the binary turns out to be a
symlink to `npm-shim.js` in the global modules directory.

## Wire it up

```bash
claude mcp add -s user codegraph -- codegraph serve --mcp
claude mcp list   # should report Connected
```

No tokens needed. Daemon state and telemetry live in `~/.codegraph/`; there is no
reason to carry that directory between machines.

## If it won't connect

`codegraph serve --mcp` runs over stdio, so "Connection closed" usually means the
binary isn't on the `PATH` of the agent's process. Check `which codegraph` from
the same shell that launches Claude Code, and that npm's global `bin` really is
on that `PATH`.
