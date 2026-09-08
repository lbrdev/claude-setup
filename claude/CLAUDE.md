# How to work with me

The rules below are generalized from real incidents. Each one cost time or lost
work, which is why they read as prohibitions rather than preferences.

## Git: nothing reaches a remote without its own "yes"

- **Never push to `develop` or `main` directly.** Feature branches and PRs only.
  An accidental push to `develop`, followed by a force-push to undo it, once
  rolled back other people's commits. This is a hard ban — no "just this once".
- **After `git commit`, never run `git push` automatically.** Stop, show what was
  committed, and wait for an explicit "push". I want the chance to read the diff.
- **Every push is confirmed separately** — plain, force, and force-with-lease
  alike. Agreement to a task ("build the feature") is not agreement to a push.
  Creating a branch and pushing it the first time also needs confirmation.
- **Don't commit automatically.** Write the files, `git add` if useful, but leave
  the commit until I've looked. This applies to subagents too.
- **Never run `git stash drop`.** If `git stash pop` conflicts, resolve the
  conflict instead of dropping — staged-but-uncommitted files have already been
  lost that way, unrecoverably. Better still, prefer a worktree or a throwaway
  commit over stashing at all.

## Secrets

- **Tokens go through environment variables only** — never paste a value into a
  command or into code. Tokens leak through logs, screenshots and transcripts,
  and rotating them every time is expensive. If `$VAR` isn't visible in a
  non-interactive shell, ask me to put the `export` in `~/.zshenv` (not
  `~/.zshrc`, which only interactive shells read) or in the settings `env` block.
- Never echo a token in full — mask it or print a few characters. If a value does
  end up in the conversation, offer rotation immediately.
- **Every write to shared infrastructure is confirmed again.** Repository secrets
  and variables, branch protection, CI configuration — an earlier "let's try it"
  does not authorize the next write. Such values are often set by hand through a
  UI, and an automatic overwrite destroys someone else's work.

## Check instead of guessing

- **Verify the actual versions and tags** of external dependencies before writing
  them into config: GitHub Actions, packages, plugins. Don't assume the usual tag
  shape — a major-version alias may not exist.
- **Look at the artifact rather than reasoning about it.** When something seems
  wrong, decode the file, read the reference implementation, print the number.
  A guess almost always costs more than the check would have.
- **Never claim "verified" or "matches" without an actual comparison.** For a
  visual result that means both sides in one frame, the same crop, at a
  magnification where the difference would show. If the comparison isn't
  possible, say exactly that. A false "verified" is worse than silence — it makes
  the commit history untrustworthy.

## Code and builds

- **Don't write explanatory comments.** No descriptions of how or why an
  algorithm works — that's visible in the code. The only exception is a hidden
  constraint, invariant or bug workaround that a name can't express. If you want
  to explain something, express it through the name of a constant or function.
- **Don't run long builds or launch the app** — I verify on the device myself.
  Fast static checks (linters, formatters) are fine. Targeted unit tests are fine
  during a TDD cycle when you need the RED/GREEN signal.
- **Never reset saved settings for development convenience.** Don't bump a
  storage key version or change defaults "temporarily" if it wipes what's already
  configured. Add new fields with tolerant decoding and defaults; to check
  appearance, change values through the interface or a separate storage domain
  rather than in code.

## Pace

- Once a plan is agreed and what's left is mechanically applying edits, apply
  them without confirming each step and without showing every diff. Ask only
  where a genuine fork appears. This does not extend to a new topic, destructive
  operations, commits, or pushes.

## Technical facts already paid for in time

- GitHub Actions does not accept `pull_request_review_thread` in an `on:` block —
  that name exists only as a webhook event. The valid PR triggers are
  `pull_request`, `pull_request_review`, `pull_request_review_comment` and
  `pull_request_target`.
