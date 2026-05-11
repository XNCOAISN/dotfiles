# このファイルは Home Manager が生成する ~/.zshrc の末尾から source される
# （compinit・履歴などは HM 側の .zshrc に任せ、このファイルは追記用）

# エイリアス（bash の ~/.bashrc と別管理）
alias ll='eza -l'

# Starship: PATH= で init すると Nix のバイナリが埋め込まれる（brew 版と混ざらない）
if [[ $TERM != "dumb" && -n "${DOTFILES_STARSHIP:-}" ]]; then
  eval "$(PATH= "$DOTFILES_STARSHIP" init zsh)"
fi
