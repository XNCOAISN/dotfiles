export STARSHIP_CONFIG="${${(%):-%x}:A:h}/../starship/starship.toml"
eval "$(starship init zsh)"
