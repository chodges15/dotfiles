export EDITOR=/usr/bin/vim
export TZ=UTC
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_RUNTIME_DIR="$HOME"/.config/systemd/user
export SOPS_PGP_FP="1388D4ECFDEC119999DE814F3BC63B1C49472D75"
export GPG_TTY=$(tty)

# Skip sops loading if running in Cursor or in non-interactive shell
if [[ -z "${CURSOR_TRACE_ID}" ]] && [[ -o interactive ]]; then
  eval "$(sops -d ~/sops.env.gpg)"
fi

export ZSH_COPILOT_AI_PROVIDER="anthropic"
