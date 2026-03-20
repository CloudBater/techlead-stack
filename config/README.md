# Configuration

## settings.json

The `settings.json` file configures Claude Code's hooks and permission deny rules.

### How to Use

**Option A: Merge into your existing project settings**

Copy the relevant sections into your project's `.claude/settings.json`:

```bash
# If you don't have one yet:
cp config/settings.json .claude/settings.json
```

**Option B: Use as global settings**

```bash
# Merge into ~/.claude/settings.json for all projects
```

### What's Configured

**Deny Rules** (from [Trail of Bits](https://github.com/trailofbits/claude-code-config)):

Blocks Claude from reading credential files:
- `~/.ssh/**` — SSH keys
- `~/.aws/**` — AWS credentials
- `~/.kube/**` — Kubernetes configs
- `~/.docker/config.json` — Docker registry auth
- `~/.npmrc`, `~/.pypirc` — Package registry tokens
- `~/.git-credentials`, `~/.config/gh/**` — Git/GitHub tokens
- `~/.bashrc`, `~/.zshrc` — Shell config (edit denied)

**Hooks** — see `hooks/README.md` for details on each hook.

### Adding Your Own Deny Rules

Common additions:

```json
{
  "permissions": {
    "deny": [
      "Read(~/.config/gcloud/**)",
      "Read(~/.terraform.d/**)",
      "Edit(~/.gitconfig)"
    ]
  }
}
```
