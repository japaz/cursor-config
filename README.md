# Cursor Configuration

Personal Cursor AI configuration with autonomous context management system.

## What's Included

### Cursor Rules (`rules/`)

| File | Purpose | Always Apply |
|------|---------|--------------|
| `project-context-system.mdc` | Autonomous context storage/retrieval system | Yes |
| `personal-preferences.mdc` | Coding preferences and autonomous behavior | Yes |
| `use-gemini-cli.mdc` | Delegate long-context tasks to Gemini CLI | No |

### CLI Tool (`bin/cursor-context`)

Helper script to manually manage project context.

```bash
cursor-context init              # Initialize local context for a project
cursor-context set test-cmd "pytest -v"  # Store metadata
cursor-context show              # View all context sources
cursor-context search "pattern"  # Search across context
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

## Uninstall

```bash
./setup.sh --uninstall
```

## License

MIT
