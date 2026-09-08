# INSTALL — instructions for the agent

This is a task, not documentation for a human. Open the repository in Claude Code
or Codex and say: **"set this up following INSTALL.md"**.

The rest is addressed to you, the agent. Work through it in order, skipping
nothing.

---

## 0. Identify the environment and target paths

| | Claude Code | Codex |
|---|---|---|
| Skills | `~/.claude/skills/` | `~/.codex/skills/` (or `~/.agents/skills/`) |
| Agents | `~/.claude/agents/` | `~/.codex/agents/` |
| Instructions | `~/.claude/CLAUDE.md` | `~/.codex/AGENTS.md` |
| Settings | `~/.claude/settings.json` | `~/.codex/config.toml` |

Work out where you are running from which of these directories exist. `$TARGET`
below is that environment's root. If both exist, ask which one to set up — don't
silently do both.

**Overwrite nothing without asking.** Before every write, check whether the file
already exists; if it does, show the difference and ask. This applies to
`settings.json` and `CLAUDE.md` as much as to anything else.

## 1. Skill packages — install them, don't copy them

The vendored skills under `claude/vendor/` are a snapshot taken at commit time,
kept for reading and for rollback. Install the working copies with their own
commands, which fetch current versions and build platform-specific binaries:

```bash
npx impeccable@latest install -y --user --providers=claude   # --providers=codex for Codex
npx skills@latest add emilkowalski/skills -g -a claude-code -s '*' -y --copy
```

Two caveats:

- `impeccable` writes its hooks into `.claude` relative to the current directory,
  not to your home. After installing, check `./.claude/settings.local.json`; if
  the hooks landed there, move them into `$TARGET/settings.json` and delete the
  stray file.
- If `impeccable` is already installed and the installer refuses, add `--force`.

With no network, copy `claude/vendor/skills/*` and `claude/vendor/agents/*`
directly — but note that the impeccable engine is not in the snapshot and can
only come from the installer.

## 2. My own skills

```bash
cp -R claude/skills/* "$TARGET/skills/"
```

## 3. Settings — substitute the home directory

`claude/settings.template.json` contains the marker `__HOME__`. It **must** be
replaced: a path inside single quotes in a hook command is never expanded by the
shell, and the hook would silently become a no-op.

```bash
sed "s|__HOME__|$HOME|g" claude/settings.template.json > /tmp/settings.new.json
```

If `$TARGET/settings.json` already exists, merge by hand — `permissions`, `hooks`
and `enabledPlugins` are lists and must be combined, not replaced — and show the
result. If it doesn't, just put the file in place.

Verify the marker is gone: `grep -c __HOME__ "$TARGET/settings.json"` → `0`. And
verify the path the hook points at actually exists.

## 4. Instructions

`claude/CLAUDE.md` → `$TARGET/CLAUDE.md` (`AGENTS.md` on Codex). If the file
already exists, append the sections rather than overwriting it.

## 5. Plugins and marketplaces

The list lives in `manifest.json` under `plugins`. The official marketplace
`anthropics/claude-plugins-official` registers itself. Install through `/plugin`,
or via `enabledPlugins` — step 3 already handled that.

`gitkraken` is a local marketplace created by the GitKraken app when it installs.
Don't recreate it by hand: if GitKraken isn't installed, simply drop
`gitkraken-hooks` from `enabledPlugins`.

## 6. MCP servers

`mcp/servers.json` is a template. It holds no tokens — only placeholders such as
`${GITHUB_TOKEN}`.

Add servers one at a time, asking whether each is wanted and **asking the human
for the token**. Never copy a value out of someone else's file and never invent
one:

```bash
claude mcp add -s user shadcn -- npx -y shadcn@latest mcp
claude mcp add -s user codegraph -- codegraph serve --mcp
claude mcp add -s user --transport http github https://api.githubcopilot.com/mcp \
  --header "Authorization: Bearer <token from the human>"
```

Check the result with `claude mcp list`.

## 7. codegraph

See `codegraph/SETUP.md`.

## 8. Verify

- `claude mcp list` — the servers you added report Connected
- Skills appear in a **new** session; they will not show up in the current one,
  so say so explicitly
- No `__HOME__` remains in `$TARGET/settings.json`
- Run `scripts/check-leaks.sh`, in case anything private got picked up on the way

Then report: what was installed, what you skipped and why, and what needs a
restart.
