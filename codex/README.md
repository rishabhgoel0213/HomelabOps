# Codex

This directory contains the ops-owned desired state for the server's Codex
integration.

- `config.toml` is the Codex config seeded into `/srv/state/codex`; enabled
  plugin blocks in this file are installed during bootstrap.
- `plugins/` is reserved for local plugin source owned by this repository.

Live Codex state, sessions, caches, auth materialization, and installed plugin
artifacts belong under `/srv/state/codex`.

Codex may create internal cache paths such as `.tmp/plugins/.agents` beneath
`/srv/state/codex`; those are runtime state, not ops repository source.
