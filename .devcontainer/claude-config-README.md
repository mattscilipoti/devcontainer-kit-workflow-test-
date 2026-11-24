# Claude Code state for this devcontainer

This folder is a **bind mount**: inside the devcontainer it appears as
`~/.claude`, and on the host it is a plain folder. Claude Code keeps its
sign-in, chat history, memory, and settings here.

## Why it is a host folder

The devcontainer's own filesystem is deleted on every rebuild, which used to
sign Claude out and wipe its history. A Docker named volume survives rebuilds,
but it can be lost when the project is opened from another path (the volume
name changes), or by `docker system prune --volumes` or Docker Desktop's
"Clean up". A host folder is affected by none of those, and normal host backups
include it.

## What is in it

| Path | Contents |
|---|---|
| `.credentials.json` | **Your login token.** Treat it like a password. |
| `.claude.json` | Sign-in state and settings. |
| `projects/<path>/*.jsonl` | One file per chat; this is the history. |
| `projects/<path>/memory/` | Claude's saved notes for the project. |
| `backups/`, `cache/`, `plugins/`, `skills/` | Housekeeping. Safe to delete. |

## Rules

- **Never commit, share, or sync this folder to a public place.** It must stay
  outside the git repository.
- **Back it up** like any other personal folder; losing it means signing in
  again and losing chat history.
- **Do not point it at your host's own `~/.claude`.** The two would fight over
  `.claude.json` and credentials.

## Common tasks

- **Sign out for good:** delete this folder. The next rebuild creates it empty.
- **Start over without signing out:** delete `projects/`.
- **Move to a new machine:** copy this folder to the same relative place
  (`~/.claude-devcontainers/<project>`) and rebuild.
- **Seed it from an old Docker volume**, with Claude idle:
  `docker run --rm -v <volume>:/v:ro -v "$PWD":/out alpine cp -a /v/. /out/`
  run from this folder. Find the volume with `docker volume ls | grep -i claude`.

The devcontainer configuration (`.devcontainer/devcontainer.json`) creates this
folder on the host and mounts it; see the project README, "Claude Code sign-in".
