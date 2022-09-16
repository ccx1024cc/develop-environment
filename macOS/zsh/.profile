# enable ALT + f to jump forward
bindkey "ƒ" forward-word
# enable ALT + b to jump backward
bindkey "∫" backward-word

# enable libressl managed by brew to replace default libressl
export PATH="/usr/local/opt/libressl/bin:$PATH"
# enable openssl managed by brew to replace default openssl
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
# enable curl managed by brew to replace default curl
export PATH="/usr/local/opt/curl/bin:$PATH"

# use nvim instead of vim
alias vim='nvim'
export EDITOR='nvim'

# add rust tools
. "$HOME/.cargo/env"

# add go environment
export GOPATH=${HOME}/Workspace/go/
export PATH="${HOME}/Workspace/go/bin:$PATH"
export PATH="/usr/local/opt/go@1.14/bin:$PATH"
export GO111MODULE=on

# docker configuration
alias docker_restart="osascript -e 'quit app \"Docker\"' && open -a Docker"

# maven
export M2_HOME=/Users/taiyou/apache-maven-3.8.2
export PATH="${M2_HOME}/bin:${PATH}"

# coreutils
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles

# java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_291.jdk/Contents/Home
export CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:.
export PATH=$JAVA_HOME/bin:$PATH:.
