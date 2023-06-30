# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
. "$HOME/.cargo/env"

# add go environment
export GOPATH=${HOME}/workspace/go/
export PATH=".:/usr/local/go/bin:${HOME}/workspace/go/bin:$PATH"
export GO111MODULE=on


export GOPRIVATE=gitlab.alipay-inc.com,code.alipay.com;
export GOPROXY=https://goproxy.io,direct;
export GIT_TERMINAL_PROMPT=1;

# add java environment
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$JAVA_HOME/bin:$PATH

# add pip scripts path for python
export PATH="/home/morgan/.local/bin:$PATH"

# gpg for sign git hub commit
export GPG_TTY=$(tty)

# auto completion of kubectl
source <(kubectl completion zsh)

# home for openssl, because it's installed manually
export OPENSSL_DIR=/usr/local/ssl
