@AGENTS.md
# Gemini Project Instructions: personal-zsh

This file provides Gemini-specific guidance. For general project rules, architecture, and workflows, refer to the shared reference.

## Primary Reference
- **Shared Guidelines**: [AGENTS.md](./AGENTS.md) (Read this first for project context).

## Gemini-Specific Guidance
- **Tooling**: Prioritize the use of `grep_search` to find modular configurations in `config/` before suggesting changes.
- **Verification**: When testing shell script changes, use `run_shell_command` with `zsh -n <file>` to check for syntax errors.
- **Context**: Remember that `zshrc.template` is the source of truth for the linked `~/.zshrc`.
