alias a="cat ~/.gitconfig | sed -n '/\[alias\]/,/\[/p'"
alias g="git"
alias pg='GIT_SSH_COMMAND="ssh -F /dev/null -i ~/.ssh/pub_gh_id_ed25519 -o IdentitiesOnly=yes" git'
alias k="kubectl"
alias ctx='function _ctx() { kubectl config set-context --current --namespace="$1"; }; _ctx'
alias recent='echo -e "\033[0;32mnewest\033[0m"; history | grep '\''^[ ]*[0-9]*[ ]*g gob'\'' | tail -n 10 | awk '\''{print "- " $NF}'\'' | tac'
alias env="set -a && source ~/.env && set +a"
alias pgp='sops -d ~/sops.env.gpg'
alias c="claude"
alias cr="claude --continue"
