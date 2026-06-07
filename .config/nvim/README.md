# Cheat Sheet

> [!NOTE]  
> Installation of nvim requires so manual steps. Not fully automated!

## Folds

Use `zo` and `zc` to open and close folds.

## File Navigation

In `normal mode`, the oil buffer can bed opened with `-`. Pressing `-`
multiple times will traverse upwards. Oil buffer can be edited like a
normal buffer. Pressing `Enter`, open the file or directory under the
cursor.

Hidden files can be toggled with `g.`.

## Code Completion

In `insert mode`, when typing, completion menu will automatically open.
This can also be forced with `CTRL-Space`.

Select choice with `CTRL-N` (next) and `CTRL-P`(previous) and confirm
with `CTRL-Y`. Arrow keys also work for selection.

The lsp omnifunc can also be used with `CTRL-X CTRL-O`.

For incremental completion, set `noselect`.

    vim.cmd[[set completeopt+=menuone,noselect,popup]]

## Hover Information

In `normal mode`, `K` (shift+k) opens the hover information.

## Signature help

When in `insert mode`, inside a function calls signature, `CTRL-S`,
opens the signature help below the signature.

## Diagnostics

The next and previous diagnostic can be cycled with `[d` and `[D`,
respectively. The following custom keymaps have been set. `CTRL+W-D`
opens a floating window for the diagnostics.

Additionally this custom keybinding opens all diagnostics in the quick
fix list.

    vim.keymap.set("n", "grq", vim.diagnostic.setqflist)

## Code Actions

In `normal mode`, when the cursor is above a token, `gra`, opens a code
action menu, offering actions by the LSP. Some of the actions have
dedicated keymaps. For example, in `normal mode`, `grn` renames the
token across the entire workspace.

Refrences and implementations can be found with `grr` and `gri`, 
and `grt` shows the type definition.

# Syntax Highlighting

To install additonal sytanx, list them in the
(settings.lua)[./lua/settings.lua] file, in order to ensure both the
parser and the file type auto command are installed.
