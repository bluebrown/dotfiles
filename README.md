# Dot Files

## Full Setup

The setup script installs all components. Config files are merged with rsync and the backup option.

```bash
bash setup.sh
```

## Configs Only

Only sync the config files without installing any tools and packages.

```bash
bash scripts/configure.sh
```

## VS Code

On wsl2 the below is required to run the integrated terminal as login shell.

```json
{
    "terminal.integrated.profiles.linux": {
        "bash": {
            "path": "bash",
            "icon": "terminal-bash",
            "args": ["-l"]
        },
    }
}
```
