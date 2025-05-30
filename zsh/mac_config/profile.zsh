. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"
. ~/.asdf/plugins/golang/set-env.zsh
export EDITOR=/usr/bin/vim

export PATH="/opt/homebrew/opt/openjdk@21/bin:/opt/homebrew/opt/node@22/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/chodges/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/chodges/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/chodges/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/chodges/google-cloud-sdk/completion.zsh.inc'; fi

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
