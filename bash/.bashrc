# ~/.bashrc の正本（Home Manager がこのファイルを ~ にリンクする）

# Nix / Home Manager が PATH や DOTFILES_STARSHIP などを載せる
[[ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]] \
  && . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

# タブ補完（nix の bash-completion が入っているときだけ読む）
if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
  for d in "$HOME/.nix-profile"; do
    [[ -f "$d/etc/profile.d/bash_completion.sh" ]] && {
      . "$d/etc/profile.d/bash_completion.sh"
      break
    }
  done
fi

# エイリアス（zsh の ~/.config/zsh/dotfiles.zshrc と別管理）
alias ll='eza -l'

# Starship: PATH= で init すると Nix のバイナリが埋め込まれる（brew 版と混ざらない）
if [[ $TERM != "dumb" && -n "${DOTFILES_STARSHIP:-}" ]]; then
  eval "$(PATH= "$DOTFILES_STARSHIP" init bash --print-full-init)"
fi
