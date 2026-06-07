# Dotfiles

## Using the dotfiles

    git clone --bare git@github.com:bluebrown/dotfiles.git 
    git --git-dir "$HOME/dotfiles.git" --work-tree="$HOME" checkout
    dash -x .config/deps.sh

## Creating your own

    git init --bare ~/dotfiles.git
    alias cfg='git --git-dir "$HOME/dotfiles.git" --work-tree "$HOME"'
    cfg remote add origin git@github.com:<your-user>/dotfiles.git
    cfg add -f .myconfig
    cfg commit -s
    cfg push -u origin main

## Cookbook

### Bash Completions

Many command line tools offer bash completions. Below example shows how
to create completions for kubectl and its alias k.

Create the third party provided completions, and search for its
function.

```bash
kubectl completion bash > kubectl
complete -p | grep kubectl
```

Use the function found by complete -p to create a new completion
triggered by the alias. The original script is sourced first, to avoid
ordering issues when loading the completions.


```bash
cat <<-EOF > k
source /etc/bash_completion.d/kubectl
complete -F __start_kubectl k
EOF
```

In order to automatically load the completions, place them into etc, and
restart the shell.

```bash
mv kubectl k /etc/bash_completion.d/
```


