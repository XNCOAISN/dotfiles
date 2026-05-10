_ST_SH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export STARSHIP_CONFIG="${_ST_SH_DIR}/../starship/starship.toml"
eval "$(starship init bash)"
unset _ST_SH_DIR
