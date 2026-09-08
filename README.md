# claude-setup

My portable Claude Code setup: skills, settings, hooks, MCP servers and working
rules. Land on a new machine, clone this, tell the agent to set it up, and you
get the same environment back.

## Getting it running

```bash
git clone https://github.com/lbrdev/claude-setup && cd claude-setup
```

Then open Claude Code or Codex here and say:

> set this up following INSTALL.md

[`INSTALL.md`](INSTALL.md) is written as a task for the agent: identify the
environment, install the skill packages with their own installers, substitute the
home directory into the settings template, wire up the MCP servers (asking you
for tokens rather than carrying someone else's), and report what still needs
doing by hand.

Skills and MCP servers only appear in a **new** session — restart afterwards.

## What's in here

```
INSTALL.md            the task handed to the agent
manifest.json         declaration: packages, plugins, MCP, npm tools + update commands
claude/
  settings.template.json  settings; __HOME__ is substituted at install time
  CLAUDE.md               working rules — how to work with me
  skills/                 my own skills: flexnative, morphicons
  vendor/                 snapshot of vendored skills and agents
mcp/servers.json      MCP servers, placeholders instead of tokens
codegraph/SETUP.md    installing and wiring up codegraph
scripts/              leak check + pre-commit installer
```

### My own skills

- **flexnative** — the `@flx` shadcn registry from
  [ui.flexnative.com](https://ui.flexnative.com): 450 blocks, patterns,
  illustrations and complete flows (sign-in, reset password, two-factor,
  payment). The registry is wired into a project's `components.json`.
- **morphicons** — [morphicons](https://www.morphicons.com) morphs one
  stroke icon into another with spring physics: menu into close, play into pause.

### Vendored

- [**impeccable**](https://github.com/pbakaus/impeccable) (Apache-2.0) — a design
  skill with a detector for typical AI slop and hooks that check UI edits as you
  make them.
- [**emilkowalski/skills**](https://github.com/emilkowalski/skills) (MIT) — 12
  skills on interfaces and animation from the author of Sonner and Vaul.

The copies under `claude/vendor/` are a snapshot at commit time, for reading and
rollback. Current versions come from the commands in `manifest.json`; the
impeccable engine is built per platform by its installer and is not in the
snapshot.

## Secrets

There are none here, and there should never be. `scripts/check-leaks.sh` looks
for tokens, home-directory paths, UUIDs, and private names listed in
`scripts/private-words.txt`. Wire it into pre-commit:

```bash
./scripts/install-hooks.sh
```

MCP tokens are requested from the human at install time and live only in the
local `~/.claude.json`, which never reaches this repository.

## Licenses

My own files are MIT (see `LICENSE`). The vendored skills keep their own
licenses; the texts, and the `NOTICE` that Apache-2.0 requires, are in
`LICENSES/`.
