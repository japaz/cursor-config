# Cursor Configuration

Personal Cursor AI configuration with autonomous context management system.

## What's Included

### Cursor Rules (`rules/`)

| File | Purpose | Always Apply |
|------|---------|--------------|
| `project-context-system.mdc` | Autonomous context storage/retrieval system | Yes |
| `personal-preferences.mdc` | Coding preferences and autonomous behavior | Yes |
| `code-knowledge-capture.mdc` | Capture code understanding and feature flows | Yes |
| `use-gemini-cli.mdc` | Delegate long-context tasks to Gemini CLI | No |

### CLI Tool (`bin/cursor-context`)

Helper script to manually manage project context.

```bash
# Basic commands
cursor-context init              # Initialize local context for a project
cursor-context set test-cmd "pytest -v"  # Store metadata
cursor-context show              # View all context sources
cursor-context search "pattern"  # Search across context

# Knowledge capture commands
cursor-context flow reschedule   # Document how a feature works
cursor-context flows             # List all documented flows
cursor-context glossary "slot"   # Define domain terminology
cursor-context entry "add-api"   # Document entry points for tasks
cursor-context qa "How does X?"  # Log Q&A about the codebase
```

## Installation

```bash
git clone https://github.com/japaz/cursor-config.git
cd cursor-config
./setup.sh
```

The setup script creates symlinks:
- `~/.cursor/rules/*.mdc` → rules files
- `~/.local/bin/cursor-context` → CLI tool

## How It Works

### Layered Context System

1. **Global Rules** (`~/.cursor/rules/`) - Apply to all projects
2. **Project Rules** (`<project>/.cursor/rules/`) - Committed, shared with team
3. **Local Context** (`<project>/.git/local-context/`) - Never pushed, personal notes

### Autonomous Behavior

Cursor will automatically:
- Check for existing context at session start
- Store valuable information discovered during work (test commands, architecture, etc.)
- Update outdated information when detected
- Save user corrections for future sessions

### What Gets Stored

| Discovery | Where |
|-----------|-------|
| Test/build/dev commands | `git config --local project.*` |
| Architecture patterns | git config + `.git/local-context/` |
| User corrections | `.cursor/rules/local-preferences.mdc` |
| Complex workflows | `.git/local-context/*.md` |
| **Feature flows** | `.git/local-context/flows/<name>.md` |
| **Domain glossary** | `.git/local-context/glossary.md` |
| **Entry points** | `.git/local-context/entry-points.md` |
| **Q&A cache** | `.git/local-context/qa.md` |

### Code Knowledge Capture

When Cursor spends time understanding how a feature works (e.g., tracing how "reschedules" or "upgrades" are implemented), it documents that knowledge so future sessions don't need to repeat the exploration.

**Flow documents** capture:
- Entry points (API, CLI, events)
- Key files involved
- Step-by-step flow sequence
- Domain concepts and terminology
- Non-obvious behaviors and gotchas

**Example:** After understanding how rescheduling works, Cursor creates `.git/local-context/flows/reschedule.md` with the complete flow documentation.

## Uninstall

```bash
./setup.sh --uninstall
```

## License

MIT
