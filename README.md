# Dotfiles

This repo is meant to be used with `git wortree`. All its content is
ignored by a wildcard in `.gitignore`. This allows to track only related
changes, while treating the repo as the users home directory.

The bare repo is cloned to get access the the repos metadata. For the
first time, git also supports the `--bare` flag for the init command.

```sh
# init repo
git init --bare ~/.config/dotfiles.git

# or clone an existing repo
git clone --bare git@github.com:bluebrown/dotfiles.git .config/dotfiles.git 
```

Afterwards, the `--git-dir` and `--work-tree` options are used to set
the working directory to the home directory and the git directory to the
bare repo. This allows leads to the home folder being treated as a git
repository.

```sh
alias cfg='git --git-dir="$HOME/.config/dotfiles.git/" --work-tree="$HOME"'
cfg checkout
```

Because of this, any changes have to be tracked via the `--force` flag,
as it is ignored by default.

```sh
cfg add -f .myconfig
cfg commit -s
cfg push -u origin main
```
