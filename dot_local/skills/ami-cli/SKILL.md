---
name: ami-cli
description: Query local Amie.app meeting recordings and transcripts from the macOS SQLite database. Use this skill whenever you need to retrieve meeting context, action items, summaries, or transcripts from Amie. Triggers on requests like "get my latest meeting", "find recordings from last week", "search transcripts for X", or any question about recorded meetings.
---

# Amie CLI Skill

Query meeting recordings and transcripts stored locally by [Amie.app](https://amie.so) on macOS.

## What This Is

Amie.app runs as an Electron desktop app on macOS and stores all recording metadata — titles, timestamps, speaker names, transcript segments, summaries, action items — in a local SQLite database. This skill gives you a CLI (`amie`) to query that data directly, with no copy/paste needed.

**Key fact**: All data is local. No network calls. No authentication. Fully offline.

## When to Use This Skill

- User asks about a specific meeting or its content
- User wants a transcript, summary, or action items from a past meeting
- User asks "what did we discuss in the meeting on [date]"
- User wants to search across all recorded meetings
- User wants to know what was decided in the past week
- Any task requiring meeting context from Amie's local DB

## The Tool

The `amie` CLI lives at `~/.local/bin/amie` (managed via chezmoi).

### Installation check

```bash
which amie && amie --agent-help
```

If not found, install it from chezmoi managed source at `~/.local/share/chezmoi/dot_local/bin/executable_amie`.

### Core Commands

```bash
# List recent recordings (most recent first)
amie list

# Most recent recording with full detail
amie latest

# Specific recording (id, short prefix, or numeric index 1=N most recent)
amie show 1
amie show 621185bf
amie show 91ed85bf-4dfc-44ea-92d8-5e8ee4f3d980

# Full transcript with speaker names and timestamps
amie transcript 1

# Short + markdown summary
amie summary 1

# Speaker roster
amie speakers 1

# Full-text search (across titles, summaries, transcripts)
amie search "商談"

# Date range (inclusive, YYYY-MM-DD)
amie span 2026-04-01 2026-04-15
```

### Flags

| Flag | Description |
|------|-------------|
| `--json` | Output as JSON (for agents, piping, programmatic use) |
| `--limit N` | Override row limit (default 20) on list/span/search |
| `--db PATH` | Override DB path (rarely needed) |
| `--agent-help` | Print machine-readable schema documentation |

### Recording Reference

Any command accepting a `<recording>` argument accepts:

1. Full UUID: `91ed85bf-4dfc-44ea-92d8-5e8ee4f3d980`
2. Short UUID prefix (8+ chars): `91ed85bf`
3. Numeric index from list output (1 = most recent): `1`

### Example: JSON output for agent consumption

```bash
# Get latest meeting as structured JSON
amie latest --json

# Get transcripts for a specific recording
amie transcript 1 --json

# Search and get machine-readable results
amie search "権限チェック" --json

# Date range as JSON
amie span 2026-04-01 2026-04-15 --json
```

## Database Schema

The SQLite DB lives at:
```
~/Library/Application Support/amie-desktop/Partitions/main/File System/000/t/00/00000023
```

**Tables:**

| Table | Description | Key columns |
|-------|-------------|-------------|
| `recordings` | Meeting metadata | `id`, `title`, `status`, `duration` (seconds), `createdAt` (epoch-ms), `updatedAt`, `shortSummary`, `summary`, `mdSummary`, `actionItems` |
| `transcripts` | Transcription jobs | `id`, `recordingId`, `language`, `status`, `createdAt` |
| `segments` | Individual spoken segments | `id`, `recordingId`, `speakerId`, `text`, `start` (ms), `end` (ms) |
| `speakers` | Speaker identities | `id`, `recordingId`, `name`, `email` |
| `steps` | Processing steps per recording | `id`, `recordingId`, `type`, `status`, `output` |

**Indexes:**
- `recordings_fts` — FTS5 full-text index over `title`, `shortSummary`, `summary`, `speakers`, `transcript`
- `recordings` indexed on `id`, `updatedAt`, `deletedAt`

## Common Patterns

### Get context before a meeting
```bash
# Find recent recordings with a specific person
amie list --limit 20 | grep "sakabe"
# Or via speakers
amie speakers $(amie list --json | jq -r '.[0].id')
```

### Get decisions from a time period
```bash
# Last week's meetings
amie span 2026-04-08 2026-04-14 --json | jq '.[] | {title, shortSummary}'
```

### Get full transcript for context
```bash
amie transcript 1 --json | jq '.segments[] | "\(.speaker_name): \(.text)"' -r
```

### Action items from a recording
```bash
amie show 1 --json | jq '.action_items'
```

## Tips for Agents

- Always use `--json` when consuming output programmatically
- Numeric references are fragile — use UUIDs when accuracy matters
- `amie --agent-help` returns a machine-readable JSON spec if you need it dynamically
- If the DB is not found, Amie.app may not be installed or no meetings recorded yet
- The DB is read-only from this tool's perspective — no risk of corruption
- When in doubt, `amie list --limit 5` is a safe starting command