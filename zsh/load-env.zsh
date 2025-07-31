# load-env.zsh
loadenv () {
  local envfile=${1:-.env}      # default file is “.env” in the current dir
  [[ -f $envfile ]] || return 0 # silently skip if file is missing

  setopt localoptions allexport # allexport only inside this function
  source "$envfile"             # read KEY=value lines; comments (# …) are ignored
}

