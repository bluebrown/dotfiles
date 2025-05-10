# Cheat Sheet

## File Navigation

In `normal mode`, the oil buffer can bed opened with `-`. Pressing `-`
multiple times will traverse upwards. Oil buffer can be edited like a
normal buffer. Pressing `Enter`, open the file or directory under the
cursor.

## Code Completion

In `insert mode`, when typing, completion menu will automaically open.
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
respectively. The following custom keymaps have been set.

    vim.keymap.set("n", "grf", vim.diagnostic.open_float)
    vim.keymap.set("n", "grq", vim.diagnostic.setqflist)

## Code Actions

In `normal mode`, when the cursor is above a token, `gra`, opens a code
action menu, offering actions by the LSP. Some of the actions have
dedicated keymaps. For example, in `normal mode`, `grn` renames the
token across the entire workspace.

Refrences and implementations can be found with `grr` and `gri`.
however, definitions and declarations dont have a built in keymap.

    vim.keymap.set("n", "grd", vim.lsp.buf.definition)
    vim.keymap.set("n", "grD", vim.lsp.buf.declaration)

## Syntax Highlighting

Install additional grammars for treesitter.

    :TSInstall toml yaml json
