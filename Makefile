# set some sane defaults
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.SUFFIXES:

##@ Options

verbose ?= 0
prefix ?= $(HOME)/.local
bindir = $(prefix)/bin

ifneq ($(verbose),1)
.SILENT:
endif

define latest_tag
$(shell curl -fsSL "https://api.github.com/repos/$(1)/releases/latest" | jq -r '.tag_name')
endef

##@ Commands

help: makehelp ## Show this help message
	makehelp $(MAKEFILE_LIST)

install: deps ## Install everything, requires sudo access
	$(MAKE) runtimes
	$(MAKE) tools
	$(MAKE) config

config: config-home ## Sync config files

tools: tools-base tools-k8s ## Install all tools

runtimes:  ## Install runtimes, requires sudo access
	$(MAKE) python
	$(MAKE) node
	$(MAKE) go rust zig lua otp

deps: deps-apt ## Install all dependencies

##@ Config files

config-home: ## sync the fsys/home dir to the user's home directory
	mkdir -p ~/.bash_completion.d
	rsync -av fsys/home/ ~
	if ! git config --global user.name  $(GIT_USER_NAME);  then echo '$$GIT_USER_NAME not set'; fi
	if ! git config --global user.email $(GIT_USER_EMAIL); then echo '$$GIT_USER_EMAIL not set'; fi

###@ Dependencies

pkgs_base = gawk build-essential bison pkg-config curl git jq unzip xz-utils
pkgs_tmux = libevent-dev ncurses-dev
pkgs_dev  = man bash-completion net-tools rsync parallel entr
pkgs_net  = dnsutils iputils-ping netcat-openbsd nmap socat tcpdump traceroute
pkgs_lua  = libreadline-dev
pkgs_otp  = libssl-dev
pkgs_nvim = fswatch shellcheck

deps-apt: ## Install apt dependencies
	sudo apt-get update
	sudo apt-get install -y \
		$(pkgs_base) $(pkgs_tmux) $(pkgs_dev) $(pkgs_net) \
		$(pkgs_nvim) $(pkgs_lua) $(pkgs_otp)

###@ Runtimes

python: /usr/bin/python3 ## install python3
/usr/bin/python3:
	sudo apt-get -y  install python3
	sudo apt-get -y  install python3-pip python3-venv

node: /usr/bin/node ## install evergreen node version
/usr/bin/node:
	curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
	sudo apt-get install -y nodejs
	sudo npm -g set prefix ~/.local

go: /usr/local/go/bin/go ## install evergreen go version
/usr/local/go/bin/go:
	$(eval $@_tag = $(shell curl -fsSL https://golang.org/VERSION?m=text | head -n1 | xargs))
	curl -fsSL -o go.tgz "https://golang.org/dl/$($@_tag).linux-amd64.tar.gz"
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf go.tgz
	rm -f go.tgz

rust: $(HOME)/.cargo/bin/cargo ## install evergreen rust toolchain
$(HOME)/.cargo/bin/cargo:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

zig: /usr/local/zig/zig ## install evergreen zig version
/usr/local/zig/zig:
	$(eval $@_tag = $(shell curl -fsSL https://ziglang.org/download/index.json | jq -r '.master.version'))
	curl -fsSL -o zig.xz "https://ziglang.org/builds/zig-linux-x86_64-$($@_tag).tar.xz"
	sudo rm -rf /usr/local/zig && sudo mkdir -p /usr/local/zig
	sudo tar -C /usr/local/zig -xJf zig.xz --strip-components 1
	rm -f zig.xz

otp: /usr/local/otp/bin/erl ## install latest erlang otp
/usr/local/otp/bin/erl:
	$(eval $@_tag = $(shell curl -fsSL https://api.github.com/repos/erlang/otp/releases/latest | jq -r '.tag_name'))
	curl -fsSL -o otp-src.tgz "https://github.com/erlang/otp/archive/$($@_tag).tar.gz"
	tar -xzf otp-src.tgz
	cd otp-$($@_tag) && ./configure --prefix=/usr/local/otp && $(MAKE) && sudo $(MAKE) install
	rm -rf otp-*

lua: /usr/local/lua/bin/lua ## install lua 5.1.5
/usr/local/lua/bin/lua:
	sudo mkdir -p /usr/local/lua
	curl -fsSL -o lua.tgz "https://www.lua.org/ftp/lua-5.1.5.tar.gz"
	tar -xzf lua.tgz
	cd lua-5.1.5 && make all PLAT=linux && sudo make install INSTALL_TOP=/usr/local/lua
	rm -rf lua-5.1.5 lua.tgz

###@ Baseline tools

tools-base: makehelp fd rg fzf starship direnv nvim lazygit ## Install base tools

makehelp: $(bindir)/makehelp ## make help
$(bindir)/makehelp:
	mkdir -p $(bindir)
	curl -fsSLO https://gist.githubusercontent.com/bluebrown/2ec155902622b5e46e2bfcbaff342eb9/raw/Makehelp.awk
	install Makehelp.awk $(bindir)/makehelp
	rm -f Makehelp.awk

rg: $(bindir)/rg ## grep alternative
$(bindir)/rg:
	mkdir -p $(bindir)
	$(eval $@_tag = $(call latest_tag,BurntSushi/ripgrep))
	curl -fsSL -o rg.tgz "https://github.com/BurntSushi/ripgrep/releases/download/$($@_tag)/ripgrep-$($@_tag)-x86_64-unknown-linux-musl.tar.gz"
	tar -xzf rg.tgz --strip-components 1 -C $(bindir) --wildcards -- */rg
	rm -f rg.tgz

fd: $(bindir)/fd ## find alternative
$(bindir)/fd:
	mkdir -p $(bindir)
	$(eval $@_tag = $(call latest_tag,sharkdp/fd))
	curl -fsSL -o fd.tgz "https://github.com/sharkdp/fd/releases/download/$($@_tag)/fd-$($@_tag)-x86_64-unknown-linux-musl.tar.gz"
	tar -xzf fd.tgz --strip-components 1 -C $(bindir) --wildcards -- */fd
	rm -f fd.tgz

fzf: $(bindir)/fzf ## fuzzy finder
$(bindir)/fzf:
	mkdir -p $(bindir)
	$(eval $@_tag = $(call latest_tag,junegunn/fzf))
	curl -fsSL -o fzf.tgz "https://github.com/junegunn/fzf/releases/download/$($@_tag)/fzf-$($@_tag)-linux_amd64.tar.gz"
	tar -xzf fzf.tgz -C $(bindir) -- fzf
	rm -f fzf.tgz
	curl -fsSLO "https://raw.githubusercontent.com/junegunn/fzf/$($@_tag)/bin/fzf-tmux"
	install fzf-tmux $(bindir)/fzf-tmux
	rm -f fzf-tmux

starship: $(bindir)/starship ## better prompt
$(bindir)/starship:
	mkdir -p $(bindir)
	curl -fsSL -o starship.sh https://starship.rs/install.sh
	sh starship.sh --yes --bin-dir=$(bindir)
	rm -f starship.sh

direnv: $(bindir)/direnv ## manage environment variables
$(bindir)/direnv:
	mkdir -p $(bindir)
	curl -fsSL -o direnv https://github.com/direnv/direnv/releases/latest/download/direnv.linux-amd64
	install direnv $(bindir)/direnv
	rm -f direnv

tmux: $(bindir)/tmux ## terminal multiplexer
$(bindir)/tmux:
	mkdir -p $(bindir)
	$(eval $@_tag = $(call latest_tag,tmux/tmux))
	curl -fsSL "https://github.com/tmux/tmux/releases/download/$($@_tag)/tmux-$($@_tag).tar.gz" | tar -xz
	cd tmux-$($@_tag) && ./configure --prefix=$(prefix) && $(MAKE) && $(MAKE) install
	rm -rf tmux-$($@_tag)

nvim: $(bindir)/nvim ## code editor (nightly)
$(bindir)/nvim:
	mkdir -p $(bindir)
	curl -fsSL -o nvim.tgz https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
	tar -xzf nvim.tgz --strip-components 1 -C $(prefix)
	rm -f nvim.tgz

lazygit: $(bindir)/lazygit ## git gui
$(bindir)/lazygit:
	mkdir -p $(bindir)
	$(eval $@_tag = $(call latest_tag,jesseduffield/lazygit))
	curl -fsSL -o lazygit.tgz "https://github.com/jesseduffield/lazygit/releases/download/$($@_tag)/lazygit_$(subst v,,$($@_tag))_Linux_x86_64.tar.gz"
	tar -xzf lazygit.tgz -C $(bindir) -- lazygit
	rm -f lazygit.tgz

###@ Kubernetes tools

tools-k8s: kubectl kind ## Install kubernetes tools

kubectl: $(bindir)/kubectl ## kubernetes cli
$(bindir)/kubectl:
	mkdir -p $(bindir)
	curl -fsSLO "https://dl.k8s.io/release/$(shell curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	install kubectl $(bindir)/kubectl
	rm -f kubectl
	mkdir -p ~/.bash_completion.d
	$(bindir)/kubectl completion bash > ~/.bash_completion.d/kubectl
	printf "\ncomplete -F __start_kubectl k\n" >> ~/.bash_completion.d/kubectl

kind: $(bindir)/kind ## kubernetes in docker
$(bindir)/kind:
	mkdir -p $(bindir)
	curl -fsSL -o kind https://github.com/kubernetes-sigs/kind/releases/latest/download/kind-linux-amd64
	install kind $(bindir)/kind
	rm -f kind
