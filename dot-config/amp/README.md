# Amp Custom Commands

Create markdown files in `.agents/commands/` to define custom commands.

**Location:**
- Project: `.agents/commands/`
- Global: `~/.config/amp/commands/`

**Syntax:** Create `.agents/commands/pr-review.md`
```markdown
Review this pull request for code quality, logic, and potential issues.
Suggest improvements and identify any bugs.
```

**Usage:** `/pr-review`

## Arguments

Use `$ARGUMENTS` or `$1`, `$2`, etc. in your command:

```markdown
Create a new component named $ARGUMENTS with TypeScript support.
```

**Usage:** `/create-component MyButton`

## Invoke Commands

- **VS Code/Cursor:** `Cmd/Alt-Shift-A`
- **Amp CLI:** `Ctrl-O`

Then type the command name to search and execute.
