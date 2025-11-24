# OpenCode Configuration

This directory contains configuration for OpenCode custom commands and settings.

## Adding Custom Commands

OpenCode supports custom commands in two ways. **Markdown files are recommended** for better readability and maintainability.

### 1. Markdown Files (Recommended)
Create markdown files with YAML frontmatter in the `command/` directory.

**Location:**
- Global: `~/.config/opencode/command/`
- Per-project: `.opencode/command/`

**Syntax:** Create `.opencode/command/test.md`
```yaml
---
description: Run tests with coverage
agent: build
model: anthropic/claude-3-5-sonnet-20241022
---
Run the full test suite with coverage report and show any failures.
Focus on the failing tests and suggest fixes.
```

**Usage:** `/test`

### 2. JSON Configuration (opencode.jsonc)
Alternatively, add a `command` block to your configuration file:

**Location:**
- Global: `~/.config/opencode/opencode.jsonc`
- Per-project: `.opencode/opencode.jsonc` in project root

**Syntax:**
```jsonc
{
  "command": {
    "test": {
      "template": "Run the full test suite with coverage report and show any failures.\nFocus on the failing tests and suggest fixes.",
      "description": "Run tests with coverage",
      "agent": "build",
      "model": "anthropic/claude-3-5-sonnet-20241022"
    }
  }
}
```

**Usage:** `/test`

## Special Variables and Placeholders

### Arguments
Use `$ARGUMENTS` to accept user input:
```yaml
---
description: Create a new component with arguments
---
Create a new React component named $ARGUMENTS with TypeScript support.
Include proper typing and basic structure.
```

**Usage:** `/component MyButton` → `$ARGUMENTS` becomes `MyButton`

### Positional Arguments
Access individual arguments using `$1`, `$2`, `$3`, etc.:
```yaml
---
description: Create a new file with content
---
Create a file named $1 in the directory $2 with the following content: $3
```

**Usage:** `/create-file config.json src "{\"key\": \"value\"}"`

### Shell Command Output
Use `!command` to inject bash command output into the prompt:
```yaml
---
description: Analyze test coverage
---
Here are the current test results:
!npm test

Based on these results, suggest improvements to increase coverage.
```

### File References
Use `@filename` to include file content:
```yaml
---
description: Review component
---
Review the component in @src/components/Button.tsx. 
Check for performance issues and suggest improvements.
```

## Configuration Options

### Template (Required)
The prompt sent to the LLM when the command is executed.

### Description (Optional)
Brief description shown in the TUI when listing commands.

### Agent (Optional)
Specify which agent should execute the command. Options include `build`, `plan`, etc.
If not specified, defaults to the current agent.

### Subtask (Optional)
Force the command to trigger a subagent invocation.
```jsonc
{
  "command": {
    "analyze": {
      "subtask": true
    }
  }
}
```

### Model (Optional)
Override the default model for this command. If not specified, uses the default configured model.

**Markdown example:**
```yaml
---
description: Analyze code
model: anthropic/claude-3-5-sonnet-20241022
---
Analyze this code for performance issues.
```
*The `model` field is optional. Omit it to use your default configured model.*

**JSON example:**
```jsonc
{
  "command": {
    "analyze": {
      "model": "anthropic/claude-3-5-sonnet-20241022"
    }
  }
}
```

## Best Practices

1. **Use Markdown files by default** - cleaner syntax, easier to edit
2. **Name descriptively** - file names become command names
3. **Organize in subdirectories** - `.opencode/command/git/commit.md` becomes `/git:commit`
4. **Add clear descriptions** to help remember what each command does
5. **Use positional arguments** when you have multiple inputs needed
6. **Use JSON only** for simple commands or global configuration needs

## Configuration Priority

OpenCode looks for configuration in this order (later overrides earlier):
1. `OPENCODE_CONFIG` environment variable
2. `.opencode/opencode.jsonc` (project directory)
3. `~/.config/opencode/opencode.jsonc` (global)

Configuration files are **merged together**, not replaced. Non-conflicting settings from all configs are preserved.

## Verification Notes

This documentation is verified against OpenCode's official documentation:
- Commands: https://opencode.ai/docs/commands/
- Config: https://opencode.ai/docs/config/
- GitHub: https://github.com/sst/opencode

**Field Status:** The `model` field is **optional** - if not specified, OpenCode uses your default configured model.
