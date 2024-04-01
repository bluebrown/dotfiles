# Dot Files

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
